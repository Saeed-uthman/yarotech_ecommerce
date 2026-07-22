import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { FieldLabel, TextInput, PrimaryButton } from "@/components/auth/AuthFormShell";
import { useAuthStore } from "@/stores/auth";

export const Route = createFileRoute("/dashboard/account")({
  component: AccountPage,
  head: () => ({ meta: [{ title: "Account — YAROTECH" }] }),
});

const PREF_KEYS = [
  { key: "orderUpdates", label: "Order updates", hint: "Status, shipping and delivery alerts." },
  { key: "promos", label: "Product news", hint: "New arrivals and important announcements." },
  {
    key: "security",
    label: "Security alerts",
    hint: "Sign-ins, password changes and account safety.",
  },
] as const;

function AccountPage() {
  const navigate = useNavigate();
  const logout = useAuthStore((s) => s.logout);
  const [prefs, setPrefs] = useState<Record<(typeof PREF_KEYS)[number]["key"], boolean>>({
    orderUpdates: true,
    promos: false,
    security: true,
  });

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Security"
        title="Account settings"
        description="Manage your password, notifications and session."
      />

      <form
        onSubmit={(e) => {
          e.preventDefault();
          toast.success("Password updated");
        }}
        className="max-w-xl space-y-4 rounded-md border border-border bg-surface p-6"
      >
        <h2 className="font-display text-lg font-semibold text-primary">Change password</h2>
        <div>
          <FieldLabel>Current password</FieldLabel>
          <TextInput type="password" autoComplete="current-password" />
        </div>
        <div>
          <FieldLabel>New password</FieldLabel>
          <TextInput type="password" autoComplete="new-password" />
        </div>
        <div>
          <FieldLabel>Confirm new password</FieldLabel>
          <TextInput type="password" autoComplete="new-password" />
        </div>
        <PrimaryButton type="submit">Update password</PrimaryButton>
      </form>

      <section className="max-w-xl rounded-md border border-border bg-surface p-6">
        <h2 className="font-display text-lg font-semibold text-primary">
          Notification preferences
        </h2>
        <p className="text-sm text-muted-foreground">
          Choose which emails you'd like to receive from YAROTECH.
        </p>
        <ul className="mt-4 divide-y divide-border">
          {PREF_KEYS.map((p) => (
            <li key={p.key} className="flex items-start justify-between gap-4 py-3">
              <div>
                <p className="text-sm font-semibold text-primary">{p.label}</p>
                <p className="text-xs text-muted-foreground">{p.hint}</p>
              </div>
              <label className="relative inline-flex cursor-pointer items-center">
                <input
                  type="checkbox"
                  className="peer sr-only"
                  checked={prefs[p.key]}
                  onChange={(e) => {
                    setPrefs((s) => ({ ...s, [p.key]: e.target.checked }));
                    toast.success(`${p.label} ${e.target.checked ? "enabled" : "disabled"}`);
                  }}
                />
                <span className="h-5 w-9 rounded-full bg-muted transition peer-checked:bg-secondary"></span>
                <span className="absolute left-0.5 top-0.5 h-4 w-4 rounded-full bg-white transition peer-checked:translate-x-4"></span>
              </label>
            </li>
          ))}
        </ul>
      </section>

      <div className="max-w-xl rounded-md border border-destructive/40 bg-destructive/5 p-6">
        <h2 className="font-display text-lg font-semibold text-destructive">Sign out</h2>
        <p className="mt-1 text-sm text-muted-foreground">
          Sign out of this device. Your data remains safe.
        </p>
        <button
          onClick={() => {
            logout();
            toast.success("Signed out successfully");
            navigate({ to: "/" });
          }}
          className="mt-4 h-10 rounded-sm border border-destructive px-5 text-sm font-bold uppercase tracking-wide text-destructive hover:bg-destructive hover:text-destructive-foreground"
        >
          Sign out
        </button>
      </div>
    </div>
  );
}
