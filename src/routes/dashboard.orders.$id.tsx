import { createFileRoute, Link, useParams } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { ArrowLeft, Download, Truck, CheckCircle2, Clock, FileText } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { OrderStatusBadge } from "@/components/common/OrderStatusBadge";
import { getOrder, printReceipt, type Order } from "@/api/orders";
import { ReceiptModal } from "@/components/common/ReceiptModal";
import { InvoicePreviewModal } from "@/components/common/InvoicePreviewModal";

export const Route = createFileRoute("/dashboard/orders/$id")({
  component: OrderDetailPage,
  head: () => ({ meta: [{ title: "Order details — YAROTECH" }] }),
});

function getTimeline(method: "delivery" | "pickup") {
  if (method === "pickup") {
    return [
      { key: "paid", label: "Payment received", icon: CheckCircle2 },
      { key: "processing", label: "Processing", icon: Clock },
      { key: "ready_for_pickup", label: "Ready for pickup", icon: Truck },
      { key: "picked_up", label: "Picked Up", icon: CheckCircle2 },
    ];
  }
  return [
    { key: "paid", label: "Payment received", icon: CheckCircle2 },
    { key: "processing", label: "Processing", icon: Clock },
    { key: "shipped", label: "Out for delivery", icon: Truck },
    { key: "delivered", label: "Delivered", icon: CheckCircle2 },
  ];
}

function indexOfStatus(s: Order["status"], method: "delivery" | "pickup" = "delivery") {
  const order = method === "pickup" 
    ? ["pending", "paid", "processing", "ready_for_pickup", "picked_up"]
    : ["pending", "paid", "processing", "shipped", "delivered"];
  const i = order.indexOf(s);
  return i < 0 ? 0 : i;
}

function formatNaira(v: number) {
  return "₦" + v.toLocaleString();
}

