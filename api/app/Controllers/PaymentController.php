<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\CartIdentity;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Models\PaymentEvent;
use App\Services\OrderService;
use App\Services\PaystackService;
use App\Services\UserActivityLogService;

/**
 * PaymentController - Paystack initialize / verify / webhook.
 */
final class PaymentController extends BaseController
{
    public function __construct(
        private OrderService $orders = new OrderService(),
        private PaystackService $paystack = new PaystackService(),
        private PaymentEvent $events = new PaymentEvent(),
        private UserActivityLogService $activity = new UserActivityLogService(),
    ) {}

    /** POST /api/payments/initialize */
    public function initialize(): never
    {
        $owner = CartIdentity::requireOwner();
        if (empty($owner['user_id'])) {
            Response::unauthorized('You must sign in to pay.');
        }

        $payload = $this->all();
        $result = $this->orders->createFromCheckout($owner, $payload);

        $this->activity->log(
            (int) $owner['user_id'],
            'payment_initialize',
            'success',
            null,
            null,
            [
                'order_number' => (string) ($result['order']['order_number'] ?? ''),
                'reference'    => (string) ($result['payment_reference'] ?? ''),
            ],
        );

        $this->ok([
            'order_number'      => $result['order']['order_number'],
            'reference'         => $result['payment_reference'],
            'authorization_url' => $result['authorization_url'],
            'access_code'       => $result['access_code'],
            'order'             => $result['order'],
        ], 'Payment initialized.');
    }

    /** GET /api/payments/verify?reference=... */
    public function verify(): never
    {
        $reference = (string) Request::query('reference', '');
        if ($reference === '') {
            Response::validation(['reference' => 'reference is required.']);
        }

        $userId = CartIdentity::userId();

        $envelope = $this->orders->finalizeByReference($reference);

        $this->activity->log(
            $userId !== null ? (int) $userId : null,
            'payment_verify',
            'success',
            null,
            null,
            [
                'reference'    => $reference,
                'order_number' => (string) ($envelope['order']['order_number'] ?? ''),
            ],
        );

        $this->ok($envelope, 'Payment verified.');
    }

    /** POST /api/payments/webhook */
    public function webhook(): never
    {
        $raw = file_get_contents('php://input') ?: '';
        $signature = Request::header('X-Paystack-Signature') ?? '';

        if (!$this->paystack->validateWebhookSignature($raw, $signature)) {
            Response::error('Invalid signature', 401);
        }

        $event = json_decode($raw, true) ?: [];
        $type  = (string) ($event['event'] ?? '');
        $data  = $event['data'] ?? [];
        $reference = (string) ($data['reference'] ?? '');

        $this->events->record(null, $reference, "webhook.$type", $event);

        if ($type === 'charge.success' && $reference !== '') {
            $verify = [
                'status'           => 'success',
                'amount'           => isset($data['amount']) ? ((int) $data['amount']) / 100 : 0.0,
                'channel'          => (string) ($data['channel'] ?? ''),
                'paid_at'          => (string) ($data['paid_at'] ?? $data['paidAt'] ?? ''),
                'gateway_response' => (string) ($data['gateway_response'] ?? ''),
                'currency'         => (string) ($data['currency'] ?? 'NGN'),
                'reference'        => $reference,
                'raw'              => $data,
            ];

            try {
                $envelope = $this->orders->finalizeByReference($reference, $verify, 'webhook');
                $this->activity->log(
                    isset($envelope['order']['user_id']) ? (int) $envelope['order']['user_id'] : null,
                    'payment_webhook_success',
                    'success',
                    null,
                    null,
                    [
                        'reference'    => $reference,
                        'order_number' => (string) ($envelope['order']['order_number'] ?? ''),
                    ],
                );
            } catch (\Throwable $e) {
                $this->events->record(null, $reference, 'webhook.error', ['msg' => $e->getMessage()]);
                $this->activity->log(
                    null,
                    'payment_webhook_failed',
                    'failed',
                    null,
                    null,
                    [
                        'reference' => $reference,
                        'error'     => $e->getMessage(),
                    ],
                );
            }
        }

        Response::success(['received' => true], 'Webhook processed.');
    }
}
