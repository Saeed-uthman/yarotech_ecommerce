import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import {
  Search,
  ArrowDownCircle,
  ArrowUpCircle,
  Filter,
  Calendar,
  Package,
  User,
  X,
} from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { StatusBadge } from "@/components/common/StatusBadge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  fetchInventoryMovements,
  type InventoryMovement,
  type InventoryMovementsResponse,
  type MovementType,
} from "@/api/admin";

export const Route = createFileRoute("/admin/stock-movements")({
  component: StockMovementsPage,
  head: () => ({ meta: [{ title: "Stock Movements — Admin" }] }),
});

const MOVEMENT_TYPES: { value: string; label: string }[] = [
  { value: "", label: "All Types" },
  { value: "stock_adjustment", label: "Stock Adjustment" },
  { value: "pos_sale", label: "POS Sale" },
  { value: "ecommerce_sale", label: "E-commerce Sale" },
  { value: "stock_return", label: "Stock Return" },
  { value: "damaged_stock", label: "Damaged Stock" },
  { value: "correction", label: "Correction" },
  { value: "initial_stock", label: "Initial Stock" },
];

const STOCK_OUT_TYPES: MovementType[] = ["pos_sale", "ecommerce_sale", "damaged_stock"];

function movementLabel(type: string): string {
  return MOVEMENT_TYPES.find((m) => m.value === type)?.label ?? type;
}

function movementDirection(type: MovementType, qty: number): "in" | "out" | "neutral" {
  if (STOCK_OUT_TYPES.includes(type)) return "out";
  if (qty > 0) return "in";
  if (qty < 0) return "out";
  return "neutral";
}

function formatDate(iso: string): string {
  try {
    const d = new Date(iso);
    return d.toLocaleDateString("en-NG", { year: "numeric", month: "short", day: "numeric" });
  } catch {
    return iso;
  }
}

function formatTime(iso: string): string {
  try {
    const d = new Date(iso);
    return d.toLocaleTimeString("en-NG", { hour: "2-digit", minute: "2-digit" });
  } catch {
    return "";
  }
}

