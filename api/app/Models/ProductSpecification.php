<?php

declare(strict_types=1);

namespace App\Models;

final class ProductSpecification extends BaseModel
{
    protected string $table = 'product_specifications';

    public function listFor(string $posProductId): array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM {$this->table} WHERE product_id = :p
             ORDER BY sort_order ASC, id ASC"
        );
        $stmt->execute([':p' => $posProductId]);
        return $stmt->fetchAll();
    }

    public function replaceAll(string $posProductId, array $specs): void
    {
        $del = $this->db->prepare("DELETE FROM {$this->table} WHERE product_id = :p");
        $del->execute([':p' => $posProductId]);
        $sort = 0;
        foreach ($specs as $spec) {
            if (empty($spec['spec_name']) || !isset($spec['spec_value'])) continue;
            $this->insert([
                'product_id' => $posProductId,
                'spec_name'      => (string) $spec['spec_name'],
                'spec_value'     => (string) $spec['spec_value'],
                'spec_group'     => $spec['spec_group'] ?? null,
                'sort_order'     => $sort++,
            ]);
        }
    }
}
