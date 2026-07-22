import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { useCartStore } from "@/stores/cart";
import { NGN } from "@/lib/format";
import { PageHeader } from "@/components/common/PageHeader";
import {
  createCheckoutPreview,
  placeOrder,
  DELIVERY_STATES,
  type FulfillmentMethod,
  type CheckoutPreview,
} from "@/api/checkout";
import { initializePaystackPayment } from "@/api/payments";
import { useAuthStore } from "@/stores/auth";
import { toast } from "sonner";
import { MapPin, Store, ShieldCheck, Lock, FileText } from "lucide-react";
import { InvoicePreviewModal } from "@/components/common/InvoicePreviewModal";

export const Route = createFileRoute("/_public/checkout")({
  head: () => ({ meta: [{ title: "Checkout — YAROTECH" }] }),
  component: CheckoutPage,
});

function CheckoutPage() {
  const items = useCartStore((s) => s.items);
  const navigate = useNavigate();
  const user = useAuthStore((s) => s.user);
  const isAuth = useAuthStore((s) => s.isAuthenticated);
  const [submitting, setSubmitting] = useState(false);
  const [invoiceModalOpen, setInvoiceModalOpen] = useState(false);
  const [fulfillment, setFulfillment] = useState<FulfillmentMethod>("delivery");
  const [state, setState] = useState<string>("Lagos");
  const [preview, setPreview] = useState<CheckoutPreview | null>(null);

  // Auth gate
  useEffect(() => {
    if (!isAuth) {
      toast.error("Please login to continue.", {
        description: "Checkout requires an account.",
      });
      navigate({ to: "/login" });
    }
  }, [isAuth, navigate]);

  useEffect(() => {
    if (items.length === 0) navigate({ to: "/cart" });
  }, [items.length, navigate]);

  // Recalculate delivery preview when fulfillment / state changes
  useEffect(() => {
    if (items.length === 0) return;
    let cancelled = false;
    createCheckoutPreview({ items, fulfillment, state })
      .then((p) => {
        if (cancelled) return;
        setPreview(p);
        if (fulfillment === "delivery") {
          toast.message(`Delivery fee calculated: ${NGN(p.deliveryFee)}`, {
            description: `${p.zoneLabel} · ETA ${p.eta}`,
          });
        }
      })
      .catch((err) => {
        if (cancelled) return;
        toast.error("Could not calculate checkout totals", {
          description: err.message || "Please check your internet connection and try again.",
        });
      });
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fulfillment, state, items.length]);

  const summary = useMemo(() => preview, [preview]);

  const onSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!summary) return;
    const fd = new FormData(e.currentTarget);
    const customer = {
      fullName: String(fd.get("fullName") ?? ""),
      email: String(fd.get("email") ?? ""),
      phone: String(fd.get("phone") ?? ""),
      company: String(fd.get("company") ?? "") || undefined,
    };
    if (!customer.email.includes("@") || !customer.fullName || !customer.phone) {
      toast.error("Please complete required customer details");
      return;
    }
    let delivery: import("@/api/checkout").DeliveryAddress | undefined;
    if (fulfillment === "delivery") {
      delivery = {
        state,
        city: String(fd.get("city") ?? ""),
        address1: String(fd.get("address1") ?? ""),
        landmark: String(fd.get("landmark") ?? "") || undefined,
        phone: customer.phone,
        notes: String(fd.get("notes") ?? "") || undefined,
      };
      if (!delivery.city || !delivery.address1) {
        toast.error("Please complete the delivery address");
        return;
      }
    }
    setSubmitting(true);
    try {
      const order = await placeOrder({
        items,
        customer,
        fulfillment,
        delivery,
        subtotal: summary.subtotal,
        vat: summary.vat,
        deliveryFee: summary.deliveryFee,
        total: summary.total,
      });
      const init = await initializePaystackPayment({
        orderId: order.orderId,
        reference: order.reference,
        email: customer.email,
        amount: summary.total,
        authorizationUrl: order.authorizationUrl,
      } as any);
      toast.message("Redirecting to secure Paystack payment…");

      if (init.authorizationUrl && init.authorizationUrl.startsWith("http")) {
        window.location.href = init.authorizationUrl;
      } else {
        navigate({
          to: "/payment/processing",
          search: { ref: init.reference, orderId: order.orderId },
        });
      }
    } catch (err) {
      toast.error((err as Error).message);
      setSubmitting(false);
    }
  };

  if (items.length === 0 || !isAuth) return null;

  return (
    <div className="mx-auto max-w-5xl px-4 py-8">
      <PageHeader
        title="Checkout Summary"
        description="Review your order details before completing payment."
      />
      <form onSubmit={onSubmit} className="mt-8 grid gap-6 md:grid-cols-[1fr_360px]">
        <div className="space-y-5">
          {/* Customer Details */}
          <Card title="Customer Details">
            <div className="grid gap-3 md:grid-cols-2">
              <Field name="fullName" label="Full Name *" defaultValue={user?.fullName} />
              <Field name="company" label="Company (optional)" defaultValue={user?.company} />
              <Field name="email" label="Email Address *" type="email" defaultValue={user?.email} />
              <Field name="phone" label="Phone Number *" type="tel" />
            </div>
          </Card>

          {/* Fulfillment Selection */}
          <Card title="Fulfillment Method">
            <div className="grid gap-3 md:grid-cols-2">
              <MethodOption
                active={fulfillment === "delivery"}
                onClick={() => setFulfillment("delivery")}
                icon={<MapPin className="h-5 w-5" />}
                title="Delivery"
                desc="We deliver to your site or office."
              />
              <MethodOption
                active={fulfillment === "pickup"}
                onClick={() => setFulfillment("pickup")}
                icon={<Store className="h-5 w-5" />}
                title="Pickup"
                desc="Collect from YAROTECH ware house, kano."
              />
            </div>

            {fulfillment === "delivery" ? (
              <div className="mt-4 grid gap-3 md:grid-cols-2">
                <div>
                  <label className="text-xs font-bold uppercase tracking-widest text-muted-foreground">
                    State *
                  </label>
                  <select
                    name="state"
                    value={state}
                    onChange={(e) => setState(e.target.value)}
                    className="mt-1 h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm focus:border-primary focus:outline-none"
                  >
                    {DELIVERY_STATES.map((s) => (
                      <option key={s} value={s}>
                        {s}
                      </option>
                    ))}
                  </select>
                </div>
                <Field name="city" label="City / LGA *" />
                <Field name="address1" label="Full Address *" className="md:col-span-2" />
                <Field name="landmark" label="Landmark (optional)" className="md:col-span-2" />
                <div className="md:col-span-2">
                  <label className="text-xs font-bold uppercase tracking-widest text-muted-foreground">
                    Delivery Note
                  </label>
                  <textarea
                    name="notes"
                    rows={2}
                    placeholder="Access instructions, gate code, contact at site…"
                    className="mt-1 w-full rounded-sm border border-border bg-surface px-3 py-2 text-sm focus:border-primary focus:outline-none"
                  />
                </div>
              </div>
            ) : (
              <div className="mt-4 rounded-sm border border-dashed border-border bg-accent/30 p-4 text-sm">
                <p className="font-semibold text-primary">Pickup Instructions</p>
                <p className="mt-1 text-muted-foreground">
                  2nd floor, lokoro plaza, farm center GSM market, kano. Bring a valid ID and your
                  order number. Pickup hours: Mon–Fri, 9:00am – 5:00pm.
                </p>
              </div>
            )}
          </Card>

          {/* Order Items Summary */}
          <Card title={`Order Items (${items.length})`}>
            <div className="divide-y divide-border">
              {items.map((i) => (
                <div key={i.productId} className="flex items-center gap-3 py-3 text-sm">
                  <div className="h-12 w-12 shrink-0 overflow-hidden rounded-sm border border-border bg-muted">
                    <img src={i.image} alt={i.name} className="h-full w-full object-cover" />
                  </div>
                  <div className="flex-1">
                    <p className="font-semibold text-primary">{i.name}</p>
                    <p className="text-xs text-muted-foreground">
                      SKU: {i.sku} · Qty {i.quantity}
                    </p>
                  </div>
                  <span className="font-bold text-primary">{NGN(i.price * i.quantity)}</span>
                </div>
              ))}
            </div>
          </Card>
        </div>

        {/* Summary aside */}
        <aside className="h-fit space-y-4">
          <div className="rounded-md border border-border bg-surface p-5">
            <h2 className="font-display text-lg font-bold text-primary">Financial Breakdown</h2>
            <div className="mt-3 space-y-2 border-t border-border pt-3 text-sm">
              <Row
                label={`Subtotal (${summary?.itemCount ?? 0} items)`}
                value={NGN(summary?.subtotal ?? 0)}
              />
              <Row
                label={
                  fulfillment === "pickup"
                    ? "Pickup Fee"
                    : `Delivery (${summary?.zoneLabel ?? "—"})`
                }
                value={NGN(summary?.deliveryFee ?? 0)}
              />
              <Row label="VAT (7.5%)" value={NGN(summary?.vat ?? 0)} />
            </div>
            <div className="mt-3 flex items-center justify-between border-t border-border pt-3">
              <span className="font-display text-base font-bold">Total</span>
              <span className="font-display text-2xl font-bold text-primary">
                {NGN(summary?.total ?? 0)}
              </span>
            </div>
            <div className="mt-4 flex items-start gap-2 rounded-sm border border-border bg-accent/30 p-3 text-xs text-muted-foreground">
              <ShieldCheck className="mt-0.5 h-4 w-4 shrink-0 text-primary" />
              <span>You will be redirected to Paystack to complete your payment securely.</span>
            </div>
            <button
              type="button"
              onClick={() => setInvoiceModalOpen(true)}
              disabled={!summary}
              className="mt-3 inline-flex h-10 w-full items-center justify-center gap-2 rounded-sm border border-border bg-surface text-xs font-semibold text-primary hover:bg-accent disabled:opacity-60"
            >
              <FileText className="h-4 w-4" /> View Invoice Preview
            </button>
            <button
              type="submit"
              disabled={submitting || !summary}
              className="mt-4 inline-flex h-12 w-full items-center justify-center gap-2 rounded-sm bg-secondary text-sm font-bold text-secondary-foreground hover:opacity-90 disabled:opacity-60"
            >
              <Lock className="h-4 w-4" />
              {submitting ? "Initializing…" : `Pay ${NGN(summary?.total ?? 0)} with Paystack`}
            </button>
            <p className="mt-2 text-center text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
              Secured by Paystack
            </p>
            <Link
              to="/cart"
              className="mt-3 block text-center text-xs text-muted-foreground hover:underline"
            >
              ← Back to cart
            </Link>
          </div>
        </aside>
      </form>

      <InvoicePreviewModal
        isOpen={invoiceModalOpen}
        onClose={() => setInvoiceModalOpen(false)}
        previewData={
          summary
            ? {
                customerName: user?.fullName ?? "",
                customerEmail: user?.email ?? "",
                customerPhone: "",
                company: user?.company,
                items: items.map((i) => ({
                  name: i.name,
                  sku: i.sku,
                  qty: i.quantity,
                  price: i.price,
                })),
                subtotal: summary.subtotal,
                vat: summary.vat,
                deliveryFee: summary.deliveryFee,
                total: summary.total,
                fulfillmentMethod: fulfillment,
                deliveryState: fulfillment === "delivery" ? state : undefined,
              }
            : undefined
        }
        showPayAction
      />
    </div>
  );
}

