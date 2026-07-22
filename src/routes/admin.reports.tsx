import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState, useRef } from "react";
import {
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  PieChart,
  Pie,
  Cell,
  Legend,
} from "recharts";
import { FileDown, CalendarRange, Loader2 } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { Skeleton } from "@/components/ui/skeleton";
import { fetchReports, type ReportRange } from "@/api/admin";
import { NGN } from "@/lib/format";
import { generateReportPDF } from "@/utils/pdf-generator";
import { toast } from "sonner";

export const Route = createFileRoute("/admin/reports")({
  component: ReportsAdmin,
  head: () => ({ meta: [{ title: "Reports — Admin" }] }),
});

const PIE_COLORS = [
  "hsl(var(--primary))",
  "hsl(var(--secondary))",
  "hsl(var(--success))",
  "hsl(var(--warning))",
];

const RANGE_OPTIONS: { value: ReportRange; label: string }[] = [
  { value: "week", label: "Week" },
  { value: "month", label: "Month" },
  { value: "quarter", label: "Quarter" },
  { value: "year", label: "Year" },
  { value: "custom", label: "Custom" },
];

/* ── Default date helpers ──────────────────────────────────────────── */
function today(): string {
  return new Date().toISOString().slice(0, 10);
}
function daysAgo(n: number): string {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
}

/* ══════════════════════════════════════════════════════════════════════
 * Component
 * ══════════════════════════════════════════════════════════════════════ */
