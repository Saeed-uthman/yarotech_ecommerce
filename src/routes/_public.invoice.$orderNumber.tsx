import { createFileRoute, Link, useParams } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { ArrowLeft } from "lucide-react";
import { fetchInvoiceData, downloadInvoicePdf, type InvoiceData } from "@/api/invoice";
import { useAuthStore } from "@/stores/auth";
import { NGN } from "@/lib/format";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";

export const Route = createFileRoute("/_public/invoice/$orderNumber")({
  head: () => ({ meta: [{ title: "Invoice — YAROTECH" }, { name: "robots", content: "noindex" }] }),
  component: InvoicePage,
});

function InvoicePage() {
  const { orderNumber } = useParams({ from: "/_public/invoice/$orderNumber" });
  const isAuth = useAuthStore((s) => s.isAuthenticated);
  const [invoice, setInvoice] = useState<InvoiceData | null>(null);
  const [loading, setLoading] = useState(true);
  const [downloading, setDownloading] = useState(false);

  useEffect(() => {
    if (!isAuth) return;
    setLoading(true);
    fetchInvoiceData(orderNumber)
      .then((data) => {
        if (data) setInvoice(data);
        else toast.error("Invoice not found.");
      })
      .catch(() => toast.error("Failed to load invoice."))
      .finally(() => setLoading(false));
  }, [orderNumber, isAuth]);

  const handleDownloadPdf = async () => {
    setDownloading(true);
    try {
      await downloadInvoicePdf(orderNumber);
      toast.success("Invoice PDF downloaded!");
    } catch {
      toast.error("Failed to download PDF.");
    } finally {
      setDownloading(false);
    }
  };

  if (!isAuth) {
    return (
      <div className="mx-auto max-w-3xl px-4 py-10 text-center">
        <p className="text-sm text-muted-foreground">Please login to view this invoice.</p>
        <Link to="/login" className="mt-4 inline-block text-sm font-semibold text-primary hover:underline">
          Go to Login
        </Link>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="mx-auto max-w-3xl px-4 py-10">
        <div className="rounded-md border border-border bg-surface p-8 text-center">
          <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-dashed border-primary/50" />
          <p className="mt-3 text-sm text-muted-foreground">Loading invoice…</p>
        </div>
      </div>
    );
  }

  if (!invoice) {
    return (
      <div className="mx-auto max-w-3xl px-4 py-10 text-center">
        <p className="text-sm text-muted-foreground">Invoice not found.</p>
        <Link to="/dashboard/orders" className="mt-4 inline-block text-sm font-semibold text-primary hover:underline">
          View My Orders
        </Link>
      </div>
    );
  }

  const { order, items } = invoice;
  const paymentStatus = order.payment_status;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <Link
        to="/dashboard/orders"
        className="inline-flex items-center gap-2 text-xs font-semibold text-primary hover:underline mb-6"
      >
        <ArrowLeft className="h-4 w-4" /> Back to orders
      </Link>

      <PageHeader
        eyebrow={invoice.invoice_number}
        title="Invoice"
        description={`Issued ${new Date(invoice.issued_at).toLocaleDateString("en-NG", { day: "2-digit", month: "short", year: "numeric" })} · Valid until ${new Date(invoice.valid_until).toLocaleDateString("en-NG", { day: "2-digit", month: "short", year: "numeric" })}`}
      />

      {/* Status + actions */}
      <div className="mt-6 flex flex-wrap items-center gap-3">
        <span
          className={`inline-block rounded-full px-3 py-1 text-[10px] font-bold uppercase tracking-wide ${
            paymentStatus === "success" || paymentStatus === "paid"
              ? "bg-success/10 text-success"
              : "bg-warning/10 text-warning"
          }`}
        >
          {paymentStatus === "success" || paymentStatus === "paid" ? "Paid" : "Awaiting Payment"}
        </span>
        <button
          onClick={handleDownloadPdf}
          disabled={downloading}
          className="inline-flex items-center gap-2 rounded-sm bg-primary px-4 py-2 text-xs font-bold text-primary-foreground hover:opacity-90 disabled:opacity-50"
        >
          {downloading ? "Generating…" : "Download PDF"}
        </button>
      </div>

      {/* Customer + Order info */}
      <div className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div className="rounded-md border border-border bg-surface p-5">
          <h3 className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground mb-2">
            Bill To
          </h3>
          <p className="text-sm font-semibold text-primary">{order.customer_name}</p>
          <p className="text-xs text-muted-foreground">{order.customer_email}</p>
          <p className="text-xs text-muted-foreground">{order.customer_phone}</p>
        </div>
        <div className="rounded-md border border-border bg-surface p-5">
          <h3 className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground mb-2">
            Fulfillment
          </h3>
          <p className="text-sm font-semibold text-primary capitalize">
            {order.fulfillment_method}
          </p>
          {order.fulfillment_method === "delivery" && (
            <p className="text-xs text-muted-foreground mt-1">
              {[order.delivery_address, order.delivery_city, order.delivery_state].filter(Boolean).join(", ")}
            </p>
          )}
        </div>
      </div>

      {/* Items */}
      <div className="mt-6 overflow-hidden rounded-md border border-border bg-surface">
        <div className="border-b border-border p-5">
          <h3 className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
            Items
          </h3>
        </div>
        <table className="w-full text-sm">
          <thead className="bg-accent/30 text-left text-[10px] uppercase tracking-widest text-muted-foreground">
            <tr>
              <th className="px-4 py-3">#</th>
              <th className="px-4 py-3">Product</th>
              <th className="px-4 py-3">SKU</th>
              <th className="px-4 py-3 text-right">Qty</th>
              <th className="px-4 py-3 text-right">Price</th>
              <th className="px-4 py-3 text-right">Total</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border">
            {items.map((item, idx) => (
              <tr key={idx}>
                <td className="px-4 py-3 text-muted-foreground">{idx + 1}</td>
                <td className="px-4 py-3 font-semibold text-primary">{item.product_name_snapshot}</td>
                <td className="px-4 py-3 font-mono text-xs text-muted-foreground">{item.sku_snapshot}</td>
                <td className="px-4 py-3 text-right">{item.quantity}</td>
                <td className="px-4 py-3 text-right">{NGN(item.unit_price_snapshot)}</td>
                <td className="px-4 py-3 text-right font-bold text-primary">{NGN(item.line_total)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Financial summary */}
      <div className="mt-6 flex justify-end">
        <div className="w-full max-w-sm rounded-md border border-border bg-surface p-5 space-y-2 text-sm">
          <div className="flex justify-between">
            <span className="text-muted-foreground">Subtotal</span>
            <span className="font-semibold text-primary">{NGN(order.subtotal)}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-muted-foreground">VAT (7.5%)</span>
            <span className="font-semibold text-primary">{NGN(order.tax_amount)}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-muted-foreground">Delivery / Fulfillment</span>
            <span className="font-semibold text-primary">{NGN(order.delivery_fee)}</span>
          </div>
          <div className="flex justify-between border-t border-border pt-3 mt-2">
            <span className="font-display text-base font-bold text-primary uppercase tracking-wider">
              Grand Total
            </span>
            <span className="font-display text-xl font-black text-primary">{NGN(order.total_amount)}</span>
          </div>
        </div>
      </div>

      {/* Payment terms */}
      <div className="mt-6 rounded-md border border-dashed border-border p-4 text-xs text-muted-foreground">
        <p className="font-bold text-primary uppercase tracking-wider mb-2">Payment Terms</p>
        <ul className="space-y-1 list-disc list-inside">
          <li>Payment is required before order processing and dispatch.</li>
          <li>This invoice is valid for 48 hours from the date of issue.</li>
          <li>Secure payment via Paystack (cards, bank transfer, USSD).</li>
        </ul>
      </div>
    </div>
  );
}
