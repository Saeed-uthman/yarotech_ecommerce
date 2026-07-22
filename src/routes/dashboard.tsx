import { Outlet, createFileRoute, redirect, Link, useRouterState } from "@tanstack/react-router";
import { Menu, Home, Package, MapPin, User, Settings, Bell, LifeBuoy } from "lucide-react";
import { useState, useEffect } from "react";
import { UserSidebar } from "@/components/layout/UserSidebar";
import { Logo } from "@/components/brand/Logo";
import { NotificationBell } from "@/components/common/NotificationBell";
import { useAuthStore } from "@/stores/auth";
import { fetchMyNotifications } from "@/api/notifications";

export const Route = createFileRoute("/dashboard")({
  beforeLoad: ({ location }) => {
    const { isAuthenticated, user } = useAuthStore.getState();
    if (!isAuthenticated) {
      throw redirect({
        to: "/login",
        search: { redirect: location.href },
      });
    }
    if (user?.role === "admin" || user?.role === "staff") {
      throw redirect({ to: "/admin" });
    }
  },
  component: DashboardLayout,
});

const MOBILE_NAV = [
  { to: "/dashboard", label: "Overview", icon: Home, exact: true },
  { to: "/dashboard/orders", label: "Orders", icon: Package },
  { to: "/dashboard/addresses", label: "Addresses", icon: MapPin },
  { to: "/dashboard/profile", label: "Profile", icon: User },
  { to: "/dashboard/account", label: "Account", icon: Settings },
  { to: "/dashboard/notifications", label: "Notifications", icon: Bell },
  { to: "/dashboard/support", label: "Support", icon: LifeBuoy },
];

function DashboardLayout() {
  const user = useAuthStore((s) => s.user);
  const [open, setOpen] = useState(false);
  const path = useRouterState({ select: (s) => s.location.pathname });

  useEffect(() => {
    fetchMyNotifications();
  }, []);

  return (
    <div className="flex min-h-screen bg-background">
      <UserSidebar />
      <div className="flex min-h-screen flex-1 flex-col">
        <header className="sticky top-0 z-30 flex items-center justify-between border-b border-border bg-surface px-4 py-3 md:px-8">
          <div className="flex items-center gap-3 md:hidden">
            <button
              onClick={() => setOpen((o) => !o)}
              className="rounded-sm border border-border p-2 text-primary"
              aria-label="Toggle menu"
            >
              <Menu className="h-4 w-4" />
            </button>
            <Logo showWordmark={false} />
          </div>
          <div className="hidden md:block">
            <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
              User Panel
            </p>
            <p className="font-display text-sm font-semibold text-primary">
              Welcome, {user?.fullName ?? "Engineer"}
            </p>
          </div>
          <div className="flex items-center gap-3">
            <NotificationBell />
            <Link
              to="/"
              className="hidden text-xs font-semibold text-muted-foreground hover:text-primary md:inline"
            >
              ← Back to site
            </Link>
          </div>
        </header>

        {/* Mobile drawer */}
        {open && (
          <div className="border-b border-border bg-surface md:hidden">
            <nav className="flex flex-col p-2">
              {MOBILE_NAV.map((n) => {
                const active = n.exact ? path === n.to : path.startsWith(n.to);
                const Icon = n.icon;
                return (
                  <Link
                    key={n.to}
                    to={n.to}
                    onClick={() => setOpen(false)}
                    className={`flex items-center gap-3 rounded-sm px-3 py-2 text-sm font-semibold ${
                      active ? "bg-primary text-primary-foreground" : "text-muted-foreground"
                    }`}
                  >
                    <Icon className="h-4 w-4" />
                    {n.label}
                  </Link>
                );
              })}
            </nav>
          </div>
        )}

        <main className="flex-1 p-4 md:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
