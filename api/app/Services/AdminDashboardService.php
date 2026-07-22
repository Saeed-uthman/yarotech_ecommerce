<?php

declare(strict_types=1);

namespace App\Services;

use App\Core\Database;
use App\Models\Notification;
use App\Models\Product;

final class AdminDashboardService
{
    private Product $products;
    private Notification $notifications;

    public function __construct(
        ?Product $products = null,
        ?Notification $notifications = null
    ) {
        $this->products = $products ?? new Product();
        $this->notifications = $notifications ?? new Notification();
    }

    /**
     * @return array<string,mixed>
     */
    public function build(): array
    {
        $db = Database::connection();
        $products = $this->products->listAll();
        $totalProducts = count($products);
        $totalInventory = (int) array_sum(array_map(function($p) {
            return (int) ($p['stock_quantity'] ?? 0);
        }, $products));
        $totalInventoryValue = (float) array_sum(array_map(function($p) {
            return (float) ($p['cost_price'] ?? 0) * (int) ($p['stock_quantity'] ?? 0);
        }, $products));
        $lowStockAlerts = (int) count(array_filter($products, function($p) {
            $threshold = max(0, (int) ($p['minimum_stock'] ?? 5));
            return (int) ($p['stock_quantity'] ?? 0) <= $threshold;
        }));

        $missingMeta = (int) count(array_filter($products, function($p) {
            return empty($p['short_description']) || empty($p['full_description']);
        }));

        $stats = $db->query(
            "SELECT
                SUM(CASE WHEN payment_status = 'success' THEN 1 ELSE 0 END) AS total_orders,
                COALESCE(SUM(CASE WHEN payment_status = 'success' THEN total_amount ELSE 0 END), 0) AS total_revenue,
                SUM(CASE WHEN payment_status = 'success' AND sale_channel = 'ecommerce' THEN 1 ELSE 0 END) AS ecommerce_orders,
                SUM(CASE WHEN payment_status = 'success' AND sale_channel = 'pos' THEN 1 ELSE 0 END) AS pos_orders
             FROM orders"
        )->fetch() ?: ['total_orders' => 0, 'total_revenue' => 0, 'ecommerce_orders' => 0, 'pos_orders' => 0];

        $profitStats = $db->query(
            "SELECT COALESCE(SUM((oi.unit_price_snapshot - COALESCE(p.cost_price, 0)) * oi.quantity), 0) AS net_profit
             FROM order_items oi
             JOIN products p ON p.id = oi.product_id
             JOIN orders o ON o.id = oi.order_id
             WHERE o.payment_status = 'success'"
        )->fetch();
        $netProfit = (float) ($profitStats['net_profit'] ?? 0);

        $customerStats = $db->query(
            "SELECT COUNT(*) AS total_customers
             FROM users
             WHERE role = 'user'"
        )->fetch() ?: ['total_customers' => 0];

        $supportStats = $db->query(
            "SELECT COUNT(*) AS support_messages
             FROM contact_messages
             WHERE status IN ('open','in_progress')"
        )->fetch() ?: ['support_messages' => 0];

        $recentPayments = $db->query(
            "SELECT p.id, p.order_id, p.reference, p.amount, p.currency, p.status, p.channel,
                    p.gateway_response, p.created_at,
                    o.order_number, o.customer_email
             FROM payments p
             LEFT JOIN orders o ON o.id = p.order_id
             ORDER BY p.created_at DESC, p.id DESC
             LIMIT 10"
        )->fetchAll();

        $unread = $this->notifications->countUnreadForAdmin();
        $totalRevenue = (float) ($stats['total_revenue'] ?? 0);

        return [
            'metrics' => [
                'total_products'                      => $totalProducts,
                'products_missing_ecommerce_details'  => $missingMeta,
                'total_inventory'                     => $totalInventory,
                'total_inventory_value'               => $totalInventoryValue,
                'total_orders'                        => (int) ($stats['total_orders'] ?? 0),
                'ecommerce_orders'                    => (int) ($stats['ecommerce_orders'] ?? 0),
                'pos_orders'                          => (int) ($stats['pos_orders'] ?? 0),
                'total_customers'                     => (int) ($customerStats['total_customers'] ?? 0),
                'total_revenue'                       => round($totalRevenue, 2),
                'net_profit'                          => round($netProfit, 2),
                'low_stock_alerts'                    => $lowStockAlerts,
                'recent_payments'                     => count($recentPayments),
                'support_messages'                    => (int) ($supportStats['support_messages'] ?? 0),
                'unread_notifications'                => $unread,
            ],
            'recentPayments' => array_map(function (array $p): array {
                return [
                    'id'              => (string) $p['id'],
                    'orderId'         => (string) ($p['order_number'] ?? $p['order_id']),
                    'reference'       => (string) ($p['reference'] ?? ''),
                    'amount'          => (float) ($p['amount'] ?? 0),
                    'currency'        => (string) ($p['currency'] ?? 'NGN'),
                    'status'          => (string) ($p['status'] ?? 'pending'),
                    'channel'         => (string) ($p['channel'] ?? 'card'),
                    'gatewayResponse' => (string) ($p['gateway_response'] ?? ''),
                    'customerEmail'   => (string) ($p['customer_email'] ?? ''),
                    'createdAt'       => $p['created_at'] ? (new \DateTime($p['created_at']))->getTimestamp() * 1000 : time() * 1000,
                ];
            }, $recentPayments),
            'recentOrders' => array_map(function (array $o): array {
                return [
                    'id'         => (string) ($o['order_number'] ?? $o['id']),
                    'status'     => (string) ($o['order_status'] ?? 'pending'),
                    'total'      => (float) ($o['total_amount'] ?? 0),
                    'createdAt'  => $o['created_at'] ? (new \DateTime($o['created_at']))->getTimestamp() * 1000 : time() * 1000,
                    'customer'   => [
                        'name'  => (string) ($o['customer_name'] ?? 'Guest'),
                        'email' => (string) ($o['customer_email'] ?? ''),
                    ]
                ];
            }, $db->query("SELECT * FROM orders ORDER BY created_at DESC LIMIT 10")->fetchAll()),
            'lowStock' => array_values(array_map(function (array $p): array {
                $qty = (int) ($p['stock_quantity'] ?? 0);
                $min = (int) ($p['minimum_stock'] ?? 5);
                return [
                    'posId'    => (string) $p['id'],
                    'name'     => (string) $p['name'],
                    'sku'      => (string) $p['sku'],
                    'stock'    => $qty,
                    'threshold'=> $min,
                    'severity' => ($qty <= 0) ? 'out' : ($qty <= max(1, floor($min/2)) ? 'critical' : 'low'),
                ];
            }, array_filter($products, function($p) {
                return (int) ($p['stock_quantity'] ?? 0) <= max(0, (int) ($p['minimum_stock'] ?? 5));
            }))),
            'charts' => [
                'low_stock_products' => array_values(array_map(function (array $p): array {
                    return [
                        'product_id'     => (string) ($p['id'] ?? ''),
                        'product_id' => (string) ($p['id'] ?? ''),
                        'name'           => (string) ($p['name'] ?? ''),
                        'sku'            => (string) ($p['sku'] ?? ''),
                        'stock_quantity' => (int) ($p['stock_quantity'] ?? 0),
                        'minimum_stock'  => max(0, (int) ($p['minimum_stock'] ?? 5)),
                    ];
                }, array_filter($products, function($p) {
                    $threshold = max(0, (int) ($p['minimum_stock'] ?? 5));
                    return (int) ($p['stock_quantity'] ?? 0) <= $threshold;
                }))),
            ],
        ];
    }
}
