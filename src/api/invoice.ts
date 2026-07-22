/**
 * Invoice service.
 * Provides invoice data (JSON) and PDF download for both pre-payment
 * (checkout preview) and post-payment (DB order) scenarios.
 *
 * Real endpoints (PHP):
 *   GET /api/invoices/data?order_number=...
 *   GET /api/invoices/pdf?order_number=...
 */
import { apiFetch, API_BASE_URL } from "./client";

export interface InvoiceItem {
  product_name_snapshot: string;
  sku_snapshot: string;
  quantity: number;
  unit_price_snapshot: number;
  line_total: number;
}

export interface InvoiceOrder {
  order_number: string;
  order_status: string;
  payment_status: string;
  fulfillment_method: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  subtotal: number;
  tax_amount: number;
  delivery_fee: number;
  total_amount: number;
  currency: string;
  created_at: string;
  delivery_state?: string;
  delivery_city?: string;
  delivery_address?: string;
  delivery_landmark?: string;
  delivery_phone?: string;
}

export interface InvoiceData {
  invoice_number: string;
  issued_at: string;
  valid_until: string;
  order: InvoiceOrder;
  items: InvoiceItem[];
  payment: { reference: string; status: string; amount: number } | null;
  tracking: unknown[];
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

/**
 * Fetch invoice JSON data for a given order number.
 */
export async function fetchInvoiceData(orderNumber: string): Promise<InvoiceData | null> {
  try {
    const res = await apiFetch<ApiResponse<InvoiceData>>(
      `/invoices/data?order_number=${encodeURIComponent(orderNumber)}`,
    );
    return res.data;
  } catch {
    return null;
  }
}

/**
 * Trigger a browser download of the invoice PDF.
 */
export async function downloadInvoicePdf(orderNumber: string): Promise<void> {
  let authToken: string | null = null;
  try {
    const state = JSON.parse(localStorage.getItem("yarotech-auth") || "{}");
    if (state?.state?.token) {
      authToken = state.state.token;
    }
  } catch {
    // ignore
  }

  const url = `${API_BASE_URL}/invoices/pdf?order_number=${encodeURIComponent(orderNumber)}`;
  const res = await fetch(url, {
    headers: authToken ? { Authorization: `Bearer ${authToken}` } : {},
  });

  if (!res.ok) {
    throw new Error(`Failed to download invoice (${res.status})`);
  }

  const blob = await res.blob();
  const blobUrl = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = blobUrl;
  a.download = `YAROTECH-Invoice-${orderNumber}.pdf`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(blobUrl);
}
