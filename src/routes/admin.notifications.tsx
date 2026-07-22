import { createFileRoute } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import {
  Bell,
  CheckCheck,
  ShoppingCart,
  CreditCard,
  AlertTriangle,
  LifeBuoy,
  Activity,
} from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { EmptyState } from "@/components/common/EmptyState";
import {
  useAdminNotificationStore,
  type AdminNotificationKind,
} from "@/stores/admin-notifications";
import { formatDistanceToNow } from "date-fns";
import { fetchUserActivityLogs } from "@/api/admin";
import { Skeleton } from "@/components/ui/skeleton";

export const Route = createFileRoute("/admin/notifications")({
  component: AdminNotifications,
  head: () => ({ meta: [{ title: "Audit & Notifications — Admin" }] }),
});

const ICON: Record<string, typeof Bell> = {
  order: ShoppingCart,
  order_created: ShoppingCart,
  payment: CreditCard,
  payment_success: CreditCard,
  system: AlertTriangle,
  support: LifeBuoy,
};

function AdminNotifications() {
  const [tab, setTab] = useState<"alerts" | "audit">("alerts");
  const items = useAdminNotificationStore((s) => s.items);
  const unread = items.filter((i) => !i.read).length;

  const handleMarkAllRead = () => {
    import("@/api/admin").then((m) => m.markAllNotificationsRead());
  };

  const handleMarkRead = (id: string) => {
    import("@/api/admin").then((m) => m.markNotificationRead(id));
  };

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="System Control"
        title="Audit & Notifications"
        description="Monitor real-time system audit logs, user activity, and admin alerts."
        actions={
          tab === "alerts" && (
            <button
              onClick={handleMarkAllRead}
              disabled={unread === 0}
              className="inline-flex h-10 items-center gap-2 rounded-sm border border-border px-4 text-xs font-semibold uppercase tracking-wide text-primary hover:bg-accent disabled:opacity-50 transition cursor-pointer"
            >
              <CheckCheck className="h-4 w-4" /> Mark all read ({unread})
            </button>
          )
        }
      />

      <div className="flex gap-1 border-b border-border">
        {(["alerts", "audit"] as const).map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`px-4 py-2 text-xs font-semibold uppercase tracking-wider border-b-2 -mb-px transition cursor-pointer ${
              tab === t
                ? "border-secondary text-primary"
                : "border-transparent text-muted-foreground hover:text-primary"
            }`}
          >
            {t === "alerts" ? `System Alerts (${unread})` : "Activity Audit Logs"}
          </button>
        ))}
      </div>

      {tab === "alerts" && (
        <div className="space-y-4">
          {items.length === 0 ? (
            <EmptyState
              icon={<Bell className="h-5 w-5" />}
              title="No alerts"
              description="Admin alerts will surface here as orders, payments, inventory events, and contact messages arrive."
            />
          ) : (
            <ul className="divide-y divide-border rounded-md border border-border bg-surface">
              {items.map((n) => {
                const Icon = ICON[n.kind] || Bell;
                return (
                  <li key={n.id}>
                    <button
                      onClick={() => !n.read && handleMarkRead(n.id)}
                      className={`flex w-full items-start gap-3 p-4 text-left transition-colors hover:bg-accent/40 ${
                        n.read ? "opacity-75" : ""
                      }`}
                    >
                      <span className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-sm bg-accent text-secondary">
                        <Icon className="h-4 w-4" />
                      </span>
                      <div className="min-w-0 flex-1">
                        <div className="flex items-start justify-between gap-2">
                          <p className="text-sm font-semibold text-primary">{n.title}</p>
                          {!n.read && (
                            <span className="text-[10px] font-bold uppercase text-secondary bg-secondary/10 px-1.5 py-0.5 rounded-sm">
                              New
                            </span>
                          )}
                        </div>
                        <p className="text-xs text-muted-foreground mt-0.5">{n.body}</p>
                        <p className="mt-1 text-[10px] uppercase tracking-widest text-muted-foreground font-medium">
                          {formatDistanceToNow(n.createdAt, { addSuffix: true })} • {n.kind}
                        </p>
                      </div>
                    </button>
                  </li>
                );
              })}
            </ul>
          )}
        </div>
      )}

      {tab === "audit" && <ActivityAuditLogs />}
    </div>
  );
}

/* ---------------- Activity Audit Logs ---------------- */
const ACTION_DESCRIPTIONS: Record<string, string> = {
  login_success: "logged in successfully",
  login_failed: "attempted to login (failed)",
  user_registered: "registered a new account",
  pos_sale_created: "created a new POS sale",
  order_status_updated: "updated order status",
  order_cancelled: "cancelled order",
  payment_initialize: "initiated payment checkout",
  payment_verify: "verified payment reference",
  payment_success: "completed payment successfully",
  payment_webhook_success: "webhook payment confirmed successfully",
  payment_webhook_failed: "webhook payment processing failed",
};

function formatContext(contextStr: string): string {
  if (!contextStr) return "";
  try {
    const parsed = JSON.parse(contextStr);
    if (parsed && typeof parsed === "object") {
      return Object.entries(parsed)
        .map(([key, val]) => {
          const cleanKey = key.replace(/_/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
          return `${cleanKey}: ${val}`;
        })
        .join(" • ");
    }
  } catch {
    return contextStr;
  }
  return contextStr;
}

function ActivityAuditLogs() {
  const [logs, setLogs] = useState<any[] | null>(null);

  useEffect(() => {
    fetchUserActivityLogs().then((res) => {
      setLogs(res || []);
    });
  }, []);

  if (!logs) return <Skeleton className="h-64" />;

  return (
    <div className="space-y-4">
      {logs.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-12 text-center border border-dashed border-border rounded-md bg-surface">
          <Activity className="h-10 w-10 text-muted-foreground/40 mb-3" />
          <h3 className="font-semibold text-muted-foreground">No activities recorded yet</h3>
          <p className="text-xs text-muted-foreground max-w-sm mt-1">
            Real-time system events such as logins, payments, and POS creation will appear here.
          </p>
        </div>
      ) : (
        <ul className="divide-y divide-border rounded-md border border-border bg-surface">
          {logs.map((l: any) => {
            const actionStr = l.action || "";
            const isError = actionStr.includes("fail") || actionStr.includes("cancel");
            const isSuccess = actionStr.includes("success") || actionStr.includes("verify");
            const actionText = ACTION_DESCRIPTIONS[actionStr] || actionStr.replace(/_/g, " ");

            return (
              <li
                key={l.id}
                className="flex items-start gap-4 px-5 py-4 hover:bg-muted/30 transition-colors"
              >
                <div
                  className={`p-2 rounded-full mt-0.5 ${
                    isError
                      ? "bg-red-500/10 text-red-500"
                      : isSuccess
                        ? "bg-emerald-500/10 text-emerald-500"
                        : "bg-blue-500/10 text-blue-500"
                  }`}
                >
                  <Activity className="h-4 w-4" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm leading-tight text-primary">
                    <span className="font-bold text-foreground">{l.userName}</span>{" "}
                    <span className="text-muted-foreground">{actionText}</span>
                  </p>
                  {l.context && (
                    <p className="text-xs text-muted-foreground mt-1 font-medium bg-muted/40 px-2 py-1 rounded-sm inline-block truncate max-w-full">
                      {formatContext(l.context)}
                    </p>
                  )}
                </div>
                <span className="text-[10px] font-semibold uppercase tracking-wider text-muted-foreground whitespace-nowrap pt-1">
                  {formatDistanceToNow(l.createdAt, { addSuffix: true })}
                </span>
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
