import { create } from "zustand";
import { persist } from "zustand/middleware";

export type AdminNotificationKind = "order" | "payment" | "system" | "support";

export interface AdminNotification {
  id: string;
  kind: AdminNotificationKind;
  title: string;
  body: string;
  createdAt: number;
  read: boolean;
  href?: string;
}

interface AdminNotificationState {
  items: AdminNotification[];
  push: (n: Omit<AdminNotification, "id" | "createdAt" | "read">) => void;
  markRead: (id: string) => void;
  markAllRead: () => void;
  hydrate: (items: AdminNotification[]) => void;
  unreadCount: () => number;
}

const HOUR = 60 * 60 * 1000;
const seed: AdminNotification[] = [
  {
    id: "an1",
    kind: "order",
    title: "New paid order ORD-9088",
    body: "Adaeze Okafor paid ₦2,110,500 — needs fulfillment.",
    createdAt: Date.now() - 2 * HOUR,
    read: false,
    href: "/admin/orders-users",
  },
  {
    id: "an2",
    kind: "payment",
    title: "Payment failed for ORD-9078",
    body: "Card declined — Femi Adeyemi.",
    createdAt: Date.now() - 4 * HOUR,
    read: false,
    href: "/admin/payments",
  },
  {
    id: "an3",
    kind: "system",
    title: "Inventory movement correction",
    body: "Manual stock correction logged for one product.",
    createdAt: Date.now() - 4 * HOUR,
    read: false,
    href: "/admin/products",
  },
  {
    id: "an4",
    kind: "system",
    title: "Low stock: TP-Link Archer AX73",
    body: "0 units remaining.",
    createdAt: Date.now() - 6 * HOUR,
    read: false,
    href: "/admin/products",
  },
  {
    id: "an5",
    kind: "support",
    title: "New contact message",
    body: "Olamide Bakare — compatibility check on 5KW inverter.",
    createdAt: Date.now() - 30 * 60 * 1000,
    read: false,
    href: "/admin/support",
  },
  {
    id: "an6",
    kind: "system",
    title: "New user registration",
    body: "Femi Adeyemi created an account (verification pending).",
    createdAt: Date.now() - 12 * HOUR,
    read: true,
    href: "/admin/orders-users",
  },
];

export const useAdminNotificationStore = create<AdminNotificationState>()(
  persist(
    (set, get) => ({
      items: seed,
      push: (n) =>
        set((s) => ({
          items: [
            {
              ...n,
              id: "an_" + Math.random().toString(36).slice(2, 9),
              createdAt: Date.now(),
              read: false,
            },
            ...s.items,
          ].slice(0, 100),
        })),
      markRead: (id) =>
        set((s) => ({ items: s.items.map((i) => (i.id === id ? { ...i, read: true } : i)) })),
      markAllRead: () => set((s) => ({ items: s.items.map((i) => ({ ...i, read: true })) })),
      hydrate: (items) => set({ items }),
      unreadCount: () => get().items.filter((i) => !i.read).length,
    }),
    { name: "yarotech-admin-notifications" },
  ),
);
