import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { toast } from "sonner";
import {
  AlertCircle,
  CheckCircle2,
  Package,
  RefreshCw,
  ShoppingCart,
  UserPlus,
  Eye,
  Clock,
} from "lucide-react";
import { ActivityLogItem, getRecentActivityLogs, markActivityLogsAsRead } from "@/api/activity-log";
import { format } from "date-fns";
import { parseApiDate } from "@/lib/dates";

export const Route = createFileRoute("/admin/activity-log")({
  component: AdminActivityLogPage,
});

function AdminActivityLogPage() {
  const [logs, setLogs] = useState<ActivityLogItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [filterType, setFilterType] = useState<string>("all");

  const fetchLogs = async () => {
    try {
      const res = await getRecentActivityLogs();
      setLogs(res.items || []);

      // Automatically mark high priority as read when viewing this page
      const unreadExists = res.items?.some((l) => !l.is_read);
      if (unreadExists) {
        await markActivityLogsAsRead();
      }
    } catch (error) {
      toast.error("Failed to load activity logs.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLogs();
  }, []);

  const filteredLogs = logs.filter((log) => {
    if (filterType === "all") return true;
    if (filterType === "high_priority") return !log.is_read;
    return log.action_type.includes(filterType);
  });

  const getActionIcon = (type: string) => {
    if (type.includes("refund") || type.includes("cancel"))
      return <AlertCircle className="w-5 h-5 text-red-500" />;
    if (type.includes("sale")) return <ShoppingCart className="w-5 h-5 text-green-500" />;
    if (type.includes("status")) return <RefreshCw className="w-5 h-5 text-blue-500" />;
    if (type.includes("user") || type.includes("customer"))
      return <UserPlus className="w-5 h-5 text-indigo-500" />;
    return <CheckCircle2 className="w-5 h-5 text-gray-500" />;
  };

  const formatActivityDate = (value: string) => {
    const date = parseApiDate(value);
    return Number.isNaN(date.getTime()) ? value : format(date, "PPp");
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Eye in the Sky</h1>
          <p className="text-muted-foreground mt-1">
            Real-time global activity feed for all staff actions across the system.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <select
            className="h-10 rounded-md border border-input bg-background px-3 py-2 text-sm focus:ring-2 focus:ring-primary outline-none"
            value={filterType}
            onChange={(e) => setFilterType(e.target.value)}
          >
            <option value="all">All Actions</option>
            <option value="high_priority">High Priority Alerts</option>
            <option value="pos_sale">POS Sales</option>
            <option value="order">Order Updates</option>
          </select>
          <button
            onClick={fetchLogs}
            className="inline-flex h-10 items-center justify-center rounded-md bg-secondary px-4 text-sm font-medium text-secondary-foreground hover:bg-secondary/80"
          >
            Refresh
          </button>
        </div>
      </div>

      <div className="rounded-xl border bg-card text-card-foreground shadow">
        <div className="p-6">
          {loading ? (
            <div className="flex h-32 items-center justify-center text-muted-foreground">
              Loading activity timeline...
            </div>
          ) : filteredLogs.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-12 text-center text-muted-foreground">
              <Eye className="h-12 w-12 opacity-20 mb-4" />
              <p>No activity logs found for this filter.</p>
            </div>
          ) : (
            <div className="relative border-l border-muted ml-3 space-y-8 pb-4">
              {filteredLogs.map((log) => (
                <div key={log.id} className="relative pl-8">
                  <div className="absolute -left-3 top-1 flex h-6 w-6 items-center justify-center rounded-full bg-background border ring-4 ring-background">
                    {getActionIcon(log.action_type)}
                  </div>

                  <div
                    className={`rounded-lg border p-4 ${!log.is_read ? "bg-red-50/50 border-red-100" : "bg-background"}`}
                  >
                    <div className="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-2">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-semibold">{log.staff_name}</span>
                          {!log.is_read && (
                            <span className="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold bg-red-100 text-red-800 border-red-200">
                              High Priority
                            </span>
                          )}
                        </div>
                        <p className="mt-1 text-sm text-foreground/90">{log.description}</p>
                      </div>

                      <div className="flex items-center text-xs text-muted-foreground whitespace-nowrap">
                        <Clock className="w-3 h-3 mr-1" />
                        {formatActivityDate(log.created_at)}
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
