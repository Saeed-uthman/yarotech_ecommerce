<?php

declare(strict_types=1);

namespace App\Models;

final class UserAddress extends BaseModel
{
    protected string $table = 'user_addresses';

    public function listForUser(int $userId): array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM user_addresses WHERE user_id = :uid ORDER BY is_primary DESC, id DESC"
        );
        $stmt->execute([':uid' => $userId]);
        return $stmt->fetchAll();
    }

    public function findForUser(int $userId, int $id): ?array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM user_addresses WHERE user_id = :uid AND id = :id LIMIT 1"
        );
        $stmt->execute([':uid' => $userId, ':id' => $id]);
        return $stmt->fetch() ?: null;
    }
}
