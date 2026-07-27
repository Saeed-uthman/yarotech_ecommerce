import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useMemo, useRef, useState } from "react";
import {
  Search,
  Upload,
  Pencil,
  Plus,
  Trash2,
  X,
  AlertTriangle,
  CheckCircle2,
  Image as ImageIcon,
  Layers,
  Tag,
  DollarSign,
  Package,
  Globe,
  Star,
  ArrowRight,
  History,
} from "lucide-react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { StatusBadge } from "@/components/common/StatusBadge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  fetchAdminProducts,
  fetchAdminProduct,
  updateProduct,
  createProduct,
  archiveProduct,
  deleteProduct,
  uploadProductImage,
  deleteProductImage,
  setPrimaryProductImage,
  updateProductSpecifications,
  adjustProductStock,
  type AdminProductRow,
  type AdminProductFilters,
  type ProductPayload,
  type StockAdjustmentPayload,
} from "@/api/admin";
import { mockAdminProducts } from "@/api/mock/products.mock";
import { USE_MOCK } from "@/api/client";
import { listCategories } from "@/api/products";
import { NGN } from "@/lib/format";

export const Route = createFileRoute("/admin/products")({
  component: ProductsAdmin,
  head: () => ({ meta: [{ title: "Product Management — Admin" }] }),
});

