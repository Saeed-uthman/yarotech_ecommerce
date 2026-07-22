/**
 * Cart service. Source of truth in Phase 1 is the local Zustand cart store.
 * Real endpoints (PHP) for server-synced cart (optional):
 *   GET    /api/cart/get.php
 *   POST   /api/cart/add.php
 *   POST   /api/cart/update.php
 *   DELETE /api/cart/remove.php
 */
import { apiFetch } from "./client";

export async function syncCart(
  items: { productId: string; quantity: number }[],
): Promise<{ ok: true }> {
  await apiFetch(`/cart/sync`, {
    method: "POST",
    body: JSON.stringify({
      items: items.map((it) => ({
        product_id: it.productId,
        quantity: it.quantity,
      })),
    }),
  });

  return { ok: true };
}
