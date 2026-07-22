/**
 * Checkout service.
 * Real endpoints (PHP):
 *   POST /api/checkout/preview.php   (calculate VAT, delivery fee, totals)
 *   POST /api/checkout/place.php     (create order, returns order id)
 *   GET  /api/orders/show.php?order_number=...
 *   GET  /api/orders/invoice.php?order_number=...
 */
import { apiFetch, ApiError } from "./client";
import type { CartItem } from "@/stores/cart";
import { syncCart } from "./cart";

export type FulfillmentMethod = "pickup" | "delivery";

export interface DeliveryAddress {
  state: string;
  city: string;
  address1: string;
  landmark?: string;
  phone: string;
  notes?: string;
}

export interface CustomerDetails {
  fullName: string;
  email: string;
  phone: string;
  company?: string;
}

export interface CheckoutPayload {
  items: CartItem[];
  customer: CustomerDetails;
  fulfillment: FulfillmentMethod;
  delivery?: DeliveryAddress;
  subtotal: number;
  vat: number;
  deliveryFee: number;
  total: number;
}

export interface PlaceOrderResponse {
  orderId: string;
  reference: string;
  authorizationUrl?: string; // Real paystack auth url
}

// Keeping this synchronous to avoid breaking the UI that expects it immediately.
// In a fuller refactor, this would fetch from /api/delivery/zones.
export const DELIVERY_STATES = ["Lagos", "Ogun", "Oyo", "Abuja", "Rivers", "Kano"];

export function calculateDeliveryFee(
  method: FulfillmentMethod,
  state: string,
): { fee: number; eta: string } {
  if (method === "pickup") return { fee: 0, eta: "Ready in 24 hours" };

  const map: Record<string, { fee: number; eta: string }> = {
    Lagos: { fee: 3500, eta: "2–3 business days" },
    Ogun: { fee: 5000, eta: "3–4 business days" },
    Oyo: { fee: 5000, eta: "3–4 business days" },
    Abuja: { fee: 8500, eta: "4–6 business days" },
    Rivers: { fee: 8500, eta: "4–6 business days" },
    Kano: { fee: 8500, eta: "4–6 business days" },
  };

  return map[state] || { fee: 12000, eta: "5–8 business days" };
}

export interface CheckoutPreview {
  subtotal: number;
  vat: number;
  deliveryFee: number;
  zoneLabel: string;
  eta: string;
  total: number;
  itemCount: number;
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export async function createCheckoutPreview(args: {
  items: CartItem[];
  fulfillment: FulfillmentMethod;
  state?: string;
}): Promise<CheckoutPreview> {
  // Sync the cart first to ensure the backend has the items to calculate totals
  await syncCart(args.items);

  // apiFetch returns the full envelope { success, message, data }
  // so the nested preview payload is at res.data (not res.data.data)
  const res = await apiFetch<{ success: boolean; message: string; data: any }>(`/checkout/preview`, {
    method: "POST",
    body: JSON.stringify({
      fulfillment_method: args.fulfillment,
      state: args.state,
    }),
  });

  // Backend shape: { data: { cart, fulfillment, totals, warnings } }
  const payload = res?.data ?? res; // guard against double-wrapped responses
  const totals = payload?.totals;
  const fulfillment = payload?.fulfillment;
  const cart = payload?.cart;

  if (!totals) {
    throw new ApiError(
      `Checkout preview returned an unexpected response. Please try again.`,
      500,
      res,
    );
  }

  return {
    subtotal: totals.subtotal,
    vat: totals.vat,
    deliveryFee: totals.delivery_fee,
    zoneLabel: fulfillment?.zone ?? "",
    eta: fulfillment?.eta ?? "",
    total: totals.total,
    itemCount: cart?.count ?? args.items.reduce((s, i) => s + i.quantity, 0),
  };
}

export async function placeOrder(payload: CheckoutPayload): Promise<PlaceOrderResponse> {
  const backendPayload: any = {
    fulfillment_method: payload.fulfillment,
    customer_name: payload.customer.fullName,
    customer_email: payload.customer.email,
    customer_phone: payload.customer.phone,
    customer_company: payload.customer.company,
  };

  if (payload.fulfillment === "delivery" && payload.delivery) {
    backendPayload.state = payload.delivery.state;
    backendPayload.city_or_lga = payload.delivery.city;
    backendPayload.address_line = payload.delivery.address1;
    backendPayload.landmark = payload.delivery.landmark;
    backendPayload.delivery_notes = payload.delivery.notes;
  }

  // Ensure cart is synced before attempting to checkout
  await syncCart(payload.items);

  const res = await apiFetch<ApiResponse<any>>(`/payments/initialize`, {
    method: "POST",
    body: JSON.stringify(backendPayload),
  });

  const responseData = res?.data ?? res;

  if (!responseData?.order_number) {
    throw new ApiError(
      res?.message || `Failed to initialize payment. Please try again.`,
      500,
      res
    );
  }

  return {
    orderId: responseData.order_number,
    reference: responseData.reference,
    authorizationUrl: responseData.authorization_url,
  };
}
