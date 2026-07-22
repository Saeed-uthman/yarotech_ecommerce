<?php

declare(strict_types=1);

namespace App\Models;

final class ProductReview extends BaseModel
{
    protected string $table = 'product_reviews';

    public function approvedFor(string $posProductId, int $limit = 50): array
    {
        $stmt = $this->db->prepare(
            "SELECT r.*, u.full_name AS user_name
             FROM {$this->table} r
             LEFT JOIN users u ON u.id = r.user_id
             WHERE r.product_id = :p AND r.status = 'approved'
             ORDER BY r.created_at DESC
             LIMIT :l"
        );
        $stmt->bindValue(':p', $posProductId);
        $stmt->bindValue(':l', $limit, \PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * @return array<string,array{average:float,count:int}> keyed by product_id
     */
    public function statsMap(array $posIds): array
    {
        if (empty($posIds)) return [];
        $in = implode(',', array_fill(0, count($posIds), '?'));
        $stmt = $this->db->prepare(
            "SELECT product_id,
                    ROUND(AVG(rating), 2) AS avg_rating,
                    COUNT(*) AS review_count
             FROM {$this->table}
             WHERE status = 'approved' AND product_id IN ($in)
             GROUP BY product_id"
        );
        $stmt->execute(array_values($posIds));
        $out = [];
        foreach ($stmt->fetchAll() as $row) {
            $out[$row['product_id']] = [
                'average' => (float) $row['avg_rating'],
                'count'   => (int) $row['review_count'],
            ];
        }
        return $out;
    }

    public function getAdminReviews(?string $status = null): array
    {
        $sql = "SELECT r.*, u.full_name AS user_name 
                FROM {$this->table} r
                LEFT JOIN users u ON u.id = r.user_id";
        
        $params = [];
        if ($status) {
            $sql .= " WHERE r.status = :status";
            $params[':status'] = $status;
        }
        $sql .= " ORDER BY r.created_at DESC";

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }
}
