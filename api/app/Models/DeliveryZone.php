<?php

declare(strict_types=1);

namespace App\Models;

final class DeliveryZone extends BaseModel
{
    protected string $table = 'delivery_zones';

    /** @return array<int,array<string,mixed>> */
    public function activeZones(): array
    {
        $stmt = $this->db->query(
            "SELECT * FROM delivery_zones WHERE is_active = 1 ORDER BY state ASC, city_or_lga ASC"
        );
        return $stmt->fetchAll();
    }

    /**
     * Resolve the most specific zone for a given state + city.
     * Falls back to the wildcard ('*') row for the same state.
     */
    public function resolve(string $state, ?string $city): ?array
    {
        $city = trim((string) $city);

        // Specific city match.
        if ($city !== '') {
            $stmt = $this->db->prepare(
                "SELECT * FROM delivery_zones
                 WHERE is_active = 1 AND state = :s AND city_or_lga = :c
                 ORDER BY id DESC LIMIT 1"
            );
            $stmt->execute([':s' => $state, ':c' => $city]);
            $row = $stmt->fetch();
            if ($row) return $row;
        }

        // State-level wildcard.
        $stmt = $this->db->prepare(
            "SELECT * FROM delivery_zones
             WHERE is_active = 1 AND state = :s AND city_or_lga = '*'
             ORDER BY id DESC LIMIT 1"
        );
        $stmt->execute([':s' => $state]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * @return array<int,array<string,mixed>>
     */
    public function listAll(?bool $active = null): array
    {
        if ($active === null) {
            $stmt = $this->db->query(
                "SELECT * FROM delivery_zones ORDER BY state ASC, city_or_lga ASC, id DESC"
            );
            return $stmt->fetchAll();
        }

        $stmt = $this->db->prepare(
            "SELECT * FROM delivery_zones
             WHERE is_active = :a
             ORDER BY state ASC, city_or_lga ASC, id DESC"
        );
        $stmt->execute([':a' => $active ? 1 : 0]);
        return $stmt->fetchAll();
    }

    public function upsert(array $payload): array
    {
        $id = (int) ($payload['id'] ?? 0);
        if ($id > 0) {
            $existing = $this->find($id);
            if ($existing) {
                $update = [];
                $keys = ['state', 'city_or_lga', 'zone_name', 'base_fee', 'extra_fee_per_kg', 'eta_text', 'is_active'];
                foreach ($keys as $k) {
                    if (array_key_exists($k, $payload) && $payload[$k] !== null && $payload[$k] !== '') {
                        $update[$k] = ($k === 'is_active') ? ($payload[$k] ? 1 : 0) : $payload[$k];
                    }
                }
                if (!empty($update)) {
                    $this->update($id, $update);
                }
                return $this->find($id) ?? [];
            }
        }

        $newId = (int) $this->insert([
            'state'            => $payload['state'],
            'city_or_lga'      => $payload['city_or_lga'],
            'zone_name'        => $payload['zone_name'],
            'base_fee'         => $payload['base_fee'],
            'extra_fee_per_kg' => $payload['extra_fee_per_kg'],
            'eta_text'         => $payload['eta_text'],
            'is_active'        => $payload['is_active'] ? 1 : 0,
        ]);

        return $this->find($newId) ?? [];
    }
}
