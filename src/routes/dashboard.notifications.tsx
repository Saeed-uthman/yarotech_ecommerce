import { createFileRoute } from "@tanstack/react-router";
import { Bell, CheckCheck } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { EmptyState } from "@/components/common/EmptyState";
import { useNotificationStore } from "@/stores/notifications";

export const Route = createFileRoute("/dashboard/notifications")({
  component: NotificationsPage,
  head: () => ({ meta: [{ title: "Notifications — YAROTECH" }] }),
});

function NotificationsPage() {
  const notifications = useNotificationStore((s) => s.items);

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Inbox"
        title="Notifications"
        description="System alerts, order updates, and account activity."
        actions={
          <button
            onClick={() => {
              import("@/api/notifications").then((m) => m.markAllNotificationsReadApi());
            }}
            className="inline-flex h-10 items-center gap-2 rounded-sm border border-border px-4 text-xs font-semibold uppercase tracking-wide text-primary hover:bg-accent"
          >
            <CheckCheck className="h-4 w-4" /> Mark all read
          </button>
        }
      />

      {notifications.length === 0 ? (
        <EmptyState
          icon={<Bell className="h-5 w-5" />}
          title="You're all caught up"
          description="New notifications will appear here."
        />
      ) : (
        <ul className="divide-y divide-border rounded-md border border-border bg-surface">
          {notifications.map((n) => (
            <li key={n.id} className="flex items-start gap-3 p-4">
              <span
                className={`mt-1 h-2 w-2 shrink-0 rounded-full ${n.read ? "bg-muted" : "bg-secondary"}`}
              />
              <div className="flex-1">
                <p className="text-sm font-semibold text-primary">{n.title}</p>
                {n.body && <p className="text-xs text-muted-foreground">{n.body}</p>}
                <p className="mt-1 text-[10px] uppercase tracking-widest text-muted-foreground">
                  {new Date(n.createdAt).toLocaleString()}
                </p>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
