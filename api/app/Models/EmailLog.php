<?php

declare(strict_types=1);

namespace App\Models;

final class EmailLog extends BaseModel
{
    protected string $table = 'email_logs';

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

        if (!empty($filters['status']) && in_array($filters['status'], ['sent', 'failed'], true)) {
            $where[] = 'status = :status';
            $params[':status'] = $filters['status'];
        }
        if (!empty($filters['email_type'])) {
            $where[] = 'email_type = :email_type';
            $params[':email_type'] = (string) $filters['email_type'];
        }
        if (!empty($filters['recipient_email'])) {
            $where[] = 'recipient_email = :recipient_email';
            $params[':recipient_email'] = (string) $filters['recipient_email'];
        }
        if (!empty($filters['related_entity_type'])) {
            $where[] = 'related_entity_type = :related_entity_type';
            $params[':related_entity_type'] = (string) $filters['related_entity_type'];
        }

        $whereSql = implode(' AND ', $where);
        $countSql = "SELECT COUNT(*) FROM {$this->table} WHERE {$whereSql}";
        $countStmt = $this->db->prepare($countSql);
        foreach ($params as $k => $v) {
            $countStmt->bindValue($k, $v);
        }
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT *
                FROM {$this->table}
                WHERE {$whereSql}
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
}

