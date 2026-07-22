import { create } from "zustand";
import { persist } from "zustand/middleware";

export type UserRole = "user" | "admin" | "staff";
export type AccountType = "individual" | "company" | null;

export interface AuthUser {
  id: string;
  fullName: string;
  email: string;
  phone?: string;
  company?: string;
  accountType?: AccountType;
  role: UserRole;
  emailVerified: boolean;
}

interface AuthState {
  user: AuthUser | null;
  token: string | null;
  isAuthenticated: boolean;
  setSession: (user: AuthUser, token: string) => void;
  setUser: (user: AuthUser) => void;
  patchUser: (patch: Partial<AuthUser>) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      isAuthenticated: false,
      setSession: (user, token) => set({ user, token, isAuthenticated: true }),
      setUser: (user) => set({ user }),
      patchUser: (patch) => {
        const u = get().user;
        if (u) set({ user: { ...u, ...patch } });
      },
      logout: () => set({ user: null, token: null, isAuthenticated: false }),
    }),
    { name: "yarotech-auth" },
  ),
);
