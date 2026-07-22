<?php

declare(strict_types=1);

namespace App\Models;

final class UserActivityLog extends BaseModel
{
    protected string $table = 'user_activity_logs';

    /**
     * @return array{items:array<int,array<string,mixed>>,total:int,page:int,per_page:int}
     */
    public function listForAdmin(array $filters = []): array
    {
        $page = max(1, (int) ($filters['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($filters['per_page'] ?? 20)));
        $offset = ($page - 1) * $perPage;

        $where = ['1=1'];
        $params = [];

        if (!empty($filters['activity_type'])) {
            $where[] = 'a.activity_type = :activity_type';
            $params[':activity_type'] = (string) $filters['activity_type'];
        }
        if (!empty($filters['status']) && in_array($filters['status'], ['success', 'failed'], true)) {
            $where[] = 'a.status = :status';
            $params[':status'] = (string) $filters['status'];
        }
        if (!empty($filters['user_id'])) {
            $where[] = 'a.user_id = :user_id';
            $params[':user_id'] = (int) $filters['user_id'];
        }

        $whereSql = implode(' AND ', $where);
        $countSql = "SELECT COUNT(*) FROM {$this->table} a WHERE {$whereSql}";
        $countStmt = $this->db->prepare($countSql);
        foreach ($params as $k => $v) {
            if ($k === ':user_id') {
                $countStmt->bindValue($k, $v, \PDO::PARAM_INT);
                continue;
            }
            $countStmt->bindValue($k, $v);
        }
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT a.*, u.full_name AS user_name
                FROM {$this->table} a
                LEFT JOIN users u ON a.user_id = u.id
                WHERE {$whereSql}
                ORDER BY a.created_at DESC, a.id DESC
                LIMIT :l OFFSET :o";
        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) {
            if ($k === ':user_id') {
                $stmt->bindValue($k, $v, \PDO::PARAM_INT);
                continue;
            }
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
}

