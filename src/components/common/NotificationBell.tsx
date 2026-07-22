import { useState, useRef, useEffect } from "react";
import { Link } from "@tanstack/react-router";
import { Bell } from "lucide-react";
import { useNotificationStore, type AppNotification } from "@/stores/notifications";
import { formatDistanceToNow } from "date-fns";

export function NotificationBell({ to = "/dashboard/notifications" }: { to?: string }) {
  const items = useNotificationStore((s) => s.items);
  const markRead = (id: string) => {
    import("@/api/notifications").then((m) => m.markNotificationReadApi(id));
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
    import("@/api/notifications").then((m) => m.fetchMyNotifications());
    const interval = setInterval(() => {
      import("@/api/notifications").then((m) => m.fetchMyNotifications());
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
        aria-label="Notifications"
      >
        <Bell className="h-4 w-4" />
        {unread > 0 && (
          <span className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-secondary px-1 text-[10px] font-bold text-secondary-foreground">
            {unread}
          </span>
        )}
      </button>
      {open && (
        <div className="absolute right-0 z-50 mt-2 w-80 rounded-md border border-border bg-surface shadow-lg">
          <div className="flex items-center justify-between border-b border-border px-3 py-2">
            <p className="text-sm font-semibold">Notifications</p>
            <span className="text-xs text-muted-foreground">{unread} unread</span>
          </div>
          <div className="max-h-80 overflow-y-auto">
            {items.length === 0 ? (
              <p className="p-6 text-center text-sm text-muted-foreground">No notifications yet.</p>
            ) : (
              items
                .slice(0, 8)
                .map((n) => <NotificationRow key={n.id} n={n} onRead={() => markRead(n.id)} />)
            )}
          </div>
          <Link
            to={to}
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

function NotificationRow({ n, onRead }: { n: AppNotification; onRead: () => void }) {
  return (
    <button
      type="button"
      onClick={onRead}
      className={`block w-full border-b border-border px-3 py-2 text-left transition-colors hover:bg-accent ${
        n.read ? "opacity-70" : ""
      }`}
    >
      <div className="flex items-start justify-between gap-2">
        <p className="text-sm font-semibold text-primary">{n.title}</p>
        {!n.read && <span className="mt-1 h-2 w-2 rounded-full bg-secondary" />}
      </div>
      <p className="mt-0.5 line-clamp-2 text-xs text-muted-foreground">{n.body}</p>
      <p className="mt-1 text-[10px] uppercase tracking-wider text-muted-foreground">
        {formatDistanceToNow(n.createdAt, { addSuffix: true })}
      </p>
    </button>
  );
}
