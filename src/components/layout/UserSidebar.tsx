import { Link, useRouterState } from "@tanstack/react-router";
import {
  LayoutDashboard,
  Package,
  MapPin,
  User,
  Settings,
  Bell,
  LogOut,
  LifeBuoy,
} from "lucide-react";
import { Logo } from "@/components/brand/Logo";
import { useAuthStore } from "@/stores/auth";
import { toast } from "sonner";

const NAV = [
  { to: "/dashboard", label: "Dashboard", icon: LayoutDashboard, exact: true },
  { to: "/dashboard/orders", label: "Orders", icon: Package },
  { to: "/dashboard/addresses", label: "Addresses", icon: MapPin },
  { to: "/dashboard/profile", label: "Profile", icon: User },
  { to: "/dashboard/account", label: "Account", icon: Settings },
  { to: "/dashboard/notifications", label: "Notifications", icon: Bell },
  { to: "/dashboard/support", label: "Support", icon: LifeBuoy },
];

export function UserSidebar() {
  const path = useRouterState({ select: (s) => s.location.pathname });
  const logout = useAuthStore((s) => s.logout);

  return (
    <aside className="hidden w-60 shrink-0 border-r border-border bg-surface md:flex md:flex-col">
      <div className="border-b border-border p-4">
        <Logo />
        <p className="mt-2 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
          User Panel
        </p>
      </div>
      <nav className="flex-1 px-2 py-4">
        {NAV.map((n) => {
          const active = n.exact ? path === n.to : path.startsWith(n.to);
          const Icon = n.icon;
          return (
            <Link
              key={n.to}
              to={n.to}
              className={`mb-1 flex items-center gap-3 rounded-sm px-3 py-2 text-sm font-semibold transition-colors ${
                active
                  ? "bg-primary text-primary-foreground"
                  : "text-muted-foreground hover:bg-accent hover:text-primary"
              }`}
            >
              <Icon className="h-4 w-4" />
              {n.label}
            </Link>
          );
        })}
      </nav>
      <button
        type="button"
        onClick={() => {
          logout();
          toast.success("Logged out");
        }}
        className="m-3 flex items-center gap-2 rounded-sm border border-border px-3 py-2 text-sm font-semibold text-muted-foreground hover:bg-accent hover:text-primary"
      >
        <LogOut className="h-4 w-4" /> Log out
      </button>
    </aside>
  );
}
