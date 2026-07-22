import { useState, useRef, useEffect } from "react";
import { Link } from "@tanstack/react-router";
import { Bell } from "lucide-react";
import { useAdminNotificationStore, type AdminNotification } from "@/stores/admin-notifications";
import { formatDistanceToNow } from "date-fns";

export function AdminNotificationBell() {
  const items = useAdminNotificationStore((s) => s.items);
  const markRead = (id: string) => {
    import("@/api/admin").then((m) => m.markNotificationRead(id));
  };
  const markAllRead = () => {
    import("@/api/admin").then((m) => m.markAllNotificationsRead());
  };
  const unread = items.filter((i) => !i.read).length;
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("mousedown", handler);

    // Fetch real notifications on mount and poll every 15 seconds
    import("@/api/admin").then((m) => m.fetchAdminNotifications());
    const interval = setInterval(() => {
      import("@/api/admin").then((m) => m.fetchAdminNotifications());
    }, 15000);

    return () => {
      document.removeEventListener("mousedown", handler);
      clearInterval(interval);
    };
  }, []);

  return (
    <div ref={ref} className="relative">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        className="relative flex h-9 w-9 items-center justify-center rounded-sm border border-border bg-surface text-primary hover:bg-accent"
        aria-label="Admin notifications"
      >
        <Bell className="h-4 w-4" />
        {unread > 0 && (
          <span className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-secondary px-1 text-[10px] font-bold text-secondary-foreground">
            {unread}
          </span>
        )}
      </button>
      {open && (
        <div className="absolute right-0 z-50 mt-2 w-96 rounded-md border border-border bg-surface shadow-lg">
          <div className="flex items-center justify-between border-b border-border px-3 py-2">
            <p className="text-sm font-semibold">Admin notifications</p>
            <div className="flex items-center gap-2">
              <span className="text-xs text-muted-foreground">{unread} unread</span>
              {unread > 0 && (
                <button
                  onClick={markAllRead}
                  className="text-[10px] font-semibold uppercase tracking-wider text-secondary hover:underline"
                >
                  Mark all
                </button>
              )}
            </div>
          </div>
          <div className="max-h-96 overflow-y-auto">
            {items.length === 0 ? (
              <p className="p-6 text-center text-sm text-muted-foreground">
                No admin notifications yet.
              </p>
            ) : (
              items
                .slice(0, 10)
                .map((n) => (
                  <Row
                    key={n.id}
                    n={n}
                    onRead={() => markRead(n.id)}
                    onNav={() => setOpen(false)}
                  />
                ))
            )}
          </div>
          <Link
            to="/admin/notifications"
            onClick={() => setOpen(false)}
            className="block border-t border-border px-3 py-2 text-center text-xs font-semibold text-primary hover:bg-accent"
          >
            View all
          </Link>
        </div>
      )}
    </div>
  );
}

const KIND_DOT: Record<AdminNotification["kind"], string> = {
  order: "bg-secondary",
  payment: "bg-success",
  system: "bg-primary",
  support: "bg-warning",
};

function Row({
  n,
  onRead,
  onNav,
}: {
  n: AdminNotification;
  onRead: () => void;
  onNav: () => void;
}) {
  const inner = (
    <div
      className={`block border-b border-border px-3 py-2.5 text-left transition-colors hover:bg-accent ${n.read ? "opacity-70" : ""}`}
    >
      <div className="flex items-start gap-2">
        <span className={`mt-1.5 h-2 w-2 shrink-0 rounded-full ${KIND_DOT[n.kind]}`} />
        <div className="min-w-0 flex-1">
          <div className="flex items-start justify-between gap-2">
            <p className="text-sm font-semibold text-primary">{n.title}</p>
            {!n.read && <span className="text-[10px] font-bold uppercase text-secondary">New</span>}
          </div>
          <p className="mt-0.5 line-clamp-2 text-xs text-muted-foreground">{n.body}</p>
          <p className="mt-1 text-[10px] uppercase tracking-wider text-muted-foreground">
            {formatDistanceToNow(n.createdAt, { addSuffix: true })}
          </p>
        </div>
      </div>
    </div>
  );

  if (n.href) {
    return (
      <Link
        to={n.href}
        onClick={() => {
          onRead();
          onNav();
        }}
        className="block"
      >
        {inner}
      </Link>
    );
  }
  return (
    <button type="button" onClick={onRead} className="block w-full">
      {inner}
    </button>
  );
}
