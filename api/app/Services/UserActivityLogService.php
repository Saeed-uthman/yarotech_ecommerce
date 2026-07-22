<?php

declare(strict_types=1);

namespace App\Services;

use App\Helpers\Request;
use App\Models\UserActivityLog;

final class UserActivityLogService
{
    /** @var string[] */
    private array $sensitiveKeys = [
        'password',
        'password_hash',
        'token',
        'access_token',
        'refresh_token',
        'otp',
        'code',
        'secret',
        'jwt',
    ];

    public function __construct(private UserActivityLog $model = new UserActivityLog()) {}

    /**
     * @param array<string,mixed>|null $metadata
     */
    public function log(
        ?int $userId,
        string $activityType,
        string $status = 'success',
        ?string $ipAddress = null,
        ?string $userAgent = null,
        ?array $metadata = null,
    ): void {
        $activityType = trim($activityType);
        if ($activityType === '') {
            return;
        }

        $status = in_array($status, ['success', 'failed'], true) ? $status : 'failed';
        $safeMeta = $this->sanitizeMetadata($metadata ?? []);

        $this->model->insert([
            'user_id'       => $userId,
            'activity_type' => mb_substr($activityType, 0, 80),
            'status'        => $status,
            'ip_address'    => mb_substr((string) ($ipAddress ?? Request::ip()), 0, 45),
            'user_agent'    => mb_substr((string) ($userAgent ?? Request::header('User-Agent') ?? ''), 0, 255),
            'metadata'      => empty($safeMeta) ? null : json_encode($safeMeta),
        ]);

        // Mirror important user events to the unified Admin Activity Log
        try {
            $adminLog = new \App\Services\ActivityLogService();
            $desc = "User {$activityType}";
            if (isset($safeMeta['email'])) {
                $desc .= " (" . $safeMeta['email'] . ")";
            } elseif (isset($safeMeta['order_number'])) {
                $desc .= " (Order: " . $safeMeta['order_number'] . ")";
            }
            $desc .= " - Status: {$status}";
            
            // Log as routine so it doesn't spam the unread bell icon
            $adminLog->logRoutine(null, "user_" . mb_substr($activityType, 0, 40), $desc, $userId);
        } catch (\Throwable $e) {
            // Ignore if mirroring fails to not break the main user flow
        }
    }

    public function logUserRegistered(?int $userId, ?string $email = null): void
    {
        $this->log($userId, 'user_registered', 'success', null, null, [
            'email' => $email,
        ]);
    }

    public function logUserVerified(?int $userId, ?string $email = null): void
    {
        $this->log($userId, 'user_verified', 'success', null, null, [
            'email' => $email,
        ]);
    }

    public function logLoginSuccess(?int $userId, ?string $email = null): void
    {
        $this->log($userId, 'login_success', 'success', null, null, [
            'email' => $email,
        ]);
    }

    public function logLoginFailed(?string $email = null, ?string $reason = null): void
    {
        $this->log(null, 'login_failed', 'failed', null, null, [
            'email'  => $email,
            'reason' => $reason,
        ]);
    }

    /**
     * @param array<string,mixed> $metadata
     * @return array<string,mixed>
     */
    private function sanitizeMetadata(array $metadata): array
    {
        $safe = [];
        foreach ($metadata as $key => $value) {
            $keyString = strtolower((string) $key);
            if (in_array($keyString, $this->sensitiveKeys, true)) {
                $safe[$key] = '[REDACTED]';
                continue;
            }

            if (is_array($value)) {
                $safe[$key] = $this->sanitizeMetadata($value);
                continue;
            }

            if (is_string($value) && strlen($value) > 1000) {
                $safe[$key] = mb_substr($value, 0, 1000);
                continue;
            }

            $safe[$key] = $value;
        }
        return $safe;
    }
}