function ReportsAdmin() {
  const [range, setRange] = useState<ReportRange>("year");
  const [startDate, setStartDate] = useState<string>(daysAgo(30));
  const [endDate, setEndDate] = useState<string>(today());
  const [data, setData] = useState<Awaited<ReturnType<typeof fetchReports>> | null>(null);
  const [exporting, setExporting] = useState(false);
  const loadRef = useRef(0);

  /* Load data whenever range / custom dates change */
  useEffect(() => {
    const id = ++loadRef.current;
    setData(null);
    fetchReports(range, startDate, endDate).then((d) => {
      if (loadRef.current === id) setData(d);
    });
  }, [range, startDate, endDate]);

  /* PDF export */
  async function handleExport() {
    if (!data) {
      toast.error("No data to export yet — please wait for the report to load.");
      return;
    }
    setExporting(true);
    try {
      await new Promise<void>((resolve) => {
        setTimeout(() => {
          generateReportPDF(range, data, startDate, endDate);
          resolve();
        }, 0);
      });
      toast.success("PDF report downloaded!");
    } catch (err) {
      console.error(err);
      toast.error("Failed to generate PDF. Please try again.");
    } finally {
      setExporting(false);
    }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Analytics"
        title="Reports"
        description="Revenue, VAT, channel mix, product performance and export."
        actions={
          <div className="flex flex-wrap items-center gap-2">
            {/* ── Range selector ── */}
            <div className="flex gap-1 rounded-md border border-border bg-surface p-1">
              {RANGE_OPTIONS.map((r) => (
                <button
                  key={r.value}
                  onClick={() => setRange(r.value)}
                  className={`px-3 py-1.5 text-xs font-semibold rounded-sm transition-colors ${
                    range === r.value
                      ? "bg-primary text-primary-foreground shadow-sm"
                      : "text-muted-foreground hover:text-primary"
                  }`}
                >
                  {r.label}
                </button>
              ))}
            </div>

            {/* ── Export PDF button ── */}
            <button
              onClick={handleExport}
              disabled={!data || exporting}
              className="flex items-center gap-2 rounded-md bg-[#FEA619] hover:bg-[#e8961a] disabled:opacity-50 disabled:cursor-not-allowed px-4 py-2 text-xs font-bold uppercase tracking-wider text-[#0D1C32] transition-colors shadow-sm"
            >
              {exporting ? (
                <Loader2 className="h-3.5 w-3.5 animate-spin" />
              ) : (
                <FileDown className="h-3.5 w-3.5" />
              )}
              Export PDF
            </button>
          </div>
        }
      />

      {/* ── Custom date range pickers ── */}
      {range === "custom" && (
        <div className="flex flex-wrap items-center gap-3 rounded-md border border-border bg-surface px-4 py-3">
          <CalendarRange className="h-4 w-4 text-muted-foreground shrink-0" />
          <span className="text-sm font-medium text-muted-foreground">Date range:</span>
          <div className="flex flex-wrap gap-3">
            <div className="flex flex-col gap-1">
              <label className="text-[10px] font-semibold uppercase tracking-wider text-muted-foreground">
                From
              </label>
              <input
                type="date"
                value={startDate}
                max={endDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="rounded-md border border-border bg-background px-3 py-1.5 text-sm text-primary focus:outline-none focus:ring-2 focus:ring-primary/30"
              />
            </div>
            <div className="flex flex-col gap-1">
              <label className="text-[10px] font-semibold uppercase tracking-wider text-muted-foreground">
                To
              </label>
              <input
                type="date"
                value={endDate}
                min={startDate}
                max={today()}
                onChange={(e) => setEndDate(e.target.value)}
                className="rounded-md border border-border bg-background px-3 py-1.5 text-sm text-primary focus:outline-none focus:ring-2 focus:ring-primary/30"
              />
            </div>
          </div>
        </div>
      )}

      {/* ── Loading state ── */}
      {!data ? (
        <div className="space-y-4">
          <div className="grid gap-3 md:grid-cols-4">
            {[...Array(4)].map((_, i) => (
              <Skeleton key={i} className="h-24" />
            ))}
          </div>
          <Skeleton className="h-72" />
          <div className="grid gap-6 lg:grid-cols-2">
            <Skeleton className="h-72" />
            <Skeleton className="h-72" />
          </div>
        </div>
      ) : (
        <>
          {/* ── KPI tiles ── */}
          <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
            <Tile label="Revenue" value={NGN(data.totals?.revenue ?? 0)} />
            <Tile label="Orders" value={data.totals?.orders ?? 0} />
            <Tile label="VAT (7.5%)" value={NGN(data.totals?.vat ?? 0)} />
            <Tile label="Avg order value" value={NGN(data.totals?.avgOrderValue ?? 0)} />
          </div>

          {/* ── Sales over time ── */}
          <div className="rounded-md border border-border bg-surface p-4">
            <h3 className="mb-4 font-display text-sm font-bold uppercase tracking-wider text-primary">
              Sales over time
            </h3>
            <div className="h-72">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={data.series}>
                  <defs>
                    <linearGradient id="rev" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="hsl(var(--secondary))" stopOpacity={0.4} />
                      <stop offset="95%" stopColor="hsl(var(--secondary))" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" opacity={0.2} />
                  <XAxis dataKey="label" fontSize={11} />
                  <YAxis fontSize={11} tickFormatter={(v) => `${(v / 1_000_000).toFixed(1)}M`} />
                  <Tooltip formatter={(v: number) => NGN(v)} />
                  <Area
                    type="monotone"
                    dataKey="total_sales"
                    stroke="hsl(var(--secondary))"
                    fill="url(#rev)"
                    strokeWidth={2}
                  />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* ── Charts row ── */}
          <div className="grid gap-6 lg:grid-cols-2">
            {/* Top products */}
            <div className="rounded-md border border-border bg-surface p-4">
              <h3 className="mb-4 font-display text-sm font-bold uppercase tracking-wider text-primary">
                Top products
              </h3>
              <div className="h-72">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={data.productPerformance} layout="vertical">
                    <CartesianGrid strokeDasharray="3 3" opacity={0.2} />
                    <XAxis
                      type="number"
                      fontSize={11}
                      tickFormatter={(v) => `${(v / 1_000_000).toFixed(0)}M`}
                    />
                    <YAxis type="category" dataKey="name" fontSize={10} width={140} />
                    <Tooltip formatter={(v: number) => NGN(v)} />
                    <Bar dataKey="revenue" fill="hsl(var(--primary))" />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Payment channel mix */}
            <div className="rounded-md border border-border bg-surface p-4">
              <h3 className="mb-4 font-display text-sm font-bold uppercase tracking-wider text-primary">
                Payment channel mix
              </h3>
              <div className="h-72">
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={data.channelMix}
                      dataKey="value"
                      nameKey="channel"
                      cx="50%"
                      cy="50%"
                      outerRadius={90}
                      label={(e: { channel?: string; value?: number }) =>
                        `${e.channel ?? ""} ${e.value ?? 0}%`
                      }
                    >
                      {(data.channelMix ?? []).map((_: any, i: number) => (
                        <Cell key={i} fill={PIE_COLORS[i % PIE_COLORS.length]} />
                      ))}
                    </Pie>
                    <Legend />
                  </PieChart>
                </ResponsiveContainer>
              </div>
            </div>
          </div>

          {/* ── Export hint bar ── */}
          <div className="flex items-center justify-between rounded-md border border-border bg-surface px-5 py-3">
            <div>
              <p className="text-sm font-semibold text-primary">Ready to export?</p>
              <p className="text-xs text-muted-foreground mt-0.5">
                Download a professional, branded PDF of this report for offline use or sharing.
              </p>
            </div>
            <button
              onClick={handleExport}
              disabled={exporting}
              className="flex items-center gap-2 rounded-md bg-[#FEA619] hover:bg-[#e8961a] disabled:opacity-50 disabled:cursor-not-allowed px-5 py-2.5 text-xs font-bold uppercase tracking-wider text-[#0D1C32] transition-colors shadow-sm"
            >
              {exporting ? (
                <Loader2 className="h-3.5 w-3.5 animate-spin" />
              ) : (
                <FileDown className="h-3.5 w-3.5" />
              )}
              Export PDF
            </button>
          </div>
        </>
      )}
    </div>
  );
}

function Tile({ label, value }: { label: string; value: number | string }) {
  return (
    <div className="rounded-md border border-border bg-surface p-4">
      <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
        {label}
      </p>
      <p className="mt-2 font-display text-2xl font-bold text-primary">{value}</p>
    </div>
  );
}
