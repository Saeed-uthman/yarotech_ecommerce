<?php

declare(strict_types=1);

namespace App\Models;

final class ProductRelated extends BaseModel
{
    protected string $table = 'product_related';

    /** @return string[] related product_ids */
    public function relatedIds(string $posProductId, int $limit = 8): array
    {
        $stmt = $this->db->prepare(
            "SELECT related_product_id FROM {$this->table}
             WHERE product_id = :p
             ORDER BY id ASC
             LIMIT :l"
        );
        $stmt->bindValue(':p', $posProductId);
        $stmt->bindValue(':l', $limit, \PDO::PARAM_INT);
        $stmt->execute();
        return array_column($stmt->fetchAll(), 'related_product_id');
    }

    public function replaceAll(string $posProductId, array $relatedIds): void
    {
        $del = $this->db->prepare("DELETE FROM {$this->table} WHERE product_id = :p");
        $del->execute([':p' => $posProductId]);
        foreach ($relatedIds as $rid) {
            if ($rid === $posProductId) continue;
            $this->insert([
                'product_id'         => $posProductId,
                'related_product_id' => (string) $rid,
            ]);
        }
    }
}
