import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { useAuthStore, type AccountType } from "@/stores/auth";
import { FieldLabel, TextInput, PrimaryButton } from "@/components/auth/AuthFormShell";
import { updateProfile } from "@/api/auth";

export const Route = createFileRoute("/dashboard/profile")({
  component: ProfilePage,
  head: () => ({ meta: [{ title: "Profile — YAROTECH" }] }),
});

function ProfilePage() {
  const user = useAuthStore((s) => s.user);
  const patchUser = useAuthStore((s) => s.patchUser);
  const [form, setForm] = useState({
    fullName: user?.fullName ?? "",
    phone: user?.phone ?? "",
    company: user?.company ?? "",
    accountType: (user?.accountType ?? "individual") as Exclude<AccountType, null>,
  });
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    try {
      await updateProfile(form);
      patchUser({
        fullName: form.fullName,
        phone: form.phone,
        company: form.company,
        accountType: form.accountType,
      });
      toast.success("Profile saved");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Could not save profile");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Account"
        title="Profile"
        description="Update your personal information and choose your account type."
      />
      <form
        onSubmit={onSubmit}
        className="grid max-w-2xl grid-cols-1 gap-4 rounded-md border border-border bg-surface p-6 md:grid-cols-2"
      >
        <div>
          <FieldLabel>Full name</FieldLabel>
          <TextInput
            value={form.fullName}
            onChange={(e) => setForm((f) => ({ ...f, fullName: e.target.value }))}
          />
        </div>
        <div>
          <FieldLabel>Email</FieldLabel>
          <TextInput type="email" defaultValue={user?.email ?? ""} disabled />
        </div>
        <div>
          <FieldLabel>Phone number</FieldLabel>
          <TextInput
            type="tel"
            value={form.phone}
            onChange={(e) => setForm((f) => ({ ...f, phone: e.target.value }))}
          />
        </div>
        <div>
          <FieldLabel>Company (optional)</FieldLabel>
          <TextInput
            value={form.company}
            onChange={(e) => setForm((f) => ({ ...f, company: e.target.value }))}
          />
        </div>
        <fieldset className="md:col-span-2">
          <FieldLabel>Account type</FieldLabel>
          <div className="mt-1 grid grid-cols-2 gap-2">
            {(["individual", "company"] as const).map((t) => (
              <label
                key={t}
                className={`flex cursor-pointer items-center gap-2 rounded-sm border px-3 py-3 text-sm font-semibold capitalize ${form.accountType === t ? "border-secondary bg-secondary/10 text-primary" : "border-border text-muted-foreground hover:border-primary"}`}
              >
                <input
                  type="radio"
                  name="accountType"
                  value={t}
                  checked={form.accountType === t}
                  onChange={() => setForm((f) => ({ ...f, accountType: t }))}
                  className="accent-secondary"
                />
                {t}
              </label>
            ))}
          </div>
        </fieldset>
        <div className="md:col-span-2">
          <PrimaryButton type="submit" loading={loading}>
            Save changes
          </PrimaryButton>
        </div>
      </form>
    </div>
  );
}
