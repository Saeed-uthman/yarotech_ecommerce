<?php

declare(strict_types=1);

namespace App\Models;

final class AuthOtp extends BaseModel
{
    protected string $table = 'auth_otps';

    public function createOtp(string $email, string $purpose, string $codeHash, int $expiresInMinutes = 10): string
    {
        $expiresAt = date('Y-m-d H:i:s', strtotime("+$expiresInMinutes minutes"));

        return $this->insert([
            'email'      => $email,
            'code_hash'  => $codeHash,
            'purpose'    => $purpose,
            'expires_at' => $expiresAt,
            'used_at'    => null,
        ]);
    }

    public function getValidOtp(string $email, string $purpose): ?array
    {
        $stmt = $this->db->prepare("
            SELECT * FROM {$this->table}
            WHERE email = ? 
              AND purpose = ? 
              AND used_at IS NULL 
              AND expires_at > NOW()
            ORDER BY created_at DESC 
            LIMIT 1
        ");
        $stmt->execute([$email, $purpose]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function markAsUsed(int $id): bool
    {
        return $this->update($id, [
            'used_at' => date('Y-m-d H:i:s')
        ]);
    }

    public function invalidateAllForEmail(string $email, string $purpose): void
    {
        $stmt = $this->db->prepare("
            UPDATE {$this->table} 
            SET used_at = NOW() 
            WHERE email = ? AND purpose = ? AND used_at IS NULL
        ");
        $stmt->execute([$email, $purpose]);
    }
}
