<?php

declare(strict_types=1);

namespace App\Services;

use App\Core\Database;
use App\Helpers\Response;
use App\Models\InventoryMovement;
use App\Models\Notification;

final class InventoryService
{
    private \PDO $db;
    private InventoryMovement $movements;
    private NotificationService $notifications;

    public function __construct(
        ?InventoryMovement $movements = null,
        ?NotificationService $notifications = null
    ) {
        $this->db = Database::connection();
        $this->movements = $movements ?? new InventoryMovement();
        $this->notifications = $notifications ?? new NotificationService();
    }

    /**
     * @return array{product_id:string,movement_type:string,quantity:int,previous_stock:int,new_stock:int}
     */
    public function reduceForEcommerceSale(
        string $productId,
        int $quantity,
        string $orderNumber,
        ?int $createdByUserId = null,
        string $note = ''
    ): array {
        return $this->applyMovement([
            'product_id' => $productId,
            'movement_type' => 'ecommerce_sale',
            'quantity' => -abs($quantity),
            'reference_type' => 'order',
            'reference_id' => $orderNumber,
            'created_by' => 'user',
            'created_by_user_id' => $createdByUserId,
            'note' => $note !== '' ? $note : 'Successful ecommerce order',
        ]);
    }

    /**
     * @return array{product_id:string,movement_type:string,quantity:int,previous_stock:int,new_stock:int}
     */
    public function reduceForPosSale(
        string $productId,
        int $quantity,
        string $orderNumber,
        string $createdBy = 'admin',
        ?int $createdByUserId = null,
        string $note = ''
    ): array {
        return $this->applyMovement([
            'product_id' => $productId,
            'movement_type' => 'pos_sale',
            'quantity' => -abs($quantity),
            'reference_type' => 'order',
            'reference_id' => $orderNumber,
            'created_by' => $createdBy,
            'created_by_user_id' => $createdByUserId,
            'note' => $note !== '' ? $note : 'Completed POS sale',
        ]);
    }

    /**
     * @return array{product_id:string,movement_type:string,quantity:int,previous_stock:int,new_stock:int}
     */
    public function stockAdjustment(
        string $productId,
        int $quantityDelta,
        string $referenceId,
        string $createdBy,
        ?int $createdByUserId = null,
        string $note = ''
    ): array {
        if ($quantityDelta === 0) {
            Response::validation(['quantity' => 'quantity delta cannot be zero.']);
        }
        return $this->applyMovement([
            'product_id' => $productId,
            'movement_type' => 'stock_adjustment',
            'quantity' => $quantityDelta,
            'reference_type' => 'adjustment',
            'reference_id' => $referenceId,
            'created_by' => $createdBy,
            'created_by_user_id' => $createdByUserId,
            'note' => $note,
        ]);
    }

    /**
     * @return array{product_id:string,movement_type:string,quantity:int,previous_stock:int,new_stock:int}
     */
    public function stockReturn(
        string $productId,
        int $quantity,
        string $referenceId,
        string $createdBy,
        ?int $createdByUserId = null,
        string $note = ''
    ): array {
        return $this->applyMovement([
            'product_id' => $productId,
            'movement_type' => 'stock_return',
            'quantity' => abs($quantity),
            'reference_type' => 'return',
            'reference_id' => $referenceId,
            'created_by' => $createdBy,
            'created_by_user_id' => $createdByUserId,
            'note' => $note,
        ]);
    }

    /**
     * @return array{product_id:string,movement_type:string,quantity:int,previous_stock:int,new_stock:int}
     */
    public function damagedStock(
        string $productId,
        int $quantity,
        string $referenceId,
        string $createdBy,
        ?int $createdByUserId = null,
        string $note = ''
    ): array {
        return $this->applyMovement([
            'product_id' => $productId,
            'movement_type' => 'damaged_stock',
            'quantity' => -abs($quantity),
            'reference_type' => 'damage',
            'reference_id' => $referenceId,
            'created_by' => $createdBy,
            'created_by_user_id' => $createdByUserId,
            'note' => $note,
        ]);
    }

