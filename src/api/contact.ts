/**
 * Contact / Inquiry service.
 *
 * Real endpoint (PHP):
 *   POST /api/contact/store.php
 *
 * Backend responsibilities (when wired):
 *   1. Validate + persist row in `contact_inquiries` table.
 *   2. Send SMTP acknowledgement email to the customer.
 *   3. Send SMTP notification email to admin (support@yarotech.ng).
 *   4. Insert an admin notification record (kind = "support") so it
 *      surfaces in /admin/notifications and the bell.
 *   5. Return { ok, ticketId } so the frontend can show a confirmation.
 *
 * IMPORTANT: This module is the ONLY inquiry intake. There is no
 * standalone service request module and no quote workflow — service
 * inquiries flow through here with `serviceType` set.
 */
import { apiFetch, ApiError } from "./client";
import { apiDateMs } from "@/lib/dates";

export const INQUIRY_TYPES = [
  "General Inquiry",
  "Product Support",
  "Delivery Support",
  "Service Inquiry",
  "Payment Issue",
  "Complaint",
] as const;
export type InquiryType = (typeof INQUIRY_TYPES)[number];

export const SERVICE_TYPES = [
  "Not applicable",
  "Solar Installation",
  "CCTV Installation",
  "Internet Networking",
  "IT Services",
] as const;
export type ServiceType = (typeof SERVICE_TYPES)[number];

export interface ContactPayload {
  name: string;
  email: string;
  phone: string;
  inquiryType: InquiryType;
  serviceType?: ServiceType;
  message: string;
  /** Optional, kept for legacy callers */
  subject?: string;
}

export interface ContactResult {
  ok: true;
  ticketId: string;
  /** Backend will mark true once SMTP customer ack is dispatched */
  customerAckQueued: boolean;
  /** Backend will mark true once admin email + notification are queued */
  adminNotified: boolean;
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export async function submitContact(payload: ContactPayload): Promise<ContactResult> {
  if (!payload.name || payload.name.trim().length < 2)
    throw new ApiError("Please enter your full name", 400);
  if (!payload.email.includes("@")) throw new ApiError("Invalid email address", 400);
  if (!payload.phone || payload.phone.trim().length < 7)
    throw new ApiError("Please enter a valid phone number", 400);
  if (!payload.inquiryType) throw new ApiError("Please select an inquiry type", 400);
  if (!payload.message || payload.message.trim().length < 10)
    throw new ApiError("Please provide a more detailed message", 400);

  const res = await apiFetch<ApiResponse<ContactResult>>(`/contact/store`, {
    method: "POST",
    body: JSON.stringify(payload),
  });

  if (!res || !res.data) {
    throw new ApiError(
      "Unexpected response from server: " + 
      (typeof res === 'string' ? res.substring(0, 50) : JSON.stringify(res)),
      500
    );
  }

  return res.data;
}

export async function fetchMyTickets(): Promise<import("./mock/admin-db").SupportMessage[]> {
  const res =
    await apiFetch<ApiResponse<import("./mock/admin-db").SupportMessage[]>>("/support/my-tickets");
  return res.data.map((t: any) => ({
    ...t,
    id: String(t.id),
    createdAt: apiDateMs(t.created_at || t.createdAt),
    status: t.status_ui || t.status,
    reply: t.admin_reply ?? t.reply,
  }));
}