function ProductsAdmin() {
  const [rows, setRows] = useState<AdminProductRow[] | null>(null);
  const [categories, setCategories] = useState<string[]>([]);
  const [filters, setFilters] = useState<AdminProductFilters>({});
  const [editing, setEditing] = useState<AdminProductRow | null>(null);
  const [isAdding, setIsAdding] = useState(false);
  const [loading, setLoading] = useState(true);

  const fetchProducts = async () => {
    setLoading(true);
    try {
      const data = await fetchAdminProducts(filters);
      setRows(data);
    } catch (err) {
      toast.error("Failed to fetch products");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, [filters]);

  useEffect(() => {
    listCategories().then(setCategories);
  }, []);

  const refresh = async () => {
    await fetchProducts();
  };

  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <PageHeader
          title="Products"
          description="Manage products, pricing, stock, ecommerce visibility, and specifications."
        />
        <button
          onClick={() => setIsAdding(true)}
          className="inline-flex h-10 items-center gap-2 rounded-sm bg-secondary px-4 text-sm font-bold uppercase tracking-wide text-secondary-foreground hover:bg-secondary/90 shadow-sm"
        >
          <Plus className="h-4 w-4" /> Add Product
        </button>
      </div>

      <div className="grid grid-cols-2 gap-3 md:grid-cols-6">
        <Tile label="Total" value={rows?.length ?? "—"} />
        <Tile
          label="Active"
          value={rows?.filter((r) => r.status === "active").length ?? "—"}
          tone="success"
        />
        <Tile
          label="Low Stock"
          value={rows?.filter((r) => r.stockStatus === "low_stock").length ?? "—"}
          tone="warning"
        />
        <Tile
          label="Out of Stock"
          value={rows?.filter((r) => r.stockStatus === "out_of_stock").length ?? "—"}
          tone="danger"
        />
        <Tile
          label="Featured"
          value={rows?.filter((r) => r.featured).length ?? "—"}
          tone="default"
        />
        <Tile label="Online" value={rows?.filter((r) => r.visible).length ?? "—"} tone="success" />
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:flex lg:flex-row lg:items-center gap-3">
        <div className="relative flex-1 min-w-[200px]">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <input
            value={filters.q || ""}
            onChange={(e) => setFilters((f) => ({ ...f, q: e.target.value }))}
            placeholder="Search by name or SKU…"
            className="h-10 w-full rounded-sm border border-border bg-surface pl-9 pr-3 text-sm focus:border-secondary focus:outline-none"
          />
        </div>
        <select
          value={filters.category || ""}
          onChange={(e) => setFilters((f) => ({ ...f, category: e.target.value || undefined }))}
          className="h-10 rounded-sm border border-border bg-surface px-3 text-sm focus:border-secondary focus:outline-none"
        >
          <option value="">All Categories</option>
          {categories.map((c) => (
            <option key={c} value={c}>
              {c}
            </option>
          ))}
        </select>
        <select
          value={filters.stock_status || ""}
          onChange={(e) => setFilters((f) => ({ ...f, stock_status: e.target.value || undefined }))}
          className="h-10 rounded-sm border border-border bg-surface px-3 text-sm focus:border-secondary focus:outline-none"
        >
          <option value="">All Stock Status</option>
          <option value="in_stock">In Stock</option>
          <option value="low_stock">Low Stock</option>
          <option value="out_of_stock">Out of Stock</option>
        </select>
        <select
          value={filters.visible === undefined ? "" : filters.visible ? "1" : "0"}
          onChange={(e) =>
            setFilters((f) => ({
              ...f,
              visible: e.target.value === "" ? undefined : e.target.value === "1",
            }))
          }
          className="h-10 rounded-sm border border-border bg-surface px-3 text-sm focus:border-secondary focus:outline-none"
        >
          <option value="">All Visibility</option>
          <option value="1">Online Only</option>
          <option value="0">Offline Only</option>
        </select>
        <select
          value={filters.status || ""}
          onChange={(e) => setFilters((f) => ({ ...f, status: e.target.value || undefined }))}
          className="h-10 rounded-sm border border-border bg-surface px-3 text-sm focus:border-secondary focus:outline-none"
        >
          <option value="">All Status</option>
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
          <option value="archived">Archived</option>
        </select>
      </div>

      {loading && !rows ? (
        <Skeleton className="h-96" />
      ) : (
        <div className="overflow-x-auto rounded-md border border-border bg-surface shadow-sm">
          <table className="w-full text-sm">
            <thead className="bg-accent/50 text-[10px] uppercase tracking-wider text-muted-foreground">
              <tr>
                <th className="px-4 py-3 text-left">Product</th>
                <th className="hidden md:table-cell px-4 py-3 text-left">SKU</th>
                <th className="px-4 py-3 text-right">Price (Selling / Cost)</th>
                <th className="px-4 py-3 text-right">Stock</th>
                <th className="hidden lg:table-cell px-4 py-3 text-center">Visibility</th>
                <th className="hidden md:table-cell px-4 py-3 text-center">Status</th>
                <th className="px-4 py-3 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {rows?.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-4 py-12 text-center text-muted-foreground">
                    No products found matching your filters.
                  </td>
                </tr>
              ) : (
                rows?.map((p) => (
                  <tr key={p.id} className="hover:bg-accent/30 transition-colors">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        <div className="h-12 w-12 shrink-0 overflow-hidden rounded-sm border border-border bg-accent/20">
                          {p.image ? (
                            <img
                              src={p.image}
                              alt={p.name}
                              className="h-full w-full object-cover"
                            />
                          ) : (
                            <div className="flex h-full w-full items-center justify-center text-muted-foreground/40">
                              <ImageIcon className="h-4 w-4" />
                            </div>
                          )}
                        </div>
                        <div>
                          <p className="font-semibold text-primary leading-tight">{p.name}</p>
                          <p className="mt-1 text-[10px] text-muted-foreground uppercase tracking-wider">
                            {p.category}
                          </p>
                        </div>
                      </div>
                    </td>
                    <td className="hidden md:table-cell px-4 py-3 font-mono text-xs text-muted-foreground">{p.sku}</td>
                    <td className="px-4 py-3 text-right">
                      <p className="font-bold text-secondary">{NGN(p.sellingPrice)}</p>
                      <p className="text-[10px] text-muted-foreground">Cost: {NGN(p.costPrice)}</p>
                    </td>
                    <td className="px-4 py-3 text-right">
                      <div className="flex flex-col items-end">
                        <span className="font-semibold">{p.stockQuantity}</span>
                        <StatusBadge
                          variant={
                            p.stockStatus === "out_of_stock"
                              ? "danger"
                              : p.stockStatus === "low_stock"
                                ? "warning"
                                : "success"
                          }
                          className="mt-1"
                        >
                          {p.stockStatus.replace("_", " ")}
                        </StatusBadge>
                      </div>
                    </td>
                    <td className="hidden lg:table-cell px-4 py-3">
                      <div className="flex justify-center gap-1.5">
                        <BadgeIcon
                          icon={Globe}
                          active={p.visible}
                          color="text-success"
                          tooltip="Visible Online"
                        />
                        <BadgeIcon
                          icon={Star}
                          active={p.featured}
                          color="text-secondary"
                          tooltip="Featured"
                        />
                      </div>
                    </td>
                    <td className="hidden md:table-cell px-4 py-3 text-center">
                      <StatusBadge
                        variant={
                          p.status === "active"
                            ? "success"
                            : p.status === "archived"
                              ? "danger"
                              : "warning"
                        }
                      >
                        {p.status}
                      </StatusBadge>
                    </td>
                    <td className="px-4 py-3 text-right">
                      <div className="flex justify-end gap-2">
                        <button
                          onClick={() => setEditing(p)}
                          className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border text-primary hover:bg-accent hover:text-secondary transition-colors"
                          title="Edit Product"
                        >
                          <Pencil className="h-3.5 w-3.5" />
                        </button>
                        <DeleteButton id={p.id} name={p.name} onDeleted={refresh} />
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      )}

      <p className="rounded-sm border border-dashed border-border bg-accent/30 p-3 text-[11px] text-muted-foreground">
        Products and inventory are managed internally. Ensure unique SKUs and slugs for all
        products.
      </p>

      {(editing || isAdding) && (
        <ProductEditor
          row={editing}
          onClose={() => {
            setEditing(null);
            setIsAdding(false);
          }}
          onSaved={async () => {
            await refresh();
            setEditing(null);
            setIsAdding(false);
          }}
        />
      )}
    </div>
  );
}

function Tile({
  label,
  value,
  tone = "default",
}: {
  label: string;
  value: number | string;
  tone?: "default" | "success" | "warning" | "danger";
}) {
  const accent =
    tone === "success"
      ? "text-success"
      : tone === "warning"
        ? "text-warning-foreground"
        : tone === "danger"
          ? "text-destructive"
          : "text-secondary";
  return (
    <div className="rounded-md border border-border bg-surface p-4 shadow-sm">
      <p className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">
        {label}
      </p>
      <p className={`mt-2 font-display text-2xl font-bold ${accent}`}>{value}</p>
    </div>
  );
}

function BadgeIcon({
  icon: Icon,
  active,
  color,
  tooltip,
}: {
  icon: any;
  active: boolean;
  color: string;
  tooltip: string;
}) {
  return (
    <div
      className={`flex h-7 w-7 items-center justify-center rounded-full border border-border ${active ? `bg-accent/50 ${color}` : "bg-transparent text-muted-foreground/20"}`}
      title={tooltip}
    >
      <Icon className="h-3.5 w-3.5" />
    </div>
  );
}

function DeleteButton({
  id,
  name,
  onDeleted,
}: {
  id: string;
  name: string;
  onDeleted: () => Promise<void>;
}) {
  const [confirming, setConfirming] = useState(false);
  const [loading, setLoading] = useState(false);

  const onDelete = async (hard: boolean) => {
    setLoading(true);
    try {
      if (hard) {
        await deleteProduct(id);
        toast.success("Product deleted permanently");
      } else {
        await archiveProduct(id);
        toast.success("Product archived successfully");
      }
      await onDeleted();
      setConfirming(false);
    } catch (err) {
      toast.error("Action failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <button
        onClick={() => setConfirming(true)}
        className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-border text-muted-foreground hover:bg-destructive/10 hover:text-destructive transition-colors"
        title="Delete/Archive Product"
      >
        <Trash2 className="h-3.5 w-3.5" />
      </button>

      {confirming && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm">
          <div className="w-full max-w-md rounded-md border border-border bg-surface p-6 shadow-2xl animate-in zoom-in-95 duration-200">
            <div className="flex h-12 w-12 items-center justify-center rounded-full bg-destructive/10 text-destructive mb-4">
              <AlertTriangle className="h-6 w-6" />
            </div>
            <h3 className="font-display text-lg font-bold text-primary">Confirm Action</h3>
            <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
              Are you sure you want to remove{" "}
              <span className="font-semibold text-primary">{name}</span>? We recommend{" "}
              <span className="font-semibold">Archiving</span> instead of permanent deletion if the
              product has sales history.
            </p>
            <div className="mt-6 flex flex-col gap-2">
              <button
                disabled={loading}
                onClick={() => onDelete(false)}
                className="w-full rounded-sm bg-secondary py-2.5 text-sm font-bold uppercase tracking-wider text-secondary-foreground hover:bg-secondary/90 disabled:opacity-50"
              >
                {loading ? "Processing…" : "Archive (Recommended)"}
              </button>
              <button
                disabled={loading}
                onClick={() => onDelete(true)}
                className="w-full rounded-sm border border-destructive py-2.5 text-sm font-bold uppercase tracking-wider text-destructive hover:bg-destructive/10 disabled:opacity-50"
              >
                Delete Permanently
              </button>
              <button
                disabled={loading}
                onClick={() => setConfirming(false)}
                className="mt-2 w-full py-2 text-xs font-semibold text-muted-foreground hover:text-primary transition-colors"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

/* ---------------- Product Editor Drawer ---------------- */
function ProductEditor({
  row,
  onClose,
  onSaved,
}: {
  row: AdminProductRow | null;
  onClose: () => void;
  onSaved: () => Promise<void>;
}) {
  const isNew = !row;
  const [formData, setFormData] = useState<Partial<AdminProductRow>>(
    row || {
      name: "",
      sku: "",
      slug: "",
      category: "",
      costPrice: 0,
      sellingPrice: 0,
      stockQuantity: 0,
      minStock: 5,
      status: "active",
      visible: true,
      featured: false,
      warranty: "",
      shortDescription: "",
      description: "",
      gallery: [],
      specsCount: 0,
    },
  );

  const [specs, setSpecs] = useState<{ spec_name: string; spec_value: string }[]>([]);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(false);
  const [activeTab, setActiveTab] = useState<
    "basic" | "pricing" | "inventory" | "ecommerce" | "images" | "specs"
  >("basic");
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (row && row.id) {
      setLoading(true);
      fetchAdminProduct(row.id)
        .then((full) => {
          setFormData((prev) => ({ ...prev, ...full }));
          if (full.specs) {
            setSpecs(full.specs.map((s) => ({ spec_name: s.label, spec_value: s.value })));
          }
        })
        .catch(() => toast.error("Failed to fetch full details"))
        .finally(() => setLoading(false));
    }
  }, [row]);

  const onUpload = async (file: File) => {
    if (isNew) {
      toast.info("Save basic info first to upload images");
      return;
    }
    try {
      const res = await uploadProductImage(row!.id, file);
      setFormData((prev) => ({
        ...prev,
        image: res.url,
        gallery: [...(prev.gallery || []), res.url],
      }));
      toast.success("Image uploaded");
    } catch (err: any) {
      const msg = err?.message || err?.data?.message || "Upload failed";
      toast.error(msg);
      console.error("Image upload error:", err);
    }
  };

  const onSave = async () => {
    if (!formData.name || !formData.sku || !formData.category) {
      toast.error("Name, SKU, and Category are required");
      return;
    }
    setSaving(true);
    try {
      const payload: ProductPayload = {
        name: formData.name!,
        sku: formData.sku!,
        slug: formData.slug || formData.name!.toLowerCase().replace(/ /g, "-"),
        category: formData.category!,
        cost_price: formData.costPrice!,
        selling_price: formData.sellingPrice!,
        discount_price: formData.discountPrice,
        stock_quantity: formData.stockQuantity!,
        minimum_stock: formData.minStock!,
        maximum_stock: formData.maxStock,
        status: formData.status!,
        is_visible_online: formData.visible!,
        is_featured: formData.featured!,
        short_description: formData.shortDescription || "",
        full_description: formData.description || "",
        warranty_info: formData.warranty || "",
      };

      if (isNew) {
        const newProduct = await createProduct(payload);
        if (specs.length > 0) {
          await updateProductSpecifications(newProduct.id, specs);
        }
        toast.success("Product created successfully");
      } else {
        await updateProduct(row!.id, payload);
        await updateProductSpecifications(row!.id, specs);
        toast.success("Product updated successfully");
      }
      await onSaved();
    } catch (err: any) {
      toast.error(err.message || "Save failed");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex overflow-hidden">
      <div className="flex-1 bg-black/40 backdrop-blur-sm transition-opacity" onClick={onClose} />
      <aside className="flex w-full max-w-2xl flex-col bg-surface shadow-2xl animate-in slide-in-from-right duration-300">
        <header className="sticky top-0 flex items-center justify-between border-b border-border bg-surface px-6 py-5">
          <div className="flex items-center gap-3">
            <div
              className={`flex h-10 w-10 items-center justify-center rounded-full ${isNew ? "bg-secondary/10 text-secondary" : "bg-primary/10 text-primary"}`}
            >
              {isNew ? <Plus className="h-5 w-5" /> : <Pencil className="h-5 w-5" />}
            </div>
            <div>
              <p className="text-[10px] font-bold uppercase tracking-widest text-secondary">
                {isNew ? "Create New" : "Edit Product"}
              </p>
              <h2 className="font-display text-xl font-bold text-primary">
                {isNew ? "New Product" : formData.name}
              </h2>
            </div>
          </div>
          <button
            onClick={onClose}
            className="flex h-10 w-10 items-center justify-center rounded-full hover:bg-accent transition-colors"
          >
            <X className="h-5 w-5" />
          </button>
        </header>

        <nav className="flex border-b border-border bg-accent/20 px-4 overflow-x-auto no-scrollbar">
          <Tab
            active={activeTab === "basic"}
            onClick={() => setActiveTab("basic")}
            icon={Layers}
            label="Basic"
          />
          <Tab
            active={activeTab === "pricing"}
            onClick={() => setActiveTab("pricing")}
            icon={DollarSign}
            label="Pricing"
          />
          <Tab
            active={activeTab === "inventory"}
            onClick={() => setActiveTab("inventory")}
            icon={Package}
            label="Inventory"
          />
          <Tab
            active={activeTab === "ecommerce"}
            onClick={() => setActiveTab("ecommerce")}
            icon={Globe}
            label="Ecommerce"
          />
          <Tab
            active={activeTab === "images"}
            onClick={() => setActiveTab("images")}
            icon={ImageIcon}
            label="Images"
          />
          <Tab
            active={activeTab === "specs"}
            onClick={() => setActiveTab("specs")}
            icon={Tag}
            label="Specs"
          />
        </nav>

        <div className="flex-1 overflow-y-auto p-4 sm:p-6 space-y-6 relative">
          {loading && (
            <div className="absolute inset-0 z-10 flex items-center justify-center bg-surface/50 backdrop-blur-[2px]">
              <div className="h-8 w-8 animate-spin rounded-full border-4 border-secondary border-t-transparent" />
            </div>
          )}
          {activeTab === "basic" && (
            <div className="space-y-4 animate-in fade-in duration-300">
              <Field label="Product Name" required>
                <input
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="e.g. 5KVA Hybrid Inverter"
                  className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                />
              </Field>
              <div className="grid grid-cols-2 gap-4">
                <Field label="SKU" required>
                  <input
                    value={formData.sku}
                    onChange={(e) => setFormData({ ...formData, sku: e.target.value })}
                    placeholder="YT-INV-5K"
                    className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm font-mono focus:border-secondary focus:outline-none"
                  />
                </Field>
                <Field label="Slug">
                  <input
                    value={formData.slug}
                    onChange={(e) => setFormData({ ...formData, slug: e.target.value })}
                    placeholder="5kva-hybrid-inverter"
                    className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm font-mono focus:border-secondary focus:outline-none"
                  />
                </Field>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <Field label="Category" required>
                  <select
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    className="h-[42px] w-full rounded-sm border border-border bg-background px-4 text-sm focus:border-secondary focus:outline-none"
                  >
                    <option value="" disabled>Select a category</option>
                    <option value="Solar Products">Solar Products</option>
                    <option value="Inverters">Inverters</option>
                    <option value="Batteries">Batteries</option>
                    <option value="CCTV Cameras">CCTV Cameras</option>
                    <option value="Networking Devices">Networking Devices</option>
                    <option value="IT Equipment">IT Equipment</option>
                  </select>
                </Field>
                <Field label="Status">
                  <select
                    value={formData.status}
                    onChange={(e) => setFormData({ ...formData, status: e.target.value as any })}
                    className="h-10 w-full rounded-sm border border-border bg-background px-3 text-sm focus:border-secondary focus:outline-none"
                  >
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                    <option value="archived">Archived</option>
                  </select>
                </Field>
              </div>
              <Field label="Short Description">
                <textarea
                  value={formData.shortDescription}
                  onChange={(e) => setFormData({ ...formData, shortDescription: e.target.value })}
                  rows={2}
                  className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                />
              </Field>
              <Field label="Full Description">
                <textarea
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  rows={6}
                  className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                />
              </Field>
            </div>
          )}

          {activeTab === "pricing" && (
            <div className="space-y-4 animate-in fade-in duration-300">
              <div className="grid grid-cols-2 gap-4">
                <Field label="Cost Price" required>
                  <div className="relative">
                    <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground font-semibold">
                      ₦
                    </span>
                    <input
                      type="number"
                      value={formData.costPrice}
                      onChange={(e) =>
                        setFormData({ ...formData, costPrice: Number(e.target.value) })
                      }
                      className="w-full rounded-sm border border-border bg-background pl-8 pr-4 py-2.5 text-sm font-semibold focus:border-secondary focus:outline-none"
                    />
                  </div>
                </Field>
                <Field label="Selling Price" required>
                  <div className="relative">
                    <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground font-semibold">
                      ₦
                    </span>
                    <input
                      type="number"
                      value={formData.sellingPrice}
                      onChange={(e) =>
                        setFormData({ ...formData, sellingPrice: Number(e.target.value) })
                      }
                      className="w-full rounded-sm border border-border bg-background pl-8 pr-4 py-2.5 text-sm font-bold text-secondary focus:border-secondary focus:outline-none"
                    />
                  </div>
                </Field>
              </div>
              <Field label="Discount Price (Optional)">
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground font-semibold">
                    ₦
                  </span>
                  <input
                    type="number"
                    value={formData.discountPrice || ""}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        discountPrice: e.target.value ? Number(e.target.value) : undefined,
                      })
                    }
                    className="w-full rounded-sm border border-border bg-background pl-8 pr-4 py-2.5 text-sm font-semibold focus:border-secondary focus:outline-none"
                  />
                </div>
              </Field>
              <div className="rounded-sm border border-dashed border-border bg-accent/20 p-4">
                <p className="text-xs text-muted-foreground flex items-center gap-2">
                  <DollarSign className="h-3 w-3" /> Profit Margin:
                  <span className="font-bold text-success ml-auto">
                    {NGN(formData.sellingPrice! - formData.costPrice!)}(
                    {(
                      ((formData.sellingPrice! - formData.costPrice!) / formData.costPrice!) *
                      100
                    ).toFixed(1)}
                    %)
                  </span>
                </p>
              </div>
            </div>
          )}

          {activeTab === "inventory" && (
            <div className="space-y-4 animate-in fade-in duration-300">
              <div className="grid grid-cols-2 gap-4">
                <Field label="Current Stock" required>
                  <input
                    type="number"
                    value={formData.stockQuantity}
                    onChange={(e) =>
                      setFormData({ ...formData, stockQuantity: Number(e.target.value) })
                    }
                    className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm font-bold focus:border-secondary focus:outline-none"
                  />
                </Field>
                <Field label="Min Stock Level (Alert)">
                  <input
                    type="number"
                    value={formData.minStock}
                    onChange={(e) => setFormData({ ...formData, minStock: Number(e.target.value) })}
                    className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                  />
                </Field>
              </div>
              <Field label="Max Stock Level (Optional)">
                <input
                  type="number"
                  value={formData.maxStock || ""}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      maxStock: e.target.value ? Number(e.target.value) : undefined,
                    })
                  }
                  className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                />
              </Field>

              {!isNew && (
                <div className="mt-8 space-y-4">
                  <h4 className="flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-primary">
                    <History className="h-3.5 w-3.5" /> Stock Adjustment
                  </h4>
                  <StockAdjuster
                    productId={row!.id}
                    currentStock={formData.stockQuantity!}
                    onAdjusted={(newStock) => setFormData({ ...formData, stockQuantity: newStock })}
                  />
                </div>
              )}
            </div>
          )}

          {activeTab === "ecommerce" && (
            <div className="space-y-6 animate-in fade-in duration-300">
              <div className="grid grid-cols-2 gap-4">
                <Toggle
                  label="Visible Online"
                  checked={formData.visible!}
                  onChange={(v) => setFormData({ ...formData, visible: v })}
                  description="Show product in the public shop."
                />
                <Toggle
                  label="Featured Product"
                  checked={formData.featured!}
                  onChange={(v) => setFormData({ ...formData, featured: v })}
                  description="Highlight in homepage carousels."
                />
              </div>
              <Field label="Warranty Information">
                <input
                  value={formData.warranty}
                  onChange={(e) => setFormData({ ...formData, warranty: e.target.value })}
                  placeholder="e.g. 24 Months Manufacturer Warranty"
                  className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                />
              </Field>
            </div>
          )}

          {activeTab === "images" && (
            <div className="space-y-6 animate-in fade-in duration-300">
              <Field label="Product Gallery">
                <div className="grid grid-cols-4 gap-3">
                  {formData.gallery?.map((img, i) => (
                    <div
                      key={i}
                      className="group relative aspect-square rounded-sm border border-border bg-accent/20 overflow-hidden"
                    >
                      <img src={img} alt="" className="h-full w-full object-cover" />
                      <div className="absolute inset-0 flex items-center justify-center gap-2 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity">
                        <button
                          onClick={async () => {
                            try {
                              await setPrimaryProductImage(row!.id, img);
                              setFormData(prev => ({ ...prev, image: img }));
                              toast.success("Primary image updated");
                            } catch (e) {
                              toast.error("Failed to set primary image");
                            }
                          }}
                          className={`rounded-full p-1.5 ${formData.image === img ? "bg-secondary text-white" : "bg-white/20 text-white hover:bg-white/40"}`}
                        >
                          <Star className="h-3 w-3" />
                        </button>
                        <button
                          onClick={async () => {
                            try {
                              await deleteProductImage(img);
                              setFormData(prev => ({
                                ...prev,
                                gallery: prev.gallery?.filter(g => g !== img),
                                image: prev.image === img ? (prev.gallery?.find(g => g !== img) || "") : prev.image
                              }));
                              toast.success("Image deleted");
                            } catch (e) {
                              toast.error("Failed to delete image");
                            }
                          }}
                          className="rounded-full bg-destructive/80 p-1.5 text-white hover:bg-destructive"
                        >
                          <Trash2 className="h-3 w-3" />
                        </button>
                      </div>
                      {formData.image === img && (
                        <div className="absolute left-1 top-1 rounded-full bg-secondary px-1.5 py-0.5 text-[8px] font-bold text-white uppercase">
                          Primary
                        </div>
                      )}
                    </div>
                  ))}
                  <button
                    onClick={() => fileRef.current?.click()}
                    className="flex aspect-square flex-col items-center justify-center gap-2 rounded-sm border-2 border-dashed border-border bg-accent/10 text-muted-foreground hover:bg-accent/20 hover:text-primary transition-all"
                  >
                    <Plus className="h-5 w-5" />
                    <span className="text-[10px] font-bold uppercase tracking-wider">
                      Add Image
                    </span>
                  </button>
                </div>
              </Field>
              <input
                ref={fileRef}
                type="file"
                accept="image/*"
                className="hidden"
                onChange={(e) => e.target.files?.[0] && onUpload(e.target.files[0])}
              />
            </div>
          )}

          {activeTab === "specs" && (
            <div className="space-y-4 animate-in fade-in duration-300">
              <h4 className="text-xs font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-2">
                <Tag className="h-3.5 w-3.5" /> Technical Specifications
              </h4>
              <div className="space-y-3">
                {specs.map((s, i) => (
                  <div
                    key={i}
                    className="grid grid-cols-[1fr,1fr,auto] items-end gap-3 rounded-sm border border-border bg-accent/5 p-3"
                  >
                    <Field label="Spec Name">
                      <input
                        value={s.spec_name}
                        onChange={(e) => {
                          const newSpecs = [...specs];
                          newSpecs[i].spec_name = e.target.value;
                          setSpecs(newSpecs);
                        }}
                        placeholder="Capacity"
                        className="w-full rounded-sm border border-border bg-background px-3 py-1.5 text-xs focus:border-secondary focus:outline-none"
                      />
                    </Field>
                    <Field label="Value">
                      <input
                        value={s.spec_value}
                        onChange={(e) => {
                          const newSpecs = [...specs];
                          newSpecs[i].spec_value = e.target.value;
                          setSpecs(newSpecs);
                        }}
                        placeholder="5KVA"
                        className="w-full rounded-sm border border-border bg-background px-3 py-1.5 text-xs font-semibold focus:border-secondary focus:outline-none"
                      />
                    </Field>
                    <button
                      onClick={() => setSpecs(specs.filter((_, idx) => idx !== i))}
                      className="flex h-8 w-8 items-center justify-center rounded-sm text-muted-foreground hover:bg-destructive/10 hover:text-destructive transition-colors"
                    >
                      <Trash2 className="h-3.5 w-3.5" />
                    </button>
                  </div>
                ))}
                <button
                  onClick={() => setSpecs([...specs, { spec_name: "", spec_value: "" }])}
                  className="flex w-full items-center justify-center gap-2 rounded-sm border border-dashed border-border py-3 text-xs font-bold uppercase tracking-widest text-muted-foreground hover:bg-accent/20 hover:text-primary transition-all"
                >
                  <Plus className="h-4 w-4" /> Add Specification Row
                </button>
              </div>
            </div>
          )}
        </div>

        <footer className="sticky bottom-0 border-t border-border bg-surface p-6 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.1)]">
          <div className="flex gap-3">
            <button
              onClick={onClose}
              className="flex-1 rounded-sm border border-border py-3 text-sm font-bold uppercase tracking-widest text-primary hover:bg-accent transition-colors"
            >
              Cancel
            </button>
            <button
              onClick={onSave}
              disabled={saving}
              className="flex-[2] rounded-sm bg-cta py-3 text-sm font-black uppercase tracking-[0.1em] text-cta-foreground hover:bg-cta/90 disabled:opacity-50 shadow-lg shadow-cta/20 flex items-center justify-center gap-2 transition-all"
            >
              {saving ? (
                <>
                  <div className="h-4 w-4 animate-spin rounded-full border-2 border-white/30 border-t-white" />
                  Saving…
                </>
              ) : (
                <>
                  <CheckCircle2 className="h-4 w-4" />
                  {isNew ? "Create Product" : "Save Changes"}
                </>
              )}
            </button>
          </div>
        </footer>
      </aside>
    </div>
  );
}

