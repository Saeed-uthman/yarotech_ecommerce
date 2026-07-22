import { Link, useRouterState } from "@tanstack/react-router";
import { ShoppingCart, Menu, X, User } from "lucide-react";
import { useState } from "react";
import { Logo } from "@/components/brand/Logo";
import { useCartStore, cartTotals } from "@/stores/cart";
import { useAuthStore } from "@/stores/auth";
import { NotificationBell } from "@/components/common/NotificationBell";

const NAV = [
  { to: "/", label: "Home" },
  { to: "/shop", label: "Shop" },
  { to: "/services", label: "Services" },
  { to: "/projects", label: "Projects" },
  { to: "/about", label: "About" },
  { to: "/contact", label: "Contact" },
];

export function PublicHeader() {
  const items = useCartStore((s) => s.items);
  const { count } = cartTotals(items);
  const isAuth = useAuthStore((s) => s.isAuthenticated);
  const [open, setOpen] = useState(false);
  const path = useRouterState({ select: (s) => s.location.pathname });

  return (
    <header className="sticky top-0 z-40 border-b border-border bg-surface/95 backdrop-blur">
      <div className="mx-auto flex h-14 max-w-7xl items-center justify-between gap-4 px-4">
        <Logo />
        <nav className="hidden items-center gap-6 md:flex">
          {NAV.map((n) => {
            const active = n.to === "/" ? path === "/" : path.startsWith(n.to);
            return (
              <Link
                key={n.to}
                to={n.to}
                className={`text-sm font-semibold transition-colors ${
                  active ? "text-primary" : "text-muted-foreground hover:text-primary"
                }`}
              >
                {n.label}
              </Link>
            );
          })}
        </nav>
        <div className="flex items-center gap-2">
          {isAuth && <NotificationBell />}
          <Link
            to="/contact"
            search={{ service: "Project Advisory" }}
            className="hidden h-9 items-center rounded-sm border border-secondary/50 bg-secondary/10 px-3 text-xs font-bold uppercase tracking-wide text-primary transition-colors hover:bg-secondary/20 lg:inline-flex"
          >
            Get Quote
          </Link>
          <Link
            to="/cart"
            className="relative flex h-9 w-9 items-center justify-center rounded-sm border border-border bg-surface text-primary hover:bg-accent"
            aria-label="Cart"
          >
            <ShoppingCart className="h-4 w-4" />
            {count > 0 && (
              <span className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-secondary px-1 text-[10px] font-bold text-secondary-foreground">
                {count}
              </span>
            )}
          </Link>
          {isAuth ? (
            <Link
              to={
                useAuthStore.getState().user?.role === "admin" ||
                useAuthStore.getState().user?.role === "staff"
                  ? "/admin"
                  : "/dashboard"
              }
              className="hidden h-9 items-center gap-1.5 rounded-sm border border-border bg-surface px-3 text-sm font-semibold text-primary hover:bg-accent md:inline-flex"
            >
              <User className="h-4 w-4" />{" "}
              {useAuthStore.getState().user?.role === "admin" ||
              useAuthStore.getState().user?.role === "staff"
                ? "Admin Panel"
                : "Dashboard"}
            </Link>
          ) : (
            <Link
              to="/login"
              className="hidden h-9 items-center rounded-sm bg-primary px-4 text-sm font-semibold text-primary-foreground hover:bg-primary/90 md:inline-flex"
            >
              Login
            </Link>
          )}
          <button
            type="button"
            onClick={() => setOpen((v) => !v)}
            className="flex h-9 w-9 items-center justify-center rounded-sm border border-border md:hidden"
            aria-label="Menu"
          >
            {open ? <X className="h-4 w-4" /> : <Menu className="h-4 w-4" />}
          </button>
        </div>
      </div>
      {open && (
        <nav className="border-t border-border bg-surface md:hidden">
          <div className="flex flex-col px-4 py-2">
            {NAV.map((n) => (
              <Link
                key={n.to}
                to={n.to}
                onClick={() => setOpen(false)}
                className="border-b border-border py-3 text-sm font-semibold text-primary"
              >
                {n.label}
              </Link>
            ))}
            {!isAuth && (
              <Link
                to="/login"
                onClick={() => setOpen(false)}
                className="mt-3 inline-flex h-10 items-center justify-center rounded-sm bg-primary text-sm font-semibold text-primary-foreground"
              >
                Login
              </Link>
            )}
          </div>
        </nav>
      )}
    </header>
  );
}
