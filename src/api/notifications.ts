/**
 * Notifications service.
 * Real endpoints (PHP):
 *   GET  /api/notifications/mine.php
 *   POST /api/notifications/mark-read.php
 *   GET  /api/admin/notifications.php
 */
import { apiFetch } from "./client";
import { useNotificationStore } from "@/stores/notifications";
import { apiDateMs } from "@/lib/dates";

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export async function fetchMyNotifications() {
  try {
    const res = await apiFetch<ApiResponse<any>>("/notifications");
    const mapped = res.data.items.map((n: any) => ({
      id: String(n.id),
      kind: n.type || "system",
      title: n.title,
      body: n.message || "",
      createdAt: apiDateMs(n.created_at),
      read: !!n.is_read,
      href: n.data?.link_url || "#",
    }));
    useNotificationStore.getState().hydrate(mapped);
    return mapped;
  } catch (err) {
    return [];
  }
}

export async function markNotificationReadApi(id: string) {
  try {
    await apiFetch("/notifications/mark-read", {
      method: "POST",
      body: JSON.stringify({ id }),
    });
    useNotificationStore.getState().markRead(id);
    return true;
  } catch {
    return false;
  }
}

export async function markAllNotificationsReadApi() {
  try {
    await apiFetch("/notifications/mark-all-read", {
      method: "POST",
    });
    useNotificationStore.getState().markAllRead();
    return true;
  } catch {
    return false;
  }
}
