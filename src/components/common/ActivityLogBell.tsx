import { useState, useRef, useEffect } from "react";
import { Link } from "@tanstack/react-router";
import { Eye } from "lucide-react";
import {
  getUnreadHighPriorityLogs,
  markActivityLogsAsRead,
  ActivityLogItem,
} from "@/api/activity-log";
import { formatDistanceToNow } from "date-fns";
import { parseApiDate } from "@/lib/dates";

export function ActivityLogBell() {
  const [items, setItems] = useState<ActivityLogItem[]>([]);
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  const fetchUnread = async () => {
    try {
      const res = await getUnreadHighPriorityLogs();
      setItems(res.items || []);
    } catch (e) {
      // ignore
    }
  };

  const markRead = async (id: number) => {
    await markActivityLogsAsRead(id);
    fetchUnread();
  };

  const markAllRead = async () => {
    await markActivityLogsAsRead();
    fetchUnread();
  };

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("mousedown", handler);

    fetchUnread();
    const interval = setInterval(fetchUnread, 15000);

    return () => {
      document.removeEventListener("mousedown", handler);
      clearInterval(interval);
    };
  }, []);

  const unread = items.length;

  return (
    <div ref={ref} className="relative">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        className="relative flex h-9 w-9 items-center justify-center rounded-sm border border-border bg-surface text-primary hover:bg-accent"
        title="Eye in the Sky (High Priority Logs)"
      >
        <Eye className="h-4 w-4" />
        {unread > 0 && (
          <span className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-red-500 px-1 text-[10px] font-bold text-white">
            {unread}
          </span>
        )}
      </button>
      {open && (
        <div className="absolute right-0 z-50 mt-2 w-96 rounded-md border border-border bg-surface shadow-lg">
          <div className="flex items-center justify-between border-b border-border px-3 py-2">
            <p className="text-sm font-semibold">High Priority Activity</p>
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
                No high-priority activity.
              </p>
            ) : (
              items.slice(0, 10).map((n) => (
                <div
                  key={n.id}
                  className="block border-b border-border px-3 py-2.5 text-left transition-colors hover:bg-accent cursor-pointer"
                  onClick={() => markRead(n.id)}
                >
                  <div className="flex items-start gap-2">
                    <span className="mt-1.5 h-2 w-2 shrink-0 rounded-full bg-red-500" />
                    <div className="min-w-0 flex-1">
                      <div className="flex items-start justify-between gap-2">
                        <p className="text-sm font-semibold text-primary">{n.staff_name}</p>
                      </div>
                      <p className="mt-0.5 line-clamp-2 text-xs text-muted-foreground">
                        {n.description}
                      </p>
                      <p className="mt-1 text-[10px] uppercase tracking-wider text-muted-foreground">
                        {formatDistanceToNow(parseApiDate(n.created_at), { addSuffix: true })}
                      </p>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
          <Link
            to="/admin/activity-log"
            onClick={() => setOpen(false)}
            className="block border-t border-border px-3 py-2 text-center text-xs font-semibold text-primary hover:bg-accent"
          >
            View all activity
          </Link>
        </div>
      )}
    </div>
  );
}
