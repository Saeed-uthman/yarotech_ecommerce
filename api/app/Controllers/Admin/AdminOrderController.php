<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Models\Order;
use App\Models\OrderTracking;
use App\Models\User;
use App\Services\AdminActivityLogService;
use App\Services\InvoicePdfService;
use App\Services\NotificationService;
use App\Services\OrderService;
use App\Services\UserActivityLogService;

final class AdminOrderController extends BaseController
{
    private array $allowedStatuses = [
        'pending', 'paid', 'processing', 'ready_for_pickup', 'shipped', 'delivered', 'picked_up', 'cancelled', 'refunded', 'failed'
    ];

    private Order $orders;
    private OrderService $service;
    private OrderTracking $tracking;
    private NotificationService $notifications;
    private AdminActivityLogService $activity;

    public function __construct(
        ?Order $orders = null,
        ?OrderService $service = null,
        ?OrderTracking $tracking = null,
        ?NotificationService $notifications = null,
        ?AdminActivityLogService $activity = null
    ) {
        $this->orders = $orders ?? new Order();
        $this->service = $service ?? new OrderService();
        $this->tracking = $tracking ?? new OrderTracking();
        $this->notifications = $notifications ?? new NotificationService();
        $this->activity = $activity ?? new AdminActivityLogService();
    }

    /** GET /api/admin/orders/index.php */
    public function index(): never
    {
        $filters = [
            'order_status'   => Request::query('order_status'),
            'payment_status' => Request::query('payment_status'),
            
            'sale_channel'   => Request::query('sale_channel'),
            'payment_method' => Request::query('payment_method'),
            'created_by'     => Request::query('created_by'),
            'search'         => Request::query('search'),
            'page'           => Request::query('page', 1),
            'per_page'       => Request::query('per_page', 20),
        ];

        $this->service->cancelStaleOrders(10);
        $result = $this->orders->listForAdmin($filters);

        $orderIds = array_column($result['items'], 'id');
        $itemsByOrder = [];
        if (!empty($orderIds)) {
            $db = \App\Core\Database::connection();
            $inClause = implode(',', array_map('intval', $orderIds));
            $stmt = $db->query("SELECT * FROM order_items WHERE order_id IN ($inClause)");
            $allItems = $stmt->fetchAll();
            foreach ($allItems as $item) {
                $orderId = (int) $item['order_id'];
                $itemsByOrder[$orderId][] = [
                    'posId' => (string) ($item['product_id'] ?? ''),
                    'name'  => (string) ($item['product_name_snapshot'] ?? $item['product_name'] ?? 'Product'),
                    'sku'   => (string) ($item['sku_snapshot'] ?? $item['sku'] ?? 'n/a'),
                    'qty'   => (int) ($item['quantity'] ?? 0),
                    'price' => (float) ($item['unit_price_snapshot'] ?? $item['unit_price'] ?? 0),
                ];
            }
        }

        $formatted = [];
        foreach ($result['items'] as $row) {
            $orderId = (int) $row['id'];
            $rowItems = $itemsByOrder[$orderId] ?? [];
            $formatted[] = $this->formatOrderRow($row, $rowItems);
        }

        $this->ok([
            'items' => $formatted,
            'pagination' => [
                'page'     => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total'    => (int) $result['total'],
            ],
        ], 'Orders fetched successfully');
    }

    /** GET /api/admin/orders/show.php?id=... */
    public function show(): never
    {
        $id = (string) Request::query('id', '');
        if ($id === '') {
            Response::validation(['id' => 'id is required.']);
        }

        $this->service->cancelStaleOrders(10);
        $order = $this->orders->findByIdOrNumber($id);
        if (!$order) {
            Response::notFound('Order not found.');
        }

        $envelope = $this->service->buildOrderEnvelope($order);
        $this->ok($envelope, 'Order fetched successfully');
    }

