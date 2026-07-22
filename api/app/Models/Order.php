<?php

declare(strict_types=1);

namespace App\Models;

final class Order extends BaseModel
{
    protected string $table = 'orders';

    public function findByNumber(string $number): ?array
    {
        $stmt = $this->db->prepare("SELECT * FROM orders WHERE order_number = :n LIMIT 1");
        $stmt->execute([':n' => $number]);
        return $stmt->fetch() ?: null;
    }

    public function listForUser(int $userId, int $limit = 50, int $offset = 0): array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM orders WHERE user_id = :u ORDER BY created_at DESC LIMIT :l OFFSET :o"
        );
        $stmt->bindValue(':u', $userId, \PDO::PARAM_INT);
        $stmt->bindValue(':l', $limit, \PDO::PARAM_INT);
        $stmt->bindValue(':o', $offset, \PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function listAll(int $limit = 100, int $offset = 0, ?string $status = null): array
    {
        $sql = "SELECT * FROM orders";
        $params = [];
        if ($status) {
            $sql .= " WHERE order_status = :s";
            $params[':s'] = $status;
        }
        $sql .= " ORDER BY created_at DESC LIMIT :l OFFSET :o";
        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) $stmt->bindValue($k, $v);
        $stmt->bindValue(':l', $limit, \PDO::PARAM_INT);
        $stmt->bindValue(':o', $offset, \PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function generateOrderNumber(): string
    {
        return 'YT-' . date('Ymd') . '-' . strtoupper(bin2hex(random_bytes(3)));
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

        if (!empty($filters['order_status'])) {
            $where[] = 'o.order_status = :order_status';
            $params[':order_status'] = (string) $filters['order_status'];
        }
        if (!empty($filters['payment_status'])) {
            $where[] = 'o.payment_status = :payment_status';
            $params[':payment_status'] = (string) $filters['payment_status'];
        }

        if (!empty($filters['payment_method'])) {
            $where[] = 'o.payment_method = :payment_method';
            $params[':payment_method'] = (string) $filters['payment_method'];
        }
        if (!empty($filters['created_by'])) {
            $where[] = 'o.created_by = :created_by';
            $params[':created_by'] = (string) $filters['created_by'];
        }
        if (!empty($filters['search'])) {
            $where[] = '(o.order_number LIKE :q OR o.customer_name LIKE :q OR o.customer_email LIKE :q OR p.reference LIKE :q)';
            $params[':q'] = '%' . trim((string) $filters['search']) . '%';
        }

        $whereSql = implode(' AND ', $where);

        $countSql = "SELECT COUNT(*)
                     FROM orders o
                     LEFT JOIN payments p ON p.id = (
                        SELECT p2.id FROM payments p2 WHERE p2.order_id = o.id ORDER BY p2.id DESC LIMIT 1
                     )
                     WHERE {$whereSql}";
        $countStmt = $this->db->prepare($countSql);
        foreach ($params as $k => $v) {
            $countStmt->bindValue($k, $v);
        }
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT o.*,
                       p.reference AS payment_reference,
                       p.channel AS payment_channel,
                       p.gateway_response,
                       p.paid_at,
                       COUNT(oi.id) AS item_count
                FROM orders o
                LEFT JOIN payments p ON p.id = (
                    SELECT p2.id FROM payments p2 WHERE p2.order_id = o.id ORDER BY p2.id DESC LIMIT 1
                )
                LEFT JOIN order_items oi ON oi.order_id = o.id
                WHERE {$whereSql}
                GROUP BY o.id, p.reference, p.channel, p.gateway_response, p.paid_at
                ORDER BY o.created_at DESC, o.id DESC
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

    public function findByIdOrNumber($idOrNumber): ?array
    {
        if (is_numeric($idOrNumber)) {
            $row = $this->find((int) $idOrNumber);
            if ($row) return $row;
        }
        return $this->findByNumber((string) $idOrNumber);
    }
}
