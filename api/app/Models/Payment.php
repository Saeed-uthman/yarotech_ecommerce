<?php

declare(strict_types=1);

namespace App\Models;

final class Payment extends BaseModel
{
    protected string $table = 'payments';

    public function findByReference(string $reference): ?array
    {
        $stmt = $this->db->prepare("SELECT * FROM payments WHERE reference = :r LIMIT 1");
        $stmt->execute([':r' => $reference]);
        return $stmt->fetch() ?: null;
    }

    public function findForOrder(int $orderId): ?array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM payments WHERE order_id = :o ORDER BY id DESC LIMIT 1"
        );
        $stmt->execute([':o' => $orderId]);
        return $stmt->fetch() ?: null;
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

        if (!empty($filters['status'])) {
            $where[] = 'p.status = :status';
            $params[':status'] = (string) $filters['status'];
        }
        if (!empty($filters['reference'])) {
            $where[] = 'p.reference = :reference';
            $params[':reference'] = (string) $filters['reference'];
        }
        if (!empty($filters['order_id'])) {
            $where[] = 'p.order_id = :order_id';
            $params[':order_id'] = (int) $filters['order_id'];
        }
        if (!empty($filters['payment_method'])) {
            $where[] = 'p.payment_method = :payment_method';
            $params[':payment_method'] = (string) $filters['payment_method'];
        }
        if (!empty($filters['sale_channel'])) {
            $where[] = 'p.sale_channel = :sale_channel';
            $params[':sale_channel'] = (string) $filters['sale_channel'];
        }
        if (!empty($filters['search'])) {
            $where[] = '(p.reference LIKE :q OR o.order_number LIKE :q OR o.customer_email LIKE :q)';
            $params[':q'] = '%' . trim((string) $filters['search']) . '%';
        }

        $whereSql = implode(' AND ', $where);

        $countSql = "SELECT COUNT(*)
                     FROM payments p
                     LEFT JOIN orders o ON o.id = p.order_id
                     WHERE {$whereSql}";
        $countStmt = $this->db->prepare($countSql);
        foreach ($params as $k => $v) {
            if ($k === ':order_id') {
                $countStmt->bindValue($k, $v, \PDO::PARAM_INT);
            } else {
                $countStmt->bindValue($k, $v);
            }
        }
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT p.*, o.order_number, o.customer_email, o.customer_name
                FROM payments p
                LEFT JOIN orders o ON o.id = p.order_id
                WHERE {$whereSql}
                ORDER BY p.created_at DESC, p.id DESC
                LIMIT :l OFFSET :o";
        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) {
            if ($k === ':order_id') {
                $stmt->bindValue($k, $v, \PDO::PARAM_INT);
            } else {
                $stmt->bindValue($k, $v);
            }
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
