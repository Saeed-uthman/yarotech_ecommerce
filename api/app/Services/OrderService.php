<?php

declare(strict_types=1);

namespace App\Services;

use App\Core\Database;
use App\Helpers\Response;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderTracking;
use App\Models\Payment;
use App\Models\PaymentEvent;
use App\Models\User;
use App\Services\CustomerService;

/**
 * OrderService owns the lifecycle of an order:
 *   1) createFromCheckout()  -> awaiting_payment order + pending payment
 *   2) finalizeByReference() -> idempotent payment finalization
 */
final class OrderService
{
    private CheckoutService $checkout;
    private CartService $cartService;
    private Order $orders;
    private OrderItem $items;
    private Payment $payments;
    private PaymentEvent $events;
    private OrderTracking $tracking;
    private PaystackService $paystack;
    private PosService $pos;
    private MailService $mail;
    private NotificationService $notifier;
    private UserActivityLogService $activity;
    private User $users;
    private InventoryService $inventory;
    private CustomerService $customerService;

    public function __construct(
        ?CheckoutService $checkout = null,
        ?CartService $cartService = null,
        ?Order $orders = null,
        ?OrderItem $items = null,
        ?Payment $payments = null,
        ?PaymentEvent $events = null,
        ?OrderTracking $tracking = null,
        ?PaystackService $paystack = null,
        ?MailService $mail = null,
        ?NotificationService $notifier = null,
        ?UserActivityLogService $activity = null,
        ?User $users = null,
        ?InventoryService $inventory = null,
        ?CustomerService $customerService = null
    ) {
        $this->checkout = $checkout ?? new CheckoutService();
        $this->cartService = $cartService ?? new CartService();
        $this->orders = $orders ?? new Order();
        $this->items = $items ?? new OrderItem();
        $this->payments = $payments ?? new Payment();
        $this->events = $events ?? new PaymentEvent();
        $this->tracking = $tracking ?? new OrderTracking();
        $this->paystack = $paystack ?? new PaystackService();
        $this->mail = $mail ?? new MailService();
        $this->notifier = $notifier ?? new NotificationService();
        $this->activity = $activity ?? new UserActivityLogService();
        $this->users = $users ?? new User();
        $this->inventory = $inventory ?? new InventoryService();
        $this->customerService = $customerService ?? new CustomerService();
    }

