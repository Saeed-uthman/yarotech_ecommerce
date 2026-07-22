<?php

declare(strict_types=1);

namespace App\Models;

/**
 * Cart model. A cart belongs to either an authenticated user_id or to a
 * guest session_token. Status transitions: active -> converted | abandoned.
 */
final class Cart extends BaseModel
{
    protected string $table = 'carts';

    public function findActiveForUser(int $userId): ?array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM carts WHERE user_id = :uid AND status = 'active' ORDER BY id DESC LIMIT 1"
        );
        $stmt->execute([':uid' => $userId]);
        return $stmt->fetch() ?: null;
    }

    public function findActiveForSession(string $token): ?array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM carts WHERE session_token = :tok AND status = 'active' ORDER BY id DESC LIMIT 1"
        );
        $stmt->execute([':tok' => $token]);
        return $stmt->fetch() ?: null;
    }

    public function createForUser(int $userId): array
    {
        $id = $this->insert([
            'user_id' => $userId,
            'status'  => 'active',
        ]);
        return $this->find((int) $id) ?? [];
    }

    public function createForSession(string $token): array
    {
        $id = $this->insert([
            'session_token' => $token,
            'status'        => 'active',
        ]);
        return $this->find((int) $id) ?? [];
    }

    public function markConverted(int $cartId): void
    {
        $this->update($cartId, ['status' => 'converted']);
    }

    /**
     * Re-assign a guest cart to a freshly authenticated user. If the user
     * already had a cart, the guest cart's items are merged into it and
     * the guest cart is dropped.
     */
    public function attachToUser(int $cartId, int $userId, CartItem $items): array
    {
        $existing = $this->findActiveForUser($userId);
        if (!$existing) {
            $stmt = $this->db->prepare(
                "UPDATE carts SET user_id = :uid, session_token = NULL WHERE id = :id"
            );
            $stmt->execute([':uid' => $userId, ':id' => $cartId]);
            return $this->find($cartId) ?? [];
        }
        // Merge items from the guest cart into the user's existing cart.
        $items->mergeInto($cartId, (int) $existing['id']);
        $this->delete($cartId);
        return $existing;
    }
}
