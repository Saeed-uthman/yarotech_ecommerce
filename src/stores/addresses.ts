import { create } from "zustand";
import { persist } from "zustand/middleware";

export interface UserAddress {
  id: string;
  label: string;
  recipient: string;
  phone: string;
  street: string;
  city: string;
  state: string;
  postalCode?: string;
  isPrimary: boolean;
}

interface AddressesState {
  items: UserAddress[];
  add: (address: Omit<UserAddress, "id" | "isPrimary"> & { isPrimary?: boolean }) => UserAddress;
  update: (id: string, patch: Partial<Omit<UserAddress, "id">>) => void;
  remove: (id: string) => void;
  setPrimary: (id: string) => void;
}

const SEED: UserAddress[] = [
  {
    id: "addr_default",
    label: "Kano office",
    recipient: "Engr. Umar",
    phone: "+2347031117567",
    street: "12 lokoro plaza A second floor",
    city: "Kano",
    state: "Kano",
    postalCode: "700242",
    isPrimary: true,
  },
];

export const useAddressesStore = create<AddressesState>()(
  persist(
    (set, get) => ({
      items: SEED,
      add: (input) => {
        const id = "addr_" + Math.random().toString(36).slice(2, 8);
        const isPrimary = input.isPrimary || get().items.length === 0;
        const next: UserAddress = {
          ...input,
          id,
          isPrimary,
        };
        set((s) => ({
          items: isPrimary
            ? [...s.items.map((a) => ({ ...a, isPrimary: false })), next]
            : [...s.items, next],
        }));
        return next;
      },
      update: (id, patch) =>
        set((s) => ({
          items: s.items.map((a) => (a.id === id ? { ...a, ...patch } : a)),
        })),
      remove: (id) =>
        set((s) => {
          const wasPrimary = s.items.find((a) => a.id === id)?.isPrimary;
          const remaining = s.items.filter((a) => a.id !== id);
          if (wasPrimary && remaining.length) remaining[0].isPrimary = true;
          return { items: remaining };
        }),
      setPrimary: (id) =>
        set((s) => ({
          items: s.items.map((a) => ({ ...a, isPrimary: a.id === id })),
        })),
    }),
    { name: "yarotech-addresses" },
  ),
);
