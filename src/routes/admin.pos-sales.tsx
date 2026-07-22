import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useMemo, useRef, useState } from "react";
import {
  Search,
  Trash2,
  ShoppingCart,
  User,
  CreditCard,
  FileText,
  Truck,
  CheckCircle2,
  PackageSearch,
  X,
  UserPlus,
} from "lucide-react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { NGN } from "@/lib/format";
import { apiDateMs } from "@/lib/dates";
import { useAuthStore } from "@/stores/auth";
import { ReceiptModal } from "@/components/common/ReceiptModal";
import { InvoicePreviewModal } from "@/components/common/InvoicePreviewModal";
import { type Order } from "@/api/orders";
import {
  createPosSale,
  fetchAdminProducts,
  fetchSettings,
  searchCustomers,
  type AdminProductRow,
  type CreatePosSalePayload,
  type AdminSettings,
  type AdminCustomer,
} from "@/api/admin";

type PosCartItem = {
  productId: string;
  name: string;
  sku: string;
  price: number;
  qty: number;
  stock: number;
};

export const Route = createFileRoute("/admin/pos-sales")({
  component: AdminPosSalesPage,
  head: () => ({ meta: [{ title: "POS Sales - Admin" }] }),
});

function AdminPosSalesPage() {
  const user = useAuthStore((s) => s.user);

  // Products
  const [products, setProducts] = useState<AdminProductRow[] | null>(null);
  const [q, setQ] = useState("");
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const searchRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  // Cart
  const [cart, setCart] = useState<PosCartItem[]>([]);
  const [saving, setSaving] = useState(false);

  // Customer search
  const [customerQ, setCustomerQ] = useState("");
  const [customerDropdownOpen, setCustomerDropdownOpen] = useState(false);
  const [customerSuggestions, setCustomerSuggestions] = useState<AdminCustomer[]>([]);
  const [selectedCustomer, setSelectedCustomer] = useState<AdminCustomer | null>(null);
  const customerSearchRef = useRef<HTMLDivElement>(null);
  const customerTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const customerSeqRef = useRef(0);

  // Sale form
  const [paymentMethod, setPaymentMethod] = useState<CreatePosSalePayload["payment_method"]>("cash");
  const [paymentStatus, setPaymentStatus] = useState<CreatePosSalePayload["payment_status"]>("success");
  const [settings, setSettings] = useState<AdminSettings | null>(null);
  const [deliveryFee, setDeliveryFee] = useState(0);
  const [notes, setNotes] = useState("");

  // Modals
  const [receiptModalOpen, setReceiptModalOpen] = useState(false);
  const [receiptOrder, setReceiptOrder] = useState<Order | null>(null);
  const [invoiceModalOpen, setInvoiceModalOpen] = useState(false);
  const [invoicePreviewData, setInvoicePreviewData] = useState<any>(null);

  useEffect(() => {
    fetchAdminProducts().then(setProducts);
    fetchSettings().then((res) => setSettings(res.settings));
  }, []);

  // Close dropdowns on outside click
  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (searchRef.current && !searchRef.current.contains(e.target as Node)) {
        setDropdownOpen(false);
      }
      if (customerSearchRef.current && !customerSearchRef.current.contains(e.target as Node)) {
        setCustomerDropdownOpen(false);
      }
    };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  // Product suggestions (local filter)
  const suggestions = useMemo(() => {
    if (!products || q.trim() === "") return [];
    const query = q.trim().toLowerCase();
    return products
      .filter(
        (p) =>
          p.status === "active" &&
          (p.name.toLowerCase().includes(query) ||
            p.sku.toLowerCase().includes(query) ||
            p.posId.toLowerCase().includes(query)),
      )
      .slice(0, 8);
  }, [products, q]);

  // Customer search (debounced API)
  const handleCustomerSearch = (value: string) => {
    setCustomerQ(value);
    if (customerTimerRef.current) clearTimeout(customerTimerRef.current);
    if (value.trim().length < 2) {
      setCustomerSuggestions([]);
      setCustomerDropdownOpen(false);
      return;
    }
    const seq = ++customerSeqRef.current;
    customerTimerRef.current = setTimeout(async () => {
      try {
        const results = await searchCustomers(value.trim());
        if (seq !== customerSeqRef.current) return;
        setCustomerSuggestions(results);
        setCustomerDropdownOpen(results.length > 0);
      } catch (e: any) {
        if (seq !== customerSeqRef.current) return;
        setCustomerSuggestions([]);
        setCustomerDropdownOpen(false);
        toast.error(e?.message || "Customer search failed. Is the backend running?");
      }
    }, 300);
  };

  const selectCustomer = (c: AdminCustomer) => {
    setSelectedCustomer(c);
    setCustomerQ(c.full_name);
    setCustomerDropdownOpen(false);
    setCustomerSuggestions([]);
  };

  const clearCustomer = () => {
    setSelectedCustomer(null);
    setCustomerQ("");
    setCustomerSuggestions([]);
    setCustomerDropdownOpen(false);
  };

  // Cart math
  const subtotal = useMemo(() => cart.reduce((sum, i) => sum + i.price * i.qty, 0), [cart]);
  const taxRate = settings?.tax?.vatEnabled ? settings.tax.vatPercent / 100 : 0;
  const tax = subtotal * taxRate;
  const discount = 0;
  const total = Math.max(0, subtotal + tax + deliveryFee - discount);

  const addToCart = (p: AdminProductRow) => {
    const stock = Math.max(0, Number(p.stockQuantity ?? 0));
    if (stock <= 0) {
      toast.error("This product is out of stock");
      return;
    }
    setCart((prev) => {
      const idx = prev.findIndex((c) => c.productId === p.posId);
      if (idx >= 0) {
        const next = [...prev];
        next[idx] = { ...next[idx], qty: Math.min(stock, next[idx].qty + 1) };
        return next;
      }
      return [...prev, { productId: p.posId, name: p.name, sku: p.sku, price: Number(p.sellingPrice ?? 0), qty: 1, stock }];
    });
    setQ("");
    setDropdownOpen(false);
    inputRef.current?.focus();
  };

  const updateQty = (productId: string, qty: number) => {
    const nextQty = Number.isFinite(qty) ? Math.trunc(qty) : 1;
    setCart((prev) =>
      prev
        .map((i) => (i.productId === productId ? { ...i, qty: Math.max(1, Math.min(i.stock, nextQty)) } : i))
        .filter((i) => i.qty > 0),
    );
  };

  const removeItem = (productId: string) => {
    setCart((prev) => prev.filter((i) => i.productId !== productId));
  };

  const completeSale = async () => {
    if (!user?.id) {
      toast.error("Missing authenticated user");
      return;
    }
    if (cart.length === 0) {
      toast.error("Add at least one product to complete sale");
      return;
    }
    const actorId = Number(user.id);
    if (!Number.isFinite(actorId) || actorId <= 0) {
      toast.error("Invalid admin/staff user id");
      return;
    }

    const payload: CreatePosSalePayload = {
      created_by: user.role === "admin" ? "admin" : "staff",
      created_by_user_id: actorId,
      customer_id: selectedCustomer?.id || null,
      customer_name: selectedCustomer?.full_name || "Walk-in customer",
      customer_phone: selectedCustomer?.phone || undefined,
      payment_method: paymentMethod,
      payment_status: paymentStatus,
      order_status: paymentStatus === "success" ? "paid" : "awaiting_payment",
      tax: Number(tax || 0),
      discount: Number(discount || 0),
      delivery_fee: Number(deliveryFee || 0),
      notes: notes.trim() || undefined,
      items: cart.map((i) => ({
        product_id: i.productId,
        quantity: i.qty,
        unit_price: i.price,
      })),
    };

    setSaving(true);
    try {
      const res = await createPosSale(payload);
      const saleOrderNumber = res?.order?.order_number ?? "success";

      if (res?.order) {
        const orderData = res.order;
        const paymentData = res.payment || {};
        const itemsData = res.items || [];

        const mappedOrder: Order = {
          id: orderData.order_number,
          reference: paymentData.reference || orderData.order_number,
          customerEmail: orderData.customer_email || "",
          customerName: orderData.customer_name || "",
          subtotal: Number(orderData.subtotal ?? 0),
          vat: Number(orderData.tax_amount ?? orderData.tax ?? 0),
          deliveryFee: Number(orderData.delivery_fee ?? 0),
          total: Number(orderData.total_amount ?? 0),
          status: orderData.order_status || "paid",
          paymentStatus: orderData.payment_status || "success",
          items: itemsData.map((it: any) => ({
            sku: it.product_id || it.sku || "UNKNOWN",
            name: it.product_name_snapshot || it.product_name || it.name || "Product",
            qty: Number(it.quantity || it.qty || 1),
            price: Number(it.unit_price_snapshot || it.unit_price || it.price || 0),
          })),
          createdAt: apiDateMs(orderData.created_at),
          itemCount: itemsData.reduce((acc: number, curr: any) => acc + Number(curr.quantity || curr.qty || 0), 0) || 1,
        };

        setReceiptOrder(mappedOrder);
        setReceiptModalOpen(true);
      } else {
        toast.success(`POS sale created: ${saleOrderNumber}`);
      }

      setCart([]);
      clearCustomer();
      setDeliveryFee(0);
      setNotes("");
      setProducts(await fetchAdminProducts());
    } catch (e: any) {
      toast.error(e?.message || "Failed to create POS sale");
    } finally {
      setSaving(false);
    }
  };

  const generateInvoice = () => {
    if (cart.length === 0) {
      toast.error("Add at least one product to generate an invoice");
      return;
    }
    setInvoicePreviewData({
      customerName: selectedCustomer?.full_name || "Walk-in customer",
      customerEmail: "",
      customerPhone: selectedCustomer?.phone || "",
      items: cart.map((i) => ({ name: i.name, sku: i.sku, qty: i.qty, price: i.price })),
      subtotal,
      vat: tax,
      deliveryFee,
      total,
      fulfillmentMethod: "pickup" as const,
    });
    setInvoiceModalOpen(true);
  };

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="POS"
        title="Create POS Sale"
        description="Search and add products, select a customer, then complete the sale."
      />

      {/* Product Search — full width, prominent */}
      <div ref={searchRef} className="relative">
        <div
          className={[
            "flex items-center gap-2 rounded-sm border bg-surface px-4 py-0 shadow-sm transition-all",
            dropdownOpen ? "border-secondary ring-2 ring-secondary/20" : "border-border",
          ].join(" ")}
        >
          {!products ? (
            <Search className="h-4 w-4 shrink-0 animate-pulse text-muted-foreground" />
          ) : (
            <Search className="h-4 w-4 shrink-0 text-primary" />
          )}
          <input
            ref={inputRef}
            value={q}
            disabled={!products}
            onChange={(e) => {
              setQ(e.target.value);
              setDropdownOpen(e.target.value.trim().length > 0);
            }}
            onFocus={() => q.trim() && setDropdownOpen(true)}
            placeholder={!products ? "Loading products..." : "Search products by name, SKU, or ID..."}
            className="h-12 flex-1 bg-transparent text-sm placeholder:text-muted-foreground/60 focus:outline-none"
            onKeyDown={(e) => {
              if (e.key === "Enter" && suggestions.length > 0) addToCart(suggestions[0]);
              if (e.key === "Escape") { setDropdownOpen(false); setQ(""); }
            }}
          />
          {q && (
            <button onClick={() => { setQ(""); setDropdownOpen(false); inputRef.current?.focus(); }} className="rounded-sm px-1 text-xs text-muted-foreground hover:text-primary">x</button>
          )}
        </div>
        {dropdownOpen && (
          <div className="absolute left-0 right-0 top-[calc(100%+4px)] z-50 overflow-hidden rounded-sm border border-border bg-surface shadow-xl">
            {suggestions.length === 0 ? (
              <div className="flex items-center gap-3 px-4 py-5 text-sm text-muted-foreground">
                <PackageSearch className="h-4 w-4 shrink-0" />
                No active products match "{q}"
              </div>
            ) : (
              <ul className="max-h-72 divide-y divide-border overflow-auto">
                {suggestions.map((p) => {
                  const alreadyInCart = cart.some((c) => c.productId === p.posId);
                  const outOfStock = p.stockQuantity <= 0;
                  return (
                    <li key={p.posId}>
                      <button
                        disabled={outOfStock}
                        onClick={() => addToCart(p)}
                        className={[
                          "flex w-full items-center gap-3 px-4 py-3 text-left transition-colors",
                          outOfStock ? "cursor-not-allowed opacity-40" : "hover:bg-accent/60",
                        ].join(" ")}
                      >
                        <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-sm bg-primary/10 text-[10px] font-bold text-primary">
                          {p.name.slice(0, 2).toUpperCase()}
                        </div>
                        <div className="min-w-0 flex-1">
                          <p className="truncate text-sm font-semibold text-primary">{p.name}</p>
                          <p className="text-[11px] text-muted-foreground">{p.sku} | Stock: {p.stockQuantity}</p>
                        </div>
                        <div className="shrink-0 text-right">
                          <p className="text-sm font-bold text-primary">{NGN(p.sellingPrice)}</p>
                          {alreadyInCart && <span className="text-[10px] text-secondary">+1 more</span>}
                          {outOfStock && <span className="text-[10px] text-destructive">Out of stock</span>}
                        </div>
                      </button>
                    </li>
                  );
                })}
              </ul>
            )}
          </div>
        )}
      </div>

      {/* Two columns: Form + Cart */}
      <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr),minmax(0,1fr)]">
        {/* Left: Sale Form */}
        <div className="space-y-5">
          {/* Customer */}
          <div className="rounded-sm border border-border bg-surface p-5 shadow-sm">
            <h3 className="mb-4 text-[10px] font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-2">
              <User className="h-3.5 w-3.5" /> Customer
            </h3>
            <div ref={customerSearchRef} className="relative">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <input
                  value={customerQ}
                  onChange={(e) => handleCustomerSearch(e.target.value)}
                  onFocus={() => customerSuggestions.length > 0 && setCustomerDropdownOpen(true)}
                  placeholder="Search customer by name or phone..."
                  className="h-10 w-full rounded-sm border border-border bg-background pl-9 pr-9 text-sm focus:border-secondary focus:outline-none"
                />
                {customerQ && (
                  <button
                    onClick={clearCustomer}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-primary"
                  >
                    <X className="h-4 w-4" />
                  </button>
                )}
              </div>
              {customerDropdownOpen && customerSuggestions.length > 0 && (
                <div className="absolute left-0 right-0 top-full z-50 mt-1 overflow-hidden rounded-sm border border-border bg-surface shadow-xl">
                  <div className="border-b border-border px-3 py-1.5 text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Existing customers
                  </div>
                  <ul className="max-h-48 divide-y divide-border overflow-auto">
                    {customerSuggestions.map((c) => (
                      <li key={`${c.user_id ?? c.id}-${c.phone}`}>
                        <button
                          type="button"
                          onClick={() => selectCustomer(c)}
                          className="flex w-full items-center gap-3 px-3 py-2.5 text-left transition-colors hover:bg-accent/60"
                        >
                          <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-sm bg-primary/10 text-[9px] font-bold text-primary">
                            {(c.full_name || "??").slice(0, 2).toUpperCase()}
                          </div>
                          <div className="min-w-0 flex-1">
                            <p className="truncate text-sm font-semibold text-primary">{c.full_name || "Unknown"}</p>
                            <p className="text-[10px] text-muted-foreground">
                              {c.phone || "No phone"} | {c.total_orders ?? 0} orders | {NGN(c.total_spent ?? 0)}
                            </p>
                          </div>
                        </button>
                      </li>
                    ))}
                  </ul>
                  <button
                    onClick={() => setCustomerDropdownOpen(false)}
                    className="w-full border-t border-border px-3 py-2 text-center text-[11px] font-semibold text-muted-foreground hover:bg-accent/60 hover:text-primary transition-colors"
                  >
                    Continue without selecting
                  </button>
                </div>
              )}
            </div>
            {selectedCustomer && (
              <div className="mt-3 flex items-center gap-2 rounded-sm bg-success/10 border border-success/20 px-3 py-2">
                <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-sm bg-success/20 text-[8px] font-bold text-success">
                  {selectedCustomer.full_name.slice(0, 2).toUpperCase()}
                </div>
                <div className="min-w-0 flex-1">
                  <p className="text-xs font-semibold text-success">{selectedCustomer.full_name}</p>
                  <p className="text-[10px] text-success/70">{selectedCustomer.phone}</p>
                </div>
                <button onClick={clearCustomer} className="text-success/60 hover:text-success">
                  <X className="h-3.5 w-3.5" />
                </button>
              </div>
            )}
            {!selectedCustomer && (
              <p className="mt-2 text-[11px] text-muted-foreground">
                Walk-in customer (no account linked)
              </p>
            )}
          </div>

          {/* Payment */}
          <div className="rounded-sm border border-border bg-surface p-5 shadow-sm">
            <h3 className="mb-4 text-[10px] font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-2">
              <CreditCard className="h-3.5 w-3.5" /> Payment
            </h3>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1.5">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Method</label>
                <select
                  value={paymentMethod}
                  onChange={(e) => setPaymentMethod(e.target.value as CreatePosSalePayload["payment_method"])}
                  className="h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm focus:border-secondary focus:outline-none"
                >
                  <option value="cash">Cash</option>
                  <option value="bank_transfer">Bank Transfer</option>
                  <option value="pos_terminal">POS Terminal</option>
                  <option value="manual_card">Manual Card</option>
                  <option value="paystack">Paystack</option>
                  <option value="other">Other</option>
                </select>
              </div>
              <div className="space-y-1.5">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Status</label>
                <select
                  value={paymentStatus}
                  onChange={(e) => setPaymentStatus(e.target.value as CreatePosSalePayload["payment_status"])}
                  className="h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm focus:border-secondary focus:outline-none"
                >
                  <option value="success">Paid</option>
                  <option value="pending">Pending</option>
                  <option value="failed">Failed</option>
                  <option value="abandoned">Abandoned</option>
                </select>
              </div>
            </div>
          </div>

          {/* Delivery & Notes */}
          <div className="rounded-sm border border-border bg-surface p-5 shadow-sm">
            <h3 className="mb-4 text-[10px] font-bold uppercase tracking-widest text-muted-foreground flex items-center gap-2">
              <Truck className="h-3.5 w-3.5" /> Additional Details
            </h3>
            <div className="space-y-4">
              <div className="space-y-1.5">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Delivery Fee (NGN)</label>
                <input
                  type="number"
                  min={0}
                  value={deliveryFee || ""}
                  onChange={(e) => {
                    const value = Number(e.target.value || 0);
                    setDeliveryFee(Number.isFinite(value) ? Math.max(0, value) : 0);
                  }}
                  placeholder="0"
                  className="h-10 w-full rounded-sm border border-border bg-background px-4 text-sm focus:border-secondary focus:outline-none"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Order Notes</label>
                <textarea
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  placeholder="Any additional info..."
                  rows={2}
                  className="w-full rounded-sm border border-border bg-background px-4 py-2.5 text-sm focus:border-secondary focus:outline-none"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Right: Cart */}
        <div className="rounded-sm border border-border bg-surface shadow-sm">
          <div className="flex items-center justify-between border-b border-border px-5 py-3">
            <div className="flex items-center gap-2">
              <ShoppingCart className="h-4 w-4 text-primary" />
              <span className="text-sm font-bold uppercase tracking-wider text-primary">Cart</span>
            </div>
            {cart.length > 0 && (
              <span className="rounded-sm bg-primary px-2 py-0.5 text-[11px] font-bold text-primary-foreground">
                {cart.length} {cart.length === 1 ? "item" : "items"}
              </span>
            )}
          </div>

          {cart.length === 0 ? (
            <div className="flex flex-col items-center gap-3 py-20 text-muted-foreground">
              <ShoppingCart className="h-12 w-12 opacity-15" />
              <p className="text-sm">No items in cart</p>
              <p className="text-[11px]">Search and add products above</p>
            </div>
          ) : (
            <>
              <ul className="max-h-[420px] divide-y divide-border overflow-auto">
                {cart.map((item) => (
                  <li key={item.productId} className="flex items-center gap-3 px-5 py-3">
                    <div className="min-w-0 flex-1">
                      <p className="truncate text-sm font-semibold text-primary">{item.name}</p>
                      <p className="text-[11px] text-muted-foreground">
                        {item.sku} | {NGN(item.price)} each
                      </p>
                    </div>
                    <input
                      type="number"
                      min={1}
                      max={item.stock}
                      value={item.qty}
                      onChange={(e) => updateQty(item.productId, Number(e.target.value || 1))}
                      className="h-8 w-16 rounded-sm border border-border bg-background px-2 text-center text-sm font-bold text-primary focus:border-secondary focus:outline-none"
                    />
                    <span className="w-24 text-right text-sm font-bold text-primary whitespace-nowrap">
                      {NGN(item.price * item.qty)}
                    </span>
                    <button
                      onClick={() => removeItem(item.productId)}
                      className="inline-flex h-7 w-7 shrink-0 items-center justify-center rounded-sm text-muted-foreground hover:bg-destructive/10 hover:text-destructive transition-colors"
                    >
                      <Trash2 className="h-3.5 w-3.5" />
                    </button>
                  </li>
                ))}
              </ul>

              <div className="space-y-2 border-t border-border px-5 py-4 text-sm">
                <div className="flex justify-between text-muted-foreground">
                  <span>Subtotal</span>
                  <span>{NGN(subtotal)}</span>
                </div>
                {taxRate > 0 && (
                  <div className="flex justify-between text-muted-foreground">
                    <span>VAT ({(taxRate * 100).toFixed(1)}%)</span>
                    <span>{NGN(tax)}</span>
                  </div>
                )}
                {deliveryFee > 0 && (
                  <div className="flex justify-between text-muted-foreground">
                    <span>Delivery</span>
                    <span>{NGN(deliveryFee)}</span>
                  </div>
                )}
                <div className="flex justify-between border-t border-border pt-2 text-base font-bold text-primary">
                  <span>Total</span>
                  <span>{NGN(total)}</span>
                </div>
              </div>
            </>
          )}

          <div className="space-y-2 border-t border-border px-5 py-4">
            <button
              id="pos-complete-sale-btn"
              disabled={saving || cart.length === 0}
              onClick={completeSale}
              className={[
                "flex w-full items-center justify-center gap-2 rounded-sm py-3 text-sm font-black uppercase tracking-[0.1em] transition-all",
                saving || cart.length === 0
                  ? "cursor-not-allowed bg-muted text-muted-foreground opacity-50"
                  : "bg-cta text-cta-foreground shadow-lg shadow-cta/20 hover:bg-cta/90 active:scale-[0.98]",
              ].join(" ")}
            >
              {saving ? (
                <div className="h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent" />
              ) : (
                <CheckCircle2 className="h-4 w-4" />
              )}
              {saving ? "Processing..." : "Create Sale"}
            </button>
            <button
              disabled={saving || cart.length === 0}
              onClick={generateInvoice}
              className={[
                "flex w-full items-center justify-center gap-2 rounded-sm border border-border py-3 text-sm font-bold uppercase tracking-widest transition-all",
                saving || cart.length === 0
                  ? "cursor-not-allowed text-muted-foreground opacity-50"
                  : "text-primary hover:bg-accent",
              ].join(" ")}
            >
              <FileText className="h-4 w-4" />
              Generate Invoice
            </button>
          </div>
        </div>
      </div>

      <ReceiptModal isOpen={receiptModalOpen} onClose={() => setReceiptModalOpen(false)} order={receiptOrder} />
      <InvoicePreviewModal
        isOpen={invoiceModalOpen}
        onClose={() => { setInvoiceModalOpen(false); setInvoicePreviewData(null); }}
        previewData={invoicePreviewData}
      />
    </div>
  );
}
