<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\CartIdentity;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Models\Order;
use App\Services\OrderService;

final class OrderController extends BaseController
{
    public function __construct(
        private Order $orders = new Order(),
        private OrderService $service = new OrderService(),
    ) {}

    /** GET /api/orders */
    public function index(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) Response::unauthorized();
        $this->service->cancelStaleOrders(10);
        $rows = $this->orders->listForUser($userId);
        $this->ok($rows, 'Orders retrieved.');
    }

    /** GET /api/orders/show?order_number=... */
    public function show(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) Response::unauthorized();
        $this->service->cancelStaleOrders(10);
        $order = $this->loadOwned((string) Request::query('order_number', ''), $userId);
        $this->ok($this->service->buildOrderEnvelope($order), 'Order retrieved.');
    }

    /** GET /api/orders/tracking?order_number=... */
    public function tracking(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) Response::unauthorized();
        $this->service->cancelStaleOrders(10);
        $order = $this->loadOwned((string) Request::query('order_number', ''), $userId);
        $envelope = $this->service->buildOrderEnvelope($order);
        $this->ok([
            'order_number' => $order['order_number'],
            'order_status' => $order['order_status'],
            'tracking'     => $envelope['tracking'],
        ], 'Tracking retrieved.');
    }

    /** GET /api/orders/invoice?order_number=...  (returns JSON; PDF is Phase 6) */
    public function invoice(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) Response::unauthorized();
        $order = $this->loadOwned((string) Request::query('order_number', ''), $userId);
        if ($order['payment_status'] !== 'success') {
            Response::error('Invoice is only available after successful payment.', 409);
        }
        $envelope = $this->service->buildOrderEnvelope($order);
        $this->ok([
            'invoice_number' => 'INV-' . $order['order_number'],
            'issued_at'      => $order['updated_at'],
            'order'          => $envelope['order'],
            'items'          => $envelope['items'],
            'payment'        => $envelope['payment'],
        ], 'Invoice ready.');
    }

    /** POST /api/orders/sync-pos  (admin manual retry) */
    public function syncPos(): never
    {
        $orderNumber = (string) Request::input('order_number', '');
        if ($orderNumber === '') Response::validation(['order_number' => 'order_number is required.']);
        $order = $this->orders->findByNumber($orderNumber);
        if (!$order) Response::notFound('Order not found.');
        $envelope = $this->service->retryPosSync((int) $order['id']);
        $this->ok($envelope, 'POS sync attempted.');
    }

    private function loadOwned(string $orderNumber, int $userId): array
    {
        if ($orderNumber === '') Response::validation(['order_number' => 'order_number is required.']);
        $order = $this->orders->findByNumber($orderNumber);
        if (!$order) Response::notFound('Order not found.');
        if ((int) $order['user_id'] !== $userId) Response::forbidden('You do not own this order.');
        return $order;
    }
}
