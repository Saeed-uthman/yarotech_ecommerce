<?php

declare(strict_types=1);

namespace App\Models;

final class Product extends BaseModel
{
    protected string $table = 'products';
    protected string $primaryKey = 'id';

    public function findBySlug(string $slug): ?array
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE slug = :s LIMIT 1");
        $stmt->execute([':s' => $slug]);
        return $stmt->fetch() ?: null;
    }

    /**
     * @return array<int,array<string,mixed>>
     */
    public function listAll(array $filters = []): array
    {
        $where = ['1=1'];
        $params = [];

        if (!empty($filters['status'])) {
            $where[] = 'status = :status';
            $params[':status'] = (string) $filters['status'];
        }
        if (!empty($filters['category'])) {
            $where[] = 'category = :category';
            $params[':category'] = (string) $filters['category'];
        }
        if (!empty($filters['search'])) {
            $where[] = '(name LIKE :q OR sku LIKE :q OR id LIKE :q)';
            $params[':q'] = '%' . trim((string) $filters['search']) . '%';
        }

        $sql = "SELECT * FROM {$this->table}
                WHERE " . implode(' AND ', $where) . "
                ORDER BY created_at DESC, id DESC";
        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) {
            $stmt->bindValue($k, $v);
        }
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * @return string[]
     */
    public function categories(): array
    {
        $stmt = $this->db->query(
            "SELECT DISTINCT category
             FROM {$this->table}
             WHERE status = 'active' AND category IS NOT NULL AND category <> ''
             ORDER BY category ASC"
        );
        return array_values(array_filter(array_map(
            fn(array $r): string => (string) ($r['category'] ?? ''),
            $stmt->fetchAll()
        )));
    }

    public function generateProductId(): string
    {
        return 'PRD-' . strtoupper(bin2hex(random_bytes(4)));
    }

    public function generateSku(): string
    {
        return 'SKU-' . strtoupper(bin2hex(random_bytes(4)));
    }

    public function ensureUniqueSlug(string $slug, ?string $excludeId = null): string
    {
        $base = strtolower(trim((string) preg_replace('/[^a-zA-Z0-9]+/', '-', $slug), '-'));
        $base = $base !== '' ? $base : 'product';

        $candidate = $base;
        $i = 2;
        while ($this->slugExists($candidate, $excludeId)) {
            $candidate = $base . '-' . $i++;
        }
        return $candidate;
    }

    private function slugExists(string $slug, ?string $excludeId = null): bool
    {
        $sql = "SELECT 1 FROM {$this->table} WHERE slug = :s";
        $params = [':s' => $slug];
        if ($excludeId !== null && $excludeId !== '') {
            $sql .= " AND id <> :id";
            $params[':id'] = $excludeId;
        }
        $sql .= " LIMIT 1";

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return (bool) $stmt->fetchColumn();
    }
}
