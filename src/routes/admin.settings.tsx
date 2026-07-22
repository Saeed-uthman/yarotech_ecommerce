import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { StatusBadge } from "@/components/common/StatusBadge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  fetchSettings,
  updateDeliveryRate,
  createDeliveryRate,
  updateBusinessSettings,
  fetchEmailLogs,
  type AdminSettings,
  type DeliveryZone,
} from "@/api/admin";
import { NGN } from "@/lib/format";
import { formatDistanceToNow } from "date-fns";
import {
  Store,
  CreditCard,
  Package,
  Receipt,
  Percent,
  Users,
  Truck,
  Bell,
  Mail,
  Building2,
  Phone,
  MapPin,
  Globe,
  Save,
  CheckCircle2,
} from "lucide-react";

export const Route = createFileRoute("/admin/settings")({
  component: SettingsAdmin,
  head: () => ({ meta: [{ title: "Settings - Admin" }] }),
});

const TABS = [
  { id: "general", label: "General", icon: Store },
  { id: "pos", label: "POS Sales", icon: Receipt },
  { id: "payments", label: "Payments", icon: CreditCard },
  { id: "inventory", label: "Inventory", icon: Package },
  { id: "receipt", label: "Receipt", icon: Receipt },
  { id: "tax", label: "Tax / VAT", icon: Percent },
  { id: "staff", label: "Staff Permissions", icon: Users },
  { id: "delivery", label: "Delivery Zones", icon: Truck },
  { id: "notifications", label: "Notifications", icon: Bell },
  { id: "email", label: "Email Log", icon: Mail },
] as const;

type TabId = (typeof TABS)[number]["id"];

