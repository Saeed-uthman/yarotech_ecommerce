<?php

declare(strict_types=1);

namespace App\Services;

use App\Helpers\Response;
use App\Models\Notification;

final class NotificationService
{
    /** @var string[] */
    private array $validTargets = ['user', 'admin', 'all'];

    private Notification $model;

    public function __construct(?Notification $model = null) {
        $this->model = $model ?? new Notification();
    }

    /**
     * @param array{
     *   user_id?:int|null,
     *   role_target?:string,
     *   type:string,
     *   title:string,
     *   message?:string|null,
     *   data?:array<string,mixed>|null
     * } $payload
     */
    public function createNotification(array $payload): array
    {
        $roleTarget = strtolower((string) ($payload['role_target'] ?? 'user'));
        if (!in_array($roleTarget, $this->validTargets, true)) {
            Response::validation(['role_target' => 'role_target must be one of user, admin, all.']);
        }

        $type = trim((string) ($payload['type'] ?? ''));
        $title = trim((string) ($payload['title'] ?? ''));
        if ($type === '' || $title === '') {
            Response::validation(['type' => 'type is required.', 'title' => 'title is required.']);
        }

        $userId = isset($payload['user_id']) ? (int) $payload['user_id'] : null;
        if ($roleTarget === 'user' && (!$userId || $userId <= 0)) {
            Response::validation(['user_id' => 'user_id is required for user notifications.']);
        }

        $message = isset($payload['message']) ? trim((string) $payload['message']) : null;
        $rawData = $payload['data'] ?? [];
        if (!is_array($rawData)) {
            $rawData = ['value' => $rawData];
        }
        $data = $this->sanitizeData($rawData);

        $id = (int) $this->model->insert([
            'user_id'     => $userId,
            'role_target' => $roleTarget,
            'type'        => mb_substr($type, 0, 80),
            'title'       => mb_substr($title, 0, 190),
            'message'     => $message !== '' ? $message : null,
            'data'        => empty($data) ? null : json_encode($data),
            'is_read'     => 0,
        ]);

        return $this->formatOne($this->model->find($id) ?: []);
    }

    /**
     * @param array<string,mixed> $data
     */
    public function createUserNotification(
        int $userId,
        string $type,
        string $title,
        string $message,
        array $data = [],
    ): array {
        return $this->createNotification([
            'user_id'     => $userId,
            'role_target' => 'user',
            'type'        => $type,
            'title'       => $title,
            'message'     => $message,
            'data'        => $data,
        ]);
    }

    /**
     * @param array<string,mixed> $data
     */
    public function createAdminNotification(
        string $type,
        string $title,
        string $message,
        array $data = [],
    ): array {
        return $this->createNotification([
            'user_id'     => null,
            'role_target' => 'admin',
            'type'        => $type,
            'title'       => $title,
            'message'     => $message,
            'data'        => $data,
        ]);
    }

    /**
     * @param array<string,mixed> $filters
     * @return array{items:array<int,array<string,mixed>>,unread_count:int,pagination:array<string,int>}
     */
    public function getUserNotifications(int $userId, array $filters = []): array
    {
        $result = $this->model->listForUser($userId, $filters);
        return [
            'items'        => array_map([$this, 'formatOne'], $result['items']),
            'unread_count' => $this->model->countUnreadForUser($userId),
            'pagination'   => [
                'page'     => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total'    => (int) $result['total'],
            ],
        ];
    }

    /**
     * @param array<string,mixed> $filters
     * @return array{items:array<int,array<string,mixed>>,unread_count:int,pagination:array<string,int>}
     */
    public function getAdminNotifications(array $filters = []): array
    {
        $result = $this->model->listForAdmin($filters);
        return [
            'items'        => array_map([$this, 'formatOne'], $result['items']),
            'unread_count' => $this->model->countUnreadForAdmin(),
            'pagination'   => [
                'page'     => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total'    => (int) $result['total'],
            ],
        ];
    }

    /**
     * @param array{role:'user'|'admin',user_id?:int} $userContext
     */
    public function markAsRead(int $notificationId, array $userContext): bool
    {
        if (($userContext['role'] ?? '') === 'admin') {
            return $this->model->markReadForAdmin($notificationId);
        }
        $userId = (int) ($userContext['user_id'] ?? 0);
        if ($userId <= 0) return false;
        return $this->model->markReadForUser($notificationId, $userId);
    }

    /**
     * @param array{role:'user'|'admin',user_id?:int} $userContext
     */
    public function markAllAsRead(array $userContext): int
    {
        if (($userContext['role'] ?? '') === 'admin') {
            return $this->model->markAllReadForAdmin();
        }
        $userId = (int) ($userContext['user_id'] ?? 0);
        if ($userId <= 0) return 0;
        return $this->model->markAllReadForUser($userId);
    }

    /**
     * @param array{role:'user'|'admin',user_id?:int} $userContext
     */
    public function countUnread(array $userContext): int
    {
        if (($userContext['role'] ?? '') === 'admin') {
            return $this->model->countUnreadForAdmin();
        }
        $userId = (int) ($userContext['user_id'] ?? 0);
        if ($userId <= 0) return 0;
        return $this->model->countUnreadForUser($userId);
    }

    // -----------------------------------------------------------------
    // Backward-compatible wrappers used in existing services
    // -----------------------------------------------------------------

    public function notifyUser(int $userId, string $type, ?string $title = null, ?string $body = null, ?string $link = null): void
    {
        $this->createUserNotification(
            $userId,
            $type,
            $title ?: ucfirst(str_replace('_', ' ', $type)),
            $body ?? '',
            $link ? ['link_url' => $link] : [],
        );
    }

    public function notifyAdmin(string $type, ?string $title = null, ?string $body = null, ?string $link = null): void
    {
        $this->createAdminNotification(
            $type,
            $title ?: ucfirst(str_replace('_', ' ', $type)),
            $body ?? '',
            $link ? ['link_url' => $link] : [],
        );
    }

    /**
     * @param array<string,mixed> $row
     * @return array<string,mixed>
     */
    private function formatOne(array $row): array
    {
        $decodedData = [];
        if (!empty($row['data']) && is_string($row['data'])) {
            $decoded = json_decode($row['data'], true);
            if (is_array($decoded)) {
                $decodedData = $decoded;
            }
        }
        return [
            'id'         => (int) ($row['id'] ?? 0),
            'user_id'    => isset($row['user_id']) && $row['user_id'] !== null ? (int) $row['user_id'] : null,
            'role_target'=> (string) ($row['role_target'] ?? 'user'),
            'type'       => (string) ($row['type'] ?? ''),
            'title'      => (string) ($row['title'] ?? ''),
            'message'    => (string) ($row['message'] ?? ''),
            'data'       => $decodedData,
            'is_read'    => (bool) ((int) ($row['is_read'] ?? 0)),
            'created_at' => (string) ($row['created_at'] ?? ''),
        ];
    }

    /**
     * @param array<string,mixed> $data
     * @return array<string,mixed>
     */
    private function sanitizeData(array $data): array
    {
        $sensitive = ['otp', 'code', 'token', 'secret', 'password', 'password_hash', 'jwt'];
        $out = [];
        foreach ($data as $k => $v) {
            $key = strtolower((string) $k);
            if (in_array($key, $sensitive, true)) {
                $out[$k] = '[REDACTED]';
                continue;
            }
            if (is_array($v)) {
                $out[$k] = $this->sanitizeData($v);
            } else {
                $out[$k] = $v;
            }
        }
        return $out;
    }
}
