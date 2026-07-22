import { useState, useEffect } from "react";
import { Link, useRouterState } from "@tanstack/react-router";
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet";
import { Menu } from "lucide-react";
import {
  LayoutDashboard,
  ShoppingCart,
  Package,
  HandCoins,
  CreditCard,
  BarChart3,
  LifeBuoy,
  Settings,
  Bell,
  LogOut,
  User,
  Eye,
  MessageSquare,
  Users,
  ArrowUpDown,
} from "lucide-react";
import { Logo } from "@/components/brand/Logo";
import { useAuthStore } from "@/stores/auth";
import { toast } from "sonner";

const getNavItems = (role: string) => {
  const items = [
    { to: "/admin", label: "Dashboard", icon: LayoutDashboard, exact: true },
    { to: "/admin/orders-users", label: "Orders & Users", icon: ShoppingCart },
    { to: "/admin/pos-sales", label: "POS Sales", icon: HandCoins },
    { to: "/admin/customers", label: "Customers", icon: Users },
    { to: "/admin/products", label: "Products", icon: Package },
    { to: "/admin/stock-movements", label: "Stock Movements", icon: ArrowUpDown },
    { to: "/admin/reviews", label: "Reviews", icon: MessageSquare },
    { to: "/admin/payments", label: "Payments", icon: CreditCard },
    { to: "/admin/support", label: "Support", icon: LifeBuoy },
    { to: "/admin/notifications", label: "Notifications", icon: Bell },
  ];

  if (role === "admin") {
    items.push({ to: "/admin/reports", label: "Reports", icon: BarChart3 });
    items.push({ to: "/admin/activity-log", label: "Activity Logs", icon: Eye });
    items.push({ to: "/admin/settings", label: "Settings", icon: Settings });
  }

  return items;
};

export function SidebarContent() {
  const path = useRouterState({ select: (s) => s.location.pathname });
  const logout = useAuthStore((s) => s.logout);
  const user = useAuthStore((s) => s.user);

  return (
    <>
      {/* Brand Header */}
      <div className="px-5 py-5 border-b border-white/5 bg-[#0A1C31]">
        <div className="flex items-center gap-3">
          <Logo showWordmark={true} light={true} size={36} />
        </div>
        <p className="mt-2.5 text-[10px] font-bold font-display uppercase tracking-widest text-[#FEA619] opacity-80">
          Operational Command Panel
        </p>
      </div>

      {/* Navigation Scroll */}
      <div className="flex-1 overflow-y-auto px-3 py-4">
        {/* Section label */}
        <p className="mb-2 px-2 text-[10px] font-bold uppercase tracking-widest text-white/30">
          Navigation
        </p>
        <div className="space-y-1">
          {getNavItems(user?.role || "user").map((n) => {
            const active = n.exact ? path === n.to : path.startsWith(n.to);
            const Icon = n.icon;
            return (
              <Link
                key={n.to}
                to={n.to}
                className={`flex items-center gap-3 rounded-md px-3 py-3 text-sm font-semibold transition-all duration-200 ${
                  active
                    ? "bg-[#FEA619] text-[#0D1C32] font-bold shadow-md"
                    : "text-white/75 hover:bg-white/8 hover:text-white"
                }`}
              >
                <Icon
                  className={`h-[18px] w-[18px] shrink-0 ${
                    active ? "text-[#0D1C32]" : "text-[#FEA619]"
                  }`}
                />
                <span className="font-display tracking-wide">{n.label}</span>
              </Link>
            );
          })}
        </div>
      </div>

      {/* Staff Profile and Logout Footer */}
      <div className="px-4 py-4 border-t border-white/5 bg-[#0A1C31] flex flex-col gap-3">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-[#0D1C32] rounded-md flex items-center justify-center border border-white/10 shrink-0">
            <User className="h-5 w-5 text-[#FEA619]" />
          </div>
          <div className="min-w-0">
            <p className="text-sm font-bold text-white truncate">
              {user?.fullName ?? "Admin Staff"}
            </p>
            <p className="text-xs text-white/50 font-display truncate">
              ID: YT-{user?.id ?? "8829"}
            </p>
          </div>
        </div>
        <button
          type="button"
          onClick={() => {
            logout();
            toast.success("Logged out");
          }}
          className="w-full flex items-center justify-center gap-2 rounded-md border border-white/10 bg-[#0D1C32] hover:bg-white/8 px-3 py-2.5 text-xs font-bold font-display uppercase tracking-wider text-white/70 hover:text-white transition-colors"
        >
          <LogOut className="h-4 w-4 text-[#FEA619]" />
          Log out
        </button>
      </div>
    </>
  );
}

export function AdminSidebar() {
  return (
    <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col bg-[#0D1C32] text-white md:flex border-r border-white/5">
      <SidebarContent />
    </aside>
  );
}

export function MobileAdminSidebar() {
  const [open, setOpen] = useState(false);
  const path = useRouterState({ select: (s) => s.location.pathname });

  // Close the sheet when path changes
  useEffect(() => {
    setOpen(false);
  }, [path]);

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger asChild>
        <button className="text-white hover:text-[#FEA619] transition-colors md:hidden focus:outline-none">
          <Menu className="h-6 w-6" />
        </button>
      </SheetTrigger>
      <SheetContent side="left" className="w-64 p-0 bg-[#0D1C32] border-r-white/5 text-white flex flex-col [&>button]:text-white">
        <SidebarContent />
      </SheetContent>
    </Sheet>
  );
}

