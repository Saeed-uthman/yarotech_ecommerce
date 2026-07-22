<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Models\Order;
use App\Models\User;
use App\Services\AdminActivityLogService;
use App\Services\NotificationService;

final class AdminUserController extends BaseController
{
    /** @var string[] */
    private array $allowedStatuses = ['active', 'inactive', 'pending', 'suspended', 'deleted'];

    private User $users;
    private Order $orders;
    private NotificationService $notifications;
    private AdminActivityLogService $activity;

    public function __construct(
        ?User $users = null,
        ?Order $orders = null,
        ?NotificationService $notifications = null,
        ?AdminActivityLogService $activity = null
    ) {
        $this->users = $users ?? new User();
        $this->orders = $orders ?? new Order();
        $this->notifications = $notifications ?? new NotificationService();
        $this->activity = $activity ?? new AdminActivityLogService();
    }

    /** GET /api/admin/users/index.php */
    public function index(): never
    {
        $filters = [
            'role'        => Request::query('role'),
            'user_status' => Request::query('user_status', Request::query('status')),
            'search'      => Request::query('search'),
            'page'        => Request::query('page', 1),
            'per_page'    => Request::query('per_page', 20),
        ];

        $result = $this->users->listForAdmin($filters);
        $this->ok([
            'items' => array_map([$this, 'formatUser'], $result['items']),
            'pagination' => [
                'page'     => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total'    => (int) $result['total'],
            ],
        ], 'Users fetched successfully');
    }

    /** GET /api/admin/users/show.php?id=... */
    public function show(): never
    {
        $id = (int) Request::query('id', 0);
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }

        $user = $this->users->findWithStats($id);
        if (!$user) {
            Response::notFound('User not found.');
        }

        $orders = $this->orders->listForUser($id, 10, 0);
        $this->ok([
            'user' => $this->formatUser($user),
            'recent_orders' => $orders,
        ], 'User fetched successfully');
    }

    /** POST /api/admin/users/update-status.php */
    public function updateStatus(): never
    {
        $id = (int) Request::input('id', 0);
        $status = trim((string) Request::input('status', Request::input('user_status', '')));
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }
        if (!in_array($status, $this->allowedStatuses, true)) {
            Response::validation(['status' => 'Invalid user status.']);
        }

        $user = $this->users->find($id);
        if (!$user) {
            Response::notFound('User not found.');
        }

        $this->users->updateStatus($id, $status);

        $this->notifications->createUserNotification(
            $id,
            'admin_reply',
            'Account status update',
            'Your account status is now ' . $status . '.',
            ['user_status' => $status],
        );

        $this->activity->log('user_status_updated', 'success', [
            'user_id' => $id,
            'status' => $status,
        ]);

        $updated = $this->users->findWithStats($id) ?: $this->users->find($id);
        $this->ok($this->formatUser($updated), 'User status updated successfully');
    }

    /**
     * @param array<string,mixed> $row
     * @return array<string,mixed>
     */
    private function formatUser(array $row): array
    {
        return [
            'id' => (int) $row['id'],
            'full_name' => (string) ($row['full_name'] ?? ''),
            'email' => (string) ($row['email'] ?? ''),
            'phone' => (string) ($row['phone'] ?? ''),
            'role' => (string) ($row['role'] ?? 'user'),
            'user_status' => (string) ($row['status'] ?? 'active'),
            'email_verified_at' => $row['email_verified_at'] ?? null,
            'last_login_at' => $row['last_login_at'] ?? null,
            'orders_count' => (int) ($row['orders_count'] ?? 0),
            'total_spend' => (float) ($row['total_spend'] ?? 0),
            'created_at' => (string) ($row['created_at'] ?? ''),
            'updated_at' => (string) ($row['updated_at'] ?? ''),
            // frontend-friendly aliases
            'fullName' => (string) ($row['full_name'] ?? ''),
            'ordersCount' => (int) ($row['orders_count'] ?? 0),
            'totalSpend' => (float) ($row['total_spend'] ?? 0),
            'emailVerified' => !empty($row['email_verified_at']),
            'status' => (string) ($row['status'] ?? 'active'),
            'lastActiveAt' => (string) ($row['last_login_at'] ?? $row['updated_at'] ?? ''),
        ];
    }
}
