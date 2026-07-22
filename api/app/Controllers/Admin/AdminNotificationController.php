<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Services\NotificationService;

final class AdminNotificationController extends BaseController
{
    private NotificationService $service;
    public function __construct(?NotificationService $service = null) {
        $this->service = $service ?? new NotificationService();
    }

    /** GET /api/admin/notifications.php */
    public function index(): never
    {
        $filters = [
            'type'     => Request::query('type'),
            'is_read'  => Request::query('is_read'),
            'page'     => Request::query('page', 1),
            'per_page' => Request::query('per_page', 20),
        ];

        if ($filters['is_read'] !== null) {
            $filters['is_read'] = in_array((string) $filters['is_read'], ['1', 'true', 'yes'], true);
        } else {
            unset($filters['is_read']);
        }

        $result = $this->service->getAdminNotifications($filters);
        $this->ok($result, 'Notifications fetched successfully');
    }

    /** GET /api/admin/notifications/unread-count.php */
    public function unreadCount(): never
    {
        $count = $this->service->countUnread(['role' => 'admin']);
        $this->ok(['unread_count' => $count], 'Unread notification count fetched successfully');
    }

    /** POST /api/admin/notifications/mark-read.php */
    public function markRead(): never
    {
        $id = (int) Request::input('notification_id', 0);
        if ($id <= 0) {
            Response::validation(['notification_id' => 'notification_id is required.']);
        }

        $ok = $this->service->markAsRead($id, ['role' => 'admin']);
        if (!$ok) {
            Response::notFound('Notification not found.');
        }

        $this->ok([
            'notification_id' => $id,
            'unread_count'    => $this->service->countUnread(['role' => 'admin']),
        ], 'Notification marked as read');
    }

    /** POST /api/admin/notifications/mark-all-read.php */
    public function markAllRead(): never
    {
        $affected = $this->service->markAllAsRead(['role' => 'admin']);
        $this->ok([
            'marked_count' => $affected,
            'unread_count' => $this->service->countUnread(['role' => 'admin']),
        ], 'All notifications marked as read');
    }
}

