/**
 * Orders service.
 * Real endpoints (PHP):
 *   GET /api/orders/mine.php
 *   GET /api/orders/show.php?order_number=...
 *   GET /api/orders/invoice.php?order_number=...   (returns PDF binary)
 *   GET /api/orders/email-preview.php?order_number=...
 *   GET /api/admin/orders.php
 */
import { apiFetch } from "./client";
import { syncSuccessfulOrderToPOS, type PosSalePayload, type PosSaleSyncResult } from "./pos";
import { useAuthStore } from "@/stores/auth";
import { apiDateMs } from "@/lib/dates";

export interface MockOrder {
  id: string;
  reference: string;
  customerEmail: string;
  customerName?: string;
  subtotal: number;
  vat: number;
  deliveryFee: number;
  total: number;
  status: "pending" | "paid" | "processing" | "ready_for_pickup" | "shipped" | "delivered" | "picked_up" | "cancelled";
  paymentStatus: "pending" | "success" | "failed";
  deliveryMethod?: "delivery" | "pickup";
  items: { sku: string; name: string; qty: number; price: number }[];
  createdAt: number;
  itemCount: number;
}

export type Order = MockOrder;

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export async function syncPaidOrderToPos(payload: PosSalePayload): Promise<PosSaleSyncResult> {
  // Try the ecommerce backend /api/orders/sync-pos first
  try {
    const res = await apiFetch<ApiResponse<any>>("/orders/sync-pos", {
      method: "POST",
      body: JSON.stringify({ order_number: payload.ecomOrderId }),
    });
    return {
      ok: true,
      status: "synced" as const,
      posSaleId: res.data.pos_sale_id || "POS-SYNC",
      syncedAt: Date.now(),
    };
  } catch (err) {
    // Fallback to direct POS sync if needed or just throw
    return syncSuccessfulOrderToPOS(payload);
  }
}

function mapOrder(backendOrder: any, items: any[] = [], payment: any = {}): Order {
  const taxAmount = backendOrder.tax_amount ?? backendOrder.vat ?? backendOrder.tax ?? 0;
  const subtotal = backendOrder.subtotal ?? backendOrder.subtotal_amount ?? 0;
  const total = backendOrder.total_amount ?? backendOrder.total ?? 0;
  const deliveryFee = backendOrder.delivery_fee ?? backendOrder.shipping_fee ?? 0;

  return {
    id: backendOrder.order_number,
    reference: payment.reference || backendOrder.order_number,
    customerEmail: backendOrder.customer_email || "",
    customerName: backendOrder.customer_name || "",
    subtotal: Number(subtotal),
    vat: Number(taxAmount),
    deliveryFee: Number(deliveryFee),
    total: Number(total),
    status: backendOrder.order_status || backendOrder.status,
    paymentStatus: (backendOrder.payment_status === "paid" ? "success" : backendOrder.payment_status) || "pending",
    deliveryMethod: backendOrder.fulfillment_method || "delivery",
    items: items.map((i) => ({
      sku: i.sku_snapshot || i.product_id || i.sku || "UNKNOWN",
      name: i.product_name_snapshot || i.product_name || i.name || "Product",
      qty: Number(i.quantity || i.qty || 1),
      price: Number(i.unit_price_snapshot || i.unit_price || i.price || 0),
    })),
    createdAt: apiDateMs(backendOrder.created_at),
    itemCount: items.reduce((acc, curr) => acc + Number(curr.quantity || curr.qty || 0), 0) || 1,
  };
}

export async function listMyOrders(): Promise<Order[]> {
  const res = await apiFetch<ApiResponse<any[]>>(`/orders`);
  return res.data.map((o) => mapOrder(o)).sort((a, b) => b.createdAt - a.createdAt);
}

export async function getOrder(id: string): Promise<Order | null> {
  try {
    const { user } = useAuthStore.getState();
    const isAdminOrStaff = user?.role === "admin" || user?.role === "staff";
    const url = isAdminOrStaff
      ? `/admin/orders/show?id=${encodeURIComponent(id)}`
      : `/orders/show?order_number=${encodeURIComponent(id)}`;

    const res = await apiFetch<ApiResponse<any>>(url);
    return mapOrder(res.data.order, res.data.items, res.data.payment);
  } catch (err) {
    return null;
  }
}

export async function fetchOrderReceipt(orderNumber: string): Promise<Order | null> {
  try {
    const res = await apiFetch<ApiResponse<any>>(
      `/orders/invoice?order_number=${encodeURIComponent(orderNumber)}`,
    );
    return mapOrder(res.data.order, res.data.items, res.data.payment);
  } catch (err) {
    return null;
  }
}

export interface OrderEmailPreview {
  subject: string;
  preheader: string;
  bodyLines: string[];
  to: string;
}

export async function fetchOrderEmailPreview(
  orderNumber: string,
): Promise<OrderEmailPreview | null> {
  const order = await getOrder(orderNumber);
  if (!order) return null;
  return {
    subject: `Your YAROTECH order ${order.id} is confirmed`,
    preheader: "Thanks for your purchase — here are your order details.",
    to: order.customerEmail,
    bodyLines: [
      `Order Number: ${order.id}`,
      `Reference: ${order.reference}`,
      `Items: ${order.itemCount}`,
      `Total Paid: ₦${order.total.toLocaleString()}`,
    ],
  };
}

export function downloadInvoice(order: Order) {
  const html = generateReceiptHtml(order);
  const blob = new Blob([html], { type: "text/html" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `YAROTECH-Invoice-${order.id}.html`;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(url);
}

export function printReceipt(order: Order) {
  const html = generateReceiptHtml(order);
  const printWindow = window.open("", "_blank");
  if (printWindow) {
    printWindow.document.write(html);
    printWindow.document.close();
    printWindow.focus();
    setTimeout(() => {
      printWindow.print();
    }, 500);
  }
}

function generateReceiptHtml(order: Order): string {
  return `<!doctype html><html><head><meta charset="utf-8"><title>Invoice ${order.id}</title>
<style>body{font-family:Arial,sans-serif;color:#0a1733;padding:32px;max-width:720px;margin:auto}
<h1>YAROTECH</h1><p class="muted">Engineering Procurement Invoice</p>
<p><b>Order:</b> ${order.id}<br/><b>Reference:</b> ${order.reference}<br/>
<b>Customer:</b> ${order.customerName || order.customerEmail || "Walk-in customer"}<br/>
<b>Date:</b> ${new Date(order.createdAt).toLocaleString()}</p>
<table><thead><tr><th>Item</th><th>SKU</th><th>Qty</th><th>Price</th></tr></thead><tbody>
${order.items.map((i) => `<tr><td>${i.name}</td><td>${i.sku}</td><td>${i.qty}</td><td>₦${i.price.toLocaleString()}</td></tr>`).join("")}
</tbody></table>
<p style="margin-top:16px">Subtotal: ₦${order.subtotal.toLocaleString()}<br/>
VAT (7.5%): ₦${order.vat.toLocaleString()}</p>
<p class="total">Total Paid: ₦${order.total.toLocaleString()}</p>
<p class="muted">Thank you for choosing YAROTECH.</p></body></html>`;
}
