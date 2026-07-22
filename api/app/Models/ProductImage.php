<?php

declare(strict_types=1);

namespace App\Models;

final class ProductImage extends BaseModel
{
    protected string $table = 'product_images';

    public function listFor(string $posProductId): array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM {$this->table} WHERE product_id = :p
             ORDER BY is_primary DESC, sort_order ASC, id ASC"
        );
        $stmt->execute([':p' => $posProductId]);
        return $stmt->fetchAll();
    }

    /** @return array<string,string> primary image path keyed by product_id */
    public function primaryMap(array $posIds): array
    {
        if (empty($posIds)) return [];
        $in = implode(',', array_fill(0, count($posIds), '?'));
        $stmt = $this->db->prepare(
            "SELECT product_id, image_path FROM {$this->table}
             WHERE product_id IN ($in)
             ORDER BY is_primary DESC, sort_order ASC, id ASC"
        );
        $stmt->execute(array_values($posIds));
        $out = [];
        foreach ($stmt->fetchAll() as $row) {
            if (!isset($out[$row['product_id']])) {
                $out[$row['product_id']] = $row['image_path'];
            }
        }
        return $out;
    }

    public function clearPrimaryFlag(string $posProductId): void
    {
        $stmt = $this->db->prepare(
            "UPDATE {$this->table} SET is_primary = 0 WHERE product_id = :p"
        );
        $stmt->execute([':p' => $posProductId]);
    }
}
