<?php

declare(strict_types=1);

namespace App\Models;

final class Customer extends BaseModel
{
    protected string $table = 'customers';

    public function findByPhone(string $phone): ?array
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE phone = :p LIMIT 1");
        $stmt->execute([':p' => $phone]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /** @return array{items:array<int,array<string,mixed>>,total:int,page:int,per_page:int} */
    public function listForAdmin(array $filters = []): array
    {
        $page    = max(1, (int) ($filters['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($filters['per_page'] ?? 20)));
        $offset  = ($page - 1) * $perPage;

        $where  = '1=1';
        $params = [];
        if (!empty($filters['search'])) {
            $where   .= ' AND (full_name LIKE :q OR phone LIKE :q OR email LIKE :q)';
            $params[':q'] = '%' . trim((string) $filters['search']) . '%';
        }

        $countStmt = $this->db->prepare("SELECT COUNT(*) FROM {$this->table} WHERE {$where}");
        foreach ($params as $k => $v) $countStmt->bindValue($k, $v);
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $stmt = $this->db->prepare(
            "SELECT id, full_name, phone, email, total_orders, total_spent, first_order_at, last_order_at, created_at
             FROM {$this->table} WHERE {$where}
             ORDER BY last_order_at DESC, created_at DESC
             LIMIT {$perPage} OFFSET {$offset}"
        );
        foreach ($params as $k => $v) $stmt->bindValue($k, $v);
        $stmt->execute();

        return [
            'items'    => $stmt->fetchAll(),
            'total'    => $total,
            'page'     => $page,
            'per_page' => $perPage,
        ];
    }

    public function incrementOrders(int $customerId, float $amount): void
    {
        $stmt = $this->db->prepare(
            "UPDATE {$this->table}
             SET total_orders = total_orders + 1,
                 total_spent  = total_spent + :amt,
                 last_order_at  = NOW(),
                 first_order_at = COALESCE(first_order_at, NOW())
             WHERE id = :id"
        );
        $stmt->bindValue(':amt', $amount);
        $stmt->bindValue(':id', $customerId, \PDO::PARAM_INT);
        $stmt->execute();
    }

    /** Search customers by name, phone, or email (for POS lookup). */
    public function searchByNameOrPhone(string $query): array
    {
        $like = '%' . $query . '%';
        $stmt = $this->db->prepare(
            "SELECT id, full_name, phone, email, total_orders, total_spent, first_order_at, last_order_at
             FROM {$this->table}
             WHERE full_name LIKE :q1 OR phone LIKE :q2 OR email LIKE :q3
             ORDER BY total_orders DESC, last_order_at DESC
             LIMIT 10"
        );
        $stmt->execute([':q1' => $like, ':q2' => $like, ':q3' => $like]);
        return $stmt->fetchAll();
    }
}

