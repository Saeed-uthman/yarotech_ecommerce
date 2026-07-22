import { Link, useRouterState } from "@tanstack/react-router";
import { Home, Store, ShoppingCart, User } from "lucide-react";
import { useCartStore, cartTotals } from "@/stores/cart";
import { useAuthStore } from "@/stores/auth";

export function MobileBottomNav() {
  const items = useCartStore((s) => s.items);
  const { count } = cartTotals(items);
  const isAuth = useAuthStore((s) => s.isAuthenticated);
  const path = useRouterState({ select: (s) => s.location.pathname });

  const tabs = [
    { to: "/", label: "Home", icon: Home, exact: true },
    { to: "/shop", label: "Shop", icon: Store },
    {
      to: "/cart",
      label: "Cart",
      icon: ShoppingCart,
      badge: count > 0 ? count : undefined,
    },
    {
      to: isAuth
        ? useAuthStore.getState().user?.role === "admin" ||
          useAuthStore.getState().user?.role === "staff"
          ? "/admin"
          : "/dashboard"
        : "/login",
      label: isAuth ? "Profile" : "Login",
      icon: User,
    },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-40 border-t border-border bg-surface md:hidden">
      <ul className="grid grid-cols-4">
        {tabs.map((t) => {
          const active = t.exact ? path === t.to : path.startsWith(t.to);
          const Icon = t.icon;
          return (
            <li key={t.to}>
              <Link
                to={t.to}
                className={`relative flex flex-col items-center justify-center gap-0.5 py-2 text-[10px] font-semibold uppercase tracking-wider ${
                  active ? "text-primary" : "text-muted-foreground"
                }`}
              >
                <Icon className="h-5 w-5" />
                {t.label}
                {t.badge && (
                  <span className="absolute right-[28%] top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-secondary px-1 text-[10px] text-secondary-foreground">
                    {t.badge}
                  </span>
                )}
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
