/**
 * POS integration shim.
 *
 * The POS system is the SOURCE OF TRUTH for core product + stock data.
 * The ecommerce system stores online-only metadata (images, specs, descriptions,
 * warranty, visibility, featured flag, reviews) and merges both views for the UI.
 *
 * Real production endpoints (PHP proxy in front of POS API):
 *   GET  /api/pos/products.php                       List POS catalog
 *   GET  /api/pos/products/show.php?product_id=  Single POS product
 *   POST /api/pos/sync-sale.php                      Push a paid online order to POS
 *   POST /api/pos/sync.php                           Trigger POS -> ecommerce mirror refresh
 *   GET  /api/admin/pos-sync/logs.php                Sale-sync audit log
 *
 * POS-controlled fields (read-only on the ecommerce side):
 *   posId, sku, name, category, price, stock, status
 *
 * Ecommerce-controlled fields (managed via admin product enrichment):
 *   slug, image/gallery, shortDescription, description, specifications,
 *   warranty, featured, visible, reviews, relatedSlugs, badges, compareAtPrice
 */
import { delay } from "./mock/delay";
import { mockPosRecords, type PosRecord } from "./mock/db";

export type { PosRecord };

/* =========================================================
 * POS catalog (read-only mirror)
 * ========================================================= */

export async function fetchPosProducts(): Promise<PosRecord[]> {
  await delay(150);
  return mockPosRecords.map((p) => ({ ...p }));
}

export async function fetchPosProduct(posId: string): Promise<PosRecord | null> {
  await delay(120);
  const p = mockPosRecords.find((x) => x.posId === posId);
  return p ? { ...p } : null;
}

export async function triggerPosSync() {
  await delay(300);
  return { ok: true as const, syncedAt: Date.now(), count: mockPosRecords.length };
}

/* =========================================================
 * Sale sync — POST a successful online order to POS so it
 * records the sale and decrements stock authoritatively.
 * ========================================================= */

export interface PosSaleLine {
  posId: string;
  sku: string;
  qty: number;
  unitPrice: number;
}

export interface PosSalePayload {
  ecomOrderId: string;
  paystackReference: string;
  customer: { name: string; email: string; phone?: string };
  items: PosSaleLine[];
  totals: { subtotal: number; vat: number; deliveryFee: number; total: number };
  paidAt: number;
}

export type PosSyncStatus = "synced" | "pending" | "failed";

export interface PosSaleSyncResult {
  ok: boolean;
  status: PosSyncStatus;
  posSaleId?: string;
  syncedAt: number;
  error?: string;
}

/**
 * Mocked POS sale sync. In production the ecommerce backend (NOT the
 * browser) calls POST /api/pos/sync-sale.php after Paystack verifies the
 * payment. The frontend only ever READS the resulting posSync status.
 */
export async function syncSuccessfulOrderToPOS(
  payload: PosSalePayload,
): Promise<PosSaleSyncResult> {
  await delay(420);
  // Simulate a 10% transient failure for realism in admin sync logs.
  const failed = Math.random() < 0.1;
  if (failed) {
    return {
      ok: false,
      status: "failed",
      syncedAt: Date.now(),
      error: "POS endpoint timeout — will retry from admin queue.",
    };
  }
  return {
    ok: true,
    status: "synced",
    posSaleId: "POS-SALE-" + payload.ecomOrderId,
    syncedAt: Date.now(),
  };
}
