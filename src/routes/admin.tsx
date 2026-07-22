import { Outlet, createFileRoute, redirect, Link } from "@tanstack/react-router";
import { AdminSidebar, MobileAdminSidebar } from "@/components/layout/AdminSidebar";
import { Logo } from "@/components/brand/Logo";
import { AdminNotificationBell } from "@/components/common/AdminNotificationBell";
import { ActivityLogBell } from "@/components/common/ActivityLogBell";
import { useAuthStore } from "@/stores/auth";

export const Route = createFileRoute("/admin")({
  beforeLoad: () => {
    const { isAuthenticated, user } = useAuthStore.getState();
    if (!isAuthenticated) {
      throw redirect({ to: "/login" });
    }
    if (user?.role !== "admin" && user?.role !== "staff") {
      throw redirect({ to: "/dashboard" });
    }
  },
  component: AdminLayout,
});

import { useEffect } from "react";
import { fetchAdminNotifications } from "@/api/admin";

function AdminLayout() {
  const user = useAuthStore((s) => s.user);

  useEffect(() => {
    fetchAdminNotifications();
  }, []);

  return (
    <div className="flex min-h-screen bg-background">
      <AdminSidebar />
      <div className="flex min-h-screen flex-1 flex-col">
        <header className="sticky top-0 z-30 flex items-center justify-between border-b border-white/10 bg-[#0D1C32] px-4 py-3 md:px-8 text-white">
          <div className="flex items-center gap-3 md:hidden">
            <MobileAdminSidebar />
            <Logo size={28} showWordmark={true} light={true} />
            <span className="font-display text-xs font-bold bg-[#FEA619] text-[#0D1C32] px-1.5 py-0.5 rounded-sm">
              {user?.role === "staff" ? "STAFF" : "ADMIN"}
            </span>
          </div>
          <div className="hidden md:block">
            <p className="text-[9px] font-bold font-display uppercase tracking-widest text-white/50">
              OPERATIONAL COMMAND
            </p>
            <p className="font-display text-xs font-bold text-[#FEA619] uppercase tracking-wider mt-0.5">
              {user?.fullName ?? (user?.role === "staff" ? "Staff Member" : "Administrator")}
            </p>
          </div>
          <div className="flex items-center gap-4">
            {user?.role === "admin" && <ActivityLogBell />}
            <AdminNotificationBell />
            <Link
              to="/"
              className="hidden text-xs font-semibold text-white/70 hover:text-[#FEA619] md:inline transition-colors"
            >
              ← Back to site
            </Link>
          </div>
        </header>
        <main className="flex-1 p-4 md:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
