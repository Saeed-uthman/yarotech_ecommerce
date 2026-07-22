import { apiFetch } from "./client";

export interface ActivityLogItem {
  id: number;
  staff_id: number;
  staff_name: string;
  action_type: string;
  description: string;
  reference_id: number | null;
  is_read: number | boolean;
  created_at: string;
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

type ActivityLogListResponse =
  | { items: ActivityLogItem[] }
  | ApiResponse<{ items: ActivityLogItem[] }>;

function unwrapActivityLogItems(res: ActivityLogListResponse): { items: ActivityLogItem[] } {
  if ("data" in res) {
    return { items: res.data?.items || [] };
  }

  return { items: res.items || [] };
}

export async function getRecentActivityLogs(): Promise<{ items: ActivityLogItem[] }> {
  const res = await apiFetch<ActivityLogListResponse>("/admin/activity-logs");
  return unwrapActivityLogItems(res);
}

export async function getUnreadHighPriorityLogs(): Promise<{ items: ActivityLogItem[] }> {
  const res = await apiFetch<ActivityLogListResponse>("/admin/activity-logs/unread");
  return unwrapActivityLogItems(res);
}

export async function markActivityLogsAsRead(id?: number): Promise<{ success: boolean }> {
  return apiFetch("/admin/activity-logs/mark-read", {
    method: "POST",
    body: JSON.stringify({ id: id || 0 }),
  });
}
