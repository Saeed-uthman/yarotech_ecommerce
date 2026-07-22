<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Core\Database;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Models\Payment;

final class AdminPaymentController extends BaseController
{
    private Payment $payments;
    public function __construct(?Payment $payments = null) {
        $this->payments = $payments ?? new Payment();
    }

    /** GET /api/admin/payments/index.php */
    public function index(): never
    {
        $filters = [
            'status'    => Request::query('status'),
            'reference' => Request::query('reference'),
            'order_id'  => Request::query('order_id'),
            'payment_method' => Request::query('payment_method'),
            'sale_channel'   => Request::query('sale_channel'),
            'search'    => Request::query('search'),
            'page'      => Request::query('page', 1),
            'per_page'  => Request::query('per_page', 20),
        ];
        $result = $this->payments->listForAdmin($filters);

        $this->ok([
            'items' => array_map([$this, 'formatPayment'], $result['items']),
            'pagination' => [
                'page' => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total' => (int) $result['total'],
            ],
        ], 'Payments fetched successfully');
    }

    /** GET /api/admin/payments/show.php?id=... */
    public function show(): never
    {
        $id = (int) Request::query('id', 0);
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }
        $row = $this->payments->find($id);
        if (!$row) {
            Response::notFound('Payment not found.');
        }
        $this->ok($this->formatPayment($row), 'Payment fetched successfully');
    }

    /** GET /api/admin/payments/summary.php */
    public function summary(): never
    {
        $db = Database::connection();
        $statusRow = $db->query(
            "SELECT
                SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS success_count,
                SUM(CASE WHEN status = 'failed' OR status = 'abandoned' THEN 1 ELSE 0 END) AS failed_count,
                SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending_count,
                COALESCE(SUM(CASE WHEN status = 'success' THEN amount ELSE 0 END), 0) AS captured_amount
             FROM payments"
        )->fetch() ?: [];

        $channelRows = $db->query(
            "SELECT
                COALESCE(NULLIF(channel,''), 'unknown') AS channel,
                COUNT(*) AS count,
                COALESCE(SUM(amount), 0) AS total_amount
             FROM payments
             WHERE status = 'success'
             GROUP BY channel
             ORDER BY count DESC"
        )->fetchAll();

        $totalSuccess = array_sum(array_map(fn($r) => (int) $r['count'], $channelRows));
        $channels = array_map(function (array $r) use ($totalSuccess): array {
            $count = (int) $r['count'];
            return [
                'channel' => (string) $r['channel'],
                'count' => $count,
                'total_amount' => (float) $r['total_amount'],
                'percent' => $totalSuccess > 0 ? round(($count / $totalSuccess) * 100, 2) : 0.0,
            ];
        }, $channelRows);

        $this->ok([
            'success_count' => (int) ($statusRow['success_count'] ?? 0),
            'failed_count' => (int) ($statusRow['failed_count'] ?? 0),
            'pending_count' => (int) ($statusRow['pending_count'] ?? 0),
            'captured_amount' => (float) ($statusRow['captured_amount'] ?? 0),
            'channels' => $channels,
        ], 'Payment summary fetched successfully');
    }

    /**
     * @param array<string,mixed> $row
     * @return array<string,mixed>
     */
    private function formatPayment(array $row): array
    {
        return [
            'id' => (int) ($row['id'] ?? 0),
            'order_id' => (int) ($row['order_id'] ?? 0),
            'reference' => (string) ($row['reference'] ?? ''),
            'amount' => (float) ($row['amount'] ?? 0),
            'currency' => (string) ($row['currency'] ?? 'NGN'),
            'status' => (string) ($row['status'] ?? 'pending'),
            'channel' => (string) ($row['channel'] ?? ''),
            'payment_method' => (string) ($row['payment_method'] ?? ''),
            'sale_channel' => (string) ($row['sale_channel'] ?? 'ecommerce'),
            'gateway_response' => (string) ($row['gateway_response'] ?? ''),
            'authorization_url' => (string) ($row['authorization_url'] ?? ''),
            'created_at' => (string) ($row['created_at'] ?? ''),
            'paid_at' => (string) ($row['paid_at'] ?? ''),
            'order_number' => (string) ($row['order_number'] ?? ''),
            'customer_email' => (string) ($row['customer_email'] ?? ''),
            // frontend-friendly aliases
            'orderId' => (string) ($row['order_number'] ?? $row['order_id'] ?? ''),
            'customerEmail' => (string) ($row['customer_email'] ?? ''),
            'paymentMethod' => (string) ($row['payment_method'] ?? ''),
            'saleChannel' => (string) ($row['sale_channel'] ?? 'ecommerce'),
            'gatewayResponse' => (string) ($row['gateway_response'] ?? ''),
            'createdAt' => (string) ($row['created_at'] ?? ''),
        ];
    }
}
