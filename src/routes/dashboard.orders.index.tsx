import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Package, Download } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { EmptyState } from "@/components/common/EmptyState";
import { OrderStatusBadge } from "@/components/common/OrderStatusBadge";
import { listMyOrders, type Order } from "@/api/orders";
import { ReceiptModal } from "@/components/common/ReceiptModal";
import { InvoicePreviewModal } from "@/components/common/InvoicePreviewModal";

export const Route = createFileRoute("/dashboard/orders/")({
  component: OrdersPage,
  head: () => ({ meta: [{ title: "My Orders — YAROTECH" }] }),
});

const STATUSES: Array<Order["status"] | "all"> = [
  "all",
  "pending",
  "paid",
  "processing",
  "ready_for_pickup",
  "shipped",
  "delivered",
  "picked_up",
  "cancelled",
];

function formatNaira(v: number) {
  return "₦" + v.toLocaleString();
}

function OrdersPage() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [filter, setFilter] = useState<(typeof STATUSES)[number]>("all");
  const [loading, setLoading] = useState(true);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [receiptOpen, setReceiptOpen] = useState(false);
  const [invoiceOpen, setInvoiceOpen] = useState(false);
  const [invoiceOrderId, setInvoiceOrderId] = useState<string>("");

  useEffect(() => {
    listMyOrders()
      .then(setOrders)
      .finally(() => setLoading(false));
  }, []);

  const filtered = filter === "all" ? orders : orders.filter((o) => o.status === filter);

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="My orders"
        title="Order history"
        description="View, track and review past purchases."
      />

      <div className="flex flex-wrap gap-2">
        {STATUSES.map((s) => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            className={`h-8 rounded-sm border px-3 text-[11px] font-semibold uppercase tracking-widest transition ${
              filter === s
                ? "border-primary bg-primary text-primary-foreground"
                : "border-border text-muted-foreground hover:border-primary hover:text-primary"
            }`}
          >
            {s.replace(/_/g, " ")}
          </button>
        ))}
      </div>

      {loading ? (
        <div className="rounded-md border border-border bg-surface p-8 text-sm text-muted-foreground">
          Loading orders…
        </div>
      ) : filtered.length === 0 ? (
        <EmptyState
          icon={<Package className="h-5 w-5" />}
          title={filter === "all" ? "No orders yet" : `No ${filter} orders`}
          description="When you place an order through the shop, it will appear here."
          action={
            <Link
              to="/shop"
              className="inline-flex h-10 items-center rounded-sm bg-cta px-5 text-sm font-bold uppercase tracking-wide text-cta-foreground hover:bg-cta/90"
            >
              Browse shop
            </Link>
          }
        />
      ) : (
        <div className="overflow-hidden rounded-md border border-border bg-surface">
          <table className="w-full text-sm">
            <thead className="bg-accent/30 text-left text-[10px] uppercase tracking-widest text-muted-foreground">
              <tr>
                <th className="px-4 py-3">Order</th>
                <th className="hidden px-4 py-3 md:table-cell">Date</th>
                <th className="hidden px-4 py-3 md:table-cell">Items</th>
                <th className="px-4 py-3">Status</th>
                <th className="px-4 py-3 text-right">Total</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {filtered.map((o) => (
                <tr key={o.id}>
                  <td className="px-4 py-3 font-mono text-primary">{o.id}</td>
                  <td className="hidden px-4 py-3 text-muted-foreground md:table-cell">
                    {new Date(o.createdAt).toLocaleDateString()}
                  </td>
                  <td className="hidden px-4 py-3 text-muted-foreground md:table-cell">
                    {o.itemCount}
                  </td>
                  <td className="px-4 py-3">
                    <OrderStatusBadge status={o.status} />
                  </td>
                  <td className="px-4 py-3 text-right font-display font-semibold text-primary">
                    {formatNaira(o.total)}
                  </td>
                  <td className="px-4 py-3 text-right">
                    <div className="flex items-center justify-end gap-3">
                      {o.paymentStatus === "success" && (
                        <>
                          <button
                            onClick={() => {
                              setSelectedOrder(o);
                              setReceiptOpen(true);
                            }}
                            className="text-xs font-semibold text-secondary hover:underline cursor-pointer bg-transparent border-none p-0"
                          >
                            Receipt
                          </button>
                          <button
                            onClick={() => {
                              setInvoiceOrderId(o.id);
                              setInvoiceOpen(true);
                            }}
                            className="inline-flex items-center gap-1 text-xs font-semibold text-primary hover:underline cursor-pointer bg-transparent border-none p-0"
                          >
                            <Download className="h-3 w-3" /> Invoice
                          </button>
                        </>
                      )}
                      <Link
                        to="/dashboard/orders/$id"
                        params={{ id: o.id }}
                        className="text-xs font-semibold text-primary hover:underline"
                      >
                        View
                      </Link>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      <ReceiptModal
        isOpen={receiptOpen}
        onClose={() => setReceiptOpen(false)}
        order={selectedOrder}
      />
      <InvoicePreviewModal
        isOpen={invoiceOpen}
        onClose={() => setInvoiceOpen(false)}
        orderId={invoiceOrderId}
      />
    </div>
  );
}
