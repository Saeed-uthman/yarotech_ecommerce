import { create } from "zustand";
import { persist } from "zustand/middleware";

export type NotificationKind = "order" | "payment" | "system" | "support";

export interface AppNotification {
  id: string;
  kind: NotificationKind;
  title: string;
  body: string;
  createdAt: number;
  read: boolean;
  href?: string;
}

interface NotificationState {
  items: AppNotification[];
  push: (n: Omit<AppNotification, "id" | "createdAt" | "read">) => void;
  markRead: (id: string) => void;
  markAllRead: () => void;
  clear: () => void;
  hydrate: (items: AppNotification[]) => void;
}

export const useNotificationStore = create<NotificationState>()(
  persist(
    (set) => ({
      items: [
        {
          id: "n1",
          kind: "system",
          title: "Welcome to YAROTECH",
          body: "Browse our verified equipment catalog and start procuring.",
          createdAt: Date.now() - 1000 * 60 * 60 * 2,
          read: false,
          href: "/shop",
        },
      ],
      push: (n) =>
        set((s) => ({
          items: [
            {
              ...n,
              id: "n_" + Math.random().toString(36).slice(2, 9),
              createdAt: Date.now(),
              read: false,
            },
            ...s.items,
          ].slice(0, 50),
        })),
      markRead: (id) =>
        set((s) => ({
          items: s.items.map((i) => (i.id === id ? { ...i, read: true } : i)),
        })),
      markAllRead: () => set((s) => ({ items: s.items.map((i) => ({ ...i, read: true })) })),
      clear: () => set({ items: [] }),
      hydrate: (items) => set({ items }),
    }),
    { name: "yarotech-notifications" },
  ),
);