function SettingsAdmin() {
  const [data, setData] = useState<{
    settings: AdminSettings;
    deliveryZones: DeliveryZone[];
  } | null>(null);
  const [emailLogs, setEmailLogs] = useState<Awaited<ReturnType<typeof fetchEmailLogs>> | null>(
    null,
  );
  const [activeTab, setActiveTab] = useState<TabId>("general");

  const [newZone, setNewZone] = useState({
    state: "",
    city: "*",
    baseFee: 0,
    perKgFee: 0,
    etaDays: "3",
    enabled: true,
  });
  const [addingZone, setAddingZone] = useState(false);

  useEffect(() => {
    fetchSettings().then(setData);
    fetchEmailLogs().then(setEmailLogs);
  }, []);

  if (!data) return <Skeleton className="h-96" />;
  const { settings, deliveryZones } = data;

  const patchSettings = async (
    patch: Partial<
      AdminSettings["posSales"] &
        AdminSettings["paymentMethods"] &
        AdminSettings["inventory"] &
        AdminSettings["receipt"] &
        AdminSettings["tax"] &
        AdminSettings["staffPermissions"] &
        AdminSettings["preferences"] &
        AdminSettings["general"]
    >,
  ) => {
    setData((prev) => {
      if (!prev) return prev;
      return {
        ...prev,
        settings: {
          ...prev.settings,
          posSales: { ...prev.settings.posSales, ...patch },
          paymentMethods: { ...prev.settings.paymentMethods, ...patch },
          inventory: { ...prev.settings.inventory, ...patch },
          receipt: { ...prev.settings.receipt, ...patch },
          tax: { ...prev.settings.tax, ...patch },
          staffPermissions: { ...prev.settings.staffPermissions, ...patch },
          preferences: { ...prev.settings.preferences, ...patch },
        },
      };
    });
    await updateBusinessSettings(patch);
  };

  const updateZone = async (id: string, patch: Partial<DeliveryZone>) => {
    setData(
      (d) =>
        d && {
          ...d,
          deliveryZones: d.deliveryZones.map((z) => (z.id === id ? { ...z, ...patch } : z)),
        },
    );
    await updateDeliveryRate(id, patch);
    toast.success("Delivery zone updated");
  };

  const handleAddZone = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newZone.state) return toast.error("State is required");
    setAddingZone(true);
    try {
      const res = await createDeliveryRate(newZone);
      setData((d) => {
        if (!d) return d;
        return {
          ...d,
          deliveryZones: [
            ...d.deliveryZones,
            {
              id: res.data.id.toString(),
              region: `${res.data.state} ${res.data.city_or_lga}`.trim(),
              baseFee: res.data.base_fee,
              perKgFee: res.data.extra_fee_per_kg || 0,
              etaDays: res.data.eta_text,
              enabled: res.data.is_active,
            }
          ]
        };
      });
      setNewZone({ state: "", city: "*", baseFee: 0, perKgFee: 0, etaDays: "3", enabled: true });
      toast.success("Delivery zone added");
    } catch (err: any) {
      toast.error(err.message || "Failed to add zone");
    } finally {
      setAddingZone(false);
    }
  };

  return (
    <div className="flex flex-col gap-4">
      <PageHeader
        eyebrow="Configuration"
        title="System settings"
        description="Independent ecommerce + POS configuration with internal inventory and payment controls."
      />

      {/* Horizontal tab bar */}
      <div className="flex overflow-x-auto border-b border-border scrollbar-none">
        {TABS.map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            id={`settings-tab-${id}`}
            onClick={() => setActiveTab(id)}
            className={[
              "flex shrink-0 items-center gap-1.5 border-b-2 px-4 py-2.5 text-xs font-semibold uppercase tracking-wider transition-colors",
              activeTab === id
                ? "border-primary text-primary"
                : "border-transparent text-muted-foreground hover:text-primary",
            ].join(" ")}
          >
            <Icon className="h-3.5 w-3.5" />
            {label}
          </button>
        ))}
      </div>

      {/* Content panel */}
      <div className="rounded-md border border-border bg-surface p-6">
        {activeTab === "general" && (
          <CompanyProfileSection settings={settings} onSave={patchSettings} />
        )}

        {activeTab === "pos" && (
          <Section title="POS Sale Settings">
            <Grid>
              <ToggleField
                label="Allow staff POS sales"
                checked={settings.posSales.allowStaffSales}
                onChange={(v) => patchSettings({ allowStaffSales: v })}
              />
              <ToggleField
                label="Require customer details"
                checked={settings.posSales.requireCustomerDetails}
                onChange={(v) => patchSettings({ requireCustomerDetails: v })}
              />
              <ToggleField
                label="Auto-complete paid POS sales"
                checked={settings.posSales.autoMarkPaidAsCompleted}
                onChange={(v) => patchSettings({ autoMarkPaidAsCompleted: v })}
              />
              <ToggleField
                label="Hold stock for pending POS sales"
                checked={settings.posSales.holdStockForPendingPosSales}
                onChange={(v) => patchSettings({ holdStockForPendingPosSales: v })}
              />
              <Field label="Default POS payment method">
                <select
                  value={settings.posSales.defaultPaymentMethod}
                  onChange={(e) =>
                    patchSettings({
                      defaultPaymentMethod: e.target
                        .value as AdminSettings["posSales"]["defaultPaymentMethod"],
                    })
                  }
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                >
                  <option value="cash">Cash</option>
                  <option value="bank_transfer">Bank transfer</option>
                  <option value="pos_terminal">POS terminal</option>
                  <option value="manual_card">Manual card</option>
                  <option value="paystack">Paystack</option>
                  <option value="other">Other</option>
                </select>
              </Field>
            </Grid>
          </Section>
        )}

        {activeTab === "payments" && (
          <Section title="Payment Methods">
            <Grid>
              <ToggleField
                label="Paystack"
                checked={settings.paymentMethods.paystack}
                onChange={(v) => patchSettings({ paystack: v })}
              />
              <ToggleField
                label="Cash"
                checked={settings.paymentMethods.cash}
                onChange={(v) => patchSettings({ cash: v })}
              />
              <ToggleField
                label="Bank transfer"
                checked={settings.paymentMethods.bankTransfer}
                onChange={(v) => patchSettings({ bankTransfer: v })}
              />
              <ToggleField
                label="POS terminal"
                checked={settings.paymentMethods.posTerminal}
                onChange={(v) => patchSettings({ posTerminal: v })}
              />
              <ToggleField
                label="Manual card"
                checked={settings.paymentMethods.manualCard}
                onChange={(v) => patchSettings({ manualCard: v })}
              />
              <ToggleField
                label="Other"
                checked={settings.paymentMethods.other}
                onChange={(v) => patchSettings({ other: v })}
              />
            </Grid>
          </Section>
        )}

        {activeTab === "inventory" && (
          <Section title="Inventory Settings">
            <Grid>
              <ToggleField
                label="Prevent overselling"
                checked={settings.inventory.enforceStockGuard}
                onChange={(v) => patchSettings({ enforceStockGuard: v })}
              />
              <ToggleField
                label="Allow negative stock"
                checked={settings.inventory.allowNegativeStock}
                onChange={(v) => patchSettings({ allowNegativeStock: v })}
              />
              <ToggleField
                label="Require inventory movement notes"
                checked={settings.inventory.trackMovementNotes}
                onChange={(v) => patchSettings({ trackMovementNotes: v })}
              />
              <Field label="Low stock threshold (units)">
                <input
                  type="number"
                  min={0}
                  value={settings.inventory.lowStockThreshold}
                  onChange={(e) => patchSettings({ lowStockThreshold: Number(e.target.value) })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
            </Grid>
          </Section>
        )}

        {activeTab === "receipt" && (
          <Section title="Receipt Settings">
            <Grid>
              <Field label="Receipt prefix">
                <input
                  value={settings.receipt.prefix}
                  onChange={(e) => patchSettings({ prefix: e.target.value })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
              <Field label="Receipt footer note">
                <input
                  value={settings.receipt.footerNote}
                  onChange={(e) => patchSettings({ footerNote: e.target.value })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
              <ToggleField
                label="Show logo on receipt"
                checked={settings.receipt.showLogo}
                onChange={(v) => patchSettings({ showLogo: v })}
              />
              <ToggleField
                label="Print customer phone on receipt"
                checked={settings.receipt.printCustomerPhone}
                onChange={(v) => patchSettings({ printCustomerPhone: v })}
              />
            </Grid>
          </Section>
        )}

        {activeTab === "tax" && (
          <Section title="Tax / VAT Settings">
            <Grid>
              <ToggleField
                label="VAT enabled"
                checked={settings.tax.vatEnabled}
                onChange={(v) => patchSettings({ vatEnabled: v })}
              />
              <ToggleField
                label="Prices include VAT"
                checked={settings.tax.pricesIncludeVat}
                onChange={(v) => patchSettings({ pricesIncludeVat: v })}
              />
              <Field label="VAT percent">
                <input
                  type="number"
                  min={0}
                  step={0.01}
                  value={settings.tax.vatPercent}
                  onChange={(e) => patchSettings({ vatPercent: Number(e.target.value) })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
            </Grid>
          </Section>
        )}

        {activeTab === "staff" && (
          <Section title="Staff Permissions for POS Sales">
            <Grid>
              <ToggleField
                label="Can create POS sales"
                checked={settings.staffPermissions.canCreatePosSales}
                onChange={(v) => patchSettings({ canCreatePosSales: v })}
              />
              <ToggleField
                label="Can edit POS line prices"
                checked={settings.staffPermissions.canEditPosPrice}
                onChange={(v) => patchSettings({ canEditPosPrice: v })}
              />
              <ToggleField
                label="Can apply discounts"
                checked={settings.staffPermissions.canApplyDiscount}
                onChange={(v) => patchSettings({ canApplyDiscount: v })}
              />
              <ToggleField
                label="Can process stock returns"
                checked={settings.staffPermissions.canProcessReturns}
                onChange={(v) => patchSettings({ canProcessReturns: v })}
              />
              <Field label="Max discount percent">
                <input
                  type="number"
                  min={0}
                  step={1}
                  value={settings.staffPermissions.maxDiscountPercent}
                  onChange={(e) => patchSettings({ maxDiscountPercent: Number(e.target.value) })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
            </Grid>
          </Section>
        )}

        {activeTab === "delivery" && (
          <Section title="Delivery Zones & Rates">
            <form onSubmit={handleAddZone} className="mb-6 grid grid-cols-2 sm:grid-cols-6 gap-3 items-end rounded-sm border border-border bg-accent/20 p-4">
              <Field label="State (Required)">
                <input
                  value={newZone.state}
                  onChange={(e) => setNewZone({ ...newZone, state: e.target.value })}
                  placeholder="e.g. Lagos"
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                  required
                />
              </Field>
              <Field label="City / LGA">
                <input
                  value={newZone.city}
                  onChange={(e) => setNewZone({ ...newZone, city: e.target.value })}
                  placeholder="*"
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
              <Field label="Base Fee (₦)">
                <input
                  type="number"
                  value={newZone.baseFee}
                  onChange={(e) => setNewZone({ ...newZone, baseFee: Number(e.target.value) })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                  required
                />
              </Field>
              <Field label="Per KG Fee (₦)">
                <input
                  type="number"
                  value={newZone.perKgFee}
                  onChange={(e) => setNewZone({ ...newZone, perKgFee: Number(e.target.value) })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
              <Field label="ETA (Days)">
                <input
                  value={newZone.etaDays}
                  onChange={(e) => setNewZone({ ...newZone, etaDays: e.target.value })}
                  className="w-full rounded-sm border border-border bg-background px-3 py-2 text-sm"
                />
              </Field>
              <button
                type="submit"
                disabled={addingZone}
                className="w-full h-[38px] rounded-sm bg-secondary text-sm font-bold uppercase tracking-wider text-secondary-foreground hover:bg-secondary/90 disabled:opacity-50"
              >
                Add Zone
              </button>
            </form>

            <div className="overflow-x-auto rounded-sm border border-border">
              <table className="w-full text-sm">
                <thead className="bg-accent/50 text-[10px] uppercase tracking-wider text-muted-foreground">
                  <tr>
                    <th className="px-3 py-2 text-left">Region</th>
                    <th className="px-3 py-2 text-right">Base fee</th>
                    <th className="px-3 py-2 text-right">Per kg</th>
                    <th className="px-3 py-2 text-left">ETA</th>
                    <th className="px-3 py-2 text-left">Enabled</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border">
                  {deliveryZones.map((z) => (
                    <tr key={z.id}>
                      <td className="px-3 py-2 font-medium">{z.region}</td>
                      <td className="px-3 py-2 text-right">
                        <input
                          type="number"
                          defaultValue={z.baseFee}
                          onBlur={(e) => updateZone(z.id, { baseFee: Number(e.target.value) })}
                          className="w-24 rounded-sm border border-border bg-background px-2 py-1 text-right text-xs"
                        />
                      </td>
                      <td className="px-3 py-2 text-right">
                        <input
                          type="number"
                          defaultValue={z.perKgFee}
                          onBlur={(e) => updateZone(z.id, { perKgFee: Number(e.target.value) })}
                          className="w-20 rounded-sm border border-border bg-background px-2 py-1 text-right text-xs"
                        />
                      </td>
                      <td className="px-3 py-2 text-xs">{z.etaDays} days</td>
                      <td className="px-3 py-2">
                        <input
                          type="checkbox"
                          checked={z.enabled}
                          onChange={(e) => updateZone(z.id, { enabled: e.target.checked })}
                          className="h-4 w-4"
                        />
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </Section>
        )}

        {activeTab === "notifications" && (
          <Section title="Admin Notification Preferences">
            <Grid>
              <ToggleField
                label="Notify on new order"
                checked={settings.preferences.notifyOnNewOrder}
                onChange={(v) => patchSettings({ notifyOnNewOrder: v })}
              />
              <ToggleField
                label="Notify on low stock"
                checked={settings.preferences.notifyOnLowStock}
                onChange={(v) => patchSettings({ notifyOnLowStock: v })}
              />
            </Grid>
          </Section>
        )}

        {activeTab === "email" && (
          <Section title="Outbound Email Log (Preview)">
            {!emailLogs ? (
              <Skeleton className="h-24" />
            ) : (
              <ul className="divide-y divide-border rounded-sm border border-border">
                {emailLogs.map((e: any) => (
                  <li key={e.id} className="flex items-start justify-between gap-3 px-3 py-2">
                    <div>
                      <p className="text-xs font-semibold text-primary">{e.subject}</p>
                      <p className="text-[10px] text-muted-foreground">
                        {"→"} {e.to} - {e.template}
                      </p>
                    </div>
                    <div className="text-right">
                      <StatusBadge
                        variant={
                          e.status === "sent"
                            ? "success"
                            : e.status === "queued"
                              ? "warning"
                              : "danger"
                        }
                      >
                        {e.status}
                      </StatusBadge>
                      <p className="mt-1 text-[10px] text-muted-foreground">
                        {formatDistanceToNow(e.sentAt, { addSuffix: true })}
                      </p>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </Section>
        )}
      </div>
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h3 className="mb-5 font-display text-sm font-bold uppercase tracking-wider text-primary">
        {title}
      </h3>
      {children}
    </div>
  );
}

function Grid({ children }: { children: React.ReactNode }) {
  return <div className="grid gap-3 sm:grid-cols-2">{children}</div>;
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <label className="mb-1 block text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
        {label}
      </label>
      {children}
    </div>
  );
}

function ToggleField({
  label,
  checked,
  onChange,
}: {
  label: string;
  checked: boolean;
  onChange: (value: boolean) => void;
}) {
  return (
    <label className="flex items-center justify-between rounded-sm border border-border bg-background px-3 py-2">
      <span className="text-sm text-primary">{label}</span>
      <input
        type="checkbox"
        checked={checked}
        onChange={(e) => onChange(e.target.checked)}
        className="h-4 w-4"
      />
    </label>
  );
}

function ReadOnly({ label, value, mono }: { label: string; value: string; mono?: boolean }) {
  return (
    <div className="rounded-sm border border-border bg-background px-3 py-2">
      <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
        {label}
      </p>
      <p className={`mt-0.5 text-sm text-primary ${mono ? "font-mono" : ""}`}>{value}</p>
    </div>
  );
}

/* ---------------- Company Profile Section ---------------- */
function CompanyProfileSection({
  settings,
  onSave,
}: {
  settings: AdminSettings;
  onSave: (patch: any) => Promise<void>;
}) {
  const g = settings.general;
  const [form, setForm] = useState({
    storeName:    g.storeName    ?? "",
    storeAddress: g.storeAddress ?? "",
    storePhone:   g.storePhone   ?? "",
    storeEmail:   g.storeEmail   ?? "",
    supportEmail: g.supportEmail ?? "",
    currency:     g.currency     ?? "NGN",
    vatPercent:   String(g.vatPercent ?? 7.5),
  });
  const [saving, setSaving] = useState(false);
  const [saved,  setSaved]  = useState(false);

  const field = (key: keyof typeof form) => ({
    value: form[key],
    onChange: (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
      setForm((f) => ({ ...f, [key]: e.target.value })),
  });

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    try {
      await onSave({
        storeName:    form.storeName,
        storeAddress: form.storeAddress,
        storePhone:   form.storePhone,
        storeEmail:   form.storeEmail,
        supportEmail: form.supportEmail,
        currency:     form.currency,
        vatPercent:   Number(form.vatPercent),
      });
      setSaved(true);
      toast.success("Company settings saved.");
      setTimeout(() => setSaved(false), 2500);
    } catch {
      toast.error("Failed to save settings.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <form onSubmit={handleSave} className="space-y-8">
      {/* Company Identity */}
      <div>
        <div className="flex items-center gap-2 mb-5">
          <Building2 className="h-4 w-4 text-secondary" />
          <h3 className="font-display text-sm font-bold uppercase tracking-wider text-primary">
            Company Identity
          </h3>
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          <CompanyField
            label="Company / Store Name"
            id="setting-store-name"
            icon={<Building2 className="h-3.5 w-3.5" />}
            {...field("storeName")}
            required
          />
          <CompanyField
            label="Business Address"
            id="setting-store-address"
            icon={<MapPin className="h-3.5 w-3.5" />}
            {...field("storeAddress")}
          />
          <CompanyField
            label="Contact Phone"
            id="setting-store-phone"
            icon={<Phone className="h-3.5 w-3.5" />}
            type="tel"
            {...field("storePhone")}
          />
        </div>
      </div>

      {/* Email Configuration */}
      <div>
        <div className="flex items-center gap-2 mb-5">
          <Mail className="h-4 w-4 text-secondary" />
          <h3 className="font-display text-sm font-bold uppercase tracking-wider text-primary">
            Email Addresses
          </h3>
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          <CompanyField
            label="Store / Order Email"
            id="setting-store-email"
            icon={<Mail className="h-3.5 w-3.5" />}
            type="email"
            {...field("storeEmail")}
          />
          <CompanyField
            label="Support Email"
            id="setting-support-email"
            icon={<Mail className="h-3.5 w-3.5" />}
            type="email"
            {...field("supportEmail")}
          />
        </div>
      </div>

      {/* Commerce Config */}
      <div>
        <div className="flex items-center gap-2 mb-5">
          <Globe className="h-4 w-4 text-secondary" />
          <h3 className="font-display text-sm font-bold uppercase tracking-wider text-primary">
            Commerce Configuration
          </h3>
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label
              htmlFor="setting-currency"
              className="mb-1.5 block text-[10px] font-semibold uppercase tracking-widest text-muted-foreground"
            >
              Currency
            </label>
            <div className="relative">
              <Globe className="pointer-events-none absolute left-3 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-muted-foreground" />
              <select
                id="setting-currency"
                {...field("currency")}
                className="h-10 w-full rounded-sm border border-border bg-background pl-9 pr-3 text-sm focus:border-secondary focus:outline-none"
              >
                <option value="NGN">NGN — Nigerian Naira (₦)</option>
                <option value="USD">USD — US Dollar ($)</option>
                <option value="GBP">GBP — British Pound (£)</option>
                <option value="EUR">EUR — Euro (€)</option>
              </select>
            </div>
          </div>
          <CompanyField
            label="VAT / Tax Rate (%)"
            id="setting-vat-percent"
            icon={<Percent className="h-3.5 w-3.5" />}
            type="number"
            min="0"
            max="100"
            step="0.1"
            {...field("vatPercent")}
          />
        </div>
      </div>

      {/* Save Button */}
      <div className="flex items-center justify-between border-t border-border pt-6">
        <p className="text-[11px] text-muted-foreground">
          Changes apply to receipts, invoices, emails, and the customer-facing storefront.
        </p>
        <button
          id="save-company-settings"
          type="submit"
          disabled={saving}
          className="inline-flex h-10 items-center gap-2 rounded-sm bg-cta px-5 text-xs font-bold uppercase tracking-wide text-cta-foreground hover:bg-cta/90 disabled:opacity-60 transition cursor-pointer"
        >
          {saved ? (
            <><CheckCircle2 className="h-4 w-4" /> Saved!</>
          ) : saving ? (
            <><div className="h-4 w-4 animate-spin rounded-full border-2 border-white/30 border-t-white" /> Saving…</>
          ) : (
            <><Save className="h-4 w-4" /> Save Changes</>
          )}
        </button>
      </div>
    </form>
  );
}

function CompanyField({
  label,
  id,
  icon,
  type = "text",
  value,
  onChange,
  required,
  min,
  max,
  step,
}: {
  label: string;
  id: string;
  icon: React.ReactNode;
  type?: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  required?: boolean;
  min?: string;
  max?: string;
  step?: string;
}) {
  return (
    <div>
      <label
        htmlFor={id}
        className="mb-1.5 block text-[10px] font-semibold uppercase tracking-widest text-muted-foreground"
      >
        {label}
      </label>
      <div className="relative">
        <span className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground">
          {icon}
        </span>
        <input
          id={id}
          type={type}
          value={value}
          onChange={onChange}
          required={required}
          min={min}
          max={max}
          step={step}
          className="h-10 w-full rounded-sm border border-border bg-background pl-9 pr-3 text-sm text-primary placeholder:text-muted-foreground/50 focus:border-secondary focus:outline-none transition-colors"
        />
      </div>
    </div>
  );
}

void NGN;
