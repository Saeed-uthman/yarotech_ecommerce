import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { CheckCircle2, Download, ShoppingBag, Mail, Bell, FileText } from "lucide-react";
import { fetchOrderReceipt, type Order } from "@/api/orders";
import { NGN } from "@/lib/format";
import { ReceiptModal } from "@/components/common/ReceiptModal";
import { InvoicePreviewModal } from "@/components/common/InvoicePreviewModal";

interface Search {
  ref?: string;
  orderId?: string;
}

export const Route = createFileRoute("/_public/payment/success")({
  validateSearch: (s: Record<string, unknown>): Search => ({
    ref: typeof s.ref === "string" ? s.ref : undefined,
    orderId: typeof s.orderId === "string" ? s.orderId : undefined,
  }),
  head: () => ({ meta: [{ title: "Payment Successful — YAROTECH" }] }),
  component: SuccessPage,
});

function SuccessPage() {
  const { ref, orderId } = Route.useSearch();
  const [order, setOrder] = useState<Order | null>(null);
  const [receiptModalOpen, setReceiptModalOpen] = useState(false);
  const [invoiceModalOpen, setInvoiceModalOpen] = useState(false);

  useEffect(() => {
    if (orderId) fetchOrderReceipt(orderId).then(setOrder);
  }, [orderId]);

  return (
    <div className="bg-[radial-gradient(circle,rgba(10,23,51,0.06)_1px,transparent_1px)] bg-[length:16px_16px] py-10">
      <div className="mx-auto max-w-xl px-4">
        <div className="rounded-md border border-border bg-surface p-5 sm:p-8 text-center shadow-sm">
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-success/10">
            <CheckCircle2 className="h-10 w-10 text-success" />
          </div>
          <h1 className="mt-4 font-display text-2xl sm:text-3xl font-bold text-primary">Payment Successful</h1>
          <p className="mt-2 text-sm text-muted-foreground">
            Thank you. Your order has been received and is being prepared.
          </p>

          <div className="mt-6 grid gap-2 rounded-sm border border-border bg-accent/30 p-3 sm:p-4 text-left text-xs sm:text-sm">
            <Row label="Order Number" value={orderId ?? "—"} mono />
            <Row label="Reference" value={ref ?? "—"} mono />
            <Row label="Total Paid" value={order ? NGN(order.total) : "—"} />
            <Row label="Items" value={order ? String(order.itemCount) : "—"} />
            <Row label="Customer" value={order?.customerEmail ?? "—"} />
          </div>

          {order && order.items.length > 0 && (
            <div className="mt-4 rounded-sm border border-border p-3 sm:p-4 text-left">
              <p className="text-xs font-bold uppercase tracking-widest text-muted-foreground">
                Products Purchased
              </p>
              <ul className="mt-2 space-y-1 text-sm">
                {order.items.map((it) => (
                  <li key={it.sku} className="flex justify-between gap-2">
                    <span className="text-primary">
                      {it.qty} × {it.name}
                    </span>
                    <span className="font-semibold text-primary">{NGN(it.price * it.qty)}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}

          <div className="mt-5 space-y-2 text-left text-xs">
            <div className="flex items-start gap-2 rounded-sm border border-border bg-surface p-3">
              <Mail className="mt-0.5 h-4 w-4 shrink-0 text-primary" />
              <span className="text-muted-foreground">
                A full order confirmation has been sent to your email.
              </span>
            </div>
            <div className="flex items-start gap-2 rounded-sm border border-border bg-surface p-3">
              <Bell className="mt-0.5 h-4 w-4 shrink-0 text-primary" />
              <span className="text-muted-foreground">
                Our procurement team has been notified and will reach out for fulfillment.
              </span>
            </div>
          </div>

          <div className="mt-6 flex flex-col gap-2 sm:flex-row sm:justify-center sm:flex-wrap">
            <button
              type="button"
              disabled={!order}
              onClick={() => setReceiptModalOpen(true)}
              className="inline-flex w-full sm:w-auto h-11 items-center justify-center gap-2 rounded-sm bg-cta px-5 text-sm font-bold text-cta-foreground hover:opacity-95 disabled:opacity-60"
            >
              View Receipt & Share
            </button>
            <button
              type="button"
              disabled={!order}
              onClick={() => setInvoiceModalOpen(true)}
              className="inline-flex w-full sm:w-auto h-11 items-center justify-center gap-2 rounded-sm bg-secondary px-5 text-sm font-bold text-secondary-foreground hover:opacity-90 disabled:opacity-60"
            >
              <FileText className="h-4 w-4" /> View Invoice
            </button>
            <Link
              to="/shop"
              className="inline-flex w-full sm:w-auto h-11 items-center justify-center gap-2 rounded-sm border border-border bg-surface px-5 text-sm font-semibold text-primary hover:bg-accent"
            >
              <ShoppingBag className="h-4 w-4" /> Continue Shopping
            </Link>
          </div>
          <Link
            to="/dashboard/orders"
            className="mt-3 block text-xs text-muted-foreground hover:underline"
          >
            View all my orders →
          </Link>
        </div>
      </div>

      <ReceiptModal
        isOpen={receiptModalOpen}
        onClose={() => setReceiptModalOpen(false)}
        order={order}
        orderNumber={orderId}
      />

      <InvoicePreviewModal
        isOpen={invoiceModalOpen}
        onClose={() => setInvoiceModalOpen(false)}
        orderNumber={orderId}
      />
    </div>
  );
}

function Row({ label, value, mono = false }: { label: string; value: string; mono?: boolean }) {
  return (
    <div className="flex items-center justify-between gap-2">
      <span className="text-muted-foreground">{label}</span>
      <span className={`font-semibold text-primary ${mono ? "font-mono text-xs" : ""}`}>
        {value}
      </span>
    </div>
  );
}
