import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import {
  Search,
  Eye,
  Pencil,
  Trash2,
  Plus,
  X,
  Phone,
  Mail,
  ShoppingCart,
  TrendingUp,
  Calendar,
  ArrowLeft,
  AlertTriangle,
  User,
} from "lucide-react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { NGN } from "@/lib/format";
import {
  fetchAdminCustomers,
  fetchAdminCustomer,
  createCustomer,
  updateCustomer,
  deleteCustomer,
  type AdminCustomer,
  type CustomerTransaction,
} from "@/api/admin";

export const Route = createFileRoute("/admin/customers")({
  component: AdminCustomersPage,
  head: () => ({ meta: [{ title: "Customers - Admin" }] }),
});

function AdminCustomersPage() {
  const [customers, setCustomers] = useState<AdminCustomer[] | null>(null);
  const [pagination, setPagination] = useState({ page: 1, per_page: 20, total: 0 });
  const [search, setSearch] = useState("");
  const [selectedCustomer, setSelectedCustomer] = useState<{
    customer: AdminCustomer;
    transactions: CustomerTransaction[];
  } | null>(null);
  const [loadingDetail, setLoadingDetail] = useState(false);

  const [editorOpen, setEditorOpen] = useState(false);
  const [editingCustomer, setEditingCustomer] = useState<AdminCustomer | null>(null);
  const [editorName, setEditorName] = useState("");
  const [editorPhone, setEditorPhone] = useState("");
  const [editorEmail, setEditorEmail] = useState("");
  const [saving, setSaving] = useState(false);

  const [deleteTarget, setDeleteTarget] = useState<AdminCustomer | null>(null);
  const [deleting, setDeleting] = useState(false);

  const loadCustomers = async (page = 1, q = "") => {
    const res = await fetchAdminCustomers({ search: q || undefined, page, per_page: 20 });
    setCustomers(res.items);
    setPagination(res.pagination);
  };

  useEffect(() => {
    loadCustomers();
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    loadCustomers(1, search);
  };

  const openDetail = async (c: AdminCustomer) => {
    setLoadingDetail(true);
    try {
      const data = await fetchAdminCustomer(c.id);
      setSelectedCustomer(data);
    } catch {
      // ignore
    } finally {
      setLoadingDetail(false);
    }
  };

  const openCreate = () => {
    setEditingCustomer(null);
    setEditorName("");
    setEditorPhone("");
    setEditorEmail("");
    setEditorOpen(true);
  };

  const openEdit = (c: AdminCustomer) => {
    setEditingCustomer(c);
    setEditorName(c.full_name);
    setEditorPhone(c.phone);
    setEditorEmail(c.email || "");
    setEditorOpen(true);
  };

  const handleSave = async () => {
    if (!editorName.trim()) {
      toast.error("Full name is required");
      return;
    }
    if (!editorPhone.trim()) {
      toast.error("Phone number is required");
      return;
    }
    setSaving(true);
    try {
      if (editingCustomer) {
        const result = await updateCustomer(editingCustomer.id, {
          full_name: editorName.trim(),
          phone: editorPhone.trim(),
          email: editorEmail.trim(),
        });
        if (result) {
          toast.success("Customer updated");
          setEditorOpen(false);
          loadCustomers(pagination.page, search);
        } else {
          toast.error("Failed to update customer");
        }
      } else {
        try {
          const result = await createCustomer({
            full_name: editorName.trim(),
            phone: editorPhone.trim(),
            email: editorEmail.trim(),
          });
          toast.success("Customer created");
          setEditorOpen(false);
          loadCustomers(1, search);
        } catch (e: any) {
          toast.error(e?.message || "Failed to create customer");
        }
      }
    } catch (e: any) {
      toast.error(e?.message || "An error occurred");
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      const ok = await deleteCustomer(deleteTarget.id);
      if (ok) {
        toast.success("Customer deleted");
        setDeleteTarget(null);
        loadCustomers(pagination.page, search);
      } else {
        toast.error("Failed to delete customer");
      }
    } catch {
      toast.error("An error occurred");
    } finally {
      setDeleting(false);
    }
  };

  const formatDate = (d: string | null) => {
    if (!d) return "N/A";
    try {
      return new Date(d).toLocaleDateString("en-NG", {
        year: "numeric",
        month: "short",
        day: "numeric",
      });
    } catch {
      return d;
    }
  };

  const formatDateTime = (d: string | null) => {
    if (!d) return "N/A";
    try {
      return new Date(d).toLocaleString("en-NG", {
        year: "numeric",
        month: "short",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      });
    } catch {
      return d;
    }
  };

  const totalPages = Math.ceil(pagination.total / pagination.per_page);

  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <PageHeader
          eyebrow="CRM"
          title="Customer Management"
          description="View, create, edit, and track all customer records and transaction history."
        />
        <button
          onClick={openCreate}
          className="inline-flex h-10 items-center gap-2 rounded-sm bg-secondary px-4 text-sm font-bold uppercase tracking-wide text-secondary-foreground hover:bg-secondary/90 shadow-sm"
        >
          <Plus className="h-4 w-4" /> Add Customer
        </button>
      </div>

      {/* Stats */}
      {customers && (
        <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
          <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
            <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Total Customers</p>
            <p className="mt-1 text-2xl font-bold text-primary">{pagination.total}</p>
          </div>
          <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
            <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Avg Orders</p>
            <p className="mt-1 text-2xl font-bold text-primary">
              {customers.length > 0
                ? (customers.reduce((s, c) => s + (c.total_orders || 0), 0) / customers.length).toFixed(1)
                : "0"}
            </p>
          </div>
          <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
            <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Total Revenue</p>
            <p className="mt-1 text-2xl font-bold text-primary">
              {NGN(customers.reduce((s, c) => s + (c.total_spent || 0), 0))}
            </p>
          </div>
          <div className="rounded-sm border border-border bg-surface p-4 shadow-sm">
            <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">With Orders</p>
            <p className="mt-1 text-2xl font-bold text-primary">
              {customers.filter((c) => (c.total_orders || 0) > 0).length}
            </p>
          </div>
        </div>
      )}

      {/* Search */}
      <form onSubmit={handleSearch} className="flex gap-3">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by name, phone, or email..."
            className="h-10 w-full rounded-sm border border-border bg-surface pl-9 pr-3 text-sm focus:border-secondary focus:outline-none"
          />
        </div>
        <button
          type="submit"
          className="rounded-sm bg-primary px-5 text-sm font-bold uppercase tracking-wider text-primary-foreground hover:bg-primary/90 transition-colors"
        >
          Search
        </button>
      </form>

      {/* Customer Detail View */}
      {selectedCustomer && (
        <CustomerDetailPanel
          data={selectedCustomer}
          loading={loadingDetail}
          onClose={() => setSelectedCustomer(null)}
          formatDate={formatDate}
          formatDateTime={formatDateTime}
        />
      )}

      {/* Customer Table */}
      {!selectedCustomer && (
        <div className="overflow-x-auto rounded-md border border-border bg-surface shadow-sm">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border bg-accent/50 text-[10px] uppercase tracking-wider text-muted-foreground">
                <th className="px-4 py-3 text-left">Name</th>
                <th className="px-4 py-3 text-left">Phone</th>
                <th className="px-4 py-3 text-left">Email</th>
                <th className="px-4 py-3 text-center">Orders</th>
                <th className="px-4 py-3 text-right">Total Spent</th>
                <th className="px-4 py-3 text-left">Last Order</th>
                <th className="px-4 py-3 text-center">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {!customers ? (
                <tr>
                  <td colSpan={7} className="flex items-center justify-center py-14">
                    <div className="h-6 w-6 animate-spin rounded-full border-2 border-primary border-t-transparent" />
                  </td>
                </tr>
              ) : customers.length === 0 ? (
                <tr>
                  <td colSpan={7} className="flex flex-col items-center gap-3 py-14 text-muted-foreground">
                    <ShoppingCart className="h-10 w-10 opacity-20" />
                    <p className="text-sm">No customers found</p>
                  </td>
                </tr>
              ) : (
                customers.map((c) => (
                  <tr key={`${c.id}-${c.phone}`} className="hover:bg-accent/30 transition-colors">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-sm bg-primary/10 text-[10px] font-bold text-primary">
                          {(c.full_name || "??").slice(0, 2).toUpperCase()}
                        </div>
                        <span className="font-semibold text-primary">{c.full_name}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-muted-foreground">{c.phone || "N/A"}</td>
                    <td className="px-4 py-3 text-muted-foreground">{c.email || "N/A"}</td>
                    <td className="px-4 py-3 text-center font-semibold text-primary">{c.total_orders || 0}</td>
                    <td className="px-4 py-3 text-right font-bold text-primary">{NGN(c.total_spent || 0)}</td>
                    <td className="px-4 py-3 text-xs text-muted-foreground">{formatDate(c.last_order_at)}</td>
                    <td className="px-4 py-3">
                      <div className="flex items-center justify-center gap-1">
                        <button
                          onClick={() => openDetail(c)}
                          className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border text-primary hover:bg-accent hover:text-secondary transition-colors"
                          title="View details"
                        >
                          <Eye className="h-3.5 w-3.5" />
                        </button>
                        <button
                          onClick={() => openEdit(c)}
                          className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border text-primary hover:bg-accent hover:text-secondary transition-colors"
                          title="Edit customer"
                        >
                          <Pencil className="h-3.5 w-3.5" />
                        </button>
                        <button
                          onClick={() => setDeleteTarget(c)}
                          className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border text-muted-foreground hover:bg-destructive/10 hover:text-destructive transition-colors"
                          title="Delete customer"
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>

          {totalPages > 1 && (
            <div className="flex items-center justify-between border-t border-border px-4 py-3">
              <span className="text-xs text-muted-foreground">
                Page {pagination.page} of {totalPages}
              </span>
              <div className="flex gap-2">
                <button
                  disabled={pagination.page <= 1}
                  onClick={() => loadCustomers(pagination.page - 1, search)}
                  className="rounded-sm border border-border px-3 py-1.5 text-xs font-semibold text-muted-foreground hover:bg-accent disabled:opacity-40"
                >
                  Previous
                </button>
                <button
                  disabled={pagination.page >= totalPages}
                  onClick={() => loadCustomers(pagination.page + 1, search)}
                  className="rounded-sm border border-border px-3 py-1.5 text-xs font-semibold text-muted-foreground hover:bg-accent disabled:opacity-40"
                >
                  Next
                </button>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Create/Edit Side Panel */}
      {editorOpen && (
        <div className="fixed inset-0 z-50 flex overflow-hidden">
          <div
            className="flex-1 bg-black/40 backdrop-blur-sm transition-opacity"
            onClick={() => setEditorOpen(false)}
          />
          <div className="flex w-full max-w-lg flex-col bg-surface shadow-2xl animate-in slide-in-from-right duration-300">
            <div className="flex items-center justify-between border-b border-border px-6 py-4">
              <h2 className="text-sm font-bold uppercase tracking-wider text-primary">
                {editingCustomer ? "Edit Customer" : "Add Customer"}
              </h2>
              <button
                onClick={() => setEditorOpen(false)}
                className="inline-flex h-8 w-8 items-center justify-center rounded-sm text-muted-foreground hover:bg-accent hover:text-primary transition-colors"
              >
                <X className="h-4 w-4" />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-6">
              <div className="space-y-5">
                <div className="space-y-1.5">
                  <label className="flex items-center gap-1 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Full Name <span className="text-destructive">*</span>
                  </label>
                  <input
                    value={editorName}
                    onChange={(e) => setEditorName(e.target.value)}
                    placeholder="e.g. Adaeze Okafor"
                    className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="flex items-center gap-1 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Phone Number <span className="text-destructive">*</span>
                  </label>
                  <input
                    value={editorPhone}
                    onChange={(e) => setEditorPhone(e.target.value)}
                    placeholder="e.g. 0803 123 4567"
                    className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="flex items-center gap-1 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Email
                  </label>
                  <input
                    value={editorEmail}
                    onChange={(e) => setEditorEmail(e.target.value)}
                    placeholder="e.g. adaeze@example.com"
                    className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                  />
                </div>
              </div>
            </div>

            <div className="flex gap-3 border-t border-border px-6 py-4">
              <button
                onClick={() => setEditorOpen(false)}
                className="flex-1 rounded-sm border border-border py-3 text-sm font-bold uppercase tracking-widest text-primary hover:bg-accent transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleSave}
                disabled={saving}
                className="flex-[2] rounded-sm bg-cta py-3 text-sm font-black uppercase tracking-[0.1em] text-cta-foreground hover:bg-cta/90 disabled:opacity-50 shadow-lg shadow-cta/20 flex items-center justify-center gap-2 transition-all"
              >
                {saving ? (
                  <div className="h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent" />
                ) : null}
                {editingCustomer ? "Save Changes" : "Create Customer"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {deleteTarget && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm">
          <div className="w-full max-w-md rounded-sm border border-border bg-surface p-6 shadow-2xl animate-in zoom-in-95 duration-200">
            <div className="flex items-center gap-3 mb-4">
              <div className="flex h-10 w-10 items-center justify-center rounded-sm bg-destructive/10">
                <AlertTriangle className="h-5 w-5 text-destructive" />
              </div>
              <div>
                <h3 className="text-sm font-bold text-primary">Delete Customer</h3>
                <p className="text-xs text-muted-foreground">This action cannot be undone.</p>
              </div>
            </div>
            <p className="mb-6 text-sm text-muted-foreground">
              Are you sure you want to delete <strong className="text-primary">{deleteTarget.full_name}</strong>?
              All their data will be permanently removed.
            </p>
            <div className="flex gap-3">
              <button
                onClick={() => setDeleteTarget(null)}
                className="flex-1 rounded-sm border border-border py-2.5 text-sm font-bold uppercase tracking-wider text-primary hover:bg-accent transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleDelete}
                disabled={deleting}
                className="flex-1 rounded-sm border border-destructive py-2.5 text-sm font-bold uppercase tracking-wider text-destructive hover:bg-destructive/10 disabled:opacity-50 transition-colors"
              >
                {deleting ? "Deleting..." : "Delete Permanently"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function CustomerDetailPanel({
  data,
  loading,
  onClose,
  formatDate,
  formatDateTime,
}: {
  data: { customer: AdminCustomer; transactions: CustomerTransaction[] };
  loading: boolean;
  onClose: () => void;
  formatDate: (d: string | null) => string;
  formatDateTime: (d: string | null) => string;
}) {
  const { customer, transactions } = data;
  const totalSpend = Number(customer.total_spent ?? 0);
  const avgOrderValue = customer.total_orders > 0 ? totalSpend / customer.total_orders : 0;

  return (
    <div className="rounded-sm border border-border bg-surface shadow-sm">
      <div className="flex items-center justify-between border-b border-border px-4 py-3">
        <div className="flex items-center gap-3">
          <button
            onClick={onClose}
            className="inline-flex h-8 w-8 items-center justify-center rounded-sm text-muted-foreground hover:bg-accent hover:text-primary transition-colors"
          >
            <ArrowLeft className="h-4 w-4" />
          </button>
          <span className="text-sm font-bold uppercase tracking-wider text-primary">
            Customer Detail
          </span>
        </div>
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-14">
          <div className="h-6 w-6 animate-spin rounded-full border-2 border-primary border-t-transparent" />
        </div>
      ) : (
        <div className="p-4">
          <div className="grid gap-4 md:grid-cols-3 mb-6">
            <div className="rounded-sm border border-border bg-accent/20 p-4">
              <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground mb-1">Total Orders</p>
              <p className="text-2xl font-bold text-primary">{customer.total_orders}</p>
            </div>
            <div className="rounded-sm border border-border bg-accent/20 p-4">
              <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground mb-1">Total Spent</p>
              <p className="text-2xl font-bold text-primary">{NGN(totalSpend)}</p>
            </div>
            <div className="rounded-sm border border-border bg-accent/20 p-4">
              <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground mb-1">Avg Order Value</p>
              <p className="text-2xl font-bold text-primary">{NGN(avgOrderValue)}</p>
            </div>
          </div>

          <div className="mb-6 rounded-sm border border-border bg-accent/10 p-4">
            <h3 className="mb-3 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Profile Information</h3>
            <div className="grid gap-3 md:grid-cols-2">
              <div className="flex items-center gap-2">
                <User className="h-3.5 w-3.5 text-primary" />
                <span className="text-sm font-semibold text-primary">{customer.full_name}</span>
              </div>
              <div className="flex items-center gap-2">
                <Phone className="h-3.5 w-3.5 text-primary" />
                <span className="text-sm text-muted-foreground">{customer.phone}</span>
              </div>
              <div className="flex items-center gap-2">
                <Mail className="h-3.5 w-3.5 text-primary" />
                <span className="text-sm text-muted-foreground">{customer.email || "N/A"}</span>
              </div>
              <div className="flex items-center gap-2">
                <Calendar className="h-3.5 w-3.5 text-primary" />
                <span className="text-sm text-muted-foreground">First order: {formatDate(customer.first_order_at)}</span>
              </div>
            </div>
          </div>

          <div>
            <h3 className="mb-3 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
              Transaction Ledger ({transactions.length})
            </h3>
            {transactions.length === 0 ? (
              <div className="flex flex-col items-center gap-3 py-10 text-muted-foreground">
                <ShoppingCart className="h-8 w-8 opacity-20" />
                <p className="text-sm">No transactions yet</p>
              </div>
            ) : (
              <div className="overflow-x-auto rounded-sm border border-border">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-border bg-accent/30">
                      <th className="px-3 py-2 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Order #</th>
                      <th className="px-3 py-2 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Date</th>
                      <th className="px-3 py-2 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Channel</th>
                      <th className="px-3 py-2 text-right text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Amount</th>
                      <th className="px-3 py-2 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Status</th>
                      <th className="px-3 py-2 text-left text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Payment</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-border">
                    {transactions.map((t) => (
                      <tr key={t.id} className="hover:bg-accent/20 transition-colors">
                        <td className="px-3 py-2.5 font-semibold text-primary">{t.order_number}</td>
                        <td className="px-3 py-2.5 text-muted-foreground text-xs">{formatDateTime(t.created_at)}</td>
                        <td className="px-3 py-2.5">
                          <span className={`inline-flex items-center rounded-sm px-2 py-0.5 text-[10px] font-bold uppercase ${
                            t.sale_channel === "pos" ? "bg-blue-100 text-blue-700" : "bg-green-100 text-green-700"
                          }`}>
                            {t.sale_channel}
                          </span>
                        </td>
                        <td className="px-3 py-2.5 text-right font-bold text-primary">{NGN(t.total_amount)}</td>
                        <td className="px-3 py-2.5">
                          <span className={`inline-flex items-center rounded-sm px-2 py-0.5 text-[10px] font-bold uppercase ${
                            t.order_status === "paid" || t.order_status === "delivered"
                              ? "bg-success/15 text-success"
                              : t.order_status === "cancelled"
                                ? "bg-destructive/15 text-destructive"
                                : "bg-warning/20 text-warning-foreground"
                          }`}>
                            {t.order_status}
                          </span>
                        </td>
                        <td className="px-3 py-2.5 text-muted-foreground text-xs">{t.payment_method || "N/A"}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
