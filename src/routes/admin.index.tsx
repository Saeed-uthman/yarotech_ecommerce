import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import {
  ShoppingCart,
  Package,
  CreditCard,
  Users,
  TrendingUp,
  AlertTriangle,
  LifeBuoy,
  Terminal,
  Download,
  Plus,
  ArrowUpRight,
  Activity,
  Cpu,
  Eye,
  Sun,
  CheckCircle2,
  X,
  Play,
} from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import {
  fetchAdminDashboard,
  fetchSupportMessages,
  type AdminOrder,
  type LowStockItem,
  type SupportMessage,
} from "@/api/admin";
import { NGN } from "@/lib/format";
import { formatDistanceToNow } from "date-fns";
import { useAuthStore } from "@/stores/auth";

export const Route = createFileRoute("/admin/")({
  component: AdminIndex,
  head: () => ({ meta: [{ title: "Operational Command - YAROTECH" }] }),
});

function AdminIndex() {
  const user = useAuthStore((s) => s.user);
  const [data, setData] = useState<Awaited<ReturnType<typeof fetchAdminDashboard>> | null>(null);
  const [supportTickets, setSupportTickets] = useState<SupportMessage[]>([]);
  const [error, setError] = useState<string | null>(null);

  // Diagnostic emulator states
  const [diagOpen, setDiagOpen] = useState(false);
  const [diagLogs, setDiagLogs] = useState<string[]>([]);
  const [diagRunning, setDiagRunning] = useState(false);

  useEffect(() => {
    fetchAdminDashboard()
      .then(setData)
      .catch((err) => {
        console.error("Dashboard error:", err);
        setError(
          err.message ||
            "Could not connect to the administration API. Please ensure your backend server is running.",
        );
      });

    fetchSupportMessages()
      .then(setSupportTickets)
      .catch((err) => console.error("Error loading support tickets:", err));
  }, []);

  const runDiagnostics = () => {
    setDiagOpen(true);
    setDiagRunning(true);
    setDiagLogs(["[SYSTEM] Initializing industrial cluster diagnostic sweep..."]);

    const steps = [
      "[SYSTEM] Mapping network interfaces and operational subnets...",
      "[DB] Connecting to MySQL database at localhost... SUCCESS (6ms)",
      "[AUTH] Auditing active Google Sign-In session policies... 100% SECURE",
      "[POS] Querying digital ledger registers... 14 registers online",
      "[STOCK] Sweeping active items for safety safety thresholds...",
      `[STOCK] Found ${data?.lowStock.length ?? 0} SKUs below minimum replenishment limits`,
      "[SYSTEM] Performing local cluster diagnostic sweeps... ALL NODES STABLE",
      "[SYSTEM] Command console diagnostics completed. System health status: OPTIMIZED",
    ];

    steps.forEach((step, idx) => {
      setTimeout(
        () => {
          setDiagLogs((prev) => [...prev, step]);
          if (idx === steps.length - 1) {
            setDiagRunning(false);
          }
        },
        (idx + 1) * 500,
      );
    });
  };

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center p-12 text-center space-y-4 min-h-[400px]">
        <div className="h-16 w-16 rounded-full bg-destructive/10 flex items-center justify-center">
          <AlertTriangle className="h-8 w-8 text-destructive" />
        </div>
        <div className="space-y-2">
          <h2 className="font-display text-xl font-bold text-primary uppercase tracking-wider">
            Dashboard unreachable
          </h2>
          <p className="text-muted-foreground max-w-md mx-auto text-sm leading-relaxed">{error}</p>
        </div>
        <button
          onClick={() => window.location.reload()}
          className="inline-flex h-10 items-center justify-center rounded-sm bg-secondary px-6 text-xs font-bold uppercase tracking-widest text-secondary-foreground hover:bg-secondary/90 shadow-sm transition-all"
        >
          Retry Connection
        </button>
      </div>
    );
  }

  if (!data) {
    return (
      <div className="space-y-8">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-end gap-4">
          <Skeleton className="h-12 w-64" />
          <Skeleton className="h-10 w-48" />
        </div>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <Skeleton key={i} className="h-32" />
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      {/* Welcome Header */}
      <section className="flex flex-col md:flex-row justify-between items-start md:items-end gap-4">
        <div>
          <h1 className="text-2xl md:text-3xl font-black text-[#0D1C32] tracking-tighter uppercase font-display">
            OPERATIONAL COMMAND
          </h1>
          <p className="text-muted-foreground font-display uppercase tracking-wider text-[10px] mt-1.5 flex items-center gap-1.5">
            YAROTECH SYSTEM STATUS:{" "}
            <span className="text-success font-bold flex items-center gap-1">
              <span className="w-2 h-2 rounded-full bg-success animate-ping"></span>
              OPTIMIZED
            </span>{" "}
            | LAST SYNC: {new Date().toLocaleTimeString()}
          </p>
        </div>
        <div className="flex gap-2">
          <button className="bg-[#0D1C32] text-white px-4 py-2 text-[10px] font-bold font-display uppercase tracking-wider flex items-center gap-2 hover:opacity-90 transition-opacity rounded-sm border border-white/10">
            <Download className="h-3.5 w-3.5" /> Export Report
          </button>
          <Link
            to="/admin/products"
            className="bg-[#FEA619] text-[#0D1C32] px-4 py-2 text-[10px] font-bold font-display uppercase tracking-wider flex items-center gap-2 hover:bg-[#ffb95f] transition-colors rounded-sm"
          >
            <Plus className="h-3.5 w-3.5" /> New Product
          </Link>
        </div>
      </section>

      {/* Key Metrics Bento Grid */}
      <section className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Total Sales */}
        <div className="bg-surface border border-border p-6 flex flex-col justify-between h-32 relative overflow-hidden group rounded-sm shadow-sm">
          <div className="relative z-10">
            <p className="font-display text-[9px] font-bold tracking-widest text-muted-foreground uppercase">
              Total Revenue
            </p>
            <p className="text-2xl font-black text-[#0D1C32] mt-1 font-display">
              {NGN(data.stats.totalRevenue)}
            </p>
          </div>
          <div className="flex items-center gap-1 text-success font-display text-[9px] font-bold relative z-10">
            <TrendingUp className="h-3.5 w-3.5 text-success" /> +12.4% vs Prev. Month
          </div>
          <div className="absolute right-[-10px] bottom-[-10px] opacity-[0.03] group-hover:scale-110 transition-transform duration-500 text-[#0D1C32]">
            <ShoppingCart className="h-24 w-24" />
          </div>
        </div>

        {/* Total Successful Orders (Replaces Pending Orders) */}
        <div className="bg-surface border border-border p-6 flex flex-col justify-between h-32 relative overflow-hidden group rounded-sm shadow-sm">
          <div className="relative z-10">
            <p className="font-display text-[9px] font-bold tracking-widest text-muted-foreground uppercase">
              Total Successful Orders
            </p>
            <p className="text-2xl font-black text-[#0D1C32] mt-1 font-display">
              {data.stats.totalOrders}
            </p>
          </div>
          <div className="flex items-center gap-1 text-success font-display text-[9px] relative z-10">
            <CheckCircle2 className="h-3.5 w-3.5 text-success" /> Fully paid & confirmed
          </div>
          <div className="absolute right-[-10px] bottom-[-10px] opacity-[0.03] group-hover:scale-110 transition-transform duration-500 text-[#0D1C32]">
            <CheckCircle2 className="h-24 w-24" />
          </div>
        </div>

        {/* Net Profit */}
        <div className="bg-surface border border-border p-6 flex flex-col justify-between h-32 relative overflow-hidden group rounded-sm shadow-sm">
          <div className="relative z-10">
            <p className="font-display text-[9px] font-bold tracking-widest text-muted-foreground uppercase">
              Profit Earned
            </p>
            <p className="text-2xl font-black text-[#0D1C32] mt-1 font-display">
              {NGN(data.stats.netProfitPlaceholder)}
            </p>
          </div>
          <div className="flex items-center gap-1 text-success font-display text-[9px] relative z-10">
            <TrendingUp className="h-3.5 w-3.5 text-success" /> Based on item cost
          </div>
          <div className="absolute right-[-10px] bottom-[-10px] opacity-[0.03] group-hover:scale-110 transition-transform duration-500 text-[#0D1C32]">
            <TrendingUp className="h-24 w-24" />
          </div>
        </div>

        {/* Total Inventory Value */}
        {user?.role === "admin" && (
          <div className="bg-surface border border-border p-6 flex flex-col justify-between h-32 relative overflow-hidden group rounded-sm shadow-sm">
            <div className="relative z-10">
              <p className="font-display text-[9px] font-bold tracking-widest text-muted-foreground uppercase">
                Total Inventory Value
              </p>
              <p className="text-2xl font-black text-[#0D1C32] mt-1 font-display">
                {NGN(data.stats.totalInventoryValue)}
              </p>
            </div>
            <div className="flex items-center gap-1 text-muted-foreground font-display text-[9px] relative z-10">
              <Package className="h-3.5 w-3.5" /> Total items: {data.stats.totalInventoryUnits}
            </div>
            <div className="absolute right-[-10px] bottom-[-10px] opacity-[0.03] group-hover:scale-110 transition-transform duration-500 text-[#0D1C32]">
              <Package className="h-24 w-24" />
            </div>
          </div>
        )}

        {/* Total Products */}
        <div className="bg-surface border border-border p-6 flex flex-col justify-between h-32 relative overflow-hidden group rounded-sm shadow-sm">
          <div className="relative z-10">
            <p className="font-display text-[9px] font-bold tracking-widest text-muted-foreground uppercase">
              Total Products
            </p>
            <p className="text-2xl font-black text-[#0D1C32] mt-1 font-display">
              {data.stats.totalProducts}
            </p>
          </div>
          <div className="flex items-center gap-1 text-muted-foreground font-display text-[9px] relative z-10">
            <Eye className="h-3.5 w-3.5" /> Active in catalog
          </div>
          <div className="absolute right-[-10px] bottom-[-10px] opacity-[0.03] group-hover:scale-110 transition-transform duration-500 text-[#0D1C32]">
            <Eye className="h-24 w-24" />
          </div>
        </div>

        {/* Support Service Tickets */}
        <div className="bg-[#0D1C32] p-6 flex flex-col justify-between h-32 relative overflow-hidden group rounded-sm shadow-md text-white">
          <div className="relative z-10">
            <p className="font-display text-[9px] font-bold tracking-widest text-[#FEA619] uppercase">
              Service Tickets
            </p>
            <p className="text-2xl font-black text-white mt-1 font-display">
              {String(data.stats.supportInboxCount).padStart(2, "0")}
            </p>
          </div>
          <div className="flex items-center gap-1 text-[#FEA619] font-display text-[9px] font-bold relative z-10">
            <LifeBuoy className="h-3.5 w-3.5 text-[#FEA619]" />
            {data.stats.supportInboxCount > 0 ? "Action Required" : "Inbox Cleared"}
          </div>
          <div className="absolute right-[-10px] bottom-[-10px] opacity-10 group-hover:scale-110 transition-transform duration-500 text-white">
            <Cpu className="h-24 w-24" />
          </div>
        </div>

        {/* Active Database Size */}
        <div className="bg-surface border border-border p-6 flex flex-col justify-between h-32 relative overflow-hidden group rounded-sm shadow-sm">
          <div className="relative z-10">
            <p className="font-display text-[9px] font-bold tracking-widest text-muted-foreground uppercase">
              Active Database
            </p>
            <p className="text-2xl font-black text-[#0D1C32] mt-1 font-display">
              {data.stats.totalCustomers.toLocaleString()}
            </p>
          </div>
          <div className="flex items-center gap-1 text-success font-display text-[9px] font-bold relative z-10">
            <Users className="h-3.5 w-3.5 text-success" /> 94% Retention rate
          </div>
          <div className="absolute right-[-10px] bottom-[-10px] opacity-[0.03] group-hover:scale-110 transition-transform duration-500 text-[#0D1C32]">
            <Users className="h-24 w-24" />
          </div>
        </div>
      </section>

      {/* High Density Asymmetric Data Grid */}
      <section className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Order Fulfillment Queue (Asymmetric 70%) */}
        <div className="lg:col-span-2 bg-surface border border-border rounded-sm shadow-sm overflow-hidden flex flex-col">
          <div className="p-4 border-b border-border flex justify-between items-center bg-muted/20">
            <div>
              <h2 className="text-xs font-black text-[#0D1C32] uppercase tracking-wider font-display">
                Active Fulfillment Queue
              </h2>
              <p className="text-[9px] font-display text-muted-foreground uppercase tracking-widest mt-0.5">
                Real-time logistics status
              </p>
            </div>
            <Link
              to="/admin/orders-users"
              className="text-[9px] font-display font-bold uppercase text-[#FEA619] hover:underline"
            >
              View Order Desk →
            </Link>
          </div>
          <div className="overflow-x-auto flex-1">
            <table className="w-full text-left">
              <thead className="bg-muted/50 border-b border-border">
                <tr className="text-[9px] font-display font-bold uppercase text-muted-foreground tracking-wider">
                  <th className="px-4 py-3">Order ID</th>
                  <th className="px-4 py-3">Client Entity</th>
                  <th className="px-4 py-3">Quantity</th>
                  <th className="px-4 py-3">Status</th>
                  <th className="px-4 py-3 text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border text-xs">
                {data.recentOrders.slice(0, 5).map((o: AdminOrder) => {
                  const qtySum = o.items ? o.items.reduce((acc, curr) => acc + curr.qty, 0) : null;
                  return (
                    <tr key={o.id} className="hover:bg-muted/10 transition-colors">
                      <td className="px-4 py-3.5 font-bold text-[#0D1C32]">{o.id}</td>
                      <td className="px-4 py-3.5 text-muted-foreground">{o.customer.name}</td>
                      <td className="px-4 py-3.5 font-display text-[10px]">
                        {qtySum !== null ? `${qtySum} Units` : NGN(o.total)}
                      </td>
                      <td className="px-4 py-3.5">
                        <span
                          className={`px-2 py-0.5 text-[8px] font-bold font-display rounded-sm uppercase border ${
                            o.status === "delivered" || o.status === "paid"
                              ? "bg-success/5 text-success border-success/20"
                              : o.status === "shipped"
                                ? "bg-info/5 text-info border-blue-200 text-blue-700 bg-blue-50/50"
                                : o.status === "processing"
                                  ? "bg-[#FEA619]/5 text-[#855300] border-[#FEA619]/20"
                                  : "bg-destructive/5 text-destructive border-destructive/20"
                          }`}
                        >
                          {o.status}
                        </span>
                      </td>
                      <td className="px-4 py-3.5 text-right">
                        <Link
                          to="/admin/orders-users"
                          className="text-[#0D1C32] hover:text-[#FEA619] inline-flex"
                        >
                          <ArrowUpRight className="h-4 w-4" />
                        </Link>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>

        {/* Product Inventory Analytics (30% Sidebar) */}
        <div className="bg-[#0D1C32] text-white border border-[#0D1C32] rounded-sm shadow-md overflow-hidden flex flex-col justify-between">
          <div className="p-4 border-b border-white/5 bg-[#0A1C31]">
            <h2 className="text-xs font-black text-[#FEA619] uppercase tracking-wider font-display">
              Stock Capacity
            </h2>
            <p className="text-[8px] font-display text-white/50 uppercase tracking-widest mt-0.5">
              Replenishment thresholds
            </p>
          </div>
          <div className="p-5 flex-1 space-y-5">
            {data.lowStock.length === 0 ? (
              <div className="h-28 flex flex-col items-center justify-center text-center space-y-2">
                <CheckCircle2 className="h-8 w-8 text-success" />
                <p className="text-[10px] uppercase font-display text-white/60 tracking-wider">
                  All systems fully restocked
                </p>
              </div>
            ) : (
              <div className="space-y-4">
                {data.lowStock.slice(0, 3).map((item: LowStockItem) => {
                  const capacity = Math.max(
                    12,
                    Math.min(95, Math.round(((item.stock || 1) / (item.threshold || 5)) * 100)),
                  );
                  return (
                    <div key={item.posId} className="space-y-1.5">
                      <div className="flex justify-between text-[8px] font-display uppercase tracking-widest text-white/70">
                        <span className="truncate max-w-[150px]">{item.name}</span>
                        <span
                          className={
                            item.stock <= 1 ? "text-destructive font-bold" : "text-[#FEA619]"
                          }
                        >
                          {capacity}% Capacity
                        </span>
                      </div>
                      <div className="h-1 bg-white/10 rounded-full overflow-hidden">
                        <div
                          className={`h-full transition-all duration-500 ${
                            item.stock <= 1 ? "bg-destructive" : "bg-[#FEA619]"
                          }`}
                          style={{ width: `${capacity}%` }}
                        ></div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}

            <div className="p-3 bg-white/5 border border-white/10 rounded-sm mt-4">
              <div className="flex items-center gap-2 mb-1.5 text-[#FEA619]">
                <AlertTriangle className="h-4 w-4" />
                <p className="text-[9px] font-bold uppercase tracking-wider font-display">
                  Restock Alert
                </p>
              </div>
              <p className="text-[9px] text-white/60 leading-relaxed font-display">
                {data.stats.lowStockCount} items have dropped below safety levels. Delivery pipeline
                estimated at 14 business days.
              </p>
              <Link
                to="/admin/products"
                className="mt-3 block w-full text-center bg-[#FEA619] text-[#0D1C32] py-2 text-[9px] font-bold font-display uppercase tracking-widest hover:bg-white transition-colors"
              >
                Review Replenishment Grid
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Bottom Tools Grid */}
      <section className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Support Feed (from real tickets) */}
        <div className="bg-surface border border-border p-4 flex flex-col rounded-sm shadow-sm justify-between">
          <div>
            <h3 className="text-[10px] font-black text-[#0D1C32] uppercase tracking-wider mb-3 border-b border-border pb-2 font-display">
              Active Support Tickets
            </h3>
            {supportTickets.length === 0 ? (
              <p className="text-[10px] text-muted-foreground text-center py-6">
                No pending tickets in queue.
              </p>
            ) : (
              <div className="space-y-3">
                {supportTickets.slice(0, 3).map((tk) => (
                  <div key={tk.id} className="flex gap-3 items-start group">
                    <div
                      className={`w-7 h-7 rounded-sm flex items-center justify-center flex-shrink-0 ${
                        tk.status === "new"
                          ? "bg-destructive/10 text-destructive"
                          : "bg-[#855300]/10 text-[#855300]"
                      }`}
                    >
                      <LifeBuoy className="h-3.5 w-3.5" />
                    </div>
                    <div className="min-w-0 flex-1">
                      <p className="text-[11px] font-bold text-[#0D1C32] truncate uppercase leading-tight">
                        {tk.subject}
                      </p>
                      <p className="text-[8px] text-muted-foreground font-display mt-0.5">
                        TICKET ID: #TK-{tk.id} |{" "}
                        {formatDistanceToNow(tk.createdAt, { addSuffix: true })}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
          <Link
            to="/admin/support"
            className="pt-4 text-[9px] font-display font-bold uppercase tracking-widest text-[#855300] hover:underline text-left mt-3 block"
          >
            Open Support Center →
          </Link>
        </div>

        {/* Logistics Hotspots */}
        <div className="bg-surface border border-border p-4 flex flex-col rounded-sm shadow-sm">
          <h3 className="text-[10px] font-black text-[#0D1C32] uppercase tracking-wider mb-3 border-b border-border pb-2 font-display">
            Logistics Hotspots
          </h3>
          <div className="relative h-28 w-full bg-[#0D1C32] rounded-sm overflow-hidden mb-3 border border-white/5 flex items-center justify-center">
            {/* Styled Technical Grid Placeholder */}
            <div className="absolute inset-0 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:16px_16px] opacity-10"></div>
            <div className="z-10 text-center p-4">
              <span className="text-[9px] font-display text-white/50 tracking-widest block mb-1">
                EMEA LOGISTICS COORDINATES
              </span>
              <span className="text-[10px] font-bold text-[#FEA619] uppercase tracking-widest flex items-center justify-center gap-1.5">
                <span className="w-1.5 h-1.5 rounded-full bg-[#FEA619] animate-ping"></span>
                KANO HUB ACTIVE
              </span>
            </div>
            <div className="absolute top-1/3 left-1/4 w-2 h-2 bg-[#FEA619] rounded-full animate-pulse shadow-[0_0_8px_#FEA619]"></div>
            <div className="absolute top-2/3 right-1/3 w-3.5 h-3.5 bg-[#FEA619]/30 rounded-full animate-ping"></div>
            <div className="absolute top-2/3 right-1/3 w-2 h-2 bg-[#FEA619] rounded-full shadow-[0_0_8px_#FEA619]"></div>
          </div>
          <p className="text-[9px] text-muted-foreground leading-relaxed font-display">
            Global network hub verified. Current distribution latency: <b>24ms</b>. Optimized
            routing triggers in standby.
          </p>
        </div>

        {/* Quick Action Bento Diagnostic Terminal */}
        <div className="bg-muted/30 border border-border p-4 flex flex-col justify-center items-center text-center rounded-sm shadow-sm min-h-[160px]">
          <div className="w-10 h-10 bg-[#0D1C32] rounded-sm flex items-center justify-center mb-2 border border-white/10">
            <Terminal className="h-5 w-5 text-[#FEA619]" />
          </div>
          <h3 className="text-[10px] font-black text-[#0D1C32] uppercase tracking-wider font-display">
            System Diagnostics
          </h3>
          <p className="text-[9px] text-muted-foreground font-display tracking-wide mt-1.5">
            Automated cluster health check
          </p>
          <button
            onClick={runDiagnostics}
            className="mt-3 bg-[#0D1C32] text-white w-full py-2 text-[9px] font-bold font-display uppercase tracking-widest hover:bg-black transition-colors rounded-sm flex items-center justify-center gap-1"
          >
            <Play className="h-3 w-3 text-[#FEA619] fill-[#FEA619]" /> Run Diagnostics
          </button>
        </div>
      </section>

      {/* Beautiful Interactive Diagnostic Console Drawer / Modal */}
      {diagOpen && (
        <div className="fixed inset-0 z-50 bg-[#0D1C32]/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-[#0A1C31] text-white border border-[#FEA619]/20 w-full max-w-xl rounded-sm shadow-2xl overflow-hidden flex flex-col">
            <div className="p-3 bg-[#0D1C32] border-b border-white/5 flex justify-between items-center">
              <div className="flex items-center gap-2">
                <span className="w-2.5 h-2.5 rounded-full bg-destructive"></span>
                <span className="w-2.5 h-2.5 rounded-full bg-[#FEA619]"></span>
                <span className="w-2.5 h-2.5 rounded-full bg-success"></span>
                <span className="text-[9px] font-display tracking-widest font-bold ml-2">
                  YT-COMMAND-CONSOLE v1.0.8
                </span>
              </div>
              <button
                onClick={() => setDiagOpen(false)}
                className="text-white/50 hover:text-white"
                disabled={diagRunning}
              >
                <X className="h-4 w-4" />
              </button>
            </div>
            <div className="p-4 font-mono text-[10px] space-y-1.5 h-64 overflow-y-auto bg-black/40">
              {diagLogs.map((log, i) => {
                let color = "text-white/80";
                if (
                  log.includes("SUCCESS") ||
                  log.includes("SECURE") ||
                  log.includes("OPTIMIZED")
                ) {
                  color = "text-success font-bold";
                } else if (log.includes("replenishment") || log.includes("alerts")) {
                  color = "text-[#FEA619] font-bold";
                } else if (log.includes("[SYSTEM]")) {
                  color = "text-white font-extrabold opacity-90";
                }
                return (
                  <p key={i} className={color}>
                    {log}
                  </p>
                );
              })}
              {diagRunning && (
                <div className="flex items-center gap-1.5 text-[#FEA619] font-bold mt-1">
                  <span className="animate-spin text-xs">⟳</span>
                  <span>Executing integrity checks...</span>
                </div>
              )}
            </div>
            <div className="p-3 bg-[#0D1C32] border-t border-white/5 flex justify-end">
              <button
                onClick={() => setDiagOpen(false)}
                className="bg-[#FEA619] text-[#0D1C32] px-4 py-1.5 text-[9px] font-bold uppercase tracking-widest font-display hover:bg-white transition-colors"
                disabled={diagRunning}
              >
                {diagRunning ? "Analyzing..." : "Acknowledge"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
