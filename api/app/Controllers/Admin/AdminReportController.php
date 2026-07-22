<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Services\AdminReportService;

final class AdminReportController extends BaseController
{
    private AdminReportService $service;
    public function __construct(?AdminReportService $service = null) {
        $this->service = $service ?? new AdminReportService();
    }

    /** GET /api/admin/reports/index.php?period=monthly */
    public function index(): never
    {
        $filters = [
            'period' => (string) Request::query('period', 'monthly'),
            'sale_channel' => Request::query('sale_channel'),
            'created_by' => Request::query('created_by', Request::query('created_by_role')),
            'payment_method' => Request::query('payment_method'),
            'payment_status' => Request::query('payment_status'),
            'start_date' => Request::query('start_date'),
            'end_date' => Request::query('end_date'),
            'product_id' => Request::query('product_id', Request::query('product_id')),
            'category' => Request::query('category'),
            'created_by_user_id' => Request::query('created_by_user_id', Request::query('staff_admin_user_id')),
            'transaction_limit' => Request::query('transaction_limit', 100),
        ];

        $data = $this->service->build($filters);
        $this->ok($data, 'Reports fetched successfully');
    }
}