    /**
     * Set exact stock using a tracked correction movement.
     *
     * @return array{product_id:string,movement_type:string,quantity:int,previous_stock:int,new_stock:int}
     */
    public function correction(
        string $productId,
        int $newStock,
        string $referenceId,
        string $createdBy,
        ?int $createdByUserId = null,
        string $note = ''
    ): array {
        if ($newStock < 0) {
            Response::validation(['new_stock' => 'new_stock cannot be negative.']);
        }
        $current = $this->currentStock($productId);
        $delta = $newStock - $current;
        if ($delta === 0) {
            return [
                'product_id' => $productId,
                'movement_type' => 'correction',
                'quantity' => 0,
                'previous_stock' => $current,
                'new_stock' => $newStock,
            ];
        }
        return $this->applyMovement([
            'product_id' => $productId,
            'movement_type' => 'correction',
            'quantity' => $delta,
            'reference_type' => 'correction',
            'reference_id' => $referenceId,
            'created_by' => $createdBy,
            'created_by_user_id' => $createdByUserId,
            'note' => $note,
        ]);
    }

    public function currentStock(string $productId): int
    {
        $stmt = $this->db->prepare("SELECT stock_quantity FROM products WHERE id = :id LIMIT 1");
        $stmt->execute([':id' => $productId]);
        $stock = $stmt->fetchColumn();
        if ($stock === false) {
            Response::notFound('Product not found.');
        }
        return (int) $stock;
    }

    /**
     * @return array<int,array<string,mixed>>
     */
    public function movementsForProduct(string $productId, int $limit = 100): array
    {
        return $this->movements->listForProduct($productId, $limit);
    }

    /**
     * @param array{
     *   product_id:string,
     *   movement_type:string,
     *   quantity:int,
     *   reference_type:?string,
     *   reference_id:?string,
     *   created_by:string,
     *   created_by_user_id:?int,
     *   note:?string
     * } $data
     * @return array{product_id:string,movement_type:string,quantity:int,previous_stock:int,new_stock:int}
     */
    private function applyMovement(array $data): array
    {
        $productId = trim((string) $data['product_id']);
        if ($productId === '') {
            Response::validation(['product_id' => 'product_id is required.']);
        }

        $qty = (int) $data['quantity'];
        if ($qty === 0) {
            Response::validation(['quantity' => 'quantity cannot be zero.']);
        }

        $startedTx = false;
        if (!$this->db->inTransaction()) {
            $this->db->beginTransaction();
            $startedTx = true;
        }

        try {
            // Lock row to prevent concurrent oversell/over-adjustment races.
            $lock = $this->db->prepare(
                "SELECT id, name, sku, stock_quantity, minimum_stock
                 FROM products
                 WHERE id = :id
                 LIMIT 1
                 FOR UPDATE"
            );
            $lock->execute([':id' => $productId]);
            $product = $lock->fetch();
            if (!$product) {
                Response::notFound('Product not found.');
            }

            $previous = (int) $product['stock_quantity'];
            $new = $previous + $qty;
            if ($new < 0) {
                Response::error(
                    "Insufficient stock for {$product['name']}. Available: {$previous}, requested change: {$qty}.",
                    409
                );
            }

            $upd = $this->db->prepare("UPDATE products SET stock_quantity = :s WHERE id = :id");
            $upd->execute([':s' => $new, ':id' => $productId]);

            $this->movements->insert([
                'product_id' => $productId,
                'movement_type' => (string) $data['movement_type'],
                'quantity' => $qty,
                'previous_stock' => $previous,
                'new_stock' => $new,
                'reference_type' => $data['reference_type'] ?? null,
                'reference_id' => $data['reference_id'] ?? null,
                'created_by' => (string) ($data['created_by'] ?? 'system'),
                'created_by_user_id' => $data['created_by_user_id'] ?? null,
                'note' => $data['note'] ?? null,
            ]);

            if ($startedTx) {
                $this->db->commit();
            }

            $this->emitLowStockAlertIfNeeded($product, $new);

            return [
                'product_id' => $productId,
                'movement_type' => (string) $data['movement_type'],
                'quantity' => $qty,
                'previous_stock' => $previous,
                'new_stock' => $new,
            ];
        } catch (\Throwable $e) {
            if ($startedTx && $this->db->inTransaction()) {
                $this->db->rollBack();
            }
            throw $e;
        }
    }

    /**
     * @param array<string,mixed> $product
     */
    private function emitLowStockAlertIfNeeded(array $product, int $newStock): void
    {
        $threshold = max(0, (int) ($product['minimum_stock'] ?? 5));
        if ($newStock > $threshold) return;

        $this->notifications->createAdminNotification(
            'low_stock',
            'Low stock alert: ' . (string) ($product['name'] ?? $product['id'] ?? 'Product'),
            'Current stock is ' . $newStock . ' unit(s).',
            [
                'product_id' => (string) ($product['id'] ?? ''),
                'sku' => (string) ($product['sku'] ?? ''),
                'stock_quantity' => $newStock,
                'minimum_stock' => $threshold,
            ]
        );
    }
}

