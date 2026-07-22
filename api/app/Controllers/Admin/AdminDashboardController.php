<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Services\AdminDashboardService;

final class AdminDashboardController extends BaseController
{
    private AdminDashboardService $service;
    public function __construct(?AdminDashboardService $service = null) {
        $this->service = $service ?? new AdminDashboardService();
    }

    /** GET /api/admin/dashboard.php */
    public function index(): never
    {
        $data = $this->service->build();
        $m = $data['metrics'];
        
        $payload = [
            'stats' => [
                'totalProducts'        => (int) $m['total_products'],
                'productsMissingMeta'  => (int) $m['products_missing_ecommerce_details'],
                'totalInventoryUnits'  => (int) $m['total_inventory'],
                'totalInventoryValue'  => (float) $m['total_inventory_value'],
                'totalOrders'          => (int) $m['total_orders'],
                'ecommerceOrders'      => (int) $m['ecommerce_orders'],
                'posOrders'            => (int) $m['pos_orders'],
                'totalCustomers'       => (int) $m['total_customers'],
                'totalRevenue'         => (float) $m['total_revenue'],
                'netProfitPlaceholder' => (float) $m['net_profit'], // Keeping the variable name same to not break other dependents, though it's real now
                'lowStockCount'        => (int) $m['low_stock_alerts'],
                'recentPaymentsCount'  => count($data['recentPayments']),
                'supportInboxCount'    => (int) $m['support_messages'],
                'unreadNotifications'  => (int) $m['unread_notifications'],
            ],
            'recentPayments' => $data['recentPayments'],
            'recentOrders'   => $data['recentOrders'],
            'lowStock'       => $data['lowStock'],
            'charts'         => $data['charts'],
        ];

        $this->ok($payload, 'Dashboard fetched successfully');
    }
}
