import { useEffect, useState, useRef } from "react";
import { X, Image, FileText } from "lucide-react";
import { getOrder, type Order } from "@/api/orders";
import { toast } from "sonner";
import { OrderStatusBadge } from "@/components/common/OrderStatusBadge";

interface ReceiptModalProps {
  isOpen: boolean;
  onClose: () => void;
  order: Order | null;
  orderNumber?: string;
}

export function ReceiptModal({
  isOpen,
  onClose,
  order: initialOrder,
  orderNumber,
}: ReceiptModalProps) {
  const [order, setOrder] = useState<Order | null>(initialOrder);
  const [loading, setLoading] = useState(false);
  const receiptRef = useRef<HTMLDivElement>(null);

  const handleDownloadImage = async () => {
    if (!receiptRef.current) return;
    try {
      toast.info("Generating JPEG image...");
      const html2canvasModule = await import("html2canvas-pro");
      const html2canvas = html2canvasModule.default || html2canvasModule;

      const canvas = await html2canvas(receiptRef.current, {
        scale: 2,
        useCORS: true,
        backgroundColor: "#ffffff",
      });
      const imgData = canvas.toDataURL("image/jpeg", 0.95);
      const link = document.createElement("a");
      link.href = imgData;
      link.download = `YAROTECH-Receipt-${order?.id}.jpg`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      toast.success("JPEG receipt downloaded successfully!");
    } catch (err) {
      console.error(err);
      toast.error("Failed to generate JPEG receipt.");
    }
  };

  const handleDownloadPDF = async () => {
    if (!receiptRef.current) return;
    try {
      toast.info("Generating PDF receipt...");
      const html2canvasModule = await import("html2canvas-pro");
      const html2canvas = html2canvasModule.default || html2canvasModule;

      const jspdfModule = await import("jspdf");
      const jsPDF = jspdfModule.jsPDF || jspdfModule.default || jspdfModule;

      const canvas = await html2canvas(receiptRef.current, {
        scale: 2,
        useCORS: true,
        backgroundColor: "#ffffff",
      });

      const imgData = canvas.toDataURL("image/jpeg", 0.95);
      const imgWidth = 80; // standard width for ticket receipt roll (80mm)
      const pageHeight = (canvas.height * imgWidth) / canvas.width;

      const pdf = new jsPDF({
        orientation: "portrait",
        unit: "mm",
        format: [imgWidth, pageHeight + 10],
      });

      pdf.addImage(imgData, "JPEG", 0, 5, imgWidth, pageHeight);
      pdf.save(`YAROTECH-Receipt-${order?.id}.pdf`);
      toast.success("PDF receipt downloaded successfully!");
    } catch (err) {
      console.error(err);
      toast.error("Failed to generate PDF receipt.");
    }
  };

  useEffect(() => {
    setOrder(initialOrder);
  }, [initialOrder]);

  useEffect(() => {
    if (isOpen && !initialOrder && orderNumber) {
      setLoading(true);
      getOrder(orderNumber)
        .then((res) => {
          if (res) {
            setOrder(res);
          } else {
            toast.error("Failed to load receipt details.");
          }
        })
        .catch(() => {
          toast.error("An error occurred loading receipt.");
        })
        .finally(() => {
          setLoading(false);
        });
    }
  }, [isOpen, initialOrder, orderNumber]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-background/70 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="relative w-full max-w-lg rounded-xl border border-border bg-surface shadow-2xl transition-all duration-300">
        {/* Header toolbar */}
        <div className="flex items-center justify-between border-b border-border px-6 py-4">
          <h3 className="font-display text-sm font-bold uppercase tracking-wider text-primary">
            Transaction Receipt
          </h3>
          <button
            onClick={onClose}
            className="rounded-full p-1.5 text-muted-foreground hover:bg-accent hover:text-primary transition"
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        {/* Receipt Container */}
        <div className="p-6 md:p-8 max-h-[70vh] overflow-y-auto">
          {loading ? (
            <div className="flex flex-col items-center justify-center py-16 space-y-3">
              <div className="h-8 w-8 animate-spin rounded-full border-2 border-dashed border-primary/50" />
              <p className="text-sm text-muted-foreground">Loading transaction invoice details…</p>
            </div>
          ) : !order ? (
            <div className="py-12 text-center text-sm text-muted-foreground">
              Receipt data not available.
            </div>
          ) : (
            <div
              ref={receiptRef}
              className="relative rounded-lg border border-border bg-background px-6 py-8 shadow-sm overflow-hidden"
            >
              {/* Top Gradient bar */}
              <div className="absolute top-0 inset-x-0 h-1.5 bg-gradient-to-r from-primary via-secondary to-accent" />

              {/* Brand Head */}
              <div className="text-center">
                <h2 className="font-display text-2xl font-black  tracking-tight text-primary">
                  YAROTECH NETWORK LIMITED
                </h2>
               <p className="text-[12px] font-black uppercase tracking-widest text-muted-foreground mt-0.5">
                  Powering Connection. Building Future
                </p>
                <p className="text-[11px] font-black text-muted-foreground mt-0.5">
                  Lokoro plaza A Farm Center, Kano State, Nigeria
                </p>
                <p className="text-[11px] font-black text-muted-foreground mt-0.5">
                  07075373603 yarotech@gmail.com
                </p>
              </div>

              {/* Receipt Metadata */}
              <div className="mt-8 grid grid-cols-2 gap-y-3 text-xs border-t border-b border-border py-4">
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Receipt Number
                  </p>
                  <p className="font-mono font-semibold text-primary">{order.id}</p>
                </div>
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Date / Time
                  </p>
                  <p className="font-semibold text-primary">
                    {new Date(order.createdAt).toLocaleString()}
                  </p>
                </div>
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Customer
                  </p>
                  <p
                    className="font-semibold text-primary truncate max-w-[160px]"
                    title={order.customerName || order.customerEmail || "Walk-in"}
                  >
                    {order.customerName || order.customerEmail || "Walk-in customer"}
                  </p>
                </div>
                <div>
                  <p className="text-[9px] font-bold uppercase tracking-widest text-muted-foreground">
                    Payment Status
                  </p>
                  <div className="mt-0.5">
                    <OrderStatusBadge status={order.status} />
                  </div>
                </div>
              </div>

              {/* Items List */}
              <div className="mt-6">
                <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground mb-3">
                  Purchased Items
                </p>
                <div className="space-y-3">
                  {order.items.map((item, idx) => (
                    <div key={idx} className="flex justify-between items-start text-xs">
                      <div className="max-w-[70%]">
                        <p className="font-semibold text-primary">{item.name}</p>
                        <p className="text-[10px] text-muted-foreground font-black">{item.sku}</p>
                      </div>
                      <div className="text-right">
                        <p className="font-bold text-primary">
                          ₦{(item.qty * item.price).toLocaleString()}
                        </p>
                        <p className="text-[10px] font-black text-muted-foreground">
                          {item.qty} x ₦{item.price.toLocaleString()}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Dotted divisions with side punches */}
              <div className="relative my-6">
                <div className="border-t border-dashed border-border" />
                <div className="absolute -left-[33px] -top-3 h-6 w-6 rounded-full bg-surface border-r border-border" />
                <div className="absolute -right-[33px] -top-3 h-6 w-6 rounded-full bg-surface border-l border-border" />
              </div>

              {/* Financial Breakdowns */}
              <div className="space-y-1.5 text-xs text-muted-foreground">
                <div className="flex justify-between">
                  <span className="font-bold text-primary">Subtotal</span>
                  <span className="font-semibold text-primary">
                    ₦{order.subtotal.toLocaleString()}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="font-bold text-primary">VAT (7.5%)</span>
                  <span className="font-semibold text-primary">₦{order.vat.toLocaleString()}</span>
                </div>
                <div className="flex justify-between">
                  <span className="font-bold text-primary">Fulfillment / Delivery</span>
                  <span className="font-semibold text-primary">
                    ₦{order.deliveryFee.toLocaleString()}
                  </span>
                </div>

                <div className="flex justify-between border-t border-border pt-3 mt-3">
                  <span className="font-display text-sm font-bold text-primary uppercase tracking-wider">
                    Total Paid
                  </span>
                  <span className="font-display text-lg font-black font-bold text-primary">
                    ₦{order.total.toLocaleString()}
                  </span>
                </div>
              </div>

              {/* Barcode representation */}
              <div className="mt-8 flex flex-col items-center justify-center">
                <div className="flex h-12 gap-[1.5px] overflow-hidden opacity-80">
                  <div className="w-[3px] bg-primary h-full"></div>
                  <div className="w-[1px] bg-primary h-full"></div>
                  <div className="w-[4px] bg-primary h-full"></div>
                  <div className="w-[2px] bg-primary h-full"></div>
                  <div className="w-[1px] bg-primary h-full"></div>
                  <div className="w-[3px] bg-primary h-full"></div>
                  <div className="w-[1px] bg-primary h-full"></div>
                  <div className="w-[2px] bg-primary h-full"></div>
                  <div className="w-[4px] bg-primary h-full"></div>
                  <div className="w-[1px] bg-primary h-full"></div>
                  <div className="w-[2px] bg-primary h-full"></div>
                  <div className="w-[4px] bg-primary h-full"></div>
                  <div className="w-[1px] bg-primary h-full"></div>
                  <div className="w-[3px] bg-primary h-full"></div>
                  <div className="w-[2px] bg-primary h-full"></div>
                  <div className="w-[1px] bg-primary h-full"></div>
                  <div className="w-[4px] bg-primary h-full"></div>
                </div>
                <p className="mt-1 font-mono font-black text-[10px] uppercase tracking-widest text-muted-foreground">
                  {order.id}
                </p>
                <p className="font-bold">
                  No Refund After Payment
                </p >
              </div>
            </div>
          )}
        </div>

        {/* Action sharing toolbar */}
        {order && (
          <div className="grid grid-cols-2 border-t border-border bg-accent/10 px-6 py-4 gap-2">
            <button
              onClick={handleDownloadImage}
              className="flex flex-col items-center justify-center rounded-lg border border-border bg-surface p-2 text-primary hover:bg-accent transition cursor-pointer"
              title="Save as Image (JPEG)"
            >
              <Image className="h-4 w-4" />
              <span className="text-[9px] font-bold uppercase tracking-wider mt-1">Save JPEG</span>
            </button>
            <button
              onClick={handleDownloadPDF}
              className="flex flex-col items-center justify-center rounded-lg border border-border bg-surface p-2 text-primary hover:bg-accent transition cursor-pointer"
              title="Save as PDF"
            >
              <FileText className="h-4 w-4" />
              <span className="text-[9px] font-bold uppercase tracking-wider mt-1">Save PDF</span>
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