    /**
     * @param array{user_id:?int,session_token:?string} $owner
     * @param array<string,mixed> $payload
     * @return array<string,mixed>
     */
    public function createFromCheckout(array $owner, array $payload): array
    {
        if (empty($owner['user_id'])) {
            Response::unauthorized('Authentication required to place an order.');
        }
        $userId = (int) $owner['user_id'];

        $preview = $this->checkout->preview($owner, $payload);

        $customer = [
            'name'  => trim((string) ($payload['customer_name'] ?? '')),
            'email' => trim((string) ($payload['customer_email'] ?? '')),
            'phone' => trim((string) ($payload['customer_phone'] ?? $payload['delivery_phone'] ?? '')),
        ];

        if ($customer['email'] === '') {
            Response::validation(['customer_email' => 'Customer email is required.']);
        }

        $fulfillment = $preview['fulfillment'];
        $totals = $preview['totals'];
        $cartView = $preview['cart'];

        $orderNumber = $this->orders->generateOrderNumber();
        
        $db = Database::connection();
        try {
            $db->beginTransaction();

            $orderId = (int) $this->orders->insert([
                'order_number'       => $orderNumber,
                'created_by'         => 'user',
                'user_id'            => $userId,
                'created_by_user_id' => $userId,
                'customer_id'        => $userId,
                'fulfillment_method' => $fulfillment['method'],
                'delivery_state'     => $fulfillment['address']['state'] ?? null,
                'delivery_city'      => $fulfillment['address']['city_or_lga'] ?? null,
                'delivery_address'   => $fulfillment['address']['address_line'] ?? null,
                'delivery_landmark'  => $fulfillment['address']['landmark'] ?? null,
                'delivery_phone'     => $customer['phone'] ?: ($fulfillment['address']['phone'] ?? null),
                'customer_name'      => $customer['name'],
                'customer_email'     => $customer['email'],
                'customer_phone'     => $customer['phone'] ?: ($fulfillment['address']['phone'] ?? null),
                'subtotal'           => $totals['subtotal'],
                'tax_amount'         => $totals['vat'],
                'discount'           => 0,
                'delivery_fee'       => $totals['delivery_fee'],
                'total_amount'       => $totals['total'],
                'currency'           => $totals['currency'],
                'order_status'       => 'awaiting_payment',
                'payment_status'     => 'pending',
                'payment_method'     => 'paystack',
                
            ]);

            foreach ($cartView['items'] as $item) {
                if (!($item['available'] ?? true)) {
                    continue;
                }
                $this->items->insert([
                    'order_id'              => $orderId,
                    'product_id'            => $item['product_id'],
                    'product_name_snapshot' => $item['name'],
                    'sku_snapshot'          => $item['sku'] ?? null,
                    'unit_price_snapshot'   => $item['price'],
                    'quantity'              => $item['quantity'],
                    'line_total'            => $item['line_total'],
                ]);
            }

            $this->tracking->add($orderId, 'awaiting_payment', 'Order created', 'Awaiting payment confirmation.');

            $order = $this->orders->find($orderId);
            $allowedOrigins = array_filter(array_map('trim', explode(',', (string) config('app.frontend_url'))));
            $frontendUrl = $_SERVER['HTTP_ORIGIN'] ?? ($allowedOrigins[0] ?? 'http://localhost');
            $callback = rtrim($frontendUrl, '/') . '/payment/processing';
            
            // Note: Paystack initialize is an external API call. 
            // If it fails, we catch it and rollback the DB.
            $init = $this->paystack->initializePayment($order, $callback, $customer['email']);

            $paymentId = (int) $this->payments->insert([
                'order_id'          => $orderId,
                'provider'          => 'paystack',
                'reference'         => $init['reference'],
                'amount'            => $totals['total'],
                'currency'          => $totals['currency'],
                'status'            => 'initialized',
                'payment_method'    => 'paystack',
            ]);

            $this->events->record($paymentId, $init['reference'], 'initialized', $init);

            $db->commit();

            return [
                'order'             => $this->orders->find($orderId),
                'payment_reference' => $init['reference'],
                'authorization_url' => $init['authorization_url'],
                'access_code'       => $init['access_code'] ?? null,
            ];
        } catch (\Throwable $e) {
            if ($db->inTransaction()) {
                $db->rollBack();
            }
            throw $e;
        }
    }

