<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Models\EmailLog;
use App\Models\UserActivityLog;

final class AdminAuditController extends BaseController
{
    private EmailLog $emailLogs;
    private UserActivityLog $activityLogs;

    public function __construct(
        ?EmailLog $emailLogs = null,
        ?UserActivityLog $activityLogs = null
    ) {
        $this->emailLogs = $emailLogs ?? new EmailLog();
        $this->activityLogs = $activityLogs ?? new UserActivityLog();
    }

    /** GET /api/admin/email-logs.php */
    public function emailLogs(): never
    {
        $filters = [
            'status'              => Request::query('status'),
            'email_type'          => Request::query('email_type'),
            'recipient_email'     => Request::query('recipient_email'),
            'related_entity_type' => Request::query('related_entity_type'),
            'page'                => Request::query('page', 1),
            'per_page'            => Request::query('per_page', 20),
        ];

        $result = $this->emailLogs->listForAdmin($filters);
        $this->ok([
            'items'       => $result['items'],
            'pagination'  => [
                'page'     => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total'    => (int) $result['total'],
            ],
        ], 'Email logs fetched successfully');
    }

    /** GET /api/admin/audit/user-activity.php */
    public function userActivity(): never
    {
        $filters = [
            'activity_type' => Request::query('activity_type'),
            'status'        => Request::query('status'),
            'user_id'       => Request::query('user_id'),
            'page'          => Request::query('page', 1),
            'per_page'      => Request::query('per_page', 20),
        ];

        $result = $this->activityLogs->listForAdmin($filters);

        $items = array_map(function (array $row): array {
            $metadata = [];
            if (!empty($row['metadata']) && is_string($row['metadata'])) {
                $decoded = json_decode($row['metadata'], true);
                if (is_array($decoded)) {
                    $metadata = $decoded;
                }
            }
            $row['metadata'] = $metadata;
            return $row;
        }, $result['items']);

        $this->ok([
            'items'      => $items,
            'pagination' => [
                'page'     => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total'    => (int) $result['total'],
            ],
        ], 'User activity logs fetched successfully');
    }
}

