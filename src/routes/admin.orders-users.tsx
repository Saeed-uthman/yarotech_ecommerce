import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { Search, Mail, Phone, Eye, X, FileText, Download } from "lucide-react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { OrderStatusBadge } from "@/components/common/OrderStatusBadge";
import { StatusBadge } from "@/components/common/StatusBadge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  fetchAdminOrders,
  fetchAdminUsers,
  updateOrderStatus,
  updateUserStatus,
  type AdminOrder,
  type AdminOrderStatus,
  type AdminUser,
  type UserStatus,
} from "@/api/admin";
import { NGN } from "@/lib/format";
import { apiDateMs } from "@/lib/dates";
import { formatDistanceToNow } from "date-fns";
import { ReceiptModal } from "@/components/common/ReceiptModal";
import { InvoicePreviewModal } from "@/components/common/InvoicePreviewModal";
import { type Order } from "@/api/orders";

const mapAdminOrderToOrder = (ao: AdminOrder): Order => {
  return {
    id: ao.id,
    reference: ao.reference || ao.id,
    customerEmail: ao.customer?.email || "",
    customerName: ao.customer?.name || "",
    subtotal: Number(ao.subtotal ?? 0),
    vat: Number(ao.vat ?? 0),
    deliveryFee: Number(ao.deliveryFee ?? 0),
    total: Number(ao.total ?? 0),
    status: ao.status,
    paymentStatus: ao.paymentStatus as any,
    items: ao.items.map((it) => ({
      sku: it.sku || String(it.posId) || "UNKNOWN",
      name: it.name,
      qty: Number(it.qty || 1),
      price: Number(it.price || 0),
    })),
    createdAt: apiDateMs(ao.createdAt),
    itemCount: ao.items.reduce((acc, curr) => acc + Number(curr.qty || 0), 0) || 1,
  };
};

export const Route = createFileRoute("/admin/orders-users")({
  component: OrdersUsersPage,
  head: () => ({ meta: [{ title: "Orders & Users — Admin" }] }),
});

const ORDER_STATUSES: AdminOrderStatus[] = [
  "pending",
  "paid",
  "processing",
  "ready_for_pickup",
  "shipped",
  "delivered",
  "picked_up",
  "cancelled",
  "refunded",
  "failed",
];

const STATUS_RANKS: Record<AdminOrderStatus, number> = {
  pending: 1,
  paid: 2,
  processing: 3,
  ready_for_pickup: 4,
  shipped: 4,
  picked_up: 5,
  delivered: 5,
  cancelled: 99,
  refunded: 99,
  failed: 99,
};

function getAvailableStatuses(currentStatus: AdminOrderStatus, method: string): AdminOrderStatus[] {
  const currentRank = STATUS_RANKS[currentStatus] ?? 0;
  
  if (currentRank === 99 || currentRank === 5) return [currentStatus]; // Terminal states

  const allowed: AdminOrderStatus[] = [currentStatus];
  
  for (const s of ORDER_STATUSES) {
    const rank = STATUS_RANKS[s];
    if (rank > currentRank && rank < 99) {
      if (method === "pickup" && (s === "shipped" || s === "delivered")) continue;
      if (method === "delivery" && (s === "ready_for_pickup" || s === "picked_up")) continue;
      allowed.push(s);
    }
  }
  
  if (currentRank < 5) allowed.push("cancelled");

  return Array.from(new Set(allowed));
}
const USER_STATUSES: UserStatus[] = ["active", "inactive", "pending", "suspended", "deleted"];

function OrdersUsersPage() {
  const [tab, setTab] = useState<"orders" | "users">("orders");

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Operations"
        title="Orders & Users"
        description="View, fulfil and manage customer orders and accounts."
      />

      <div className="flex gap-1 border-b border-border">
        {(["orders", "users"] as const).map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`px-4 py-2 text-xs font-semibold uppercase tracking-wider border-b-2 -mb-px ${
              tab === t
                ? "border-secondary text-primary"
                : "border-transparent text-muted-foreground hover:text-primary"
            }`}
          >
            {t}
          </button>
        ))}
      </div>

      {tab === "orders" && <OrdersTab />}
      {tab === "users" && <UsersTab />}
    </div>
  );
}

