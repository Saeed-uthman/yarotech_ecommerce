<?php

declare(strict_types=1);

namespace App\Models;

final class OrderTracking extends BaseModel
{
    protected string $table = 'order_tracking';

    public function add(int $orderId, string $status, string $title, ?string $description = null): void
    {
        $this->insert([
            'order_id'    => $orderId,
            'status'      => $status,
            'title'       => $title,
            'description' => $description,
        ]);
    }

    public function listForOrder(int $orderId): array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM order_tracking WHERE order_id = :o ORDER BY created_at ASC, id ASC"
        );
        $stmt->execute([':o' => $orderId]);
        return $stmt->fetchAll();
    }
}