    /** POST /api/admin/orders/update-status.php */
    public function updateStatus(): never
    {
        $id = (string) Request::input('id', '');
        $status = trim((string) Request::input('order_status', Request::input('status', '')));

        if ($id === '') {
            Response::validation(['id' => 'id is required.']);
        }
        if (!in_array($status, $this->allowedStatuses, true)) {
            Response::validation(['order_status' => 'Invalid order status.']);
        }

        $order = $this->orders->findByIdOrNumber($id);
        if (!$order) {
            Response::notFound('Order not found.');
        }

        $currentStatus = $order['order_status'] ?? 'pending';
        
        $ranks = [
            'pending' => 1,
            'paid' => 2,
            'processing' => 3,
            'ready_for_pickup' => 4,
            'shipped' => 4,
            'picked_up' => 5,
            'delivered' => 5,
            'cancelled' => 99,
            'refunded' => 99,
            'failed' => 99,
        ];

        $currentRank = $ranks[$currentStatus] ?? 0;
        $newRank = $ranks[$status] ?? 0;

        if ($newRank < $currentRank && !in_array($status, ['cancelled', 'refunded', 'failed'], true)) {
            Response::validation(['order_status' => 'Cannot transition order status backwards.']);
        }
        
        if (in_array($currentStatus, ['cancelled', 'refunded', 'failed', 'delivered', 'picked_up'], true) && $status !== $currentStatus) {
            Response::validation(['order_status' => "Cannot change status of a {$currentStatus} order."]);
        }

        $this->orders->update((int) $order['id'], [
            'order_status' => $status,
        ]);
        $this->tracking->add(
            (int) $order['id'],
            $status,
            'Admin status update',
            'Order status set to ' . $status . '.'
        );

        $this->notifications->createUserNotification(
            (int) $order['user_id'],
            'order_created',
            'Order status updated',
            'Order ' . $order['order_number'] . ' is now ' . $status . '.',
            [
                'order_number' => $order['order_number'],
                'status' => $status,
            ],
        );

        $this->activity->log('order_status_updated', 'success', [
            'order_id' => (int) $order['id'],
            'order_number' => $order['order_number'],
            'status' => $status,
        ]);

        $activityType = ($status === 'cancelled') ? 'order_cancelled' : 'order_status_updated';
        (new UserActivityLogService())->log(
            isset($order['user_id']) ? (int) $order['user_id'] : null,
            $activityType,
            'success',
            "Order status changed to {$status}",
            ['order_number' => $order['order_number'], 'new_status' => $status]
        );

        if (in_array($status, ['delivered', 'picked_up'], true)) {
            $mail = new \App\Services\MailService();
            $mail->sendOrderFulfilledEmail($order, $status);
        }
        
        $actorId = isset($_SERVER['AUTH_USER_ID']) ? (int)$_SERVER['AUTH_USER_ID'] : null;
        if ($actorId) {
            $activityLog = new \App\Services\ActivityLogService();
            $desc = "Order {$order['order_number']} status was updated to {$status}";
            if (in_array($status, ['refunded', 'cancelled'])) {
                $activityLog->logHighPriority($actorId, 'order_' . $status, $desc, (int)$order['id']);
            } else {
                $activityLog->logRoutine($actorId, 'order_status_updated', $desc, (int)$order['id']);
            }
        }

        $updated = $this->orders->find((int) $order['id']);
        $this->ok($updated, 'Order status updated successfully');
    }

    /** POST /api/admin/orders/create-pos-sale */
    public function createPosSale(): never
    {
        $payload = $this->all();

        if (empty($payload['created_by_user_id'])) {
            $fromHeader = Request::header('X-User-Id');
            if ($fromHeader !== null && filter_var($fromHeader, FILTER_VALIDATE_INT) !== false) {
                $payload['created_by_user_id'] = (int) $fromHeader;
            }
        }
        if (empty($payload['created_by'])) {
            $payload['created_by'] = (string) (Request::header('X-User-Role') ?? 'admin');
        }

        $envelope = $this->service->createPosSale($payload);
        $order = $envelope['order'] ?? [];

        $this->activity->log('pos_sale_created', 'success', [
            'order_id' => (int) ($order['id'] ?? 0),
            'order_number' => (string) ($order['order_number'] ?? ''),
            'sale_channel' => (string) ($order['sale_channel'] ?? 'pos'),
            'created_by' => (string) ($order['created_by'] ?? 'admin'),
            'payment_method' => (string) ($order['payment_method'] ?? ''),
        ]);

        (new UserActivityLogService())->log(
            empty($payload['created_by_user_id']) ? null : (int)$payload['created_by_user_id'],
            'pos_sale_created',
            'success',
            null,
            null,
            [
                'order_number' => (string) ($order['order_number'] ?? ''),
                'customer_name' => (string) ($order['customer_name'] ?? ''),
                'total_amount' => (float) ($order['total_amount'] ?? 0),
            ]
        );

        $this->ok($envelope, 'POS sale created successfully');
    }

    /** GET /api/admin/orders/invoice-data?id=... (admin/staff: no ownership check) */
    public function invoiceData(): never
    {
        $id = (string) Request::query('id', Request::query('order_number', ''));
        if ($id === '') {
            Response::validation(['id' => 'id or order_number is required.']);
        }

        $order = $this->orders->findByIdOrNumber($id);
        if (!$order) Response::notFound('Order not found.');

        $envelope = $this->service->buildOrderEnvelope($order);

        $this->ok([
            'invoice_number' => 'INV-' . $order['order_number'],
            'issued_at'      => $order['created_at'],
            'valid_until'    => date('Y-m-d H:i:s', strtotime($order['created_at'] . ' + 48 hours')),
            'order'          => $envelope['order'],
            'items'          => $envelope['items'],
            'payment'        => $envelope['payment'],
            'tracking'       => $envelope['tracking'] ?? [],
        ], 'Invoice data ready.');
    }

