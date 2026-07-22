<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\ActivityLog;

final class AdminActivityLogController extends BaseController
{
    private ActivityLog $logs;

    public function __construct()
    {
        $this->logs = new ActivityLog();
    }

    /** GET /api/admin/activity-logs */
    public function index(): never
    {
        $this->ok([
            'items' => $this->logs->getRecent(100),
        ], 'Activity logs fetched successfully');
    }

    /** GET /api/admin/activity-logs/unread */
    public function unread(): never
    {
        $this->ok([
            'items' => $this->logs->getUnreadHighPriority(),
        ], 'Unread activity logs fetched successfully');
    }

    /** POST /api/admin/activity-logs/mark-read */
    public function markRead(): never
    {
        $id = (int) $this->input('id', 0);
        
        if ($id > 0) {
            $this->logs->markAsRead($id);
        } else {
            $this->logs->markAllAsRead();
        }
        
        $this->ok(['success' => true], 'Marked as read');
    }
}
