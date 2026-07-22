import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { Trash2, ShoppingBag } from "lucide-react";
import { toast } from "sonner";
import { useCartStore, cartTotals } from "@/stores/cart";
import { useAuthStore } from "@/stores/auth";
import { NGN } from "@/lib/format";
import { PageHeader } from "@/components/common/PageHeader";
import { EmptyState } from "@/components/common/EmptyState";

export const Route = createFileRoute("/_public/cart")({
  head: () => ({ meta: [{ title: "Shopping Cart — YAROTECH" }] }),
  component: CartPage,
});

function CartPage() {
  const items = useCartStore((s) => s.items);
  const update = useCartStore((s) => s.update);
  const remove = useCartStore((s) => s.remove);
  const isAuth = useAuthStore((s) => s.isAuthenticated);
  const navigate = useNavigate();
  const { subtotal, vat, total, count } = cartTotals(items);

  const handleRemove = (id: string, name: string) => {
    remove(id);
    toast.success(`Removed ${name} from cart`);
  };

  const handleCheckout = () => {
    if (!isAuth) {
      toast.error("Please login to continue.", {
        description: "Checkout requires an account.",
      });
      navigate({ to: "/login" });
      return;
    }
    navigate({ to: "/checkout" });
  };

  return (
    <div className="mx-auto max-w-5xl px-4 py-8">
      <PageHeader
        title="Shopping Cart"
        description="Review your technical hardware selection before procurement."
      />

      {items.length === 0 ? (
        <div className="mt-8">
          <EmptyState
            icon={<ShoppingBag className="h-5 w-5" />}
            title="Your cart is empty"
            description="Browse the shop to add equipment to your cart."
            action={
              <Link
                to="/shop"
                className="inline-flex h-10 items-center rounded-sm bg-primary px-5 text-sm font-bold text-primary-foreground"
              >
                Go to Shop
              </Link>
            }
          />
        </div>
      ) : (
        <div className="mt-8 grid gap-6 md:grid-cols-[1fr_360px]">
          <div className="space-y-3">
            {items.map((item) => (
              <div key={item.productId} className="rounded-md border border-border bg-surface p-4">
                <div className="flex gap-3">
                  <div className="h-20 w-20 shrink-0 overflow-hidden rounded-sm bg-muted">
                    <img src={item.image} alt={item.name} className="h-full w-full object-cover" />
                  </div>
                  <div className="flex-1">
                    <Link
                      to="/shop/$slug"
                      params={{ slug: item.slug }}
                      className="font-semibold text-primary hover:underline"
                    >
                      {item.name}
                    </Link>
                    <p className="mt-0.5 text-xs text-muted-foreground">SKU: {item.sku}</p>
                  </div>
                </div>
                <div className="mt-3 grid grid-cols-2 gap-3 border-t border-border pt-3 text-sm">
                  <div>
                    <p className="text-muted-foreground">Price</p>
                    <p className="font-bold text-primary">{NGN(item.price)}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-muted-foreground">Subtotal</p>
                    <p className="font-bold text-primary">{NGN(item.price * item.quantity)}</p>
                  </div>
                </div>
                <div className="mt-3 flex items-center justify-between">
                  <div className="flex items-center rounded-sm border border-border">
                    <button
                      type="button"
                      onClick={() => update(item.productId, item.quantity - 1)}
                      className="h-8 w-8 text-base font-bold"
                    >
                      −
                    </button>
                    <span className="w-8 text-center text-sm font-semibold">{item.quantity}</span>
                    <button
                      type="button"
                      onClick={() => update(item.productId, item.quantity + 1)}
                      className="h-8 w-8 text-base font-bold"
                    >
                      +
                    </button>
                  </div>
                  <button
                    type="button"
                    onClick={() => handleRemove(item.productId, item.name)}
                    className="flex h-8 w-8 items-center justify-center rounded-sm text-muted-foreground hover:bg-destructive/10 hover:text-destructive"
                    aria-label="Remove"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>

          <aside className="h-fit rounded-md border border-border bg-surface p-5">
            <h2 className="font-display text-xl font-bold text-primary">Procurement Summary</h2>
            <div className="mt-4 space-y-2 border-t border-border pt-4 text-sm">
              <Row label={`Subtotal (${count} items)`} value={NGN(subtotal)} />
              <Row label="VAT (7.5%)" value={NGN(vat)} />
              <div className="flex items-start justify-between text-sm">
                <span className="text-muted-foreground">Estimated Shipping</span>
                <span className="text-muted-foreground">Calculated at checkout</span>
              </div>
            </div>
            <div className="mt-4 flex items-center justify-between border-t border-border pt-4">
              <span className="font-display text-lg font-bold">Total</span>
              <span className="font-display text-2xl font-bold text-primary">{NGN(total)}</span>
            </div>
            <button
              type="button"
              onClick={handleCheckout}
              className="mt-5 inline-flex h-12 w-full items-center justify-center gap-2 rounded-sm bg-secondary text-sm font-bold text-secondary-foreground hover:opacity-90"
            >
              Proceed to Checkout →
            </button>
            <p className="mt-3 text-center text-[11px] font-semibold uppercase tracking-widest text-muted-foreground">
              🔒 Secure Encrypted Checkout
            </p>
          </aside>
        </div>
      )}
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