function Card({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="rounded-md border border-border bg-surface p-5">
      <h2 className="font-display text-lg font-bold text-primary">{title}</h2>
      <div className="mt-4">{children}</div>
    </div>
  );
}

function MethodOption({
  active,
  onClick,
  icon,
  title,
  desc,
}: {
  active: boolean;
  onClick: () => void;
  icon: React.ReactNode;
  title: string;
  desc: string;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`flex items-start gap-3 rounded-sm border p-3 text-left transition ${
        active
          ? "border-secondary bg-secondary/10"
          : "border-border bg-surface hover:border-primary/50"
      }`}
    >
      <span className={`mt-0.5 ${active ? "text-secondary" : "text-primary"}`}>{icon}</span>
      <span>
        <span className="block font-semibold text-primary">{title}</span>
        <span className="block text-xs text-muted-foreground">{desc}</span>
      </span>
    </button>
  );
}

function Field({
  name,
  label,
  type = "text",
  defaultValue,
  className = "",
}: {
  name: string;
  label: string;
  type?: string;
  defaultValue?: string;
  className?: string;
}) {
  return (
    <div className={className}>
      <label className="text-xs font-bold uppercase tracking-widest text-muted-foreground">
        {label}
      </label>
      <input
        name={name}
        type={type}
        defaultValue={defaultValue}
        className="mt-1 h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm focus:border-primary focus:outline-none"
      />
    </div>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center justify-between">
      <span className="text-muted-foreground">{label}</span>
      <span className="font-semibold text-primary">{value}</span>
    </div>
  );
}