    /**
     * Create a POS sale using the same orders/order_items/payments model
     * used by ecommerce checkout.
     *
     * @param array<string,mixed> $payload
     * @return array<string,mixed>
     */
    public function createPosSale(array $payload): array
    {
        $allowedMethods = ['paystack', 'cash', 'bank_transfer', 'pos_terminal', 'manual_card', 'other'];
        $allowedPaymentStatuses = ['pending', 'success', 'failed', 'abandoned'];
        $allowedCreators = ['admin', 'staff', 'user'];

        $createdBy = strtolower(trim((string) ($payload['created_by'] ?? 'admin')));
        if (!in_array($createdBy, $allowedCreators, true)) {
            Response::validation(['created_by' => 'created_by must be one of user, admin, staff.']);
        }

        $paymentMethod = strtolower(trim((string) ($payload['payment_method'] ?? 'cash')));
        if (!in_array($paymentMethod, $allowedMethods, true)) {
            Response::validation(['payment_method' => 'Unsupported payment method.']);
        }

        $paymentStatus = strtolower(trim((string) ($payload['payment_status'] ?? 'success')));
        if (!in_array($paymentStatus, $allowedPaymentStatuses, true)) {
            Response::validation(['payment_status' => 'Invalid payment_status.']);
        }

        $rawItems = $payload['items'] ?? [];
        if (!is_array($rawItems) || empty($rawItems)) {
            Response::validation(['items' => 'At least one sale item is required.']);
        }

        $actorUserId = isset($payload['created_by_user_id']) && (int) $payload['created_by_user_id'] > 0
            ? (int) $payload['created_by_user_id']
            : null;
        if ($actorUserId === null) {
            Response::validation(['created_by_user_id' => 'created_by_user_id is required for POS sales.']);
        }
        $customerId = isset($payload['customer_id']) && (int) $payload['customer_id'] > 0
            ? (int) $payload['customer_id']
            : null;

        $customerName = trim((string) ($payload['customer_name'] ?? 'Walk-in customer'));
        $customerPhone = trim((string) ($payload['customer_phone'] ?? ''));
        $customerEmail = trim((string) ($payload['customer_email'] ?? ''));

        $normalizedItems = [];
        $subtotal = 0.0;

        foreach ($rawItems as $idx => $item) {
            if (!is_array($item)) {
                Response::validation(["items.$idx" => 'Item must be an object.']);
            }

            $productId = trim((string) ($item['product_id'] ?? $item['id'] ?? ''));
            if ($productId === '') {
                Response::validation(["items.$idx.product_id" => 'product_id is required.']);
            }

            $qty = (int) ($item['quantity'] ?? 0);
            if ($qty <= 0) {
                Response::validation(["items.$idx.quantity" => 'quantity must be at least 1.']);
            }

            $product = [];
            if ($productId !== 'custom') {
                $product = (new ProductService())->detailById($productId) ?? [];
                if (!$product) {
                    Response::validation(["items.$idx.product_id" => "Product not found: $productId"]);
                }
                if (strtolower((string) ($product['status'] ?? 'active')) !== 'active') {
                    Response::validation(["items.$idx.product_id" => "Product is inactive: $productId"]);
                }

                $stock = (int) ($product['stock_quantity'] ?? 0);
                if ($qty > $stock) {
                    Response::validation(["items.$idx.quantity" => "Only $stock unit(s) available for {$product['name']}."]);
                }
            }

            $unitPrice = isset($item['unit_price']) && is_numeric($item['unit_price'])
                ? max(0, (float) $item['unit_price'])
                : (isset($item['price']) && is_numeric($item['price']) 
                    ? max(0, (float) $item['price']) 
                    : (float) ($product['price'] ?? 0));
            $lineTotal = $unitPrice * $qty;
            $subtotal += $lineTotal;

            $itemName = trim((string) ($item['name'] ?? ''));
            $productName = trim((string) ($product['name'] ?? ''));
            $finalName = $productName !== '' ? $productName : ($itemName !== '' ? $itemName : 'Custom Product');
            
            $itemSku = trim((string) ($item['sku'] ?? ''));
            $productSku = trim((string) ($product['sku'] ?? ''));
            $finalSku = $productSku !== '' ? $productSku : ($itemSku !== '' ? $itemSku : 'CUSTOM');

            $normalizedItems[] = [
                'product_id'        => (string) ($product['product_id'] ?? $productId),
                'product_name_snapshot' => $finalName,
                'sku_snapshot'          => $finalSku,
                'unit_price_snapshot'   => $unitPrice,
                'quantity'              => $qty,
                'line_total'            => round($lineTotal, 2),
            ];
        }

        $tax = isset($payload['tax']) && is_numeric($payload['tax'])
            ? max(0, (float) $payload['tax'])
            : (isset($payload['tax_amount']) && is_numeric($payload['tax_amount']) ? max(0, (float) $payload['tax_amount']) : 0.0);
        $discount = isset($payload['discount']) && is_numeric($payload['discount'])
            ? max(0, (float) $payload['discount'])
            : 0.0;
        $deliveryFee = isset($payload['delivery_fee']) && is_numeric($payload['delivery_fee'])
            ? max(0, (float) $payload['delivery_fee'])
            : 0.0;

        $total = round(max(0, $subtotal + $tax + $deliveryFee - $discount), 2);
        $currency = (string) ($payload['currency'] ?? 'NGN');
        $orderStatus = $paymentStatus === 'success' ? 'paid' : 'awaiting_payment';
        if (isset($payload['order_status']) && is_string($payload['order_status']) && trim($payload['order_status']) !== '') {
            $orderStatus = trim((string) $payload['order_status']);
        }

        $orderNumber = $this->orders->generateOrderNumber();
        $legacyUserId = $customerId ?? $actorUserId;

        $db = Database::connection();
        try {
            $db->beginTransaction();

            $orderId = (int) $this->orders->insert([
                'order_number'       => $orderNumber,
                'created_by'         => $createdBy,
                'created_by_user_id' => $actorUserId,
                'customer_id'        => $customerId,
                'fulfillment_method' => 'pickup',
                'delivery_state'     => null,
                'delivery_city'      => null,
                'delivery_address'   => null,
                'delivery_landmark'  => null,
                'delivery_phone'     => $customerPhone !== '' ? $customerPhone : null,
                'customer_name'      => $customerName,
                'customer_email'     => $customerEmail !== '' ? $customerEmail : null,
                'customer_phone'     => $customerPhone !== '' ? $customerPhone : null,
                'subtotal'           => round($subtotal, 2),
                'tax_amount'         => round($tax, 2),
                'discount'           => round($discount, 2),
                'delivery_fee'       => round($deliveryFee, 2),
                'total_amount'       => $total,
                'currency'           => $currency,
                'order_status'       => $orderStatus,
                'payment_status'     => $paymentStatus,
                'payment_method'     => $paymentMethod,
                'sale_channel'       => $payload['sale_channel'] ?? 'pos',
                

                'notes'              => isset($payload['notes']) ? (string) $payload['notes'] : null,
            ]);

            foreach ($normalizedItems as $item) {
                $this->items->insert([
                    'order_id'              => $orderId,
                    'product_id'        => $item['product_id'],
                    'product_name_snapshot' => $item['product_name_snapshot'],
                    'sku_snapshot'          => $item['sku_snapshot'],
                    'unit_price_snapshot'   => $item['unit_price_snapshot'],
                    'quantity'              => $item['quantity'],
                    'line_total'            => $item['line_total'],
                ]);
            }

            if ($paymentStatus === 'success') {
                foreach ($normalizedItems as $item) {
                    if ((string) $item['product_id'] !== 'custom') {
                        $this->inventory->reduceForPosSale(
                            (string) $item['product_id'],
                            (int) $item['quantity'],
                            $orderNumber,
                            $createdBy,
                            $actorUserId,
                            'POS sale stock deduction'
                        );
                    }
                }
                $this->orders->update($orderId, [
                    'inventory_reduced_at' => date('Y-m-d H:i:s'),
                ]);
            }

            $paymentReference = 'YT-POS-' . preg_replace('/[^A-Za-z0-9]/', '', $orderNumber) . '-' . strtoupper(bin2hex(random_bytes(3)));
            $paymentId = (int) $this->payments->insert([
                'order_id'          => $orderId,
                'provider'          => $paymentMethod === 'paystack' ? 'paystack' : 'internal',
                'reference'         => $paymentReference,
                'amount'            => $total,
                'currency'          => $currency,
                'status'            => $paymentStatus,
                'channel'           => $paymentMethod,
                'payment_method'    => $paymentMethod,
                
                'gateway_response'  => (string) ($payload['gateway_response'] ?? 'POS sale'),
                'paid_at'           => $paymentStatus === 'success' ? date('Y-m-d H:i:s') : null,
            ]);
            $this->events->record($paymentId, $paymentReference, 'pos_sale_created', [
                
                'created_by' => $createdBy,
                'payment_method' => $paymentMethod,
            ]);

            $this->tracking->add(
                $orderId,
                $orderStatus,
                'POS sale created',
                'POS sale created from dashboard.'
            );
            
            if ($actorUserId) {
                $activityLog = new \App\Services\ActivityLogService();
                $desc = ucfirst($createdBy) . " created POS sale {$orderNumber} for NGN " . number_format($total, 2);
                if ($total > 1000000) {
                    $activityLog->logHighPriority($actorUserId, 'pos_sale', $desc, $orderId);
                } else {
                    $activityLog->logRoutine($actorUserId, 'pos_sale', $desc, $orderId);
                }
            }

            $db->commit();
        } catch (\Throwable $e) {
            if ($db->inTransaction()) {
                $db->rollBack();
            }
            Response::error('Failed to create POS sale: ' . $e->getMessage(), 500);
        }

        // Link or create a customer record for every sale (without duplicating)
        $hasRealName = $customerName !== '' && strtolower($customerName) !== 'walk-in customer';
        $hasPhone = $customerPhone !== '';
        if ($customerId !== null || $hasRealName || $hasPhone) {
            try {
                if ($customerId !== null) {
                    // An existing customer was explicitly selected at the POS:
                    // attach the sale to their record and increment stats only.
                    $cust = $this->customerService->findById($customerId) ?? ['id' => null];
                } elseif ($hasPhone) {
                    // Phone is the strongest identifier — match or create on it.
                    $cust = $this->customerService->findOrCreate([
                        'name'  => $customerName !== '' ? $customerName : 'Walk-in customer',
                        'phone' => $customerPhone,
                        'email' => $customerEmail,
                    ]);
                } elseif ($hasRealName) {
                    // No phone supplied: reuse an existing customer with the same
                    // name before creating a new record (prevents duplicates).
                    $cust = $this->customerService->findByName($customerName);
                    if ($cust && $customerEmail !== '' && trim((string) ($cust['email'] ?? '')) !== $customerEmail) {
                        $cust = $this->customerService->updateCustomer((int) $cust['id'], [
                            'email' => $customerEmail,
                        ]) ?? $cust;
                    } elseif (!$cust) {
                        $cust = $this->customerService->createCustomer([
                            'name'  => $customerName,
                            'phone' => 'POS-' . $orderId . '-' . time(),
                            'email' => $customerEmail,
                        ]) ?? ['id' => null];
                    }
                } else {
                    $cust = ['id' => null];
                }

                if (!empty($cust['id'])) {
                    $this->customerService->recordOrder((int) $cust['id'], $total);
                    $this->orders->update($orderId, ['customer_id' => (int) $cust['id']]);
                }
            } catch (\Throwable $e) {
                // Non-critical: don't fail the sale if customer recording fails
            }
        }

        $order = $this->orders->findByNumber($orderNumber);
        $payment = $this->payments->findForOrder((int) ($order['id'] ?? 0));
        $items = $this->items->listForOrder((int) ($order['id'] ?? 0));

        return $this->buildOrderEnvelope($order, $payment, $items);
    }