/* ---------------- Orders ---------------- */
function OrdersTab() {
  const [orders, setOrders] = useState<AdminOrder[] | null>(null);
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState<AdminOrderStatus | "all">("all");
  const [selected, setSelected] = useState<AdminOrder | null>(null);
  const [receiptOpen, setReceiptOpen] = useState(false);
  const [receiptOrder, setReceiptOrder] = useState<Order | null>(null);
  const [invoiceOpen, setInvoiceOpen] = useState(false);
  const [invoiceOrderId, setInvoiceOrderId] = useState<string>("");
  const [page, setPage] = useState(1);
  const itemsPerPage = 10;

  useEffect(() => {
    fetchAdminOrders().then(setOrders);
  }, []);

  useEffect(() => {
    setPage(1);
  }, [search, filter]);

  const filtered = useMemo(() => {
    if (!orders) return [];
    return orders.filter((o) => {
      if (filter !== "all" && o.status !== filter) return false;
      if (!search) return true;
      const q = search.toLowerCase();
      return (
        (o.id || "").toLowerCase().includes(q) ||
        (o.customer?.name || "").toLowerCase().includes(q) ||
        (o.customer?.email || "").toLowerCase().includes(q) ||
        (o.reference || "").toLowerCase().includes(q)
      );
    });
  }, [orders, search, filter]);

  const totalPages = Math.ceil(filtered.length / itemsPerPage);
  const startIndex = (page - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const paginated = useMemo(() => {
    return filtered.slice(startIndex, endIndex);
  }, [filtered, startIndex, endIndex]);

  const onStatusChange = async (id: string, status: AdminOrderStatus) => {
    await updateOrderStatus(id, status);
    setOrders((prev) => prev?.map((o) => (o.id === id ? { ...o, status } : o)) ?? prev);
    toast.success(`Order ${id} → ${status}`);
  };

  return (
    <>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:flex lg:flex-row lg:items-center gap-3">
        <div className="relative flex-1">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by order, customer, reference…"
            className="h-10 w-full rounded-sm border border-border bg-surface pl-9 pr-3 text-sm focus:border-secondary focus:outline-none"
          />
        </div>
        <select
          value={filter}
          onChange={(e) => setFilter(e.target.value as typeof filter)}
          className="h-10 rounded-sm border border-border bg-surface px-3 text-sm capitalize"
        >
          <option value="all">All statuses</option>
          {ORDER_STATUSES.map((s) => (
            <option key={s} value={s} className="capitalize">
              {s.replace(/_/g, " ")}
            </option>
          ))}
        </select>
      </div>

      {!orders ? (
        <Skeleton className="h-64" />
      ) : (
        <div className="space-y-4">
          <div className="overflow-x-auto rounded-md border border-border bg-surface">
            <table className="w-full text-sm">
              <thead className="bg-accent/50 text-[10px] uppercase tracking-wider text-muted-foreground">
                <tr>
                  <th className="px-4 py-2 text-left">Order</th>
                  <th className="px-4 py-2 text-left">Customer</th>
                  <th className="hidden md:table-cell px-4 py-2 text-left">Items</th>
                  <th className="px-4 py-2 text-right">Total</th>
                  <th className="px-4 py-2 text-left">Payment</th>
                  <th className="px-4 py-2 text-left">Status</th>
                  <th className="hidden lg:table-cell px-4 py-2 text-left">POS</th>
                  <th className="hidden lg:table-cell px-4 py-2 text-left">When</th>
                  <th className="px-4 py-2"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {paginated.map((o) => (
                  <tr key={o.id} className="hover:bg-accent/30">
                    <td className="px-4 py-3">
                      <p className="font-semibold text-primary">{o.id}</p>
                      <p className="font-mono text-[10px] text-muted-foreground">{o.reference}</p>
                    </td>
                    <td className="px-4 py-3">
                      <p className="font-medium text-primary">{o.customer.name}</p>
                      <p className="text-xs text-muted-foreground">{o.customer.email}</p>
                    </td>
                    <td className="hidden md:table-cell px-4 py-3 text-xs">
                      {(o as any).item_count || o.items.reduce((s, i) => s + i.qty, 0)} × items
                    </td>
                    <td className="px-4 py-3 text-right font-semibold">{NGN(o.total)}</td>
                    <td className="px-4 py-3">
                      <StatusBadge
                        variant={
                          o.paymentStatus === "paid"
                            ? "success"
                            : o.paymentStatus === "failed"
                              ? "danger"
                              : "warning"
                        }
                      >
                        {o.paymentStatus}
                      </StatusBadge>
                    </td>
                    <td className="px-4 py-3">
                      <select
                        value={o.status}
                        onChange={(e) => onStatusChange(o.id, e.target.value as AdminOrderStatus)}
                        className="rounded-sm border border-border bg-background px-2 py-1 text-xs capitalize"
                      >
                        {getAvailableStatuses(o.status, o.deliveryMethod).map((s) => (
                          <option key={s} value={s} className="capitalize">
                            {s.replace(/_/g, " ")}
                          </option>
                        ))}
                      </select>
                    </td>
                    <td className="hidden lg:table-cell px-4 py-3">
                      <StatusBadge
                        variant={
                          o.posSync === "synced"
                            ? "success"
                            : o.posSync === "failed"
                              ? "danger"
                              : o.posSync === "pending"
                                ? "warning"
                                : "muted"
                        }
                      >
                        {o.posSync}
                      </StatusBadge>
                    </td>
                    <td className="hidden lg:table-cell px-4 py-3 text-xs text-muted-foreground">
                      {formatDistanceToNow(o.createdAt, { addSuffix: true })}
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-1.5">
                        <button
                          onClick={() => setSelected(o)}
                          className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border hover:bg-accent cursor-pointer"
                          aria-label="View Details"
                          title="View Details"
                        >
                          <Eye className="h-3.5 w-3.5 text-primary" />
                        </button>
                        {o.paymentStatus === "paid" && (
                          <>
                            <button
                              onClick={() => {
                                setReceiptOrder(mapAdminOrderToOrder(o));
                                setReceiptOpen(true);
                              }}
                              className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border bg-secondary/5 hover:bg-secondary/15 hover:border-secondary/30 text-secondary cursor-pointer"
                              title="View Ticket Receipt"
                              aria-label="View Ticket Receipt"
                            >
                              <FileText className="h-3.5 w-3.5" />
                            </button>
                            <button
                              onClick={() => {
                                setInvoiceOrderId(String(o.id));
                                setInvoiceOpen(true);
                              }}
                              className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border bg-primary/5 hover:bg-primary/15 hover:border-primary/30 text-primary cursor-pointer"
                              title="View Invoice"
                              aria-label="View Invoice"
                            >
                              <Download className="h-3.5 w-3.5" />
                            </button>
                          </>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
                {filtered.length === 0 && (
                  <tr>
                    <td colSpan={9} className="px-4 py-8 text-center text-sm text-muted-foreground">
                      No orders match.
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

      {selected && (
        <OrderDetailDrawer
          order={selected}
          onClose={() => setSelected(null)}
          onViewReceipt={(o) => {
            setReceiptOrder(mapAdminOrderToOrder(o));
            setReceiptOpen(true);
          }}
          onViewInvoice={(o) => {
            setInvoiceOrderId(String(o.id));
            setInvoiceOpen(true);
          }}
        />
      )}

      <ReceiptModal
        isOpen={receiptOpen}
        onClose={() => setReceiptOpen(false)}
        order={receiptOrder}
      />

      <InvoicePreviewModal
        isOpen={invoiceOpen}
        onClose={() => setInvoiceOpen(false)}
        orderId={invoiceOrderId}
        adminMode
      />
    </>
  );
}

function OrderDetailDrawer({
  order,
  onClose,
  onViewReceipt,
  onViewInvoice,
}: {
  order: AdminOrder;
  onClose: () => void;
  onViewReceipt: (o: AdminOrder) => void;
  onViewInvoice: (o: AdminOrder) => void;
}) {
  return (
    <div className="fixed inset-0 z-50 flex">
      <div className="flex-1 bg-black/40" onClick={onClose} />
      <aside className="flex w-full max-w-lg flex-col overflow-y-auto bg-surface shadow-2xl">
        <header className="sticky top-0 flex items-center justify-between border-b border-border bg-surface px-5 py-4">
          <div>
            <p className="text-[10px] font-semibold uppercase tracking-widest text-secondary">
              New paid order
            </p>
            <h2 className="font-display text-xl font-bold text-primary">{order.id}</h2>
          </div>
          <button
            onClick={onClose}
            className="flex h-8 w-8 items-center justify-center rounded-sm hover:bg-accent"
          >
            <X className="h-4 w-4" />
          </button>
        </header>
        <div className="space-y-5 p-4 sm:p-5 text-sm">
          <Section title="Customer">
            <p className="font-semibold text-primary">{order.customer.name}</p>
            <p className="flex items-center gap-1 text-xs text-muted-foreground">
              <Mail className="h-3 w-3" /> {order.customer.email}
            </p>
            <p className="flex items-center gap-1 text-xs text-muted-foreground">
              <Phone className="h-3 w-3" /> {order.customer.phone}
            </p>
          </Section>

          <Section title="Items">
            <ul className="divide-y divide-border rounded-sm border border-border">
              {order.items.map((it) => (
                <li
                  key={it.posId}
                  className="flex items-center justify-between gap-3 px-3 py-2 text-xs"
                >
                  <div>
                    <p className="font-medium text-primary">{it.name}</p>
                    <p className="text-muted-foreground">
                      {it.sku} • POS {it.posId}
                    </p>
                  </div>
                  <div className="text-right">
                    <p>
                      {it.qty} × {NGN(it.price)}
                    </p>
                    <p className="font-semibold">{NGN(it.qty * it.price)}</p>
                  </div>
                </li>
              ))}
            </ul>
          </Section>

          <Section title="Totals">
            <Row label="Subtotal" value={NGN(order.subtotal)} />
            <Row label="Delivery fee" value={NGN(order.deliveryFee)} />
            <Row label="VAT (7.5%)" value={NGN(order.vat)} />
            <Row label="Total paid" value={NGN(order.total)} bold />
          </Section>

          <Section title="Fulfilment">
            <Row
              label="Method"
              value={order.deliveryMethod === "delivery" ? "Delivery" : "Pickup"}
            />
            {order.deliveryAddress && <Row label="Address" value={order.deliveryAddress} />}
            <Row label="Status" value={<OrderStatusBadge status={order.status} />} />
            <Row
              label="POS sync"
              value={
                <StatusBadge
                  variant={
                    order.posSync === "synced"
                      ? "success"
                      : order.posSync === "failed"
                        ? "danger"
                        : "warning"
                  }
                >
                  {order.posSync}
                </StatusBadge>
              }
            />
          </Section>

          <Section title="Payment">
            <Row
              label="Paystack ref"
              value={<span className="font-mono text-xs">{order.reference}</span>}
            />
            <Row
              label="Status"
              value={
                <StatusBadge
                  variant={
                    order.paymentStatus === "paid"
                      ? "success"
                      : order.paymentStatus === "failed"
                        ? "danger"
                        : "warning"
                  }
                >
                  {order.paymentStatus}
                </StatusBadge>
              }
            />
          </Section>

          {order.paymentStatus === "paid" && (
            <div className="flex gap-2 mt-2">
              <button
                onClick={() => onViewReceipt(order)}
                className="flex-1 inline-flex h-10 items-center justify-center gap-2 rounded-sm bg-cta text-cta-foreground text-xs font-bold uppercase tracking-wide hover:bg-cta/90 cursor-pointer"
              >
                <FileText className="h-4 w-4" /> Ticket Receipt
              </button>
              <button
                onClick={() => onViewInvoice(order)}
                className="flex-1 inline-flex h-10 items-center justify-center gap-2 rounded-sm bg-primary text-primary-foreground text-xs font-bold uppercase tracking-wide hover:opacity-90 cursor-pointer"
              >
                <Download className="h-4 w-4" /> Invoice
              </button>
            </div>
          )}

          <p className="rounded-sm border border-dashed border-border bg-accent/30 p-3 text-[11px] text-muted-foreground">
            Backend will send a confirmation email to the customer and a notification email to
            admin@yarotech.ng on every paid order.
          </p>
        </div>
      </aside>
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h4 className="mb-2 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
        {title}
      </h4>
      <div className="space-y-1">{children}</div>
    </div>
  );
}

function Row({ label, value, bold }: { label: string; value: React.ReactNode; bold?: boolean }) {
  return (
    <div className="flex items-center justify-between gap-3 text-sm">
      <span className="text-muted-foreground">{label}</span>
      <span className={bold ? "font-bold text-primary" : "text-primary"}>{value}</span>
    </div>
  );
}

/* ---------------- Users ---------------- */
function UsersTab() {
  const [users, setUsers] = useState<AdminUser[] | null>(null);
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const itemsPerPage = 10;

  useEffect(() => {
    fetchAdminUsers().then(setUsers);
  }, []);

  useEffect(() => {
    setPage(1);
  }, [search]);

  const filtered = useMemo(() => {
    if (!users) return [];
    if (!search) return users;
    const q = search.toLowerCase();
    return users.filter(
      (u) =>
        u.fullName.toLowerCase().includes(q) ||
        u.email.toLowerCase().includes(q) ||
        u.id.toLowerCase().includes(q),
    );
  }, [users, search]);

  const totalPages = Math.ceil(filtered.length / itemsPerPage);
  const startIndex = (page - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const paginated = useMemo(() => {
    return filtered.slice(startIndex, endIndex);
  }, [filtered, startIndex, endIndex]);

  const onStatusChange = async (id: string, status: UserStatus) => {
    await updateUserStatus(id, status);
    setUsers((prev) => prev?.map((u) => (u.id === id ? { ...u, status } : u)) ?? prev);
    toast.success(`User ${id} → ${status}`);
  };

  return (
    <>
      <div className="relative">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search users…"
          className="h-10 w-full rounded-sm border border-border bg-surface pl-9 pr-3 text-sm"
        />
      </div>

      {!users ? (
        <Skeleton className="h-64" />
      ) : (
        <div className="space-y-4">
          <div className="overflow-x-auto rounded-md border border-border bg-surface">
            <table className="w-full text-sm">
              <thead className="bg-accent/50 text-[10px] uppercase tracking-wider text-muted-foreground">
                <tr>
                  <th className="px-4 py-2 text-left">User</th>
                  <th className="px-4 py-2 text-left">Contact</th>
                  <th className="hidden md:table-cell px-4 py-2 text-left">Role</th>
                  <th className="px-4 py-2 text-right">Orders</th>
                  <th className="px-4 py-2 text-right">Spend</th>
                  <th className="hidden lg:table-cell px-4 py-2 text-left">Verified</th>
                  <th className="hidden md:table-cell px-4 py-2 text-left">Last active</th>
                  <th className="px-4 py-2 text-left">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {paginated.map((u) => (
                  <tr key={u.id} className="hover:bg-accent/30">
                    <td className="px-4 py-3">
                      <p className="font-semibold text-primary">{u.fullName}</p>
                      <p className="font-mono text-[10px] text-muted-foreground">{u.id}</p>
                    </td>
                    <td className="px-4 py-3 text-xs">
                      <p>{u.email}</p>
                      <p className="text-muted-foreground">{u.phone}</p>
                    </td>
                    <td className="hidden md:table-cell px-4 py-3">
                      <StatusBadge variant={u.role === "admin" ? "navy" : "muted"}>
                        {u.role}
                      </StatusBadge>
                    </td>
                    <td className="px-4 py-3 text-right">{u.ordersCount}</td>
                    <td className="px-4 py-3 text-right font-medium">{NGN(u.totalSpend)}</td>
                    <td className="hidden lg:table-cell px-4 py-3">
                      <StatusBadge variant={u.emailVerified ? "success" : "warning"}>
                        {u.emailVerified ? "Verified" : "Pending"}
                      </StatusBadge>
                    </td>
                    <td className="hidden md:table-cell px-4 py-3 text-xs text-muted-foreground">
                      {formatDistanceToNow(u.lastActiveAt, { addSuffix: true })}
                    </td>
                    <td className="px-4 py-3">
                      <select
                        value={u.status}
                        onChange={(e) => onStatusChange(u.id, e.target.value as UserStatus)}
                        className="rounded-sm border border-border bg-background px-2 py-1 text-xs capitalize"
                      >
                        {USER_STATUSES.map((s) => (
                          <option key={s} value={s} className="capitalize">
                            {s}
                          </option>
                        ))}
                      </select>
                    </td>
                  </tr>
                ))}
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
    </>
  );
}