    /** GET /api/admin/orders/invoice-pdf?id=... (admin/staff: no ownership check) */
    public function invoicePdf(): never
    {
        $id = (string) Request::query('id', Request::query('order_number', ''));
        if ($id === '') {
            Response::validation(['id' => 'id or order_number is required.']);
        }

        $order = $this->orders->findByIdOrNumber($id);
        if (!$order) Response::notFound('Order not found.');

        $envelope = $this->service->buildOrderEnvelope($order);
        $user = (new User())->find((string) ($order['user_id'] ?? 0));

        $invoiceService = new InvoicePdfService();
        $pdfContent = $invoiceService->generateFromOrder(
            $envelope['order'],
            $envelope['items'],
            $user ?? ['name' => $order['customer_name'], 'email' => $order['customer_email']]
        );

        $filename = 'YAROTECH-Invoice-' . $order['order_number'] . '.pdf';
        $invoiceService->streamDownload($pdfContent, $filename);
    }


    /**
     * @param array<string,mixed> $row
     * @param array<int,array<string,mixed>> $rowItems
     * @return array<string,mixed>
     */
    private function formatOrderRow(array $row, array $rowItems = []): array
    {
        return [
            'id' => (int) $row['id'],
            'order_number' => (string) ($row['order_number'] ?? ''),
            'customer_name' => (string) ($row['customer_name'] ?? ''),
            'customer_email' => (string) ($row['customer_email'] ?? ''),
            'delivery_phone' => (string) ($row['delivery_phone'] ?? ''),
            'customer_phone' => (string) ($row['customer_phone'] ?? $row['delivery_phone'] ?? ''),
            'subtotal' => (float) ($row['subtotal'] ?? 0),
            'tax_amount' => (float) ($row['tax_amount'] ?? 0),
            'discount' => (float) ($row['discount'] ?? 0),
            'tax' => (float) ($row['tax'] ?? $row['tax_amount'] ?? 0),
            'delivery_fee' => (float) ($row['delivery_fee'] ?? 0),
            'total_amount' => (float) ($row['total_amount'] ?? 0),
            'total' => (float) ($row['total'] ?? $row['total_amount'] ?? 0),
            'currency' => (string) ($row['currency'] ?? 'NGN'),
            'sale_channel' => (string) ($row['sale_channel'] ?? 'ecommerce'),
            'created_by' => (string) ($row['created_by'] ?? 'user'),
            'created_by_user_id' => isset($row['created_by_user_id']) ? (int) $row['created_by_user_id'] : null,
            'customer_id' => isset($row['customer_id']) ? (int) $row['customer_id'] : null,
            'payment_method' => (string) ($row['payment_method'] ?? ''),
            'order_status' => (string) ($row['order_status'] ?? ''),
            'payment_status' => (string) ($row['payment_status'] ?? ''),
            
            'payment_reference' => (string) ($row['payment_reference'] ?? ''),
            'payment_channel' => (string) ($row['payment_channel'] ?? ''),
            'gateway_response' => (string) ($row['gateway_response'] ?? ''),
            'item_count' => (int) ($row['item_count'] ?? 0),
            'created_at' => (string) ($row['created_at'] ?? ''),
            'updated_at' => (string) ($row['updated_at'] ?? ''),
            // frontend-friendly aliases
            'reference' => (string) ($row['payment_reference'] ?? ''),
            'status' => (string) ($row['order_status'] ?? ''),
            'paymentStatus' => (string) ($row['payment_status'] ?? ''),
            'saleChannel' => (string) ($row['sale_channel'] ?? 'ecommerce'),
            'createdBy' => (string) ($row['created_by'] ?? 'user'),
            'paymentMethod' => (string) ($row['payment_method'] ?? ''),
            'total' => (float) ($row['total'] ?? $row['total_amount'] ?? 0),
            'vat' => (float) ($row['tax'] ?? $row['tax_amount'] ?? 0),
            'deliveryFee' => (float) ($row['delivery_fee'] ?? 0),
            'createdAt' => (string) ($row['created_at'] ?? ''),
            'customer' => [
                'name' => (string) ($row['customer_name'] ?? ''),
                'email' => (string) ($row['customer_email'] ?? ''),
                'phone' => (string) ($row['customer_phone'] ?? $row['delivery_phone'] ?? ''),
            ],
            'items' => $rowItems,
        ];
    }
}