    /**
     * Idempotent finalization by payment reference.
     *
     * @param array<string,mixed>|null $verifyResult
     * @return array<string,mixed>
     */
    public function finalizeByReference(string $reference, ?array $verifyResult = null, string $eventSource = 'verify'): array
    {
        $payment = $this->payments->findByReference($reference);
        if (!$payment) {
            Response::notFound('Payment reference not found.');
        }

        $order = $this->orders->find((int) $payment['order_id']);
        if (!$order) {
            Response::notFound('Order not found for payment.');
        }

        if ($payment['status'] === 'success' && $order['payment_status'] === 'success') {
            return $this->buildOrderEnvelope($order, $payment);
        }

        $verify = $verifyResult ?? $this->paystack->verifyPayment($reference);
        $this->events->record((int) $payment['id'], $reference, "verify.$eventSource", $verify);

        if (($verify['status'] ?? '') !== 'success') {
            $gatewayResponse = (string) ($verify['gateway_response'] ?? 'Payment was not successful.');

            $this->payments->update((int) $payment['id'], [
                'status'           => $verify['status'] === 'abandoned' ? 'abandoned' : 'failed',
                'gateway_response' => mb_substr($gatewayResponse, 0, 250),
            ]);
            $this->orders->update((int) $order['id'], ['payment_status' => 'failed']);
            $this->tracking->add((int) $order['id'], 'payment_failed', 'Payment failed', $gatewayResponse);

            $targetUserId = (int) ($order['user_id'] ?? $order['customer_id'] ?? 0);
            
            if ($targetUserId > 0) {
                $this->notifier->createUserNotification(
                    $targetUserId,
                    'payment_failed',
                    'Payment failed',
                    'Payment failed for order ' . $order['order_number'] . '.',
                    [
                        'order_number' => $order['order_number'],
                        'reference'    => $reference,
                    ],
                );
                
                $this->activity->log(
                    $targetUserId,
                    'payment_failed',
                    'failed',
                    null,
                    null,
                    [
                        'order_number' => $order['order_number'],
                        'reference'    => $reference,
                    ],
                );
            }

            $this->notifier->createAdminNotification(
                'payment_failed',
                'Payment failed for order ' . $order['order_number'],
                $gatewayResponse,
                [
                    'order_number' => $order['order_number'],
                    'reference'    => $reference,
                    'user_id'      => $targetUserId,
                ],
            );

            Response::error('Payment verification failed: ' . ($verify['gateway_response'] ?? 'declined'), 402);
        }

        $reported = (float) ($verify['amount'] ?? 0);
        $expected = (float) $order['total_amount'];
        if ($reported > 0 && abs($reported - $expected) > 0.5) {
            $this->events->record((int) $payment['id'], $reference, 'verify.amount_mismatch', [
                'expected' => $expected,
                'reported' => $reported,
            ]);
            $this->notifier->createAdminNotification(
                'payment_failed',
                'Payment amount mismatch for ' . $order['order_number'],
                'Gateway reported amount does not match expected order total.',
                [
                    'order_number' => $order['order_number'],
                    'reference'    => $reference,
                    'expected'     => $expected,
                    'reported'     => $reported,
                ],
            );
            $targetUserId = (int) ($order['user_id'] ?? $order['customer_id'] ?? 0);

            if ($targetUserId > 0) {
                $this->activity->log(
                    $targetUserId,
                    'payment_failed',
                    'failed',
                    null,
                    null,
                    [
                        'order_number' => $order['order_number'],
                        'reference'    => $reference,
                        'reason'       => 'amount_mismatch',
                    ],
                );
            }
            Response::error('Payment amount mismatch - contact support.', 409);
        }

        $this->payments->update((int) $payment['id'], [
            'status'           => 'success',
            'channel'          => mb_substr((string) ($verify['channel'] ?? ''), 0, 40),
            'gateway_response' => mb_substr((string) ($verify['gateway_response'] ?? ''), 0, 250),
            'paid_at'          => $this->normalizePaidAt($verify['paid_at'] ?? null),
        ]);
        $this->orders->update((int) $order['id'], [
            'payment_status' => 'success',
            'order_status'   => 'paid',
            'payment_method' => 'paystack',
            
        ]);
        $this->tracking->add((int) $order['id'], 'paid', 'Payment confirmed', 'Paystack reference ' . $reference . ' verified.');

        $order = $this->orders->find((int) $order['id']);
        $payment = $this->payments->find((int) $payment['id']);
        $items = $this->items->listForOrder((int) $order['id']);
        $user = $this->users->findOrSynthesize(
            (int) $order['user_id'],
            $order['customer_email'],
            $order['customer_name'],
        );

        $this->applyInventoryForSuccessfulOrder($order, $items, 'user', isset($order['user_id']) ? (int) $order['user_id'] : null);
        $order = $this->orders->find((int) $order['id']);

        $this->sendEmailsOnce($order, $items, $user, $payment);

        // Always create/update customer record for ecommerce orders
        try {
            $phoneForCustomer = !empty($order['customer_phone'])
                ? $order['customer_phone']
                : ('EC-' . $order['id'] . '-' . time());
            $cust = $this->customerService->findOrCreate([
                'name'  => $order['customer_name'] ?? '',
                'phone' => $phoneForCustomer,
                'email' => $order['customer_email'] ?? '',
            ]);
            if (!empty($cust['id'])) {
                $this->customerService->recordOrder((int) $cust['id'], (float) $order['total_amount']);
                if (empty($order['customer_id'])) {
                    $this->orders->update((int) $order['id'], ['customer_id' => (int) $cust['id']]);
                }
            }
        } catch (\Throwable $e) {
            // Non-critical
        }

        $targetUserId = (int) ($order['user_id'] ?? $order['customer_id'] ?? 0);
        
        $this->notifier->createAdminNotification(
            'order_created',
            'New order ' . $order['order_number'] . ' placed',
            'A payment of ' . $order['currency'] . ' ' . number_format((float)$order['total_amount'], 2) . ' was confirmed.',
            [
                'order_number' => $order['order_number'],
                'reference'    => (string) $payment['reference'],
                'user_id'      => $targetUserId,
            ]
        );
        
        $adminActivityLog = new \App\Services\ActivityLogService();
        $adminActivityLog->logHighPriority(
            null, 
            'order_placed', 
            "Order {$order['order_number']} placed successfully for {$order['currency']} " . number_format((float)$order['total_amount'], 2) . " (Ref: {$payment['reference']})",
            (int) $order['id']
        );

        if ($targetUserId > 0) {
            $this->notifier->createUserNotification(
                $targetUserId,
                'order_created',
                'Order ' . $order['order_number'] . ' confirmed',
                'Thanks for your purchase. Your order has been confirmed.',
                [
                    'order_number' => $order['order_number'],
                    'link_url'     => '/dashboard/orders/' . $order['order_number'],
                ],
            );
            $this->notifier->createUserNotification(
                $targetUserId,
                'payment_success',
                'Payment successful',
                'Your payment for order ' . $order['order_number'] . ' was successful.',
                [
                    'order_number' => $order['order_number'],
                    'reference'    => (string) $payment['reference'],
                ],
            );
            $this->activity->log(
                $targetUserId,
                'payment_success',
                'success',
                null,
                null,
                [
                    'order_number' => $order['order_number'],
                    'reference'    => (string) $payment['reference'],
                ],
            );
        }

        return $this->buildOrderEnvelope($order, $payment, $items);
    }



