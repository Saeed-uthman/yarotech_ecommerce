<?php

declare(strict_types=1);

namespace App\Models;

final class CartItem extends BaseModel
{
    protected string $table = 'cart_items';

    /** @return array<int,array<string,mixed>> */
    public function listForCart(int $cartId): array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM cart_items WHERE cart_id = :cid ORDER BY id ASC"
        );
        $stmt->execute([':cid' => $cartId]);
        return $stmt->fetchAll();
    }

    public function findInCart(int $cartId, string $posProductId): ?array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM cart_items WHERE cart_id = :cid AND product_id = :pid LIMIT 1"
        );
        $stmt->execute([':cid' => $cartId, ':pid' => $posProductId]);
        return $stmt->fetch() ?: null;
    }

    public function upsert(int $cartId, string $posProductId, int $quantity): void
    {
        $existing = $this->findInCart($cartId, $posProductId);
        if ($existing) {
            $this->setQuantity((int) $existing['id'], $quantity);
            return;
        }
        $this->insert([
            'cart_id'        => $cartId,
            'product_id' => $posProductId,
            'quantity'       => $quantity,
        ]);
    }

    public function setQuantity(int $itemId, int $quantity): void
    {
        if ($quantity <= 0) { $this->delete($itemId); return; }
        $stmt = $this->db->prepare("UPDATE cart_items SET quantity = :q WHERE id = :id");
        $stmt->execute([':q' => $quantity, ':id' => $itemId]);
    }

    public function removeProduct(int $cartId, string $posProductId): void
    {
        $stmt = $this->db->prepare(
            "DELETE FROM cart_items WHERE cart_id = :cid AND product_id = :pid"
        );
        $stmt->execute([':cid' => $cartId, ':pid' => $posProductId]);
    }

    public function clearCart(int $cartId): void
    {
        $stmt = $this->db->prepare("DELETE FROM cart_items WHERE cart_id = :cid");
        $stmt->execute([':cid' => $cartId]);
    }

    /** Move items from $fromCart into $toCart, summing on conflict. */
    public function mergeInto(int $fromCart, int $toCart): void
    {
        foreach ($this->listForCart($fromCart) as $row) {
            $existing = $this->findInCart($toCart, $row['product_id']);
            if ($existing) {
                $this->setQuantity(
                    (int) $existing['id'],
                    (int) $existing['quantity'] + (int) $row['quantity']
                );
            } else {
                $this->insert([
                    'cart_id'        => $toCart,
                    'product_id' => $row['product_id'],
                    'quantity'       => (int) $row['quantity'],
                ]);
            }
        }
        $this->clearCart($fromCart);
    }
}
