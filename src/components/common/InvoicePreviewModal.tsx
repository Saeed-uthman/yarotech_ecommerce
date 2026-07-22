import { useEffect, useState, useRef } from "react";
import { X, Download, Printer, FileText, ExternalLink } from "lucide-react";
import { toast } from "sonner";
import {
  fetchInvoiceData,
  type InvoiceData,
  type InvoiceItem,
  type InvoiceOrder,
} from "@/api/invoice";
import {
  fetchAdminInvoiceData,
  type AdminInvoiceData,
} from "@/api/admin";
import { NGN } from "@/lib/format";
import { Link } from "@tanstack/react-router";

interface InvoicePreviewModalProps {
  isOpen: boolean;
  onClose: () => void;
  /** Post-payment: order number to fetch invoice from API (user mode) */
  orderNumber?: string;
  /** Admin/staff mode: order ID to fetch invoice from admin API */
  orderId?: string;
  /** Enable admin mode (uses admin API endpoints, no ownership check) */
  adminMode?: boolean;
  /** Pre-payment: inline data from checkout (no DB order yet) */
  previewData?: {
    customerName: string;
    customerEmail: string;
    customerPhone: string;
    company?: string;
    items: { name: string; sku: string; qty: number; price: number }[];
    subtotal: number;
    vat: number;
    deliveryFee: number;
    total: number;
    fulfillmentMethod: "delivery" | "pickup";
    deliveryState?: string;
    deliveryCity?: string;
    deliveryAddress?: string;
    deliveryLandmark?: string;
  };
  /** Show "Pay Now" CTA (pre-payment mode) */
  showPayAction?: boolean;
}