    /**
     * Lazily cancel orders that have been awaiting payment for more than X minutes.
     */
    public function cancelStaleOrders(int $minutes = 10): void
    {
        $db = Database::connection();
        $stmt = $db->prepare(
            "SELECT id, order_number, user_id FROM orders 
             WHERE order_status = 'awaiting_payment' 
               AND payment_status = 'pending' 
               AND created_at < DATE_SUB(NOW(), INTERVAL :m MINUTE)"
        );
        $stmt->bindValue(':m', $minutes, \PDO::PARAM_INT);
        $stmt->execute();
        $staleOrders = $stmt->fetchAll();

        foreach ($staleOrders as $order) {
            $orderId = (int) $order['id'];
            $this->orders->update($orderId, [
                'order_status'   => 'cancelled',
                'payment_status' => 'failed'
            ]);
            $this->tracking->add($orderId, 'cancelled', 'Order cancelled', "Payment not received within {$minutes} minutes.");
            
            if (!empty($order['user_id'])) {
                $this->notifier->createUserNotification(
                    (int) $order['user_id'],
                    'order_cancelled',
                    'Order ' . $order['order_number'] . ' cancelled',
                    "Order cancelled because payment was not received within {$minutes} minutes.",
                    ['order_number' => $order['order_number']]
                );
            }
        }
    }

