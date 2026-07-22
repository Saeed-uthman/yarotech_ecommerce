<?php

declare(strict_types=1);

namespace App\Services;

use App\Helpers\Request;
use App\Models\AdminActivityLog;

final class AdminActivityLogService
{
    public function __construct(private AdminActivityLog $model = new AdminActivityLog()) {}

    /**
     * @param array<string,mixed> $metadata
     */
    public function log(
        string $activityType,
        string $status = 'success',
        array $metadata = [],
        ?int $adminUserId = null,
    ): void {
        if ($activityType === '') {
            return;
        }

        $status = in_array($status, ['success', 'failed'], true) ? $status : 'failed';

        try {
            $this->model->insert([
                'admin_user_id' => $adminUserId,
                'activity_type' => mb_substr($activityType, 0, 80),
                'status'        => $status,
                'ip_address'    => mb_substr(Request::ip(), 0, 45),
                'user_agent'    => mb_substr((string) (Request::header('User-Agent') ?? ''), 0, 255),
                'metadata'      => empty($metadata) ? null : json_encode($this->sanitize($metadata)),
            ]);
        } catch (\Throwable) {
            // Activity logging must never block primary API behavior.
        }
    }

    /**
     * @param array<string,mixed> $metadata
     * @return array<string,mixed>
     */
    private function sanitize(array $metadata): array
    {
        $sensitive = ['password', 'token', 'secret', 'otp', 'code', 'key', 'api_key'];
        $out = [];
        foreach ($metadata as $k => $v) {
            $lk = strtolower((string) $k);
            if (in_array($lk, $sensitive, true)) {
                $out[$k] = '[REDACTED]';
                continue;
            }
            if (is_array($v)) {
                $out[$k] = $this->sanitize($v);
                continue;
            }
            $out[$k] = $v;
        }
        return $out;
    }
}