export function InvoicePreviewModal({
  isOpen,
  onClose,
  orderNumber,
  orderId,
  adminMode = false,
  previewData,
  showPayAction = false,
}: InvoicePreviewModalProps) {
  const [invoice, setInvoice] = useState<InvoiceData | AdminInvoiceData | null>(null);
  const [loading, setLoading] = useState(false);
  const [downloading, setDownloading] = useState(false);
  const invoiceRef = useRef<HTMLDivElement>(null);

  // Fetch invoice data for post-payment mode
  useEffect(() => {
    if (!isOpen) return;
    if (previewData) return; // pre-payment uses inline data

    const id = adminMode ? orderId : orderNumber;
    if (!id) return;

    setLoading(true);
    const fetcher = adminMode
      ? fetchAdminInvoiceData(id)
      : fetchInvoiceData(id);

    fetcher
      .then((data) => {
        if (data) setInvoice(data);
        else toast.error("Failed to load invoice data.");
      })
      .catch(() => toast.error("Error loading invoice."))
      .finally(() => setLoading(false));
  }, [isOpen, orderNumber, orderId, adminMode, previewData]);

  // Reset state when modal closes
  useEffect(() => {
    if (!isOpen) {
      setInvoice(null);
      setDownloading(false);
    }
  }, [isOpen]);

  const handleDownloadPdf = async () => {
    const el = invoiceRef.current;
    if (!el) return;
    setDownloading(true);
    try {
      toast.info("Generating invoice PDF…");

      const html2canvasModule = await import("html2canvas-pro");
      const html2canvas = html2canvasModule.default || html2canvasModule;

      const jspdfModule = await import("jspdf");
      const jsPDF = jspdfModule.jsPDF || jspdfModule.default || jspdfModule;

      const canvas = await html2canvas(el, {
        scale: 2,
        useCORS: true,
        backgroundColor: "#ffffff",
      });

      const imgData = canvas.toDataURL("image/jpeg", 0.95);
      const imgWidth = 210; // A4 width in mm
      const pageHeight = (canvas.height * imgWidth) / canvas.width;

      const pdf = new jsPDF({
        orientation: "portrait",
        unit: "mm",
        format: [imgWidth, pageHeight],
      });

      pdf.addImage(imgData, "JPEG", 0, 0, imgWidth, pageHeight);

      const label = invoiceNumber || "preview";
      pdf.save(`YAROTECH-Invoice-${label}.pdf`);
      toast.success("Invoice PDF downloaded!");
    } catch (err) {
      console.error(err);
      toast.error("Failed to generate PDF. Please try again.");
    } finally {
      setDownloading(false);
    }
  };

  const handlePrint = () => {
    const printContent = invoiceRef.current;
    if (!printContent) return;
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;
    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>Invoice ${orderNumber ?? "Preview"}</title>
        <style>
          @media print {
            body { margin: 0; }
            @page { margin: 15mm; size: A4; }
          }
          body { font-family: 'DejaVu Sans', Arial, sans-serif; color: #0D1C32; }
        </style>
      </head>
      <body>${printContent.innerHTML}</body>
      </html>
    `);
    printWindow.document.close();
    setTimeout(() => {
      printWindow.print();
      printWindow.close();
    }, 400);
  };

  if (!isOpen) return null;

  const isPostPayment = !!invoice;
  const isPrePayment = !!previewData && !isPostPayment;
  const displayId = adminMode ? orderId : orderNumber;

  // Derive display data
  let displayOrder: Partial<InvoiceOrder>;
  let displayItems: InvoiceItem[];
  let invoiceNumber: string;
  let issuedAt: string;
  let validUntil: string;
  let paymentStatus: string;

  if (isPostPayment && invoice) {
    displayOrder = invoice.order;
    displayItems = invoice.items;
    invoiceNumber = invoice.invoice_number;
    issuedAt = invoice.issued_at;
    validUntil = invoice.valid_until;
    paymentStatus = invoice.order.payment_status;
  } else if (isPrePayment && previewData) {
    const now = new Date();
    const valid = new Date(now.getTime() + 48 * 60 * 60 * 1000);
    displayOrder = {
      order_number: "PREVIEW",
      fulfillment_method: previewData.fulfillmentMethod,
      customer_name: previewData.customerName,
      customer_email: previewData.customerEmail,
      customer_phone: previewData.customerPhone,
      delivery_state: previewData.deliveryState,
      delivery_city: previewData.deliveryCity,
      delivery_address: previewData.deliveryAddress,
      delivery_landmark: previewData.deliveryLandmark,
    };
    displayItems = previewData.items.map((i) => ({
      product_name_snapshot: i.name,
      sku_snapshot: i.sku,
      quantity: i.qty,
      unit_price_snapshot: i.price,
      line_total: i.price * i.qty,
    }));
    invoiceNumber = "INV-PREVIEW";
    issuedAt = now.toISOString();
    validUntil = valid.toISOString();
    paymentStatus = "pending";
  } else {
    return null;
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-background/70 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="relative w-full max-w-3xl rounded-xl border border-border bg-surface shadow-2xl transition-all duration-300">
        {/* Header toolbar */}
        <div className="flex items-center justify-between border-b border-border px-6 py-4">
          <div className="flex items-center gap-3">
            <FileText className="h-5 w-5 text-secondary" />
            <h3 className="font-display text-sm font-bold uppercase tracking-wider text-primary">
              {isPrePayment ? "Proforma Invoice" : "Invoice"}
            </h3>
          </div>
          <button
            onClick={onClose}
            className="rounded-full p-1.5 text-muted-foreground hover:bg-accent hover:text-primary transition"
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        {/* Invoice Preview */}
        <div className="p-6 md:p-8 max-h-[70vh] overflow-y-auto">
          {loading ? (
            <div className="flex flex-col items-center justify-center py-16 space-y-3">
              <div className="h-8 w-8 animate-spin rounded-full border-2 border-dashed border-primary/50" />
              <p className="text-sm text-muted-foreground">Loading invoice…</p>
            </div>
          ) : (
            <div
              ref={invoiceRef}
              className="relative rounded-lg border border-border bg-background px-8 py-10 shadow-sm overflow-hidden"
            >
              {/* Top gradient bar */}
              <div className="absolute top-0 inset-x-0 h-2 bg-gradient-to-r from-primary via-primary to-secondary" />

              {/* Brand header */}
              <div className="flex items-start justify-between">
                <div>
                  <h2 className="font-display text-2xl font-black tracking-tight text-primary">
                    YAROTECH NETWORK LIMITED
                  </h2>
                  <p className="text-[10px] font-bold uppercase tracking-[2px] text-muted-foreground mt-1">
                    Powering Connection. Building Future
                  </p>
                  <p className="text-[11px] text-muted-foreground mt-1">
                    Lokoro plaza A Farm Center, Kano State, Nigeria
                  </p>
                  <p className="text-[11px] text-muted-foreground mt-0.5">
                    07075373603 · yarotech@gmail.com
                  </p>
                </div>
                <div className="text-right">
                  <h3 className="font-display text-3xl font-black tracking-[4px] text-primary">
                    INVOICE
                  </h3>
                  <div className="mt-2">
                    <span
                      className={`inline-block rounded-full px-3 py-1 text-[10px] font-bold uppercase tracking-wide ${
                        paymentStatus === "success" || paymentStatus === "paid"
                          ? "bg-success/10 text-success"
                          : paymentStatus === "failed"
                            ? "bg-destructive/10 text-destructive"
                            : "bg-warning/10 text-warning"
                      }`}
                    >
                      {paymentStatus === "success" || paymentStatus === "paid"
                        ? "PAID"
                        : isPrePayment
                          ? "AWAITING PAYMENT"
                          : "PENDING"}
                    </span>
                  </div>
                </div>
              </div>

              {/* Invoice meta */}
              <div className="mt-8 grid grid-cols-2 gap-y-4 text-xs border-t border-b border-border py-5">
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Invoice Number
                  </p>
                  <p className="font-mono font-bold text-primary text-sm">{invoiceNumber}</p>
                </div>
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Date Issued
                  </p>
                  <p className="font-semibold text-primary">
                    {new Date(issuedAt).toLocaleDateString("en-NG", {
                      day: "2-digit",
                      month: "short",
                      year: "numeric",
                    })}
                  </p>
                </div>
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Bill To
                  </p>
                  <p className="font-semibold text-primary">
                    {displayOrder.customer_name || "Customer"}
                  </p>
                  <p className="text-muted-foreground">{displayOrder.customer_email}</p>
                  <p className="text-muted-foreground">{displayOrder.customer_phone}</p>
                </div>
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Valid Until
                  </p>
                  <p className="font-semibold text-primary">
                    {new Date(validUntil).toLocaleString("en-NG", {
                      day: "2-digit",
                      month: "short",
                      year: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
              </div>

              {/* Fulfillment */}
              <div className="mt-5 rounded-sm border-l-4 border-secondary bg-accent/30 p-3 text-xs">
                <p className="font-bold text-primary uppercase tracking-wider">
                  {displayOrder.fulfillment_method === "pickup" ? "Pickup" : "Delivery"}
                </p>
                {displayOrder.fulfillment_method === "pickup" ? (
                  <p className="text-muted-foreground mt-1">
                    Lokoro plaza A Farm Center, Kano State
                  </p>
                ) : (
                  <p className="text-muted-foreground mt-1">
                    {[
                      displayOrder.delivery_address,
                      displayOrder.delivery_city,
                      displayOrder.delivery_state,
                    ]
                      .filter(Boolean)
                      .join(", ")}
                    {displayOrder.delivery_landmark
                      ? ` — ${displayOrder.delivery_landmark}`
                      : ""}
                  </p>
                )}
              </div>

              {/* Items table */}
              <div className="mt-6">
                <table className="w-full text-xs">
                  <thead>
                    <tr className="bg-primary text-white">
                      <th className="px-3 py-2.5 text-left font-bold uppercase tracking-wider">
                        #
                      </th>
                      <th className="px-3 py-2.5 text-left font-bold uppercase tracking-wider">
                        Product
                      </th>
                      <th className="px-3 py-2.5 text-center font-bold uppercase tracking-wider">
                        Qty
                      </th>
                      <th className="px-3 py-2.5 text-right font-bold uppercase tracking-wider">
                        Unit Price
                      </th>
                      <th className="px-3 py-2.5 text-right font-bold uppercase tracking-wider">
                        Total
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-border">
                    {displayItems.map((item, idx) => (
                      <tr
                        key={idx}
                        className={idx % 2 === 1 ? "bg-accent/20" : "bg-background"}
                      >
                        <td className="px-3 py-2.5 text-muted-foreground">{idx + 1}</td>
                        <td className="px-3 py-2.5">
                          <p className="font-bold text-primary">{item.product_name_snapshot}</p>
                          <p className="text-[10px] text-muted-foreground font-mono mt-0.5">
                            {item.sku_snapshot}
                          </p>
                        </td>
                        <td className="px-3 py-2.5 text-center text-primary">
                          {item.quantity}
                        </td>
                        <td className="px-3 py-2.5 text-right text-primary">
                          {NGN(item.unit_price_snapshot)}
                        </td>
                        <td className="px-3 py-2.5 text-right font-bold text-primary">
                          {NGN(item.line_total)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Financial breakdown */}
              <div className="mt-6 flex justify-end">
                <div className="w-full max-w-xs space-y-2 text-xs">
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Subtotal</span>
                    <span className="font-semibold text-primary">
                      {NGN(displayOrder.subtotal ?? previewData?.subtotal ?? 0)}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">VAT (7.5%)</span>
                    <span className="font-semibold text-primary">
                      {NGN(displayOrder.tax_amount ?? previewData?.vat ?? 0)}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Delivery / Fulfillment</span>
                    <span className="font-semibold text-primary">
                      {NGN(displayOrder.delivery_fee ?? previewData?.deliveryFee ?? 0)}
                    </span>
                  </div>
                  <div className="flex justify-between border-t border-border pt-3">
                    <span className="font-display text-sm font-bold text-primary uppercase tracking-wider">
                      Grand Total
                    </span>
                    <span className="font-display text-lg font-black text-primary">
                      {NGN(displayOrder.total_amount ?? previewData?.total ?? 0)}
                    </span>
                  </div>
                </div>
              </div>

              {/* Payment terms */}
              <div className="mt-8 rounded-sm border border-dashed border-border p-4 text-[11px] text-muted-foreground">
                <p className="font-bold text-primary uppercase tracking-wider mb-2">
                  Payment Terms
                </p>
                <ul className="space-y-1 list-disc list-inside">
                  <li>Payment is required before order processing and dispatch.</li>
                  <li>This invoice is valid for 48 hours from the date of issue.</li>
                  <li>
                    Secure payment via <strong>Paystack</strong> (cards, bank transfer, USSD).
                  </li>
                  {invoiceNumber !== "INV-PREVIEW" && (
                    <li>
                      Reference: <strong className="font-mono">{invoiceNumber}</strong>
                    </li>
                  )}
                </ul>
              </div>

              {/* Footer */}
              <div className="mt-8 border-t-2 border-primary pt-4 text-center">
                <p className="text-[10px] text-muted-foreground">
                  YAROTECH NETWORK LIMITED · Kano State, Nigeria
                </p>
                <p className="text-[10px] text-muted-foreground mt-0.5">
                  Thank you for choosing YAROTECH. Powering Connection. Building Future.
                </p>
                <div className="mt-2 mx-auto w-16 h-0.5 bg-secondary" />
              </div>
            </div>
          )}
        </div>

        {/* Action toolbar */}
        <div className="flex flex-wrap items-center justify-between gap-3 border-t border-border bg-accent/10 px-6 py-4">
          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              disabled={loading}
              className="inline-flex items-center gap-2 rounded-sm border border-border bg-surface px-4 py-2 text-xs font-semibold text-primary hover:bg-accent transition disabled:opacity-50"
            >
              <Printer className="h-3.5 w-3.5" /> Print
            </button>
            <button
              onClick={handleDownloadPdf}
              disabled={downloading || loading}
              className="inline-flex items-center gap-2 rounded-sm bg-primary px-4 py-2 text-xs font-bold text-primary-foreground hover:opacity-90 transition disabled:opacity-50"
            >
              <Download className="h-3.5 w-3.5" />
              {downloading ? "Generating…" : "Download PDF"}
            </button>
          </div>

          <div className="flex items-center gap-2">
            {showPayAction && (
              <Link
                to="/checkout"
                onClick={onClose}
                className="inline-flex items-center gap-2 rounded-sm bg-secondary px-4 py-2 text-xs font-bold text-secondary-foreground hover:opacity-90 transition"
              >
                Proceed to Payment <ExternalLink className="h-3.5 w-3.5" />
              </Link>
            )}
            <button
              onClick={onClose}
              className="rounded-sm border border-border px-4 py-2 text-xs font-semibold text-muted-foreground hover:bg-accent transition"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