    // ---------------------------------------------------------------



    /**
     * @param array<string,mixed> $order
     * @param array<int,array<string,mixed>> $items
     * @param array<string,mixed> $user
     * @param array<string,mixed> $payment
     */
    private function sendEmailsOnce(array $order, array $items, array $user, array $payment): void
    {
        if ($this->paymentEventsExists((int) $payment['id'], 'emails.sent')) {
            return;
        }

        $this->mail->sendOrderConfirmationEmail($user, $order, $items);
        $this->mail->sendPaymentConfirmationEmail($user, $order, $payment);
        $this->mail->sendAdminNewOrderEmail($order, $user, $items, $payment);

        $this->events->record((int) $payment['id'], (string) $payment['reference'], 'emails.sent', [
            'to' => $user['email'] ?? $order['customer_email'],
        ]);
    }

    private function paymentEventsExists(int $paymentId, string $eventType): bool
    {
        $db = Database::connection();
        $stmt = $db->prepare('SELECT 1 FROM payment_events WHERE payment_id = :p AND event_type = :t LIMIT 1');
        $stmt->execute([':p' => $paymentId, ':t' => $eventType]);
        return (bool) $stmt->fetchColumn();
    }

    private function normalizePaidAt($raw): ?string
    {
        if (!$raw) {
            return date('Y-m-d H:i:s');
        }

        try {
            return (new \DateTimeImmutable((string) $raw))->format('Y-m-d H:i:s');
        } catch (\Throwable) {
            return date('Y-m-d H:i:s');
        }
    }

