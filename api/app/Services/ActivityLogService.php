<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\ActivityLog;

final class ActivityLogService
{
    private ActivityLog $logs;

    public function __construct()
    {
        $this->logs = new ActivityLog();
    }

    /**
     * Passively logs routine actions without triggering an unread alert (is_read = 1).
     */
    public function logRoutine(?int $staffId, string $actionType, string $description, ?int $referenceId = null): void
    {
        $this->logs->insert([
            'staff_id'     => $staffId,
            'action_type'  => $actionType,
            'description'  => $description,
            'reference_id' => $referenceId,
            'is_read'      => 1, // Routine actions are already considered "read" so they don't trigger alerts
        ]);
    }

    /**
     * Logs high priority actions and triggers an unread alert (is_read = 0).
     */
    public function logHighPriority(?int $staffId, string $actionType, string $description, ?int $referenceId = null): void
    {
        $this->logs->insert([
            'staff_id'     => $staffId,
            'action_type'  => $actionType,
            'description'  => $description,
            'reference_id' => $referenceId,
            'is_read'      => 0, // High-priority triggers the red notification bell
        ]);
    }
}