function StockAdjuster({
  productId,
  currentStock,
  onAdjusted,
}: {
  productId: string;
  currentStock: number;
  onAdjusted: (n: number) => void;
}) {
  const [type, setType] = useState<StockAdjustmentPayload["adjustment_type"]>("increase");
  const [qty, setQty] = useState(1);
  const [notes, setNotes] = useState("");
  const [busy, setBusy] = useState(false);

  const onSubmit = async () => {
    setBusy(true);
    try {
      const res = await adjustProductStock(productId, {
        adjustment_type: type,
        quantity: qty,
        notes,
      });
      onAdjusted(res.stock_quantity);
      toast.success("Stock adjusted");
      setQty(1);
      setNotes("");
    } catch {
      toast.error("Adjustment failed");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="space-y-3 rounded-md border border-border bg-accent/10 p-4">
      <div className="grid grid-cols-2 gap-3">
        <select
          value={type}
          onChange={(e) => setType(e.target.value as any)}
          className="h-9 rounded-sm border border-border bg-background px-2 text-xs font-semibold focus:outline-none"
        >
          <option value="increase">Add Stock (+)</option>
          <option value="decrease">Remove Stock (-)</option>
          <option value="correction">Inventory Correction</option>
          <option value="set">Set Absolute Value</option>
        </select>
        <input
          type="number"
          min={1}
          value={qty}
          onChange={(e) => setQty(Number(e.target.value))}
          className="h-9 rounded-sm border border-border bg-background px-3 text-sm font-bold focus:outline-none"
        />
      </div>
      <input
        value={notes}
        onChange={(e) => setNotes(e.target.value)}
        placeholder="Reason for adjustment (optional)"
        className="h-9 w-full rounded-sm border border-border bg-background px-3 text-xs focus:outline-none"
      />
      <button
        disabled={busy}
        onClick={onSubmit}
        className="w-full rounded-sm bg-primary py-2 text-[10px] font-black uppercase tracking-widest text-primary-foreground hover:bg-primary/90 disabled:opacity-50"
      >
        {busy ? "Applying…" : "Apply Adjustment"}
      </button>
    </div>
  );
}

function Tab({
  active,
  onClick,
  icon: Icon,
  label,
}: {
  active: boolean;
  onClick: () => void;
  icon: any;
  label: string;
}) {
  return (
    <button
      onClick={onClick}
      className={`flex items-center gap-2 border-b-2 px-4 py-3 text-[10px] font-bold uppercase tracking-widest transition-all whitespace-nowrap ${
        active
          ? "border-secondary text-secondary bg-surface shadow-[0_4px_0_-2px_white]"
          : "border-transparent text-muted-foreground hover:text-primary"
      }`}
    >
      <Icon className={`h-3.5 w-3.5 ${active ? "text-secondary" : "text-muted-foreground/50"}`} />
      {label}
    </button>
  );
}

function Field({
  label,
  required,
  children,
}: {
  label: string;
  required?: boolean;
  children: React.ReactNode;
}) {
  return (
    <div className="space-y-1.5">
      <label className="flex items-center gap-1 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
        {label}
        {required && <span className="text-destructive">*</span>}
      </label>
      {children}
    </div>
  );
}

function Toggle({
  label,
  description,
  checked,
  onChange,
}: {
  label: string;
  description?: string;
  checked: boolean;
  onChange: (v: boolean) => void;
}) {
  return (
    <div
      className={`flex cursor-pointer items-start justify-between gap-4 rounded-sm border p-4 transition-all ${
        checked ? "border-secondary/50 bg-secondary/5 shadow-sm" : "border-border bg-background"
      }`}
      onClick={() => onChange(!checked)}
    >
      <div className="flex-1">
        <p className="text-xs font-bold text-primary">{label}</p>
        {description && (
          <p className="mt-0.5 text-[10px] text-muted-foreground leading-tight">{description}</p>
        )}
      </div>
      <div
        className={`relative h-5 w-9 shrink-0 rounded-full transition-colors ${checked ? "bg-secondary" : "bg-muted"}`}
      >
        <div
          className={`absolute top-1 h-3 w-3 rounded-full bg-white transition-all ${checked ? "left-5" : "left-1"}`}
        />
      </div>
    </div>
  );
}
