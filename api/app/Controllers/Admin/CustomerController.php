<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Services\CustomerService;

final class CustomerController extends BaseController
{
    private CustomerService $service;

    public function __construct(?CustomerService $service = null)
    {
        $this->service = $service ?? new CustomerService();
    }

    /** GET /api/admin/customers */
    public function index(): never
    {
        $filters = [
            'search'   => Request::query('search'),
            'page'     => Request::query('page', 1),
            'per_page' => Request::query('per_page', 20),
        ];

        $result = $this->service->list($filters);
        $this->ok([
            'items' => $result['items'],
            'pagination' => [
                'page'     => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total'    => (int) $result['total'],
            ],
        ], 'Customers fetched successfully');
    }

    /** GET /api/admin/customers/show?id=... */
    public function show(): never
    {
        $id = (int) Request::query('id', 0);
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }

        $result = $this->service->detail($id);
        if (!$result) {
            Response::notFound('Customer not found.');
        }

        $this->ok($result, 'Customer fetched successfully');
    }

    /** GET /api/admin/customers/search?q=... (for POS lookup by name or phone) */
    public function search(): never
    {
        $q = trim((string) Request::query('q', ''));
        if (strlen($q) < 2) {
            $this->ok([], 'Search query too short');
        }

        $results = $this->service->search($q);

        @file_put_contents(
            dirname(__DIR__, 2) . '/storage/logs/customer-search.log',
            date('[Y-m-d H:i:s] ') . "query=\"{$q}\" results=" . count($results) . PHP_EOL,
            FILE_APPEND
        );

        $this->ok($results, 'Customers found');
    }

    /** POST /api/admin/customers/create */
    public function create(): never
    {
        $name = trim((string) Request::input('full_name', ''));
        $phone = trim((string) Request::input('phone', ''));
        $email = trim((string) Request::input('email', ''));

        if ($name === '') {
            Response::validation(['full_name' => 'Full name is required.']);
        }
        if ($phone === '') {
            Response::validation(['phone' => 'Phone number is required.']);
        }

        $customer = $this->service->createCustomer([
            'name'  => $name,
            'phone' => $phone,
            'email' => $email,
        ]);

        if (!$customer) {
            Response::validation(['phone' => 'A customer with this phone number already exists.']);
        }

        $this->ok($customer, 'Customer created successfully');
    }

    /** POST /api/admin/customers/update */
    public function update(): never
    {
        $id = (int) Request::input('id', 0);
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }

        $name = trim((string) Request::input('full_name', ''));
        $phone = trim((string) Request::input('phone', ''));
        $email = trim((string) Request::input('email', ''));

        if ($name === '') {
            Response::validation(['full_name' => 'Full name is required.']);
        }
        if ($phone === '') {
            Response::validation(['phone' => 'Phone number is required.']);
        }

        $customer = $this->service->updateCustomer($id, [
            'full_name' => $name,
            'phone'     => $phone,
            'email'     => $email,
        ]);

        if (!$customer) {
            Response::notFound('Customer not found or phone already in use.');
        }

        $this->ok($customer, 'Customer updated successfully');
    }

    /** POST /api/admin/customers/delete */
    public function delete(): never
    {
        $id = (int) Request::input('id', 0);
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }

        $deleted = $this->service->deleteCustomer($id);
        if (!$deleted) {
            Response::notFound('Customer not found.');
        }

        $this->ok(['id' => $id], 'Customer deleted successfully');
    }
}
