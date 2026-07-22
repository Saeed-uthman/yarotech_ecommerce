import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { Search, CreditCard, Banknote, Smartphone, QrCode, FileText } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { StatusBadge } from "@/components/common/StatusBadge";
import { Skeleton } from "@/components/ui/skeleton";
import { fetchPayments, type AdminPayment } from "@/api/admin";
import { NGN } from "@/lib/format";
import { formatDistanceToNow } from "date-fns";
import { ReceiptModal } from "@/components/common/ReceiptModal";

export const Route = createFileRoute("/admin/payments")({
  component: PaymentsAdmin,
  head: () => ({ meta: [{ title: "Payments — Admin" }] }),
});

const CHANNEL_ICON: Record<string, any> = {
  card: CreditCard,
  bank_transfer: Banknote,
  transfer: Banknote,
  cash: Banknote,
  pos: CreditCard,
  ussd: Smartphone,
  qr: QrCode,
};

function PaymentsAdmin() {
  const [items, setItems] = useState<AdminPayment[] | null>(null);
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState<"all" | "success" | "failed" | "pending">("all");
  const [selectedOrderId, setSelectedOrderId] = useState<string | null>(null);
  const [receiptOpen, setReceiptOpen] = useState(false);
  const [page, setPage] = useState(1);
  const itemsPerPage = 10;

  useEffect(() => {
    fetchPayments().then(setItems);
  }, []);

  useEffect(() => {
    setPage(1);
  }, [search, filter]);

  const filtered = useMemo(() => {
    if (!items) return [];
    return items.filter((p) => {
      if (filter !== "all" && p.status !== filter) return false;
      if (!search) return true;
      const q = search.toLowerCase();
      return (
        p.reference.toLowerCase().includes(q) ||
        p.orderId.toLowerCase().includes(q) ||
        p.customerEmail.toLowerCase().includes(q)
      );
    });
  }, [items, search, filter]);

  const totalPages = Math.ceil(filtered.length / itemsPerPage);
  const startIndex = (page - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const paginated = useMemo(() => {
    return filtered.slice(startIndex, endIndex);
  }, [filtered, startIndex, endIndex]);

  const stats = useMemo(() => {
    if (!items) return { success: 0, failed: 0, pending: 0, total: 0 };
    return items.reduce(
      (acc, p) => ({
        ...acc,
        [p.status]: acc[p.status] + 1,
        total: acc.total + (p.status === "success" ? p.amount : 0),
      }),
      { success: 0, failed: 0, pending: 0, total: 0 } as {
        success: number;
        failed: number;
        pending: number;
        total: number;
      },
    );
  }, [items]);

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Finance"
        title="Payments"
        description="Reconcile Paystack transactions across channels."
      />

      <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
        <Tile label="Successful" value={stats.success} tone="success" />
        <Tile label="Failed" value={stats.failed} tone="danger" />
        <Tile label="Pending" value={stats.pending} tone="warning" />
        <Tile label="Captured (NGN)" value={NGN(stats.total)} />
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:flex lg:flex-row lg:items-center gap-3">
        <div className="relative flex-1">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by reference, order, email…"
            className="h-10 w-full rounded-sm border border-border bg-surface pl-9 pr-3 text-sm"
          />
        </div>
        <select
          value={filter}
          onChange={(e) => setFilter(e.target.value as typeof filter)}
          className="h-10 rounded-sm border border-border bg-surface px-3 text-sm capitalize"
        >
          <option value="all">All statuses</option>
          <option value="success">Successful</option>
          <option value="failed">Failed</option>
          <option value="pending">Pending</option>
        </select>
      </div>

      {!items ? (
        <Skeleton className="h-64" />
      ) : (
        <div className="space-y-4">
          <div className="overflow-x-auto rounded-md border border-border bg-surface">
            <table className="w-full text-sm">
              <thead className="bg-accent/50 text-[10px] uppercase tracking-wider text-muted-foreground">
                <tr>
                  <th className="px-4 py-2 text-left">Reference</th>
                  <th className="px-4 py-2 text-left">Order</th>
                  <th className="px-4 py-2 text-left">Customer</th>
                  <th className="px-4 py-2 text-right">Amount</th>
                  <th className="hidden md:table-cell px-4 py-2 text-left">Channel</th>
                  <th className="px-4 py-2 text-left">Status</th>
                  <th className="hidden lg:table-cell px-4 py-2 text-left">Gateway</th>
                  <th className="hidden md:table-cell px-4 py-2 text-left">When</th>
                  <th className="px-4 py-2"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {paginated.map((p) => {
                  const Icon = CHANNEL_ICON[p.channel] || CreditCard;
                  return (
                    <tr key={p.id} className="hover:bg-accent/30">
                      <td className="px-4 py-3 font-mono text-xs">{p.reference}</td>
                      <td className="px-4 py-3 font-semibold text-primary">{p.orderId}</td>
                      <td className="px-4 py-3 text-xs text-muted-foreground">{p.customerEmail}</td>
                      <td className="px-4 py-3 text-right font-semibold">{NGN(p.amount)}</td>
                      <td className="hidden md:table-cell px-4 py-3">
                        <span className="inline-flex items-center gap-1.5 text-xs capitalize">
                          <Icon className="h-3 w-3" /> {p.channel.replace("_", " ")}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <StatusBadge
                          variant={
                            p.status === "success"
                              ? "success"
                              : p.status === "failed"
                                ? "danger"
                                : "warning"
                          }
                        >
                          {p.status}
                        </StatusBadge>
                      </td>
                      <td className="hidden lg:table-cell px-4 py-3 text-xs text-muted-foreground">
                        {p.gatewayResponse}
                      </td>
                      <td className="hidden md:table-cell px-4 py-3 text-xs text-muted-foreground">
                        {formatDistanceToNow(p.createdAt, { addSuffix: true })}
                      </td>
                      <td className="px-4 py-3">
                        {p.status === "success" && (
                          <button
                            onClick={() => {
                              setSelectedOrderId(p.orderId);
                              setReceiptOpen(true);
                            }}
                            className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border bg-secondary/5 hover:bg-secondary/15 hover:border-secondary/30 text-secondary cursor-pointer"
                            title="View Ticket Receipt"
                            aria-label="View Ticket Receipt"
                          >
                            <FileText className="h-3.5 w-3.5" />
                          </button>
                        )}
                      </td>
                    </tr>
                  );
                })}
                {filtered.length === 0 && (
                  <tr>
                    <td colSpan={9} className="px-4 py-8 text-center text-sm text-muted-foreground">
                      No payments match.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* Pagination Controls */}
          {filtered.length > 0 && (
            <div className="flex flex-col sm:flex-row items-center justify-between gap-4 mt-2 px-1 text-xs flex-wrap">
              <span className="text-muted-foreground font-medium">
                Showing {Math.min(startIndex + 1, filtered.length)} to{" "}
                {Math.min(endIndex, filtered.length)} of {filtered.length} records
              </span>
              <div className="inline-flex items-center gap-1">
                <button
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                  disabled={page === 1}
                  className="inline-flex h-8 px-2.5 items-center justify-center rounded-sm border border-border bg-surface hover:bg-accent disabled:opacity-40 disabled:hover:bg-surface text-primary font-semibold transition cursor-pointer"
                >
                  Previous
                </button>
                {Array.from({ length: totalPages }, (_, i) => i + 1)
                  .filter((p) => p === 1 || p === totalPages || Math.abs(p - page) <= 1)
                  .map((p, idx, arr) => {
                    const showEllipsis = idx > 0 && p - arr[idx - 1] > 1;
                    return (
                      <div key={p} className="flex items-center gap-1">
                        {showEllipsis && <span className="px-1.5 text-muted-foreground">...</span>}
                        <button
                          onClick={() => setPage(p)}
                          className={`inline-flex h-8 w-8 items-center justify-center rounded-sm border text-xs font-bold transition cursor-pointer ${
                            page === p
                              ? "border-secondary bg-secondary/10 text-secondary"
                              : "border-border bg-surface hover:bg-accent text-primary"
                          }`}
                        >
                          {p}
                        </button>
                      </div>
                    );
                  })}
                <button
                  onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                  disabled={page === totalPages || totalPages === 0}
                  className="inline-flex h-8 px-2.5 items-center justify-center rounded-sm border border-border bg-surface hover:bg-accent disabled:opacity-40 disabled:hover:bg-surface text-primary font-semibold transition cursor-pointer"
                >
                  Next
                </button>
              </div>
            </div>
          )}
        </div>
      )}

      <ReceiptModal
        isOpen={receiptOpen}
        onClose={() => {
          setReceiptOpen(false);
          setSelectedOrderId(null);
        }}
        order={null}
        orderNumber={selectedOrderId || undefined}
      />
    </div>
  );
}

function Tile({
  label,
  value,
  tone = "default",
}: {
  label: string;
  value: number | string;
  tone?: "default" | "success" | "warning" | "danger";
}) {
  const accent =
    tone === "success"
      ? "text-success"
      : tone === "warning"
        ? "text-warning-foreground"
        : tone === "danger"
          ? "text-destructive"
          : "text-secondary";
  return (
    <div className="rounded-md border border-border bg-surface p-4">
      <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
        {label}
      </p>
      <p className={`mt-2 font-display text-2xl font-bold ${accent}`}>{value}</p>
    </div>
  );
}
