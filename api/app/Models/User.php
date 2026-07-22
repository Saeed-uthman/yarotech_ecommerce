<?php

declare(strict_types=1);

namespace App\Models;

/**
 * Phase 2 will own this fully (auth, roles, profile). For Phase 5 we only
 * need a lightweight reader so the order/payment pipeline can fetch the
 * customer's email + name when sending confirmation messages. The schema
 * is assumed to include id, name, email, phone — adjust to whatever Phase 2
 * settles on without breaking this contract.
 */
final class User extends BaseModel
{
    protected string $table = 'users';

    public function findByEmail(string $email): ?array
    {
        $stmt = $this->db->prepare("SELECT * FROM users WHERE email = :e LIMIT 1");
        $stmt->execute([':e' => $email]);
        return $stmt->fetch() ?: null;
    }

    /**
     * Safe lookup that tolerates a missing users table (Phase 2 hasn't
     * landed yet in some environments) — returns a synthetic row from the
     * X-User-* request headers so order emails still render.
     */
    public function findOrSynthesize(int $id, ?string $emailFallback = null, ?string $nameFallback = null): array
    {
        try {
            $row = $this->find($id);
            if ($row) return $row;
        } catch (\Throwable) {
            // table not yet present
        }
        return [
            'id'    => $id,
            'name'  => $nameFallback ?: 'Customer',
            'email' => $emailFallback ?: '',
            'phone' => null,
        ];
    }

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

        if (!empty($filters['role'])) {
            $where[] = 'u.role = :role';
            $params[':role'] = (string) $filters['role'];
        }
        if (!empty($filters['user_status'])) {
            $where[] = 'u.status = :user_status';
            $params[':user_status'] = (string) $filters['user_status'];
        }
        if (!empty($filters['search'])) {
            $where[] = '(u.full_name LIKE :q OR u.email LIKE :q OR u.phone LIKE :q OR CAST(u.id AS CHAR) LIKE :q)';
            $params[':q'] = '%' . trim((string) $filters['search']) . '%';
        }

        $whereSql = implode(' AND ', $where);

        $countStmt = $this->db->prepare("SELECT COUNT(*) FROM users u WHERE {$whereSql}");
        foreach ($params as $k => $v) {
            $countStmt->bindValue($k, $v);
        }
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT u.*,
                       COUNT(o.id) AS orders_count,
                       COALESCE(SUM(CASE WHEN o.payment_status = 'success' THEN o.total_amount ELSE 0 END), 0) AS total_spend
                FROM users u
                LEFT JOIN orders o ON o.user_id = u.id
                WHERE {$whereSql}
                GROUP BY u.id
                ORDER BY u.created_at DESC, u.id DESC
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

    public function findWithStats(int $id): ?array
    {
        $stmt = $this->db->prepare(
            "SELECT u.*,
                    COUNT(o.id) AS orders_count,
                    COALESCE(SUM(CASE WHEN o.payment_status = 'success' THEN o.total_amount ELSE 0 END), 0) AS total_spend
             FROM users u
             LEFT JOIN orders o ON o.user_id = u.id
             WHERE u.id = :id
             GROUP BY u.id
             LIMIT 1"
        );
        $stmt->execute([':id' => $id]);
        return $stmt->fetch() ?: null;
    }

    public function updateStatus(int $id, string $status): bool
    {
        $stmt = $this->db->prepare(
            "UPDATE users SET status = :s, updated_at = CURRENT_TIMESTAMP WHERE id = :id"
        );
        return $stmt->execute([
            ':s'  => $status,
            ':id' => $id,
        ]);
    }
}
