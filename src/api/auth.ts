/**
 * Auth service — frontend stubs for PHP/MySQL + SMTP backend.
 *
 * Real endpoints (to be wired in production):
 *   POST /api/auth/register.php
 *   POST /api/auth/login.php
 *   POST /api/auth/verify-account.php
 *   POST /api/auth/resend-verification-otp.php
 *   POST /api/auth/forgot-password.php
 *   POST /api/auth/verify-forgot-otp.php
 *   POST /api/auth/reset-password.php
 *   GET  /api/auth/me.php
 *   PATCH /api/auth/profile.php
 *
 * Backend notes:
 *   - SMTP delivers a 6-digit OTP for email verification + password reset.
 *   - OTP records stored in `auth_otps` (email, code_hash, purpose, expires_at, used_at).
 *   - Verification + reset OTPs expire after 10 minutes.
 *   - Resend throttled server-side (60 second window).
 *   - Sessions issued as JWT, returned as `token` in the response body.
 */
import type { AuthUser, AccountType } from "@/stores/auth";
import { delay } from "./mock/delay";
import { ApiError, apiFetch } from "./client";

export interface RegisterPayload {
  fullName: string;
  email: string;
  phone: string;
  password: string;
  confirmPassword: string;
  acceptTerms: boolean;
}

export interface LoginPayload {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: AuthUser;
  token: string;
}

function transformUser(u: any): AuthUser {
  return {
    id: u.id,
    email: u.email,
    fullName: u.full_name || u.fullName || "",
    phone: u.phone || "",
    role: u.role || "user",
    accountType: u.account_type || u.accountType || null,
    company: u.company || null,
    emailVerified: !!(u.email_verified_at || u.emailVerified),
  };
}

export async function register(payload: RegisterPayload): Promise<{ user: AuthUser }> {
  const res = await apiFetch<{ data: { user: any }; message: string }>("/auth/register", {
    method: "POST",
    body: JSON.stringify({
      full_name: payload.fullName,
      email: payload.email,
      phone: payload.phone,
      password: payload.password,
    }),
  });
  return {
    user: transformUser(res.data.user),
  };
}

export async function login(payload: LoginPayload): Promise<AuthResponse> {
  const res = await apiFetch<{ data: { user: any; token: string }; message: string }>(
    "/auth/login",
    {
      method: "POST",
      body: JSON.stringify({
        email: payload.email,
        password: payload.password,
      }),
    },
  );
  return {
    user: transformUser(res.data.user),
    token: res.data.token,
  };
}

export interface GoogleLoginPayload {
  email: string;
  fullName: string;
}

export async function googleLogin(payload: GoogleLoginPayload): Promise<AuthResponse> {
  const res = await apiFetch<{ data: { user: any; token: string }; message: string }>(
    "/auth/google",
    {
      method: "POST",
      body: JSON.stringify({
        email: payload.email,
        full_name: payload.fullName,
      }),
    },
  );
  return {
    user: transformUser(res.data.user),
    token: res.data.token,
  };
}

export async function verifyOtp(email: string, otp: string): Promise<{ ok: true }> {
  await apiFetch("/auth/verify-account", {
    method: "POST",
    body: JSON.stringify({ email, otp }),
  });
  return { ok: true };
}

export const verifyAccount = verifyOtp;

export async function resendOtp(email: string): Promise<{ ok: true }> {
  await apiFetch("/auth/resend-verification-otp", {
    method: "POST",
    body: JSON.stringify({ email }),
  });
  return { ok: true };
}

export async function forgotPassword(email: string): Promise<{ ok: true }> {
  await apiFetch("/auth/forgot-password", {
    method: "POST",
    body: JSON.stringify({ email }),
  });
  return { ok: true };
}

export async function verifyForgotOtp(
  email: string,
  otp: string,
): Promise<{ ok: true; resetToken: string }> {
  const res = await apiFetch<{ data: { reset_token: string } }>("/auth/verify-forgot-otp", {
    method: "POST",
    body: JSON.stringify({ email, otp }),
  });
  return { ok: true, resetToken: res.data.reset_token };
}

export async function resetPassword(
  email: string,
  resetToken: string,
  newPassword: string,
): Promise<{ ok: true }> {
  await apiFetch("/auth/reset-password", {
    method: "POST",
    body: JSON.stringify({ email, reset_token: resetToken, password: newPassword }),
  });
  return { ok: true };
}

export async function getCurrentUser(): Promise<AuthUser | null> {
  try {
    const res = await apiFetch<{ data: any }>("/auth/me");
    return transformUser(res.data);
  } catch {
    return null;
  }
}

export interface ProfileUpdatePayload {
  fullName?: string;
  phone?: string;
  company?: string;
  accountType?: AccountType;
}

export async function updateProfile(patch: ProfileUpdatePayload): Promise<{ ok: true }> {
  await delay(220);
  if (patch.fullName !== undefined && !patch.fullName.trim()) {
    throw new ApiError("Name cannot be empty", 400);
  }
  return { ok: true };
}

/* =========================================================
 * Ecommerce-only audit log
 * Real endpoint: POST /api/admin/audit/user-activity.php
 *
 * The ecommerce system records its OWN events only (registration, login,
 * logout, failed login, password reset, OTP verify, checkout attempt,
 * successful payment). It NEVER tries to audit POS login activity — POS
 * audit is only affected by the successful sale sync push from
 * syncSuccessfulOrderToPOS().
 * ========================================================= */
export type AuditEvent =
  | "register"
  | "login"
  | "logout"
  | "login_failed"
  | "password_reset"
  | "otp_verified"
  | "checkout_attempt"
  | "payment_success";

export async function recordUserActivity(
  event: AuditEvent,
  meta?: Record<string, unknown>,
): Promise<{ ok: true }> {
  await delay(60);
  if (import.meta.env.DEV) {
    console.debug("[audit]", event, meta ?? {});
  }
  return { ok: true };
}
