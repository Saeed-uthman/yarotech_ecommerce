<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\CartIdentity;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Models\Order;
use App\Models\User;
use App\Services\InvoicePdfService;
use App\Services\OrderService;

/**
 * InvoiceController — serves invoice data (JSON) and PDF downloads.
 *
 * Endpoints:
 *   GET /api/invoices/data?order_number=...   (JSON invoice payload)
 *   GET /api/invoices/pdf?order_number=...    (PDF binary download)
 */
final class InvoiceController extends BaseController
{
    public function __construct(
        private Order $orders = new Order(),
        private OrderService $service = new OrderService(),
    ) {}

    /** GET /api/invoices/data?order_number=... */
    public function data(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) Response::unauthorized();

        $orderNumber = (string) Request::query('order_number', '');
        if ($orderNumber === '') {
            Response::validation(['order_number' => 'order_number is required.']);
        }

        $order = $this->orders->findByNumber($orderNumber);
        if (!$order) Response::notFound('Order not found.');
        if ((int) $order['user_id'] !== $userId) {
            Response::forbidden('You do not own this order.');
        }

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

    /** GET /api/invoices/pdf?order_number=... */
    public function pdf(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) Response::unauthorized();

        $orderNumber = (string) Request::query('order_number', '');
        if ($orderNumber === '') {
            Response::validation(['order_number' => 'order_number is required.']);
        }

        $order = $this->orders->findByNumber($orderNumber);
        if (!$order) Response::notFound('Order not found.');
        if ((int) $order['user_id'] !== $userId) {
            Response::forbidden('You do not own this order.');
        }

        $envelope = $this->service->buildOrderEnvelope($order);
        $user = (new User())->find((string) $userId);

        $invoiceService = new InvoicePdfService();
        $pdfContent = $invoiceService->generateFromOrder(
            $envelope['order'],
            $envelope['items'],
            $user ?? ['name' => $order['customer_name'], 'email' => $order['customer_email']]
        );

        $filename = 'YAROTECH-Invoice-' . $order['order_number'] . '.pdf';
        $invoiceService->streamDownload($pdfContent, $filename);
    }
}
