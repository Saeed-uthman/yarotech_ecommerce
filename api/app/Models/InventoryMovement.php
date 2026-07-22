<?php

declare(strict_types=1);

namespace App\Models;

final class InventoryMovement extends BaseModel
{
    protected string $table = 'inventory_movements';

    /**
     * @return array<int,array<string,mixed>>
     */
    public function listForProduct(string $productId, int $limit = 100): array
    {
        $limit = max(1, min(500, $limit));
        $stmt = $this->db->prepare(
            "SELECT * FROM {$this->table}
             WHERE product_id = :p
             ORDER BY created_at DESC, id DESC
             LIMIT :l"
        );
        $stmt->bindValue(':p', $productId);
        $stmt->bindValue(':l', $limit, \PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * @return array{items:array<int,array<string,mixed>>,total:int,page:int,per_page:int}
     */
    public function listAll(array $filters = []): array
    {
        $page    = max(1, (int) ($filters['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($filters['per_page'] ?? 20)));
        $offset  = ($page - 1) * $perPage;

        $where  = '1=1';
        $params = [];

        if (!empty($filters['movement_type'])) {
            $where   .= ' AND im.movement_type = :type';
            $params[':type'] = $filters['movement_type'];
        }

        if (!empty($filters['product_search'])) {
            $where   .= ' AND (p.name LIKE :ps OR p.sku LIKE :ps)';
            $params[':ps'] = '%' . trim((string) $filters['product_search']) . '%';
        }

        if (!empty($filters['date_from'])) {
            $where   .= ' AND im.created_at >= :df';
            $params[':df'] = $filters['date_from'] . ' 00:00:00';
        }

        if (!empty($filters['date_to'])) {
            $where   .= ' AND im.created_at <= :dt';
            $params[':dt'] = $filters['date_to'] . ' 23:59:59';
        }

        $countSql = "SELECT COUNT(*) FROM {$this->table} im
                     LEFT JOIN products p ON p.id = im.product_id
                     WHERE {$where}";
        $countStmt = $this->db->prepare($countSql);
        foreach ($params as $k => $v) $countStmt->bindValue($k, $v);
        $countStmt->execute();
        $total = (int) $countStmt->fetchColumn();

        $sql = "SELECT im.id, im.product_id, im.movement_type, im.quantity,
                       im.previous_stock, im.new_stock,
                       im.reference_type, im.reference_id, im.note,
                       im.created_by, im.created_by_user_id, im.created_at,
                       p.name AS product_name, p.sku AS product_sku,
                       u.full_name AS recorded_by_name
                FROM {$this->table} im
                LEFT JOIN products p ON p.id = im.product_id
                LEFT JOIN users u ON u.id = im.created_by_user_id
                WHERE {$where}
                ORDER BY im.created_at DESC, im.id DESC
                LIMIT {$perPage} OFFSET {$offset}";

        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) $stmt->bindValue($k, $v);
        $stmt->execute();

        return [
            'items'    => $stmt->fetchAll(),
            'total'    => $total,
            'page'     => $page,
            'per_page' => $perPage,
        ];
    }
}

