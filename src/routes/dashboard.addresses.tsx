import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { MapPin, Pencil, Trash2, Star, Plus } from "lucide-react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { EmptyState } from "@/components/common/EmptyState";
import { FieldLabel, TextInput, PrimaryButton } from "@/components/auth/AuthFormShell";
import { useAddressesStore, type UserAddress } from "@/stores/addresses";

export const Route = createFileRoute("/dashboard/addresses")({
  component: AddressesPage,
  head: () => ({ meta: [{ title: "Addresses — YAROTECH" }] }),
});

type FormState = Omit<UserAddress, "id" | "isPrimary"> & {
  id?: string;
  isPrimary: boolean;
};

const EMPTY: FormState = {
  label: "",
  recipient: "",
  phone: "",
  street: "",
  city: "",
  state: "",
  postalCode: "",
  isPrimary: false,
};

function AddressesPage() {
  const items = useAddressesStore((s) => s.items);
  const add = useAddressesStore((s) => s.add);
  const update = useAddressesStore((s) => s.update);
  const remove = useAddressesStore((s) => s.remove);
  const setPrimary = useAddressesStore((s) => s.setPrimary);

  const [open, setOpen] = useState(false);
  const [form, setForm] = useState<FormState>(EMPTY);
  const editing = Boolean(form.id);

  function set<K extends keyof FormState>(k: K, v: FormState[K]) {
    setForm((f) => ({ ...f, [k]: v }));
  }

  function openCreate() {
    setForm({ ...EMPTY, isPrimary: items.length === 0 });
    setOpen(true);
  }

  function openEdit(a: UserAddress) {
    setForm({ ...a });
    setOpen(true);
  }

  function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!form.recipient || !form.street || !form.city || !form.state) {
      toast.error("Please fill in all required fields.");
      return;
    }
    if (editing && form.id) {
      update(form.id, form);
      if (form.isPrimary) setPrimary(form.id);
      toast.success("Address updated");
    } else {
      add(form);
      toast.success("Address added");
    }
    setOpen(false);
    setForm(EMPTY);
  }

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Delivery"
        title="Saved addresses"
        description="Manage delivery and billing addresses for faster checkout."
        actions={
          <button
            onClick={openCreate}
            className="inline-flex h-10 items-center gap-2 rounded-sm bg-cta px-5 text-sm font-bold uppercase tracking-wide text-cta-foreground hover:bg-cta/90"
          >
            <Plus className="h-4 w-4" /> Add address
          </button>
        }
      />

      {items.length === 0 ? (
        <EmptyState
          icon={<MapPin className="h-5 w-5" />}
          title="No addresses saved"
          description="Add a delivery address to speed up checkout next time."
        />
      ) : (
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          {items.map((a) => (
            <article
              key={a.id}
              className={`relative rounded-md border bg-surface p-5 ${a.isPrimary ? "border-secondary/60" : "border-border"}`}
            >
              {a.isPrimary && (
                <span className="absolute right-4 top-4 inline-flex items-center gap-1 rounded-sm bg-secondary/15 px-2 py-1 text-[10px] font-semibold uppercase tracking-widest text-secondary">
                  <Star className="h-3 w-3" /> Primary
                </span>
              )}
              <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
                {a.label}
              </p>
              <p className="mt-1 font-display text-base font-semibold text-primary">
                {a.recipient}
              </p>
              <div className="mt-2 space-y-0.5 text-sm text-muted-foreground">
                <p>{a.street}</p>
                <p>
                  {a.city}, {a.state}
                  {a.postalCode ? ` ${a.postalCode}` : ""}
                </p>
                <p>{a.phone}</p>
              </div>
              <div className="mt-4 flex flex-wrap gap-2">
                {!a.isPrimary && (
                  <button
                    onClick={() => {
                      setPrimary(a.id);
                      toast.success("Primary address updated");
                    }}
                    className="inline-flex h-8 items-center gap-1 rounded-sm border border-border px-3 text-[11px] font-semibold uppercase tracking-widest text-primary hover:bg-accent"
                  >
                    <Star className="h-3 w-3" /> Set primary
                  </button>
                )}
                <button
                  onClick={() => openEdit(a)}
                  className="inline-flex h-8 items-center gap-1 rounded-sm border border-border px-3 text-[11px] font-semibold uppercase tracking-widest text-primary hover:bg-accent"
                >
                  <Pencil className="h-3 w-3" /> Edit
                </button>
                <button
                  onClick={() => {
                    remove(a.id);
                    toast.success("Address removed");
                  }}
                  className="inline-flex h-8 items-center gap-1 rounded-sm border border-destructive/40 px-3 text-[11px] font-semibold uppercase tracking-widest text-destructive hover:bg-destructive/10"
                >
                  <Trash2 className="h-3 w-3" /> Delete
                </button>
              </div>
            </article>
          ))}
        </div>
      )}

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-primary/40 p-4"
          onClick={() => setOpen(false)}
        >
          <div
            onClick={(e) => e.stopPropagation()}
            className="w-full max-w-lg rounded-md border border-border bg-surface p-6 shadow-2xl"
          >
            <h2 className="font-display text-lg font-semibold text-primary">
              {editing ? "Edit address" : "Add new address"}
            </h2>
            <form onSubmit={onSubmit} className="mt-4 grid grid-cols-1 gap-3 md:grid-cols-2">
              <div className="md:col-span-2">
                <FieldLabel>Label (e.g. Office, Home)</FieldLabel>
                <TextInput
                  required
                  value={form.label}
                  onChange={(e) => set("label", e.target.value)}
                  placeholder="Lagos warehouse"
                />
              </div>
              <div>
                <FieldLabel>Recipient name</FieldLabel>
                <TextInput
                  required
                  value={form.recipient}
                  onChange={(e) => set("recipient", e.target.value)}
                />
              </div>
              <div>
                <FieldLabel>Phone</FieldLabel>
                <TextInput
                  required
                  value={form.phone}
                  onChange={(e) => set("phone", e.target.value)}
                  placeholder="+234 800 000 0000"
                />
              </div>
              <div className="md:col-span-2">
                <FieldLabel>Street address</FieldLabel>
                <TextInput
                  required
                  value={form.street}
                  onChange={(e) => set("street", e.target.value)}
                />
              </div>
              <div>
                <FieldLabel>City</FieldLabel>
                <TextInput
                  required
                  value={form.city}
                  onChange={(e) => set("city", e.target.value)}
                />
              </div>
              <div>
                <FieldLabel>State</FieldLabel>
                <TextInput
                  required
                  value={form.state}
                  onChange={(e) => set("state", e.target.value)}
                />
              </div>
              <div>
                <FieldLabel>Postal code</FieldLabel>
                <TextInput
                  value={form.postalCode ?? ""}
                  onChange={(e) => set("postalCode", e.target.value)}
                />
              </div>
              <label className="md:col-span-2 flex cursor-pointer items-center gap-2 text-xs text-muted-foreground">
                <input
                  type="checkbox"
                  checked={form.isPrimary}
                  onChange={(e) => set("isPrimary", e.target.checked)}
                  className="h-4 w-4 accent-secondary"
                />
                Set as primary delivery address
              </label>
              <div className="md:col-span-2 mt-2 flex gap-2">
                <button
                  type="button"
                  onClick={() => setOpen(false)}
                  className="h-10 flex-1 rounded-sm border border-border text-xs font-semibold uppercase tracking-wide text-primary hover:bg-accent"
                >
                  Cancel
                </button>
                <div className="flex-1">
                  <PrimaryButton type="submit">
                    {editing ? "Save changes" : "Add address"}
                  </PrimaryButton>
                </div>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
