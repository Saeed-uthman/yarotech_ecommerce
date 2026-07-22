<?php

declare(strict_types=1);

namespace App\Models;

final class Setting extends BaseModel
{
    protected string $table = 'settings';
    private bool $hasKeyName = false;
    private bool $hasValueJson = false;

    public function __construct()
    {
        parent::__construct();
        $this->detectLegacyColumns();
    }

    public function findByKey(string $key): ?array
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE setting_key = :k LIMIT 1");
        $stmt->execute([':k' => $key]);
        return $stmt->fetch() ?: null;
    }

    public function upsert(string $key, string $value, string $group = 'general', bool $isPublic = false): array
    {
        $existing = $this->findByKey($key);
        if ($existing) {
            $data = [
                'setting_value' => $value,
                'setting_group' => $group,
                'is_public'     => $isPublic ? 1 : 0,
            ];
            if ($this->hasKeyName) $data['key_name'] = $key;
            if ($this->hasValueJson) $data['value_json'] = $this->safeJson($value);
            $this->update((int) $existing['id'], $data);
            return $this->find((int) $existing['id']) ?? $existing;
        }

        $insertData = [
            'setting_key'   => $key,
            'setting_value' => $value,
            'setting_group' => $group,
            'is_public'     => $isPublic ? 1 : 0,
        ];
        if ($this->hasKeyName) $insertData['key_name'] = $key;
        if ($this->hasValueJson) $insertData['value_json'] = $this->safeJson($value);

        $id = (int) $this->insert($insertData);

        return $this->find($id) ?? [];
    }

    /**
     * @return array<int,array<string,mixed>>
     */
    public function listByGroup(?string $group = null): array
    {
        if ($group === null || $group === '') {
            $stmt = $this->db->query(
                "SELECT * FROM {$this->table} ORDER BY setting_group ASC, setting_key ASC"
            );
            return $stmt->fetchAll();
        }

        $stmt = $this->db->prepare(
            "SELECT * FROM {$this->table} WHERE setting_group = :g ORDER BY setting_key ASC"
        );
        $stmt->execute([':g' => $group]);
        return $stmt->fetchAll();
    }

    /**
     * @return array<string,string>
     */
    public function mapByGroup(?string $group = null): array
    {
        $rows = $this->listByGroup($group);
        $out = [];
        foreach ($rows as $r) {
            $out[(string) $r['setting_key']] = (string) ($r['setting_value'] ?? '');
        }
        return $out;
    }

    private function safeJson(string $value): string
    {
        $decoded = json_decode($value, true);
        if (json_last_error() === JSON_ERROR_NONE) {
            return json_encode($decoded);
        }
        return json_encode($value);
    }

    private function detectLegacyColumns(): void
    {
        $stmt = $this->db->prepare(
            "SELECT COLUMN_NAME
             FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = :table
               AND COLUMN_NAME IN ('key_name', 'value_json')"
        );
        $stmt->execute([':table' => $this->table]);
        $cols = array_map(fn($r) => (string) $r['COLUMN_NAME'], $stmt->fetchAll());
        $this->hasKeyName = in_array('key_name', $cols, true);
        $this->hasValueJson = in_array('value_json', $cols, true);
    }
}
