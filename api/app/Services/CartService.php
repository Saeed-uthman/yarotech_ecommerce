<?php

declare(strict_types=1);

namespace App\Services;

use App\Helpers\Response;
use App\Models\Cart;
use App\Models\CartItem;

/**
 * CartService — single source of truth for cart state.
 *
 * Pricing & stock are pulled live from ProductService at every read, so the
 * frontend can never spoof totals. Display fields (slug, image,
 * description) come from the local ecommerce metadata tables.
 */
final class CartService
{
    public function __construct(
        private Cart $carts = new Cart(),
        private CartItem $items = new CartItem(),
        private TaxService $tax = new TaxService(),
    ) {}

    // ----------------------------- Resolution -----------------------------

    public function getOrCreateCart(?int $userId, ?string $sessionToken): array
    {
        if ($userId !== null) {
            return $this->carts->findActiveForUser($userId)
                ?? $this->carts->createForUser($userId);
        }
        if ($sessionToken !== null) {
            return $this->carts->findActiveForSession($sessionToken)
                ?? $this->carts->createForSession($sessionToken);
        }
        Response::error('Cannot resolve cart owner.', 400);
    }

    // ----------------------------- Mutations -----------------------------

    public function addItem(array $cart, string $posProductId, int $quantity): array
    {
        if ($quantity < 1) Response::validation(['quantity' => 'Quantity must be at least 1.']);

        $product = clone (new ProductService())->detailById($posProductId) ?? [];
        if (empty($product)) Response::notFound('Product not found.');
        if (($product['status'] ?? 'active') !== 'active') {
            Response::error('Product is not currently available.', 409);
        }

        $existing = $this->items->findInCart((int) $cart['id'], $posProductId);
        $newQty   = ($existing ? (int) $existing['quantity'] : 0) + $quantity;

        $this->guardStock($product, $newQty);

        $this->items->upsert((int) $cart['id'], $posProductId, $newQty);
        return $this->buildCartView($cart);
    }

    public function updateItem(array $cart, string $posProductId, int $quantity): array
    {
        if ($quantity < 0) Response::validation(['quantity' => 'Quantity cannot be negative.']);

        if ($quantity === 0) {
            $this->items->removeProduct((int) $cart['id'], $posProductId);
            return $this->buildCartView($cart);
        }

        $product = clone (new ProductService())->detailById($posProductId) ?? [];
        if (empty($product)) Response::notFound('Product not found.');
        $this->guardStock($product, $quantity);

        $existing = $this->items->findInCart((int) $cart['id'], $posProductId);
        if (!$existing) Response::notFound('Item is not in the cart.');

        $this->items->setQuantity((int) $existing['id'], $quantity);
        return $this->buildCartView($cart);
    }

    public function removeItem(array $cart, string $posProductId): array
    {
        $this->items->removeProduct((int) $cart['id'], $posProductId);
        return $this->buildCartView($cart);
    }

    public function clear(array $cart): array
    {
        $this->items->clearCart((int) $cart['id']);
        return $this->buildCartView($cart);
    }

    public function syncItems(array $cart, array $items): array
    {
        $this->items->clearCart((int) $cart['id']);
        foreach ($items as $item) {
            $posId = (string) ($item['product_id'] ?? '');
            $qty   = (int) ($item['quantity'] ?? 1);
            if ($posId !== '' && $qty > 0) {
                // We use silent upsert here; stock guarding happens during buildCartView warnings
                $this->items->upsert((int) $cart['id'], $posId, $qty);
            }
        }
        return $this->buildCartView($cart);
    }

    // ----------------------------- Read -----------------------------

    /**
     * Build the merged cart view used by every cart endpoint AND by
     * checkout preview — guarantees consistent pricing logic.
     */
    public function buildCartView(array $cart): array
    {
        $rows  = $this->items->listForCart((int) $cart['id']);
        if (empty($rows)) {
            return $this->emptyView($cart);
        }

        $posIds     = array_column($rows, 'product_id');

        $items    = [];
        $warnings = [];
        $subtotal = 0.0;
        $count    = 0;

        foreach ($rows as $row) {
            $posId   = $row['product_id'];
            $qty     = (int) $row['quantity'];
            $product = (new ProductService())->detailById($posId);

            // Product gone from POS — flag and skip in totals.
            if (!$product) {
                $items[] = [
                    'product_id' => $posId,
                    'name'           => 'Unavailable product',
                    'sku'            => '',
                    'quantity'       => $qty,
                    'price'          => 0,
                    'line_total'     => 0,
                    'stock_quantity' => 0,
                    'stock_status'   => 'unavailable',
                    'image'          => '',
                    'slug'           => $posId,
                    'available'      => false,
                ];
                $warnings[] = "Item $posId is no longer available and will be removed at checkout.";
                continue;
            }

            // Auto-clamp quantity if POS stock dropped below cart qty.
            $stock     = (int) $product['stock_quantity'];
            $clamped   = min($qty, max(0, $stock));
            if ($clamped !== $qty) {
                $warnings[] = "{$product['name']} quantity reduced to $clamped due to POS stock.";
                $this->items->setQuantity((int) $row['id'], $clamped);
                $qty = $clamped;
            }
            if ($qty === 0) continue;

            $price     = (float) $product['price'];
            $lineTotal = $price * $qty;
            $subtotal += $lineTotal;
            $count    += $qty;

            $items[] = [
                'product_id' => $posId,
                'name'           => $product['name'],
                'sku'            => $product['sku'],
                'category'       => $product['category'],
                'quantity'       => $qty,
                'price'          => $price,
                'line_total'     => $lineTotal,
                'stock_quantity' => $stock,
                'stock_status'   => $stock <= 0 ? 'out_of_stock' : ($stock <= 5 ? 'low_stock' : 'in_stock'),
                'image'          => $product['primary_image'] ?? '',
                'slug'           => $product['slug'] ?? $posId,
                'available'      => true,
            ];
        }

        $vat   = $this->tax->vatFor($subtotal);
        $total = $subtotal + $vat;

        return [
            'cart_id'    => (int) $cart['id'],
            'user_id'    => $cart['user_id'] !== null ? (int) $cart['user_id'] : null,
            'session_token' => $cart['session_token'] ?? null,
            'items'      => $items,
            'count'      => $count,
            'subtotal'   => round($subtotal, 2),
            'vat'        => round($vat, 2),
            'vat_rate'   => $this->tax->rate(),
            'total'      => round($total, 2),
            'warnings'   => $warnings,
        ];
    }

    private function emptyView(array $cart): array
    {
        return [
            'cart_id'       => (int) $cart['id'],
            'user_id'       => $cart['user_id'] !== null ? (int) $cart['user_id'] : null,
            'session_token' => $cart['session_token'] ?? null,
            'items'         => [],
            'count'         => 0,
            'subtotal'      => 0,
            'vat'           => 0,
            'vat_rate'      => $this->tax->rate(),
            'total'         => 0,
            'warnings'      => [],
        ];
    }

    private function guardStock(array $product, int $requestedQty): void
    {
        $stock = (int) ($product['stock_quantity'] ?? 0);
        if ($stock <= 0) {
            Response::error("{$product['name']} is out of stock.", 409);
        }
        if ($requestedQty > $stock) {
            Response::error(
                "Only $stock unit(s) of {$product['name']} are available.",
                409,
            );
        }
    }
}

