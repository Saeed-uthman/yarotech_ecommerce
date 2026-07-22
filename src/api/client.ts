/**
 * API client wrapper.
 *
 * In Phase 1 every service uses an in-memory mock layer (USE_MOCK = true).
 * To wire to the real PHP + MySQL backend later:
 *   1. Set USE_MOCK = false
 *   2. Set VITE_API_BASE_URL to your PHP backend root, e.g. https://api.yarotech.ng
 *   3. Each service file documents the exact PHP endpoint to hit.
 */

export const USE_MOCK = false;

export const API_BASE_URL = (import.meta as any).env?.VITE_API_BASE_URL ?? "/api";

export const ASSET_BASE_URL = API_BASE_URL.replace(/\/api\/?$/, "");

export class ApiError extends Error {
  status: number;
  data?: unknown;
  constructor(message: string, status = 500, data?: unknown) {
    super(message);
    this.status = status;
    this.data = data;
  }
}

export async function apiFetch<T = unknown>(
  path: string,
  init: RequestInit & { token?: string | null } = {},
): Promise<T> {
  const { token, headers, ...rest } = init;

  // Retrieve token from zustand store if not explicitly provided
  let authToken = token;
  if (authToken === undefined) {
    try {
      const state = JSON.parse(localStorage.getItem("yarotech-auth") || "{}");
      if (state?.state?.token) {
        authToken = state.state.token;
      }
    } catch (e) {
      // ignore parsing errors
    }
  }

  const defaultHeaders: Record<string, string> = {};
  if (!(rest.body instanceof FormData)) {
    defaultHeaders["Content-Type"] = "application/json";
  }
  if (authToken) {
    defaultHeaders["Authorization"] = `Bearer ${authToken}`;
  }

  const res = await fetch(`${API_BASE_URL}${path}`, {
    ...rest,
    headers: {
      ...defaultHeaders,
      ...(headers ?? {}),
    },
  });
  const text = await res.text();
  const data = text ? safeParse(text) : null;
  if (!res.ok) {
    const msg = (data && (data as any).message) || `Request failed (${res.status})`;
    throw new ApiError(msg, res.status, data);
  }
  return data as T;
}

function safeParse(t: string) {
  try {
    return JSON.parse(t);
  } catch {
    return t;
  }
}
