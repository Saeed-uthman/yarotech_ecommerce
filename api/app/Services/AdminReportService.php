<?php

declare(strict_types=1);

namespace App\Services;

use App\Core\Database;

final class AdminReportService
{
    /**
     * @param array<string,mixed>|string $input
     * @return array<string,mixed>
     */
    public function build($input): array
    {
        $rawFilters = is_array($input) ? $input : ['period' => (string) $input];
        $filters = $this->normalizeFilters($rawFilters);

        $db = Database::connection();
        $bucket = $this->bucketParams($filters['period']);

        $summary = $this->summary($db, $filters);
        $series = $this->salesSeries($db, $filters, $bucket['orders_expr']);
        $productPerformance = $this->bestSellingProducts($db, $filters);
        $paymentBreakdown = $this->paymentMethodBreakdown($db, $filters);
        $profit = $this->profit($db, $filters);
        $inventoryMovements = $this->inventoryMovements($db, $filters, $bucket['movements_expr']);
        $lowStock = $this->lowStockProducts($db, $filters);
        $failedPayments = $this->failedPayments($db, $filters);
        $orderStatusSummary = $this->orderStatusSummary($db, $filters);
        $transactions = $this->transactionHistory($db, $filters);

        return [
            'filters' => [
                'period' => $filters['period'],
                'sale_channel' => $filters['sale_channel'],
                'created_by' => $filters['created_by'],
                'payment_method' => $filters['payment_method'],
                'payment_status' => $filters['payment_status'],
                'created_by_user_id' => $filters['created_by_user_id'],
                'product_id' => $filters['product_id'],
                'category' => $filters['category'],
                'start_date' => $filters['start_date'],
                'end_date' => $filters['end_date'],
            ],
            'summary' => $summary,
            'sales' => [
                'total' => $summary['total_sales'],
                'ecommerce' => $summary['ecommerce_sales'],
                'pos' => $summary['pos_sales'],
                'total_orders' => $summary['total_orders'],
                'successful_orders' => $summary['successful_orders'],
                'ecommerce_orders' => $summary['ecommerce_orders'],
                'pos_orders' => $summary['pos_orders'],
            ],
            'payment_method_breakdown' => $paymentBreakdown,
            'profit' => $profit,
            'inventory_movements' => $inventoryMovements,
            'best_selling_products' => $productPerformance,
            'low_stock_products' => $lowStock,
            'failed_payments' => $failedPayments,
            'order_status_summary' => $orderStatusSummary,
            'transactions' => $transactions,
            // chart-friendly blocks
            'charts' => [
                'sales_over_time' => $series,
                'payment_method_breakdown' => $paymentBreakdown['items'],
                'inventory_movement_trend' => $inventoryMovements['trend'],
                'best_selling_products' => array_map(function (array $r): array {
                    return [
                        'label' => $r['name'],
                        'product_id' => $r['product_id'],
                        'units' => $r['units_sold'],
                        'revenue' => $r['revenue'],
                    ];
                }, $productPerformance),
                'low_stock_products' => array_map(function (array $r): array {
                    return [
                        'label' => $r['name'],
                        'product_id' => $r['product_id'],
                        'stock_quantity' => $r['stock_quantity'],
                        'minimum_stock' => $r['minimum_stock'],
                    ];
                }, $lowStock['items']),
                'order_status_summary' => $orderStatusSummary['items'],
                'failed_payments_over_time' => $failedPayments['trend'],
            ],
            // backward-compatible aliases used by current frontend
            'period' => $filters['period'],
            'series' => $series,
            'product_performance' => $productPerformance,
            'payment' => [
                'success' => $summary['successful_orders'],
                'failed' => $failedPayments['count'],
                'pending' => $summary['pending_orders'],
            ],
            'channel_mix' => array_map(function (array $r): array {
                return [
                    'channel' => $r['payment_method'],
                    'count' => $r['orders'],
                    'amount' => $r['amount'],
                    'percent' => $r['percent'],
                ];
            }, $paymentBreakdown['items']),
            'channel_mix_totals' => [
                'success_count' => array_sum(array_map(fn($r) => (int) ($r['orders'] ?? 0), $paymentBreakdown['items'])),
                'success_amount' => $paymentBreakdown['total_amount'],
            ],
            'vat' => [
                'total_vat' => $summary['total_tax'],
                'taxed_orders' => $summary['successful_orders'],
            ],
            'delivery' => [
                'total_delivery_fee' => $summary['total_delivery_fee'],
                'avg_delivery_fee' => $summary['successful_orders'] > 0
                    ? round($summary['total_delivery_fee'] / max(1, $summary['successful_orders']), 2)
                    : 0.0,
            ],
            'pos_sync' => ['success' => 0, 'failed' => 0],
            'totals' => [
                'revenue' => $summary['total_sales'],
                'orders' => $summary['total_orders'],
                'customers' => $summary['unique_customers'],
                'vat' => $summary['total_tax'],
                'avgOrderValue' => $summary['avg_order_value'],
            ],
            'productPerformance' => array_map(function (array $r): array {
                return [
                    'name' => $r['name'],
                    'revenue' => $r['revenue'],
                    'units' => $r['units_sold'],
                ];
            }, $productPerformance),
            'channelMix' => array_map(function (array $r): array {
                return [
                    'channel' => $r['payment_method'],
                    'value' => $r['percent'],
                ];
            }, $paymentBreakdown['items']),
            // explicit transaction history alias
            'transaction_history' => $transactions,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function normalizeFilters(array $filters): array
    {
        $period = strtolower(trim((string) ($filters['period'] ?? 'monthly')));
        if (!in_array($period, ['weekly', 'monthly', 'quarterly', 'annual'], true)) {
            $period = 'monthly';
        }

        $saleChannel = strtolower(trim((string) ($filters['sale_channel'] ?? '')));
        if (!in_array($saleChannel, ['ecommerce', 'pos'], true)) {
            $saleChannel = null;
        }

        $createdBy = strtolower(trim((string) ($filters['created_by'] ?? '')));
        if (!in_array($createdBy, ['user', 'admin', 'staff'], true)) {
            $createdBy = null;
        }

        $paymentStatus = strtolower(trim((string) ($filters['payment_status'] ?? '')));
        if (!in_array($paymentStatus, ['pending', 'success', 'failed', 'abandoned'], true)) {
            $paymentStatus = null;
        }

        $paymentMethod = trim((string) ($filters['payment_method'] ?? ''));
        $paymentMethod = $paymentMethod !== '' ? $paymentMethod : null;

        $createdByUserId = filter_var($filters['created_by_user_id'] ?? null, FILTER_VALIDATE_INT);
        $createdByUserId = ($createdByUserId !== false && (int) $createdByUserId > 0) ? (int) $createdByUserId : null;

        $productId = trim((string) ($filters['product_id'] ?? ''));
        $productId = $productId !== '' ? $productId : null;

        $category = trim((string) ($filters['category'] ?? ''));
        $category = $category !== '' ? $category : null;

        $txnLimit = filter_var($filters['transaction_limit'] ?? 100, FILTER_VALIDATE_INT);
        $txnLimit = $txnLimit !== false ? (int) $txnLimit : 100;
        $txnLimit = max(10, min(500, $txnLimit));

        [$defaultStart, $defaultEnd] = $this->defaultDateWindow($period);
        $start = $this->normalizeDateStart($filters['start_date'] ?? null) ?? $defaultStart;
        $end = $this->normalizeDateEnd($filters['end_date'] ?? null) ?? $defaultEnd;

        if (strtotime($start) > strtotime($end)) {
            [$start, $end] = [$end, $start];
        }

        return [
            'period' => $period,
            'sale_channel' => $saleChannel,
            'created_by' => $createdBy,
            'payment_method' => $paymentMethod,
            'payment_status' => $paymentStatus,
            'created_by_user_id' => $createdByUserId,
            'product_id' => $productId,
            'category' => $category,
            'start_date' => $start,
            'end_date' => $end,
            'transaction_limit' => $txnLimit,
        ];
    }

    /**
     * @return array{0:string,1:string}
     */
    private function defaultDateWindow(string $period): array
    {
        $now = new \DateTimeImmutable('now');
        switch ($period) {
            case 'weekly':
                return [$now->modify('-6 days')->format('Y-m-d 00:00:00'), $now->format('Y-m-d 23:59:59')];
            case 'quarterly':
                return [$now->modify('-89 days')->format('Y-m-d 00:00:00'), $now->format('Y-m-d 23:59:59')];
            case 'annual':
                return [$now->modify('-364 days')->format('Y-m-d 00:00:00'), $now->format('Y-m-d 23:59:59')];
            default:
                return [$now->modify('-29 days')->format('Y-m-d 00:00:00'), $now->format('Y-m-d 23:59:59')];
        }
    }

    private function normalizeDateStart($raw): ?string
    {
        $val = trim((string) ($raw ?? ''));
        if ($val === '') return null;
        try {
            return (new \DateTimeImmutable($val))->format('Y-m-d 00:00:00');
        } catch (\Throwable) {
            return null;
        }
    }

    private function normalizeDateEnd($raw): ?string
    {
        $val = trim((string) ($raw ?? ''));
        if ($val === '') return null;
        try {
            return (new \DateTimeImmutable($val))->format('Y-m-d 23:59:59');
        } catch (\Throwable) {
            return null;
        }
    }

    /**
     * @return array{orders_expr:string,movements_expr:string}
     */
    private function bucketParams(string $period): array
    {
        if (in_array($period, ['quarterly', 'annual'], true)) {
            return [
                'orders_expr' => "DATE_FORMAT(o.created_at, '%Y-%m')",
                'movements_expr' => "DATE_FORMAT(im.created_at, '%Y-%m')",
            ];
        }

        return [
            'orders_expr' => "DATE_FORMAT(o.created_at, '%Y-%m-%d')",
            'movements_expr' => "DATE_FORMAT(im.created_at, '%Y-%m-%d')",
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array{sql:string,params:array<string,mixed>}
     */
    private function orderScope(array $filters, string $alias = 'o'): array
    {
        $where = [
            "{$alias}.created_at >= :order_start_date",
            "{$alias}.created_at <= :order_end_date",
        ];
        $params = [
            ':order_start_date' => $filters['start_date'],
            ':order_end_date' => $filters['end_date'],
        ];

        if ($filters['sale_channel'] !== null) {
            $where[] = "{$alias}.sale_channel = :order_sale_channel";
            $params[':order_sale_channel'] = $filters['sale_channel'];
        }
        if ($filters['created_by'] !== null) {
            $where[] = "{$alias}.created_by = :order_created_by";
            $params[':order_created_by'] = $filters['created_by'];
        }
        if ($filters['payment_method'] !== null) {
            $where[] = "{$alias}.payment_method = :order_payment_method";
            $params[':order_payment_method'] = $filters['payment_method'];
        }
        if ($filters['payment_status'] !== null) {
            $where[] = "{$alias}.payment_status = :order_payment_status";
            $params[':order_payment_status'] = $filters['payment_status'];
        }
        if ($filters['created_by_user_id'] !== null) {
            $where[] = "{$alias}.created_by_user_id = :order_created_by_user_id";
            $params[':order_created_by_user_id'] = $filters['created_by_user_id'];
        }
        if ($filters['product_id'] !== null || $filters['category'] !== null) {
            $exists = [
                "SELECT 1 FROM order_items oi",
                "LEFT JOIN products pr ON pr.id = oi.product_id",
                "WHERE oi.order_id = {$alias}.id",
            ];
            if ($filters['product_id'] !== null) {
                $exists[] = "AND oi.product_id = :order_product_id";
                $params[':order_product_id'] = $filters['product_id'];
            }
            if ($filters['category'] !== null) {
                $exists[] = "AND pr.category = :order_category";
                $params[':order_category'] = $filters['category'];
            }
            $where[] = 'EXISTS (' . implode(' ', $exists) . ')';
        }

        return [
            'sql' => implode(' AND ', $where),
            'params' => $params,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array{sql:string,params:array<string,mixed>}
     */
    private function movementScope(array $filters): array
    {
        $where = [
            "im.created_at >= :move_start_date",
            "im.created_at <= :move_end_date",
        ];
        $params = [
            ':move_start_date' => $filters['start_date'],
            ':move_end_date' => $filters['end_date'],
        ];

        if ($filters['created_by'] !== null) {
            $where[] = "im.created_by = :move_created_by";
            $params[':move_created_by'] = $filters['created_by'];
        }
        if ($filters['created_by_user_id'] !== null) {
            $where[] = "im.created_by_user_id = :move_created_by_user_id";
            $params[':move_created_by_user_id'] = $filters['created_by_user_id'];
        }
        if ($filters['product_id'] !== null) {
            $where[] = "im.product_id = :move_product_id";
            $params[':move_product_id'] = $filters['product_id'];
        }
        if ($filters['category'] !== null) {
            $where[] = "pr.category = :move_category";
            $params[':move_category'] = $filters['category'];
        }
        if ($filters['sale_channel'] === 'ecommerce') {
            $where[] = "im.movement_type = 'ecommerce_sale'";
        } elseif ($filters['sale_channel'] === 'pos') {
            $where[] = "im.movement_type = 'pos_sale'";
        }

        return [
            'sql' => implode(' AND ', $where),
            'params' => $params,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function summary(\PDO $db, array $filters): array
    {
        $scope = $this->orderScope($filters, 'o');
        $stmt = $db->prepare(
            "SELECT
                COUNT(*) AS total_orders,
                SUM(CASE WHEN o.payment_status = 'success' THEN 1 ELSE 0 END) AS successful_orders,
                SUM(CASE WHEN o.payment_status = 'pending' THEN 1 ELSE 0 END) AS pending_orders,
                SUM(CASE WHEN o.payment_status = 'success' AND o.sale_channel = 'ecommerce' THEN 1 ELSE 0 END) AS ecommerce_orders,
                SUM(CASE WHEN o.payment_status = 'success' AND o.sale_channel = 'pos' THEN 1 ELSE 0 END) AS pos_orders,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' THEN o.total_amount ELSE 0 END), 0) AS total_sales,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' AND o.sale_channel = 'ecommerce' THEN o.total_amount ELSE 0 END), 0) AS ecommerce_sales,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' AND o.sale_channel = 'pos' THEN o.total_amount ELSE 0 END), 0) AS pos_sales,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' THEN o.tax_amount ELSE 0 END), 0) AS total_tax,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' THEN o.delivery_fee ELSE 0 END), 0) AS total_delivery_fee,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' THEN o.discount ELSE 0 END), 0) AS total_discount,
                COUNT(DISTINCT COALESCE(o.customer_id, o.user_id)) AS unique_customers
             FROM orders o
             WHERE {$scope['sql']}"
        );
        $stmt->execute($scope['params']);
        $row = $stmt->fetch() ?: [];

        $successful = (int) ($row['successful_orders'] ?? 0);
        $totalSales = (float) ($row['total_sales'] ?? 0);

        return [
            'total_orders' => (int) ($row['total_orders'] ?? 0),
            'successful_orders' => $successful,
            'pending_orders' => (int) ($row['pending_orders'] ?? 0),
            'ecommerce_orders' => (int) ($row['ecommerce_orders'] ?? 0),
            'pos_orders' => (int) ($row['pos_orders'] ?? 0),
            'total_sales' => round($totalSales, 2),
            'ecommerce_sales' => round((float) ($row['ecommerce_sales'] ?? 0), 2),
            'pos_sales' => round((float) ($row['pos_sales'] ?? 0), 2),
            'total_tax' => round((float) ($row['total_tax'] ?? 0), 2),
            'total_delivery_fee' => round((float) ($row['total_delivery_fee'] ?? 0), 2),
            'total_discount' => round((float) ($row['total_discount'] ?? 0), 2),
            'unique_customers' => (int) ($row['unique_customers'] ?? 0),
            'avg_order_value' => $successful > 0 ? round($totalSales / $successful, 2) : 0.0,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<int,array<string,mixed>>
     */
    private function salesSeries(\PDO $db, array $filters, string $bucketExpression): array
    {
        $scope = $this->orderScope($filters, 'o');
        $stmt = $db->prepare(
            "SELECT
                {$bucketExpression} AS bucket,
                SUM(CASE WHEN o.payment_status = 'success' THEN 1 ELSE 0 END) AS successful_orders,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' THEN o.total_amount ELSE 0 END), 0) AS total_sales,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' AND o.sale_channel = 'ecommerce' THEN o.total_amount ELSE 0 END), 0) AS ecommerce_sales,
                COALESCE(SUM(CASE WHEN o.payment_status = 'success' AND o.sale_channel = 'pos' THEN o.total_amount ELSE 0 END), 0) AS pos_sales
             FROM orders o
             WHERE {$scope['sql']}
             GROUP BY bucket
             ORDER BY bucket ASC"
        );
        $stmt->execute($scope['params']);
        $rows = $stmt->fetchAll();

        return array_map(function (array $row): array {
            return [
                'label' => (string) ($row['bucket'] ?? ''),
                'bucket' => (string) ($row['bucket'] ?? ''),
                'total_sales' => (float) ($row['total_sales'] ?? 0),
                'ecommerce_sales' => (float) ($row['ecommerce_sales'] ?? 0),
                'pos_sales' => (float) ($row['pos_sales'] ?? 0),
                'orders' => (int) ($row['successful_orders'] ?? 0),
            ];
        }, $rows);
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function paymentMethodBreakdown(\PDO $db, array $filters): array
    {
        $scope = $this->orderScope($filters, 'o');
        $stmt = $db->prepare(
            "SELECT
                COALESCE(NULLIF(o.payment_method, ''), 'unknown') AS payment_method,
                COUNT(*) AS orders,
                COALESCE(SUM(o.total_amount), 0) AS amount
             FROM orders o
             WHERE {$scope['sql']}
               AND o.payment_status = 'success'
             GROUP BY payment_method
             ORDER BY amount DESC, orders DESC"
        );
        $stmt->execute($scope['params']);
        $rows = $stmt->fetchAll();
        $totalAmount = array_sum(array_map(fn($r) => (float) ($r['amount'] ?? 0), $rows));

        $items = array_map(function (array $r) use ($totalAmount): array {
            $amount = (float) ($r['amount'] ?? 0);
            return [
                'payment_method' => (string) ($r['payment_method'] ?? 'unknown'),
                'orders' => (int) ($r['orders'] ?? 0),
                'amount' => round($amount, 2),
                'percent' => $totalAmount > 0 ? round(($amount / $totalAmount) * 100, 2) : 0.0,
            ];
        }, $rows);

        return [
            'items' => $items,
            'total_amount' => round($totalAmount, 2),
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<int,array<string,mixed>>
     */
    private function bestSellingProducts(\PDO $db, array $filters): array
    {
        $scope = $this->orderScope($filters, 'o');
        $stmt = $db->prepare(
            "SELECT
                oi.product_id AS product_id,
                MAX(oi.product_name_snapshot) AS name,
                MAX(COALESCE(pr.category, '')) AS category,
                COALESCE(SUM(oi.quantity), 0) AS units_sold,
                COALESCE(SUM(oi.line_total), 0) AS revenue
             FROM order_items oi
             INNER JOIN orders o ON o.id = oi.order_id
             LEFT JOIN products pr ON pr.id = oi.product_id
             WHERE {$scope['sql']}
               AND o.payment_status = 'success'
             GROUP BY oi.product_id
             ORDER BY units_sold DESC, revenue DESC
             LIMIT 20"
        );
        $stmt->execute($scope['params']);
        $rows = $stmt->fetchAll();

        return array_map(function (array $r): array {
            return [
                'product_id' => (string) ($r['product_id'] ?? ''),
                'name' => (string) ($r['name'] ?? ''),
                'category' => (string) ($r['category'] ?? ''),
                'units_sold' => (int) ($r['units_sold'] ?? 0),
                'revenue' => round((float) ($r['revenue'] ?? 0), 2),
            ];
        }, $rows);
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function profit(\PDO $db, array $filters): array
    {
        $scope = $this->orderScope($filters, 'o');
        $stmt = $db->prepare(
            "SELECT
                COALESCE(SUM(oi.line_total), 0) AS sales_revenue,
                COALESCE(SUM(COALESCE(pr.cost_price, 0) * oi.quantity), 0) AS cogs
             FROM order_items oi
             INNER JOIN orders o ON o.id = oi.order_id
             LEFT JOIN products pr ON pr.id = oi.product_id
             WHERE {$scope['sql']}
               AND o.payment_status = 'success'"
        );
        $stmt->execute($scope['params']);
        $row = $stmt->fetch() ?: [];

        $revenue = (float) ($row['sales_revenue'] ?? 0);
        $cogs = (float) ($row['cogs'] ?? 0);
        $grossProfit = $revenue - $cogs;

        return [
            'sales_revenue' => round($revenue, 2),
            'cost_of_goods_sold' => round($cogs, 2),
            'gross_profit' => round($grossProfit, 2),
            'gross_margin_percent' => $revenue > 0 ? round(($grossProfit / $revenue) * 100, 2) : 0.0,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function inventoryMovements(\PDO $db, array $filters, string $bucketExpression): array
    {
        $scope = $this->movementScope($filters);

        $summaryStmt = $db->prepare(
            "SELECT
                COUNT(*) AS movement_count,
                COALESCE(SUM(CASE WHEN im.quantity > 0 THEN im.quantity ELSE 0 END), 0) AS total_units_in,
                COALESCE(SUM(CASE WHEN im.quantity < 0 THEN ABS(im.quantity) ELSE 0 END), 0) AS total_units_out,
                COALESCE(SUM(ABS(im.quantity)), 0) AS total_units_moved
             FROM inventory_movements im
             LEFT JOIN products pr ON pr.id = im.product_id
             WHERE {$scope['sql']}"
        );
        $summaryStmt->execute($scope['params']);
        $summaryRow = $summaryStmt->fetch() ?: [];

        $typeStmt = $db->prepare(
            "SELECT
                im.movement_type,
                COUNT(*) AS movement_count,
                COALESCE(SUM(im.quantity), 0) AS net_quantity,
                COALESCE(SUM(ABS(im.quantity)), 0) AS absolute_quantity
             FROM inventory_movements im
             LEFT JOIN products pr ON pr.id = im.product_id
             WHERE {$scope['sql']}
             GROUP BY im.movement_type
             ORDER BY movement_count DESC"
        );
        $typeStmt->execute($scope['params']);
        $types = array_map(function (array $r): array {
            return [
                'movement_type' => (string) ($r['movement_type'] ?? ''),
                'movement_count' => (int) ($r['movement_count'] ?? 0),
                'net_quantity' => (int) ($r['net_quantity'] ?? 0),
                'absolute_quantity' => (int) ($r['absolute_quantity'] ?? 0),
            ];
        }, $typeStmt->fetchAll());

        $trendStmt = $db->prepare(
            "SELECT
                {$bucketExpression} AS bucket,
                COALESCE(SUM(CASE WHEN im.quantity > 0 THEN im.quantity ELSE 0 END), 0) AS units_in,
                COALESCE(SUM(CASE WHEN im.quantity < 0 THEN ABS(im.quantity) ELSE 0 END), 0) AS units_out
             FROM inventory_movements im
             LEFT JOIN products pr ON pr.id = im.product_id
             WHERE {$scope['sql']}
             GROUP BY bucket
             ORDER BY bucket ASC"
        );
        $trendStmt->execute($scope['params']);
        $trend = array_map(function (array $r): array {
            return [
                'bucket' => (string) ($r['bucket'] ?? ''),
                'label' => (string) ($r['bucket'] ?? ''),
                'units_in' => (int) ($r['units_in'] ?? 0),
                'units_out' => (int) ($r['units_out'] ?? 0),
            ];
        }, $trendStmt->fetchAll());

        return [
            'movement_count' => (int) ($summaryRow['movement_count'] ?? 0),
            'total_units_in' => (int) ($summaryRow['total_units_in'] ?? 0),
            'total_units_out' => (int) ($summaryRow['total_units_out'] ?? 0),
            'total_units_moved' => (int) ($summaryRow['total_units_moved'] ?? 0),
            'by_type' => $types,
            'trend' => $trend,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function lowStockProducts(\PDO $db, array $filters): array
    {
        $where = ['p.stock_quantity <= p.minimum_stock'];
        $params = [];
        if ($filters['product_id'] !== null) {
            $where[] = 'p.id = :low_product_id';
            $params[':low_product_id'] = $filters['product_id'];
        }
        if ($filters['category'] !== null) {
            $where[] = 'p.category = :low_category';
            $params[':low_category'] = $filters['category'];
        }

        $stmt = $db->prepare(
            "SELECT p.id, p.name, p.sku, p.category, p.stock_quantity, p.minimum_stock, p.status
             FROM products p
             WHERE " . implode(' AND ', $where) . "
             ORDER BY p.stock_quantity ASC, p.minimum_stock DESC, p.name ASC
             LIMIT 100"
        );
        $stmt->execute($params);
        $rows = $stmt->fetchAll();

        return [
            'count' => count($rows),
            'items' => array_map(function (array $r): array {
                return [
                    'product_id' => (string) ($r['id'] ?? ''),
                    'name' => (string) ($r['name'] ?? ''),
                    'sku' => (string) ($r['sku'] ?? ''),
                    'category' => (string) ($r['category'] ?? ''),
                    'stock_quantity' => (int) ($r['stock_quantity'] ?? 0),
                    'minimum_stock' => (int) ($r['minimum_stock'] ?? 0),
                    'status' => (string) ($r['status'] ?? ''),
                ];
            }, $rows),
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function failedPayments(\PDO $db, array $filters): array
    {
        $scope = $this->orderScope($filters, 'o');
        $summaryStmt = $db->prepare(
            "SELECT
                COUNT(*) AS failed_count,
                COALESCE(SUM(p.amount), 0) AS failed_amount
             FROM payments p
             INNER JOIN orders o ON o.id = p.order_id
             WHERE {$scope['sql']}
               AND p.status IN ('failed', 'abandoned')"
        );
        $summaryStmt->execute($scope['params']);
        $summary = $summaryStmt->fetch() ?: [];

        $trendStmt = $db->prepare(
            "SELECT
                DATE_FORMAT(p.created_at, '%Y-%m-%d') AS bucket,
                COUNT(*) AS count,
                COALESCE(SUM(p.amount), 0) AS amount
             FROM payments p
             INNER JOIN orders o ON o.id = p.order_id
             WHERE {$scope['sql']}
               AND p.status IN ('failed', 'abandoned')
             GROUP BY bucket
             ORDER BY bucket ASC"
        );
        $trendStmt->execute($scope['params']);
        $trend = array_map(function (array $r): array {
            return [
                'bucket' => (string) ($r['bucket'] ?? ''),
                'label' => (string) ($r['bucket'] ?? ''),
                'count' => (int) ($r['count'] ?? 0),
                'amount' => round((float) ($r['amount'] ?? 0), 2),
            ];
        }, $trendStmt->fetchAll());

        return [
            'count' => (int) ($summary['failed_count'] ?? 0),
            'amount' => round((float) ($summary['failed_amount'] ?? 0), 2),
            'trend' => $trend,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function orderStatusSummary(\PDO $db, array $filters): array
    {
        $scope = $this->orderScope($filters, 'o');
        $stmt = $db->prepare(
            "SELECT o.order_status, COUNT(*) AS count
             FROM orders o
             WHERE {$scope['sql']}
             GROUP BY o.order_status
             ORDER BY count DESC"
        );
        $stmt->execute($scope['params']);
        $rows = array_map(function (array $r): array {
            return [
                'status' => (string) ($r['order_status'] ?? ''),
                'count' => (int) ($r['count'] ?? 0),
            ];
        }, $stmt->fetchAll());

        return [
            'total' => array_sum(array_map(fn($r) => (int) ($r['count'] ?? 0), $rows)),
            'items' => $rows,
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array<string,mixed>
     */
    private function transactionHistory(\PDO $db, array $filters): array
    {
        $scope = $this->orderScope($filters, 'o');
        $sql = "SELECT
                    o.id,
                    o.order_number,
                    o.sale_channel,
                    o.created_by,
                    o.created_by_user_id,
                    u.full_name AS created_by_name,
                    o.customer_id,
                    o.customer_name,
                    o.customer_phone,
                    o.customer_email,
                    o.subtotal,
                    o.tax_amount,
                    o.discount,
                    o.delivery_fee,
                    o.total_amount,
                    o.currency,
                    o.payment_method,
                    o.payment_status,
                    o.order_status,
                    o.created_at,
                    o.updated_at,
                    p.reference AS payment_reference,
                    p.status AS payment_record_status,
                    p.paid_at
                FROM orders o
                LEFT JOIN users u ON u.id = o.created_by_user_id
                LEFT JOIN payments p ON p.id = (
                    SELECT p2.id FROM payments p2 WHERE p2.order_id = o.id ORDER BY p2.id DESC LIMIT 1
                )
                WHERE {$scope['sql']}
                ORDER BY o.created_at DESC, o.id DESC
                LIMIT :txn_limit";
        $stmt = $db->prepare($sql);
        foreach ($scope['params'] as $k => $v) {
            if (is_int($v)) {
                $stmt->bindValue($k, $v, \PDO::PARAM_INT);
            } else {
                $stmt->bindValue($k, $v);
            }
        }
        $stmt->bindValue(':txn_limit', (int) $filters['transaction_limit'], \PDO::PARAM_INT);
        $stmt->execute();
        $rows = $stmt->fetchAll();

        return [
            'count' => count($rows),
            'items' => array_map(function (array $r): array {
                return [
                    'id' => (int) ($r['id'] ?? 0),
                    'order_number' => (string) ($r['order_number'] ?? ''),
                    'sale_channel' => (string) ($r['sale_channel'] ?? 'ecommerce'),
                    'created_by' => (string) ($r['created_by'] ?? 'user'),
                    'created_by_user_id' => isset($r['created_by_user_id']) ? (int) $r['created_by_user_id'] : null,
                    'created_by_name' => (string) ($r['created_by_name'] ?? ''),
                    'customer_id' => isset($r['customer_id']) ? (int) $r['customer_id'] : null,
                    'customer_name' => (string) ($r['customer_name'] ?? ''),
                    'customer_phone' => (string) ($r['customer_phone'] ?? ''),
                    'customer_email' => (string) ($r['customer_email'] ?? ''),
                    'subtotal' => (float) ($r['subtotal'] ?? 0),
                    'tax' => (float) ($r['tax_amount'] ?? 0),
                    'discount' => (float) ($r['discount'] ?? 0),
                    'delivery_fee' => (float) ($r['delivery_fee'] ?? 0),
                    'total' => (float) ($r['total_amount'] ?? 0),
                    'currency' => (string) ($r['currency'] ?? 'NGN'),
                    'payment_method' => (string) ($r['payment_method'] ?? ''),
                    'payment_status' => (string) ($r['payment_status'] ?? ''),
                    'order_status' => (string) ($r['order_status'] ?? ''),
                    'payment_reference' => (string) ($r['payment_reference'] ?? ''),
                    'payment_record_status' => (string) ($r['payment_record_status'] ?? ''),
                    'paid_at' => (string) ($r['paid_at'] ?? ''),
                    'created_at' => (string) ($r['created_at'] ?? ''),
                    'updated_at' => (string) ($r['updated_at'] ?? ''),
                    // frontend aliases
                    'saleChannel' => (string) ($r['sale_channel'] ?? 'ecommerce'),
                    'createdBy' => (string) ($r['created_by'] ?? 'user'),
                    'paymentMethod' => (string) ($r['payment_method'] ?? ''),
                    'paymentStatus' => (string) ($r['payment_status'] ?? ''),
                    'orderStatus' => (string) ($r['order_status'] ?? ''),
                    'paymentReference' => (string) ($r['payment_reference'] ?? ''),
                    'createdAt' => (string) ($r['created_at'] ?? ''),
                ];
            }, $rows),
        ];
    }
}
