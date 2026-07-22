import { createFileRoute, Link } from "@tanstack/react-router";
import { Package, MapPin, Bell, ShoppingBag, Truck, ArrowRight, CheckCircle2 } from "lucide-react";
import { useEffect, useState } from "react";
import { PageHeader } from "@/components/common/PageHeader";
import { OrderStatusBadge } from "@/components/common/OrderStatusBadge";
import { useAuthStore } from "@/stores/auth";
import { useAddressesStore } from "@/stores/addresses";
import { useNotificationStore } from "@/stores/notifications";
import { listMyOrders, type Order } from "@/api/orders";

export const Route = createFileRoute("/dashboard/")({
  component: DashboardIndex,
  head: () => ({ meta: [{ title: "Dashboard — YAROTECH" }] }),
});

function formatNaira(value: number) {
  return "₦" + value.toLocaleString();
}

function DashboardIndex() {
  const user = useAuthStore((s) => s.user);
  const addresses = useAddressesStore((s) => s.items);
  const notifications = useNotificationStore((s) => s.items);
  const [orders, setOrders] = useState<Order[]>([]);

  useEffect(() => {
    listMyOrders().then(setOrders);
  }, []);

  const first = user?.fullName?.split(" ")[0] ?? "Engineer";
  const inTransit = orders.filter((o) => o.status === "shipped" || o.status === "processing");
  const activeOrder = inTransit[0];
  const recent = orders.slice(0, 4);
  const primary = addresses.find((a) => a.isPrimary) ?? addresses[0];
  const unread = notifications.filter((n) => !n.read).length;
  const recentAlerts = notifications.slice(0, 3);

  const stats = [
    { label: "Total orders", value: orders.length, hint: "Lifetime", icon: Package },
    { label: "In transit", value: inTransit.length, hint: "Active shipments", icon: ShoppingBag },
    { label: "Saved addresses", value: addresses.length, hint: "Delivery profiles", icon: MapPin },
    { label: "Unread alerts", value: unread, hint: "Notifications", icon: Bell },
  ];

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Overview"
        title={`Hello, ${first}`}
        description="Track your procurement, manage addresses, and review your account activity."
      />

      {/* Profile summary */}
      <section className="grid grid-cols-1 gap-4 lg:grid-cols-[1fr_auto]">
        <div className="rounded-md border border-border bg-surface p-6">
          <div className="flex items-start justify-between gap-4">
            <div className="flex items-center gap-4">
              <div className="flex h-14 w-14 items-center justify-center rounded-full bg-primary text-lg font-bold text-primary-foreground">
                {first.charAt(0).toUpperCase()}
              </div>
              <div>
                <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
                  Account holder
                </p>
                <p className="font-display text-xl font-semibold text-primary">
                  {user?.fullName ?? "Engineer"}
                </p>
                <p className="text-sm text-muted-foreground">{user?.email}</p>
              </div>
            </div>
            <div className="hidden md:flex flex-col items-end gap-1">
              <span
                className={`inline-flex items-center gap-1 rounded-sm px-2 py-1 text-[10px] font-semibold uppercase tracking-widest ${user?.emailVerified ? "bg-success/10 text-success" : "bg-warning/10 text-warning"}`}
              >
                {user?.emailVerified && <CheckCircle2 className="h-3 w-3" />}
                {user?.emailVerified ? "Verified" : "Unverified"}
              </span>
              <span className="text-[10px] uppercase tracking-widest text-muted-foreground">
                {user?.accountType ?? "Account type not set"}
              </span>
            </div>
          </div>
          <div className="mt-4 flex flex-wrap gap-2">
            <Link
              to="/dashboard/profile"
              className="inline-flex h-9 items-center rounded-sm border border-border px-3 text-xs font-semibold text-primary hover:bg-accent"
            >
              Edit profile
            </Link>
            <Link
              to="/dashboard/account"
              className="inline-flex h-9 items-center rounded-sm border border-border px-3 text-xs font-semibold text-primary hover:bg-accent"
            >
              Account settings
            </Link>
          </div>
        </div>
      </section>

      {/* Stats */}
      <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
        {stats.map((s) => {
          const Icon = s.icon;
          return (
            <div key={s.label} className="rounded-md border border-border bg-surface p-4">
              <div className="flex items-center justify-between">
                <span className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
                  {s.label}
                </span>
                <Icon className="h-4 w-4 text-secondary" />
              </div>
              <p className="mt-2 font-display text-3xl font-bold text-primary">{s.value}</p>
              <p className="text-xs text-muted-foreground">{s.hint}</p>
            </div>
          );
        })}
      </div>

      {/* Active delivery + Primary address */}
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <div className="rounded-md border border-border bg-surface p-6">
          <div className="flex items-center justify-between">
            <h2 className="font-display text-base font-semibold text-primary">Active delivery</h2>
            <Truck className="h-4 w-4 text-secondary" />
          </div>
          {activeOrder ? (
            <div className="mt-3 space-y-3">
              <div className="flex items-center justify-between text-sm">
                <span className="font-mono text-primary">{activeOrder.id}</span>
                <OrderStatusBadge status={activeOrder.status} />
              </div>
              <p className="text-sm text-muted-foreground">
                {activeOrder.items[0]?.name}
                {activeOrder.itemCount > 1 && ` +${activeOrder.itemCount - 1} more`}
              </p>
              <div className="flex items-center justify-between border-t border-border pt-3">
                <span className="text-xs text-muted-foreground">Total</span>
                <span className="font-display font-semibold text-primary">
                  {formatNaira(activeOrder.total)}
                </span>
              </div>
              <Link
                to="/dashboard/orders/$id"
                params={{ id: activeOrder.id }}
                className="inline-flex items-center gap-1 text-xs font-semibold text-primary hover:underline"
              >
                Track order <ArrowRight className="h-3 w-3" />
              </Link>
            </div>
          ) : (
            <p className="mt-3 text-sm text-muted-foreground">No active deliveries right now.</p>
          )}
        </div>

        <div className="rounded-md border border-border bg-surface p-6">
          <div className="flex items-center justify-between">
            <h2 className="font-display text-base font-semibold text-primary">Primary address</h2>
            <MapPin className="h-4 w-4 text-secondary" />
          </div>
          {primary ? (
            <div className="mt-3 space-y-1 text-sm text-muted-foreground">
              <p className="font-semibold text-primary">{primary.label}</p>
              <p>{primary.recipient}</p>
              <p>{primary.street}</p>
              <p>
                {primary.city}, {primary.state}
                {primary.postalCode ? ` ${primary.postalCode}` : ""}
              </p>
              <p>{primary.phone}</p>
              <Link
                to="/dashboard/addresses"
                className="mt-2 inline-flex items-center gap-1 text-xs font-semibold text-primary hover:underline"
              >
                Manage addresses <ArrowRight className="h-3 w-3" />
              </Link>
            </div>
          ) : (
            <div className="mt-3">
              <p className="text-sm text-muted-foreground">No saved address yet.</p>
              <Link
                to="/dashboard/addresses"
                className="mt-3 inline-flex h-9 items-center rounded-sm bg-cta px-4 text-xs font-bold uppercase tracking-wide text-cta-foreground hover:bg-cta/90"
              >
                Add address
              </Link>
            </div>
          )}
        </div>
      </div>

      {/* Recent orders */}
      <section className="rounded-md border border-border bg-surface">
        <div className="flex items-center justify-between border-b border-border p-6">
          <div>
            <h2 className="font-display text-base font-semibold text-primary">Recent orders</h2>
            <p className="text-xs text-muted-foreground">Your latest procurement activity.</p>
          </div>
          <Link
            to="/dashboard/orders"
            className="text-xs font-semibold text-primary hover:underline"
          >
            View all
          </Link>
        </div>
        {recent.length === 0 ? (
          <div className="p-6 text-sm text-muted-foreground">
            No orders yet.{" "}
            <Link to="/shop" className="font-semibold text-primary hover:underline">
              Browse the shop
            </Link>
          </div>
        ) : (
          <ul className="divide-y divide-border">
            {recent.map((o) => (
              <li key={o.id} className="flex items-center justify-between gap-3 p-4">
                <div className="min-w-0">
                  <p className="font-mono text-sm text-primary">{o.id}</p>
                  <p className="truncate text-xs text-muted-foreground">
                    {o.items[0]?.name}
                    {o.itemCount > 1 && ` +${o.itemCount - 1} more`}
                  </p>
                </div>
                <div className="flex items-center gap-3">
                  <OrderStatusBadge status={o.status} />
                  <span className="hidden font-display text-sm font-semibold text-primary sm:inline">
                    {formatNaira(o.total)}
                  </span>
                  <Link
                    to="/dashboard/orders/$id"
                    params={{ id: o.id }}
                    className="text-xs font-semibold text-primary hover:underline"
                  >
                    View
                  </Link>
                </div>
              </li>
            ))}
          </ul>
        )}
      </section>

      {/* Recent notifications */}
      <section className="rounded-md border border-border bg-surface">
        <div className="flex items-center justify-between border-b border-border p-6">
          <div>
            <h2 className="font-display text-base font-semibold text-primary">
              Recent notifications
            </h2>
            <p className="text-xs text-muted-foreground">Account, order and system alerts.</p>
          </div>
          <Link
            to="/dashboard/notifications"
            className="text-xs font-semibold text-primary hover:underline"
          >
            View inbox
          </Link>
        </div>
        {recentAlerts.length === 0 ? (
          <div className="p-6 text-sm text-muted-foreground">You're all caught up.</div>
        ) : (
          <ul className="divide-y divide-border">
            {recentAlerts.map((n) => (
              <li key={n.id} className="flex items-start gap-3 p-4">
                <span
                  className={`mt-1 h-2 w-2 shrink-0 rounded-full ${n.read ? "bg-muted" : "bg-secondary"}`}
                />
                <div className="flex-1">
                  <p className="text-sm font-semibold text-primary">{n.title}</p>
                  {n.body && <p className="text-xs text-muted-foreground">{n.body}</p>}
                </div>
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}
