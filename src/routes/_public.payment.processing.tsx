import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useRef } from "react";
import { Lock } from "lucide-react";
import { verifyPaystackPayment } from "@/api/payments";
import { useCartStore, cartTotals } from "@/stores/cart";
import { useAuthStore } from "@/stores/auth";
import { useNotificationStore } from "@/stores/notifications";
import { toast } from "sonner";

interface Search {
  ref?: string;
  orderId?: string;
  reference?: string;
}

export const Route = createFileRoute("/_public/payment/processing")({
  validateSearch: (s: Record<string, unknown>): Search => ({
    ref: typeof s.ref === "string" ? s.ref : undefined,
    orderId: typeof s.orderId === "string" ? s.orderId : undefined,
    reference: typeof s.reference === "string" ? s.reference : undefined,
  }),
  head: () => ({ meta: [{ title: "Processing Secure Payment — YAROTECH" }] }),
  component: ProcessingPage,
});

function ProcessingPage() {
  const search = Route.useSearch();
  const paymentRef = search.reference || search.ref;
  const navigate = useNavigate();
  const items = useCartStore((s) => s.items);
  const clear = useCartStore((s) => s.clear);
  const user = useAuthStore((s) => s.user);
  const pushNotif = useNotificationStore((s) => s.push);
  const ran = useRef(false);

  useEffect(() => {
    if (ran.current) return;
    ran.current = true;
    if (!paymentRef) {
      navigate({ to: "/cart" });
      return;
    }
    toast.loading("Processing payment with Paystack…", { id: "pay" });
    verifyPaystackPayment(paymentRef).then((res) => {
      toast.dismiss("pay");
      if (res.status === "success") {
        const totals = cartTotals(items);
        const resolvedOrderId = res.orderNumber || search.orderId || "Order";
        // Customer email confirmation (mock)
        pushNotif({
          kind: "payment",
          title: `Payment confirmed — ${resolvedOrderId}`,
          body: "Your order has been received. A confirmation email has been sent.",
          href: "/dashboard/orders",
        });
        // Admin notification (mock)
        pushNotif({
          kind: "order",
          title: `New order received — ${resolvedOrderId}`,
          body: `${user?.email ?? "Customer"} placed a new order for ₦${totals.total.toLocaleString()}.`,
          href: "/admin/orders-users",
        });
        toast.success("Payment successful — confirmation email sent.");
        clear();
        navigate({ to: "/payment/success", search: { ref: paymentRef, orderId: resolvedOrderId } });
      } else {
        toast.error("Payment failed. No funds were charged.");
        navigate({
          to: "/payment/failed",
          search: { ref: paymentRef, orderId: search.orderId || "Order" },
        });
      }
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div className="flex min-h-[70vh] items-center justify-center bg-[radial-gradient(circle,rgba(10,23,51,0.08)_1px,transparent_1px)] bg-[length:16px_16px] px-4">
      <div className="w-full max-w-md rounded-md border border-border bg-surface p-10 text-center shadow-sm">
        <div className="relative mx-auto flex h-24 w-24 items-center justify-center">
          <div className="absolute inset-0 animate-spin rounded-full border-2 border-dashed border-primary/30" />
          <div className="flex h-14 w-14 items-center justify-center rounded-full bg-primary/5">
            <Lock className="h-7 w-7 text-primary" />
          </div>
        </div>
        <h1 className="mt-6 font-display text-3xl font-bold leading-tight text-primary">
          Processing Secure Payment…
        </h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Please do not refresh this page or click back.
        </p>
        <div className="my-8 h-px bg-border" />
        <p className="text-xs font-semibold uppercase tracking-widest text-muted-foreground">
          Secured by Paystack
        </p>
        {paymentRef && (
          <p className="mt-3 font-mono text-[10px] text-muted-foreground">Ref: {paymentRef}</p>
        )}
      </div>
    </div>
  );
}