    /**
     * @param array<string,mixed> $order
     * @param array<string,mixed>|null $payment
     * @param array<int,array<string,mixed>>|null $items
     * @return array<string,mixed>
     */
    public function buildOrderEnvelope(array $order, ?array $payment = null, ?array $items = null): array
    {
        $items = $items ?? $this->items->listForOrder((int) $order['id']);
        $payment = $payment ?? $this->payments->findForOrder((int) $order['id']);
        $tracking = $this->tracking->listForOrder((int) $order['id']);

        return [
            'order'    => $order,
            'items'    => $items,
            'payment'  => $payment,
            'tracking' => $tracking,
        ];
    }

    /**
     * @param array<int,array<string,mixed>> $items
     */
    private function applyInventoryForSuccessfulOrder(
        array $order,
        array $items,
        string $createdBy,
        ?int $createdByUserId = null
    ): void
    {
        if (($order['payment_status'] ?? '') !== 'success') return;
        if (($order['sale_channel'] ?? 'ecommerce') !== 'ecommerce') return;
        if (!empty($order['inventory_reduced_at'])) return;

        foreach ($items as $item) {
            $productId = (string) ($item['product_id'] ?? '');
            $qty = (int) ($item['quantity'] ?? 0);
            if ($productId === '' || $qty <= 0) continue;

            $this->inventory->reduceForEcommerceSale(
                $productId,
                $qty,
                (string) ($order['order_number'] ?? ''),
                $createdByUserId,
                'Ecommerce paid order stock deduction'
            );
        }

        $this->orders->update((int) $order['id'], [
            'inventory_reduced_at' => date('Y-m-d H:i:s'),
        ]);
    }


}