function StockMovementsPage() {
  const [data, setData] = useState<InventoryMovementsResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [typeFilter, setTypeFilter] = useState("");
  const [productSearch, setProductSearch] = useState("");
  const [productSearchInput, setProductSearchInput] = useState("");
  const [dateFrom, setDateFrom] = useState("");
  const [dateTo, setDateTo] = useState("");
  const perPage = 20;

  const fetchData = async () => {
    setLoading(true);
    try {
      const result = await fetchInventoryMovements({
        page,
        per_page: perPage,
        movement_type: typeFilter || undefined,
        product_search: productSearch || undefined,
        date_from: dateFrom || undefined,
        date_to: dateTo || undefined,
      });
      setData(result);
    } catch {
      setData({ items: [], total: 0, page: 1, per_page: perPage });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [page, typeFilter, productSearch, dateFrom, dateTo]);

  const handleProductSearch = () => {
    setPage(1);
    setProductSearch(productSearchInput.trim());
  };

  const clearFilters = () => {
    setTypeFilter("");
    setProductSearchInput("");
    setProductSearch("");
    setDateFrom("");
    setDateTo("");
    setPage(1);
  };

  const hasFilters = typeFilter || productSearch || dateFrom || dateTo;

  const totalStockIn = data?.items.filter((m) => movementDirection(m.movement_type, m.quantity) === "in").length ?? 0;
  const totalStockOut = data?.items.filter((m) => movementDirection(m.movement_type, m.quantity) === "out").length ?? 0;
  const totalPages = data ? Math.ceil(data.total / perPage) : 0;

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Inventory"
        title="Stock Movements"
        description="Track all stock-in and stock-out records across every product."
      />

      {/* Stat tiles */}
      <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
        <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
          <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Total Movements</p>
          <p className="mt-1 text-2xl font-black text-primary">{data?.total ?? 0}</p>
        </div>
        <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
          <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Stock In</p>
          <div className="mt-1 flex items-center gap-2">
            <ArrowDownCircle className="h-5 w-5 text-emerald-500" />
            <span className="text-2xl font-black text-emerald-600">{totalStockIn}</span>
          </div>
        </div>
        <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
          <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Stock Out</p>
          <div className="mt-1 flex items-center gap-2">
            <ArrowUpCircle className="h-5 w-5 text-red-500" />
            <span className="text-2xl font-black text-red-600">{totalStockOut}</span>
          </div>
        </div>
        <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
          <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Page</p>
          <p className="mt-1 text-2xl font-black text-primary">{page} / {totalPages || 1}</p>
        </div>
      </div>

      {/* Filters */}
      <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
        <div className="flex items-center gap-2 mb-3">
          <Filter className="h-4 w-4 text-muted-foreground" />
          <span className="text-xs font-bold uppercase tracking-widest text-muted-foreground">Filters</span>
          {hasFilters && (
            <button onClick={clearFilters} className="ml-auto flex items-center gap-1 text-xs text-muted-foreground hover:text-primary transition-colors">
              <X className="h-3 w-3" /> Clear all
            </button>
          )}
        </div>
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">
          {/* Movement type */}
          <div className="space-y-1">
            <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Type</label>
            <select
              value={typeFilter}
              onChange={(e) => { setTypeFilter(e.target.value); setPage(1); }}
              className="h-10 w-full rounded-sm border border-border bg-background px-3 text-sm focus:border-secondary focus:outline-none"
            >
              {MOVEMENT_TYPES.map((mt) => (
                <option key={mt.value} value={mt.value}>{mt.label}</option>
              ))}
            </select>
          </div>

          {/* Product search */}
          <div className="space-y-1">
            <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Product</label>
            <div className="relative">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <input
                value={productSearchInput}
                onChange={(e) => setProductSearchInput(e.target.value)}
                onKeyDown={(e) => { if (e.key === "Enter") handleProductSearch(); }}
                onBlur={handleProductSearch}
                placeholder="Search product name or SKU..."
                className="h-10 w-full rounded-sm border border-border bg-background pl-9 pr-3 text-sm focus:border-secondary focus:outline-none"
              />
            </div>
          </div>

          {/* Date from */}
          <div className="space-y-1">
            <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">From</label>
            <div className="relative">
              <Calendar className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <input
                type="date"
                value={dateFrom}
                onChange={(e) => { setDateFrom(e.target.value); setPage(1); }}
                className="h-10 w-full rounded-sm border border-border bg-background pl-9 pr-3 text-sm focus:border-secondary focus:outline-none"
              />
            </div>
          </div>

          {/* Date to */}
          <div className="space-y-1">
            <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">To</label>
            <div className="relative">
              <Calendar className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <input
                type="date"
                value={dateTo}
                onChange={(e) => { setDateTo(e.target.value); setPage(1); }}
                className="h-10 w-full rounded-sm border border-border bg-background pl-9 pr-3 text-sm focus:border-secondary focus:outline-none"
              />
            </div>
          </div>
        </div>
      </div>

      {/* Table */}
      <div className="rounded-sm border border-border bg-surface shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border bg-muted/30">
                <th className="px-4 py-3 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Date</th>
                <th className="px-4 py-3 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Product</th>
                <th className="px-4 py-3 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Type</th>
                <th className="px-4 py-3 text-right text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Qty</th>
                <th className="hidden md:table-cell px-4 py-3 text-center text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Stock Change</th>
                <th className="hidden lg:table-cell px-4 py-3 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Reference</th>
                <th className="hidden lg:table-cell px-4 py-3 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Recorded By</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {loading ? (
                Array.from({ length: 5 }).map((_, i) => (
                  <tr key={i}>
                    <td className="px-4 py-3"><Skeleton className="h-4 w-20" /></td>
                    <td className="px-4 py-3"><Skeleton className="h-4 w-32" /></td>
                    <td className="px-4 py-3"><Skeleton className="h-5 w-24" /></td>
                    <td className="px-4 py-3 text-right"><Skeleton className="h-4 w-10 ml-auto" /></td>
                    <td className="hidden md:table-cell px-4 py-3 text-center"><Skeleton className="h-4 w-28 mx-auto" /></td>
                    <td className="hidden lg:table-cell px-4 py-3"><Skeleton className="h-4 w-20" /></td>
                    <td className="hidden lg:table-cell px-4 py-3"><Skeleton className="h-4 w-24" /></td>
                  </tr>
                ))
              ) : data?.items.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-4 py-16 text-center">
                    <div className="flex flex-col items-center gap-3 text-muted-foreground">
                      <Package className="h-10 w-10 opacity-20" />
                      <p className="text-sm">No stock movements found</p>
                      {hasFilters && (
                        <button onClick={clearFilters} className="text-xs text-secondary hover:underline">Clear filters</button>
                      )}
                    </div>
                  </td>
                </tr>
              ) : (
                data!.items.map((m) => {
                  const dir = movementDirection(m.movement_type, m.quantity);
                  return (
                    <tr key={m.id} className="hover:bg-muted/20 transition-colors">
                      <td className="px-4 py-3">
                        <p className="text-sm font-medium text-primary">{formatDate(m.created_at)}</p>
                        <p className="text-[11px] text-muted-foreground">{formatTime(m.created_at)}</p>
                      </td>
                      <td className="px-4 py-3">
                        <p className="truncate text-sm font-semibold text-primary max-w-[200px]">{m.product_name || "—"}</p>
                        <p className="text-[11px] text-muted-foreground">{m.product_sku || "—"}</p>
                      </td>
                      <td className="px-4 py-3">
                        <StatusBadge variant={
                          dir === "out" ? "danger" : dir === "in" ? "success" : "default"
                        }>
                          {movementLabel(m.movement_type)}
                        </StatusBadge>
                      </td>
                      <td className="px-4 py-3 text-right">
                        <span className={`text-sm font-bold ${
                          dir === "in" ? "text-emerald-600" : dir === "out" ? "text-red-600" : "text-muted-foreground"
                        }`}>
                          {m.quantity > 0 ? "+" : ""}{m.quantity}
                        </span>
                      </td>
                      <td className="hidden md:table-cell px-4 py-3 text-center">
                        <span className="text-xs text-muted-foreground">
                          {m.previous_stock} <span className="text-muted-foreground/60">&rarr;</span> {m.new_stock}
                        </span>
                      </td>
                      <td className="hidden lg:table-cell px-4 py-3">
                        {m.reference_id ? (
                          <span className="text-xs text-muted-foreground font-mono">{m.reference_id}</span>
                        ) : (
                          <span className="text-xs text-muted-foreground/50">—</span>
                        )}
                      </td>
                      <td className="hidden lg:table-cell px-4 py-3">
                        <div className="flex items-center gap-2">
                          <User className="h-3 w-3 text-muted-foreground shrink-0" />
                          <span className="text-xs text-muted-foreground truncate max-w-[120px]">
                            {m.recorded_by_name || m.created_by || "System"}
                          </span>
                        </div>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {data && data.total > perPage && (
          <div className="flex items-center justify-between border-t border-border px-4 py-3">
            <p className="text-xs text-muted-foreground">
              Showing {((page - 1) * perPage) + 1}–{Math.min(page * perPage, data.total)} of {data.total}
            </p>
            <div className="flex items-center gap-2">
              <button
                disabled={page <= 1}
                onClick={() => setPage((p) => Math.max(1, p - 1))}
                className="rounded-sm border border-border px-3 py-1.5 text-xs font-semibold text-primary hover:bg-accent disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
              >
                Previous
              </button>
              <button
                disabled={page >= totalPages}
                onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                className="rounded-sm border border-border px-3 py-1.5 text-xs font-semibold text-primary hover:bg-accent disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
              >
                Next
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Note about movements */}
      <p className="text-[11px] text-muted-foreground">
        Stock movements are automatically recorded for every sale, adjustment, return, and correction. Each record shows who initiated the change.
      </p>
    </div>
  );
}