function OrderDetailPage() {
  const { id } = useParams({ from: "/dashboard/orders/$id" });
  const [order, setOrder] = useState<Order | null>(null);
  const [loading, setLoading] = useState(true);
  const [receiptModalOpen, setReceiptModalOpen] = useState(false);
  const [invoiceModalOpen, setInvoiceModalOpen] = useState(false);

  useEffect(() => {
    getOrder(id)
      .then(setOrder)
      .finally(() => setLoading(false));
  }, [id]);

  if (loading) {
    return (
      <div className="rounded-md border border-border bg-surface p-8 text-sm text-muted-foreground">
        Loading order…
      </div>
    );
  }
  if (!order) {
    return (
      <div className="space-y-4">
        <Link
          to="/dashboard/orders"
          className="inline-flex items-center gap-2 text-xs font-semibold text-primary hover:underline"
        >
          <ArrowLeft className="h-4 w-4" /> Back to orders
        </Link>
        <div className="rounded-md border border-border bg-surface p-8 text-sm">
          Order not found.
        </div>
      </div>
    );
  }

  const method = order.deliveryMethod === "pickup" ? "pickup" : "delivery";
  const currentStep = indexOfStatus(order.status, method);
  const timeline = getTimeline(method);
  const cancelled = order.status === "cancelled";

  return (
    <div className="space-y-8">
      <Link
        to="/dashboard/orders"
        className="inline-flex items-center gap-2 text-xs font-semibold text-primary hover:underline"
      >
        <ArrowLeft className="h-4 w-4" /> Back to orders
      </Link>

      <PageHeader
        eyebrow={`Order ${order.id}`}
        title="Order details"
        description={`Placed on ${new Date(order.createdAt).toLocaleString()} · Reference ${order.reference}`}
        actions={
          <div className="flex flex-wrap gap-2">
            <OrderStatusBadge status={order.status} />
            {order.paymentStatus === "success" && (
              <>
                <button
                  onClick={() => setReceiptModalOpen(true)}
                  className="inline-flex h-10 items-center gap-2 rounded-sm bg-cta px-4 text-xs font-bold uppercase tracking-wide text-cta-foreground hover:bg-cta/95 cursor-pointer"
                >
                  View Ticket Receipt
                </button>
                <button
                  onClick={() => printReceipt(order)}
                  className="inline-flex h-10 items-center gap-2 rounded-sm border border-border px-4 text-xs font-semibold uppercase tracking-wide text-primary hover:bg-accent cursor-pointer"
                >
                  Print Simple
                </button>
                <button
                  onClick={() => setInvoiceModalOpen(true)}
                  className="inline-flex h-10 items-center gap-2 rounded-sm border border-border px-4 text-xs font-semibold uppercase tracking-wide text-primary hover:bg-accent cursor-pointer"
                >
                  <FileText className="h-4 w-4" /> Invoice
                </button>
              </>
            )}
          </div>
        }
      />

      {/* Timeline */}
      <section className="rounded-md border border-border bg-surface p-6">
        <h2 className="font-display text-base font-semibold text-primary">Tracking timeline</h2>
        {cancelled ? (
          <p className="mt-3 text-sm text-destructive">This order was cancelled.</p>
        ) : (
          <ol className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-4">
            {timeline.map((step, i) => {
              const Icon = step.icon;
              const reached = i <= currentStep;
              return (
                <li
                  key={step.key}
                  className={`flex items-start gap-3 rounded-sm border border-dashed p-3 ${reached ? "border-secondary/60 bg-secondary/5" : "border-border"}`}
                >
                  <span
                    className={`mt-0.5 inline-flex h-6 w-6 items-center justify-center rounded-full ${reached ? "bg-secondary text-secondary-foreground" : "bg-muted text-muted-foreground"}`}
                  >
                    <Icon className="h-3 w-3" />
                  </span>
                  <div>
                    <p className="text-xs font-semibold uppercase tracking-widest text-muted-foreground">
                      Step {i + 1}
                    </p>
                    <p
                      className={`text-sm font-semibold ${reached ? "text-primary" : "text-muted-foreground"}`}
                    >
                      {step.label}
                    </p>
                  </div>
                </li>
              );
            })}
          </ol>
        )}
      </section>

      {/* Items */}
      <section className="overflow-hidden rounded-md border border-border bg-surface">
        <div className="border-b border-border p-6">
          <h2 className="font-display text-base font-semibold text-primary">Items</h2>
        </div>
        <table className="w-full text-sm">
          <thead className="bg-accent/30 text-left text-[10px] uppercase tracking-widest text-muted-foreground">
            <tr>
              <th className="px-4 py-3">Item</th>
              <th className="px-4 py-3">SKU</th>
              <th className="px-4 py-3 text-right">Qty</th>
              <th className="px-4 py-3 text-right">Price</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border">
            {order.items.map((it) => (
              <tr key={it.sku}>
                <td className="px-4 py-3 text-primary">{it.name}</td>
                <td className="px-4 py-3 font-mono text-xs text-muted-foreground">{it.sku}</td>
                <td className="px-4 py-3 text-right">{it.qty}</td>
                <td className="px-4 py-3 text-right font-semibold text-primary">
                  {formatNaira(it.price)}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>

      {/* Summary */}
      <section className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <div className="rounded-md border border-border bg-surface p-6">
          <h3 className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
            Fulfillment
          </h3>
          <p className="mt-2 text-sm text-primary">
            Method: <span className="font-semibold capitalize">{method}</span>
          </p>
          <p className="text-sm text-muted-foreground">
            Customer: {order.customerName || order.customerEmail || "Walk-in customer"}
          </p>
          <p className="text-sm text-muted-foreground">
            Payment: <span className="capitalize">{order.paymentStatus}</span>
          </p>
        </div>
        <div className="rounded-md border border-border bg-surface p-6">
          <h3 className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
            Summary
          </h3>
          <dl className="mt-3 space-y-2 text-sm">
            <div className="flex justify-between">
              <dt className="text-muted-foreground">Subtotal</dt>
              <dd className="font-semibold text-primary">{formatNaira(order.subtotal)}</dd>
            </div>
            <div className="flex justify-between">
              <dt className="text-muted-foreground">VAT (7.5%)</dt>
              <dd className="font-semibold text-primary">{formatNaira(order.vat)}</dd>
            </div>
            <div className="flex justify-between border-t border-border pt-2 font-display text-lg">
              <dt className="font-semibold text-primary">Total</dt>
              <dd className="font-bold text-primary">{formatNaira(order.total)}</dd>
            </div>
          </dl>
        </div>
      </section>

      <ReceiptModal
        isOpen={receiptModalOpen}
        onClose={() => setReceiptModalOpen(false)}
        order={order}
      />

      <InvoicePreviewModal
        isOpen={invoiceModalOpen}
        onClose={() => setInvoiceModalOpen(false)}
        orderNumber={order.id}
      />
    </div>
  );
}
