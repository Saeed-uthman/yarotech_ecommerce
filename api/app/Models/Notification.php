<?php

declare(strict_types=1);

namespace App\Models;

final class Notification extends BaseModel
{
    protected string $table = 'notifications';

    /**
     * @return array{items:array<int,array<string,mixed>>,total:int,page:int,per_page:int}
     */
    public function listForUser(int $userId, $filters = []): array
    {
        if (is_int($filters)) {
            $filters = ['per_page' => $filters];
        }
        $page = max(1, (int) ($filters['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($filters['per_page'] ?? 20)));
        $offset = ($page - 1) * $perPage;

        $where = ["(role_target = 'all' OR (role_target = 'user' AND user_id = :uid))"];
        $params = [':uid' => $userId];

        if (isset($filters['type']) && is_string($filters['type']) && $filters['type'] !== '') {
            $where[] = 'type = :type';
            $params[':type'] = $filters['type'];
        }
        if (array_key_exists('is_read', $filters)) {
            $where[] = 'is_read = :is_read';
            $params[':is_read'] = (int) ((bool) $filters['is_read']);
        }

        $whereSql = implode(' AND ', $where);

        $countSql = "SELECT COUNT(*) FROM notifications WHERE $whereSql";
        $countStmt = $this->db->prepare($countSql);
        foreach ($params as $k => $v) {
            $countStmt->bindValue($k, $v);
        }
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT id, user_id, role_target, type, title, message, data, is_read, created_at
                FROM notifications
                WHERE $whereSql
                ORDER BY created_at DESC, id DESC
                LIMIT :l OFFSET :o";

        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) {
            $stmt->bindValue($k, $v);
        }
        $stmt->bindValue(':l', $perPage, \PDO::PARAM_INT);
        $stmt->bindValue(':o', $offset, \PDO::PARAM_INT);
        $stmt->execute();

        return [
            'items'    => $stmt->fetchAll(),
            'total'    => $total,
            'page'     => $page,
            'per_page' => $perPage,
        ];
    }

    /**
     * @return array{items:array<int,array<string,mixed>>,total:int,page:int,per_page:int}
     */
    public function listForAdmin($filters = []): array
    {
        if (is_int($filters)) {
            $filters = ['per_page' => $filters];
        }
        $page = max(1, (int) ($filters['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($filters['per_page'] ?? 20)));
        $offset = ($page - 1) * $perPage;

        $where = ["role_target IN ('admin','all')"];
        $params = [];

        if (isset($filters['type']) && is_string($filters['type']) && $filters['type'] !== '') {
            $where[] = 'type = :type';
            $params[':type'] = $filters['type'];
        }
        if (array_key_exists('is_read', $filters)) {
            $where[] = 'is_read = :is_read';
            $params[':is_read'] = (int) ((bool) $filters['is_read']);
        }

        $whereSql = implode(' AND ', $where);
        $countSql = "SELECT COUNT(*) FROM notifications WHERE $whereSql";
        $countStmt = $this->db->prepare($countSql);
        foreach ($params as $k => $v) {
            $countStmt->bindValue($k, $v);
        }
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT id, user_id, role_target, type, title, message, data, is_read, created_at
                FROM notifications
                WHERE $whereSql
                ORDER BY created_at DESC, id DESC
                LIMIT :l OFFSET :o";
        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) {
            $stmt->bindValue($k, $v);
        }
        $stmt->bindValue(':l', $perPage, \PDO::PARAM_INT);
        $stmt->bindValue(':o', $offset, \PDO::PARAM_INT);
        $stmt->execute();

        return [
            'items'    => $stmt->fetchAll(),
            'total'    => $total,
            'page'     => $page,
            'per_page' => $perPage,
        ];
    }

    public function countUnreadForUser(int $userId): int
    {
        $stmt = $this->db->prepare(
            "SELECT COUNT(*) FROM notifications
             WHERE is_read = 0 AND (role_target = 'all' OR (role_target = 'user' AND user_id = :uid))"
        );
        $stmt->bindValue(':uid', $userId, \PDO::PARAM_INT);
        $stmt->execute();
        return (int) $stmt->fetchColumn();
    }

    public function countUnreadForAdmin(): int
    {
        $stmt = $this->db->query(
            "SELECT COUNT(*) FROM notifications
             WHERE is_read = 0 AND role_target IN ('admin','all')"
        );
        return (int) $stmt->fetchColumn();
    }

    public function markReadForUser(int $notificationId, int $userId): bool
    {
        $stmt = $this->db->prepare(
            "UPDATE notifications
             SET is_read = 1
             WHERE id = :id
               AND (role_target = 'all' OR (role_target = 'user' AND user_id = :uid))"
        );
        $stmt->bindValue(':id', $notificationId, \PDO::PARAM_INT);
        $stmt->bindValue(':uid', $userId, \PDO::PARAM_INT);
        return $stmt->execute() && $stmt->rowCount() > 0;
    }

    public function markReadForAdmin(int $notificationId): bool
    {
        $stmt = $this->db->prepare(
            "UPDATE notifications
             SET is_read = 1
             WHERE id = :id AND role_target IN ('admin','all')"
        );
        $stmt->bindValue(':id', $notificationId, \PDO::PARAM_INT);
        return $stmt->execute() && $stmt->rowCount() > 0;
    }

    public function markAllReadForUser(int $userId): int
    {
        $stmt = $this->db->prepare(
            "UPDATE notifications
             SET is_read = 1
             WHERE is_read = 0
               AND (role_target = 'all' OR (role_target = 'user' AND user_id = :uid))"
        );
        $stmt->bindValue(':uid', $userId, \PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->rowCount();
    }

    public function markAllReadForAdmin(): int
    {
        $stmt = $this->db->prepare(
            "UPDATE notifications
             SET is_read = 1
             WHERE is_read = 0 AND role_target IN ('admin','all')"
        );
        $stmt->execute();
        return $stmt->rowCount();
    }
}
