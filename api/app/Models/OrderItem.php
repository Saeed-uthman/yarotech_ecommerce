<?php

declare(strict_types=1);

namespace App\Models;

final class OrderItem extends BaseModel
{
    protected string $table = 'order_items';

    public function listForOrder(int $orderId): array
    {
        $stmt = $this->db->prepare("SELECT * FROM order_items WHERE order_id = :o ORDER BY id ASC");
        $stmt->execute([':o' => $orderId]);
        return $stmt->fetchAll();
    }
}
