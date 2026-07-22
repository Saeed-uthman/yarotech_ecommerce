/**
 * Paystack payments service.
 * Real endpoints (PHP):
 *   POST /api/payments/initialize.php   (returns Paystack authorization_url + reference)
 *   GET  /api/payments/verify.php?reference=...   (server-side verify with Paystack secret key,
 *        marks order paid, sends customer + admin emails, pushes admin notification)
 *
 * Phase 4: simulated. We skip the real Paystack redirect and emulate the
 * processing -> success/failed flow client-side.
 */
import { apiFetch, ApiError } from "./client";

export interface InitializePaymentPayload {
  orderId: string;
  reference: string;
  email: string;
  amount: number;
}

export interface InitializePaymentResponse {
  authorizationUrl: string;
  reference: string;
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export async function initializePaystackPayment(
  payload: InitializePaymentPayload,
): Promise<InitializePaymentResponse> {
  // placeOrder already initialized payment and returned the authorizationUrl.
  // We don't actually need to make another API call here if the frontend passes the url,
  // but to keep the frontend contract intact, we'll just return what's expected.
  // In a real flow, if it wasn't returned earlier, we'd hit /api/payments/initialize.

  return {
    authorizationUrl:
      (payload as any).authorizationUrl ||
      `/payment/processing?ref=${encodeURIComponent(payload.reference)}&orderId=${encodeURIComponent(payload.orderId)}`,
    reference: payload.reference,
  };
}

// Backwards-compatible alias used by older callers.
export const initializePayment = initializePaystackPayment;

export interface VerifyPaymentResponse {
  status: "success" | "failed";
  reference: string;
  orderNumber?: string;
  reason?: string;
  gatewayResponse?: string;
}

export async function verifyPaystackPayment(reference: string): Promise<VerifyPaymentResponse> {
  try {
    const res = await apiFetch<ApiResponse<any>>(
      `/payments/verify?reference=${encodeURIComponent(reference)}`,
    );
    // Backend returns { success: true, data: { order, payment } }
    return {
      status: "success",
      reference,
      gatewayResponse: "Approved",
      orderNumber: res.data?.order?.order_number,
    };
  } catch (err: any) {
    return {
      status: "failed",
      reference,
      reason: err.message || "Payment verification failed",
      gatewayResponse: "Declined",
    };
  }
}

export const verifyPayment = verifyPaystackPayment;
