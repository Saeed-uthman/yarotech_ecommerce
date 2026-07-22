<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\CartIdentity;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Services\NotificationService;

final class NotificationController extends BaseController
{
    public function __construct(private NotificationService $service = new NotificationService()) {}

    /** GET /api/notifications/index.php */
    public function index(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) {
            Response::unauthorized('Authentication required to read notifications.');
        }

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

        $result = $this->service->getUserNotifications((int) $userId, $filters);
        $this->ok($result, 'Notifications fetched successfully');
    }

    /** GET /api/notifications/unread-count.php */
    public function unreadCount(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) {
            Response::unauthorized('Authentication required to read notification count.');
        }

        $count = $this->service->countUnread([
            'role'    => 'user',
            'user_id' => (int) $userId,
        ]);

        $this->ok(['unread_count' => $count], 'Unread notification count fetched successfully');
    }

    /** POST /api/notifications/mark-read.php */
    public function markRead(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) {
            Response::unauthorized('Authentication required.');
        }

        $id = (int) Request::input('notification_id', 0);
        if ($id <= 0) {
            Response::validation(['notification_id' => 'notification_id is required.']);
        }

        $ok = $this->service->markAsRead($id, [
            'role'    => 'user',
            'user_id' => (int) $userId,
        ]);
        if (!$ok) {
            Response::notFound('Notification not found.');
        }

        $this->ok([
            'notification_id' => $id,
            'unread_count'    => $this->service->countUnread([
                'role'    => 'user',
                'user_id' => (int) $userId,
            ]),
        ], 'Notification marked as read');
    }

    /** POST /api/notifications/mark-all-read.php */
    public function markAllRead(): never
    {
        $userId = CartIdentity::userId();
        if (!$userId) {
            Response::unauthorized('Authentication required.');
        }

        $affected = $this->service->markAllAsRead([
            'role'    => 'user',
            'user_id' => (int) $userId,
        ]);

        $this->ok([
            'marked_count' => $affected,
            'unread_count' => $this->service->countUnread([
                'role'    => 'user',
                'user_id' => (int) $userId,
            ]),
        ], 'All notifications marked as read');
    }
}

