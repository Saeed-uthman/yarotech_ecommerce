import { apiFetch, ASSET_BASE_URL } from "./client";
import { apiDateMs } from "@/lib/dates";

import type {
  AdminOrder,
  AdminOrderStatus,
  AdminUser,
  UserStatus,
  AdminPayment,
  SupportMessage,
  DeliveryZone,
  AdminSettings,
} from "./mock/admin-db";

export type {
  AdminOrder,
  AdminOrderStatus,
  AdminUser,
  UserStatus,
  AdminPayment,
  SupportMessage,
  DeliveryZone,
  AdminSettings,
};

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

function supportCategoryFromInquiryType(value: string | null | undefined): SupportMessage["category"] {
  const t = String(value || "").toLowerCase();
  if (t.includes("product")) return "product";
  if (t.includes("delivery")) return "delivery";
  if (t.includes("payment")) return "payment";
  if (t.includes("complaint")) return "complaint";
  return "general";
}

function mapSupportMessage(s: any): SupportMessage & {
  updated_at?: string;
  emailSent?: boolean;
  notificationCreated?: boolean;
} {
  return {
    id: String(s.id),
    name: s.full_name || s.name || "",
    email: s.email || "",
    phone: s.phone || "",
    category: s.category || supportCategoryFromInquiryType(s.inquiry_type),
    subject: s.subject || s.service_type || s.inquiry_type || "Support Inquiry",
    body: s.body || s.message || "",
    status: s.status_ui || s.status,
    createdAt: apiDateMs(s.created_at || s.createdAt),
    reply: s.admin_reply ?? s.reply,
    updated_at: s.updated_at,
    emailSent: s.email_sent,
    notificationCreated: s.notification_created,
  };
}

/* =========================================================
 * Customers
 * ========================================================= */
export interface AdminCustomer {
  id: number;
  full_name: string;
  phone: string;
  email: string | null;
  total_orders: number;
  total_spent: number;
  first_order_at: string | null;
  last_order_at: string | null;
  created_at: string;
}

export interface CustomerTransaction {
  id: number;
  order_number: string;
  customer_name: string;
  subtotal: number;
  tax_amount: number;
  delivery_fee: number;
  total_amount: number;
  currency: string;
  order_status: string;
  payment_status: string;
  payment_method: string;
  sale_channel: string;
  payment_reference: string;
  created_at: string;
}

export async function fetchAdminCustomers(
  params: { search?: string; page?: number; per_page?: number } = {},
): Promise<{ items: AdminCustomer[]; pagination: { page: number; per_page: number; total: number } }> {
  try {
    const query = new URLSearchParams();
    if (params.search) query.set("search", params.search);
    if (params.page) query.set("page", String(params.page));
    if (params.per_page) query.set("per_page", String(params.per_page));
    const res = await apiFetch<ApiResponse<any>>(`/admin/customers?${query.toString()}`);
    return res.data;
  } catch {
    return { items: [], pagination: { page: 1, per_page: 20, total: 0 } };
  }
}

export async function fetchAdminCustomer(
  id: number,
): Promise<{ customer: AdminCustomer; transactions: CustomerTransaction[] } | null> {
  try {
    const res = await apiFetch<ApiResponse<any>>(`/admin/customers/show?id=${id}`);
    return res.data;
  } catch {
    return null;
  }
}

export async function searchCustomers(
  q: string,
): Promise<AdminCustomer[]> {
  try {
    const url = `/admin/customers/search?q=${encodeURIComponent(q)}`;
    console.log("[searchCustomers] calling:", url);
    const res = await apiFetch<ApiResponse<any>>(url);
    console.log("[searchCustomers] raw response:", res);
    const raw = res.data;
    const items: any[] = Array.isArray(raw)
      ? raw
      : Array.isArray(raw?.items)
        ? raw.items
        : [];
    console.log("[searchCustomers] parsed items:", items.length);
    return items.map((c: any) => ({
      id: Number(c.id ?? 0),
      full_name: c.full_name || "",
      phone: c.phone || "",
      email: c.email || null,
      total_orders: Number(c.total_orders ?? 0),
      total_spent: Number(c.total_spent ?? 0),
      first_order_at: c.first_order_at ?? null,
      last_order_at: c.last_order_at ?? null,
      created_at: c.created_at ?? "",
    }));
  } catch (e: any) {
    console.error("[searchCustomers] error:", e);
    throw new Error(e?.message || "Failed to search customers");
  }
}

export async function createCustomer(
  data: { full_name: string; phone: string; email?: string },
): Promise<AdminCustomer> {
  const res = await apiFetch<ApiResponse<any>>("/admin/customers/create", {
    method: "POST",
    body: JSON.stringify(data),
  });
  return res.data;
}

export async function updateCustomer(
  id: number,
  data: { full_name: string; phone: string; email?: string },
): Promise<AdminCustomer | null> {
  try {
    const res = await apiFetch<ApiResponse<any>>("/admin/customers/update", {
      method: "POST",
      body: JSON.stringify({ id, ...data }),
    });
    return res.data;
  } catch {
    return null;
  }
}

export async function deleteCustomer(id: number): Promise<boolean> {
  try {
    await apiFetch<ApiResponse<any>>("/admin/customers/delete", {
      method: "POST",
      body: JSON.stringify({ id }),
    });
    return true;
  } catch {
    return false;
  }
}

/* =========================================================
 * Dashboard
 * ========================================================= */
export interface AdminDashboardStats {
  totalProducts: number;
  productsMissingMeta: number;
  totalInventoryUnits: number;
  totalOrders: number;
  ecommerceOrders: number;
  posOrders: number;
  totalCustomers: number;
  totalRevenue: number;
  netProfitPlaceholder: number;
  lowStockCount: number;
  recentPaymentsCount: number;
  supportInboxCount: number;
  unreadNotifications: number;
}

export interface LowStockItem {
  posId: string;
  name: string;
  sku: string;
  stock: number;
  threshold: number;
  severity: "out" | "critical" | "low";
}

export async function fetchAdminDashboard() {
  const res = await apiFetch<ApiResponse<any>>("/admin/dashboard");
  return res.data;
}

/* =========================================================
 * Orders
 * ========================================================= */
export async function fetchAdminOrders(): Promise<AdminOrder[]> {
  try {
    const res = await apiFetch<ApiResponse<any>>("/admin/orders");
    return res.data?.items || [];
  } catch {
    return [];
  }
}

export async function fetchAdminOrder(id: string): Promise<AdminOrder | null> {
  try {
    const res = await apiFetch<ApiResponse<any>>(`/admin/orders/show?id=${encodeURIComponent(id)}`);
    if (!res.data?.order) return null;
    const o = res.data.order;
    return {
      id: o.order_number,
      reference: res.data.payment?.reference || o.order_number,
      customer: {
        id: String(o.user_id),
        name: o.customer_name,
        email: o.customer_email,
        phone: o.delivery_phone || "",
      },
      items: (res.data.items || []).map((i: any) => ({
        posId: i.product_id,
        name: i.product_name,
        sku: i.sku || i.product_id,
        qty: i.quantity,
        price: i.unit_price,
      })),
      subtotal: o.subtotal_amount || o.subtotal || 0,
      deliveryFee: o.delivery_fee,
      vat: o.tax_amount,
      total: o.total_amount,
      status: o.order_status,
      paymentStatus: o.payment_status,
      deliveryMethod: o.delivery_method || "delivery",
      deliveryAddress: o.delivery_address || "",

      createdAt: apiDateMs(o.created_at),
    };
  } catch {
    return null;
  }
}

export async function updateOrderStatus(
  id: string,
  status: AdminOrderStatus,
): Promise<{ ok: true; id: string; status: AdminOrderStatus }> {
  await apiFetch(`/admin/orders/update-status`, {
    method: "POST",
    body: JSON.stringify({ id, order_status: status }),
  });
  return { ok: true, id, status };
}

export interface CreatePosSalePayload {
  created_by: "admin" | "staff" | "user";
  created_by_user_id: number;
  customer_id?: number | null;
  customer_name: string;
  customer_phone?: string;
  customer_email?: string;
  payment_method: "paystack" | "cash" | "bank_transfer" | "pos_terminal" | "manual_card" | "other";
  payment_status: "pending" | "success" | "failed" | "abandoned";
  order_status?: string;
  tax?: number;
  discount?: number;
  delivery_fee?: number;
  notes?: string;
  items: Array<{
    product_id: string;
    quantity: number;
    unit_price?: number;
  }>;
}

export async function createPosSale(payload: CreatePosSalePayload): Promise<any> {
  const res = await apiFetch<ApiResponse<any>>("/admin/orders/create-pos-sale", {
    method: "POST",
    body: JSON.stringify(payload),
  });
  return res.data;
}

/* =========================================================
 * Users
 * ========================================================= */
export async function fetchAdminUsers(): Promise<AdminUser[]> {
  try {
    const res = await apiFetch<ApiResponse<any>>("/admin/users");
    if (!res.data?.items) return [];
    return res.data.items.map((u: any) => ({
      id: String(u.id),
      fullName: u.full_name,
      email: u.email,
      phone: u.phone || "",
      role: u.role,
      status: u.status,
      emailVerified: !!u.email_verified_at,
      ordersCount: u.orders_count || 0,
      totalSpend: u.total_spend || 0,
      lastActiveAt: u.last_login_at ? apiDateMs(u.last_login_at) : 0,
      createdAt: apiDateMs(u.created_at),
    }));
  } catch {
    return [];
  }
}

export async function updateUserStatus(
  id: string,
  status: UserStatus,
): Promise<{ ok: true; id: string; status: UserStatus }> {
  await apiFetch(`/admin/users/update-status`, {
    method: "POST",
    body: JSON.stringify({ id, status }),
  });
  return { ok: true, id, status };
}

/* =========================================================
 * Products / POS enrichment
 * ========================================================= */
export interface AdminProductRow {
  id: string;
  posId: string;
  sku: string;
  slug: string;
  name: string;
  category: string;
  costPrice: number;
  sellingPrice: number;
  discountPrice?: number;
  stockQuantity: number;
  minStock: number;
  maxStock?: number;
  status: "active" | "inactive" | "archived";
  stockStatus: "in_stock" | "low_stock" | "out_of_stock";
  hasMeta: boolean;
  visible: boolean;
  featured: boolean;
  warranty: string;
  image: string;
  gallery: string[];
  shortDescription: string;
  description: string;
  specsCount: number;
  specs?: { label: string; value: string }[];
  rating: number;
  reviewCount: number;
}

export interface AdminProductFilters {
  q?: string;
  category?: string;
  stock_status?: string;
  visible?: boolean;
  featured?: boolean;
  status?: string;
}

export async function fetchAdminProducts(
  params: AdminProductFilters = {},
): Promise<AdminProductRow[]> {
  try {
    const query = new URLSearchParams();
    if (params.q) query.set("search", params.q);
    if (params.category) query.set("category", params.category);
    if (params.stock_status) query.set("stock_status", params.stock_status);
    if (params.visible !== undefined) query.set("is_visible_online", params.visible ? "1" : "0");
    if (params.featured !== undefined) query.set("is_featured", params.featured ? "1" : "0");
    if (params.status) query.set("status", params.status);

    const res = await apiFetch<ApiResponse<any>>(`/admin/products?${query.toString()}`);
    if (!res.data?.items) return [];
    return res.data.items.map(mapAdminProduct);
  } catch {
    return [];
  }
}

function mapAdminProduct(p: any): AdminProductRow {
  return {
    id: String(p.product_id),
    posId: p.product_id || String(p.product_id),
    sku: p.sku,
    slug: p.slug,
    name: p.name,
    category: p.category || "",
    costPrice: Number(p.cost_price ?? 0),
    sellingPrice: Number(p.selling_price ?? 0),
    discountPrice: p.discount_price ? Number(p.discount_price) : undefined,
    stockQuantity: Number(p.stock_quantity ?? 0),
    minStock: Number(p.minimum_stock ?? 0),
    maxStock: p.maximum_stock ? Number(p.maximum_stock) : undefined,
    status: p.status || "active",
    stockStatus: p.stock_status || "in_stock",
    hasMeta: !!p.has_ecommerce_meta,
    visible: !!p.is_visible_online,
    featured: !!p.is_featured,
    warranty: p.warranty_info || "",
    image: p.image_url
      ? p.image_url.startsWith("http")
        ? p.image_url
        : `${ASSET_BASE_URL}${p.image_url}`
      : "",
    gallery: p.images
      ? p.images.map((img: any) =>
          img.image_path.startsWith("http") ? img.image_path : `${ASSET_BASE_URL}${img.image_path}`,
        )
      : [],
    shortDescription: p.short_description || "",
    description: p.full_description || "",
    specsCount: Number(p.specs_count || 0),
    specs: p.specifications
      ? p.specifications.map((s: any) => ({ label: s.spec_name, value: s.spec_value }))
      : undefined,
    rating: Number(p.rating_average || 0),
    reviewCount: Number(p.review_count || 0),
  };
}

export async function fetchAdminProduct(id: string): Promise<AdminProductRow> {
  const res = await apiFetch<ApiResponse<any>>(`/admin/products/${id}`);
  return mapAdminProduct(res.data);
}

export interface ProductPayload {
  name: string;
  sku: string;
  slug: string;
  category: string;
  cost_price: number;
  selling_price: number;
  discount_price?: number;
  stock_quantity: number;
  minimum_stock: number;
  maximum_stock?: number;
  status: string;
  is_visible_online: boolean;
  is_featured: boolean;
  short_description: string;
  full_description: string;
  warranty_info: string;
}

export async function createProduct(payload: ProductPayload): Promise<AdminProductRow> {
  const res = await apiFetch<ApiResponse<any>>("/admin/products/create", {
    method: "POST",
    body: JSON.stringify(payload),
  });
  return mapAdminProduct(res.data);
}

export async function updateProduct(
  id: string,
  payload: Partial<ProductPayload>,
): Promise<AdminProductRow> {
  const res = await apiFetch<ApiResponse<any>>(`/admin/products/update-core`, {
    method: "POST",
    body: JSON.stringify({ ...payload, product_id: id }),
  });
  return mapAdminProduct(res.data);
}

export async function deleteProduct(id: string): Promise<{ success: boolean }> {
  await apiFetch(`/admin/products/${id}`, { method: "DELETE" });
  return { success: true };
}

export async function archiveProduct(id: string): Promise<{ success: boolean }> {
  await apiFetch(`/admin/products/${id}/archive`, { method: "POST" });
  return { success: true };
}

export async function fetchProductsMissingMetadata(): Promise<AdminProductRow[]> {
  const res = await apiFetch<ApiResponse<any>>("/admin/products/missing-meta");
  return res.data.items.map((p: any) => ({
    posId: p.product_id || p.product_id,
    sku: p.sku || p.product_id || p.product_id,
    name: p.name,
    category: p.category || "",
    posPrice: p.price,
    posStock: p.stock_quantity,
    posStatus: p.pos_status || "active",
    hasMeta: false,
    visible: false,
    featured: false,
    warranty: "",
    image: "",
    shortDescription: "",
    description: "",
    specsCount: 0,
    rating: 0,
    reviewCount: 0,
  }));
}

export interface ProductMetadataPatch {
  shortDescription?: string;
  description?: string;
  warranty?: string;
  visible?: boolean;
  featured?: boolean;
}

export async function updateProductMetadata(
  posId: string,
  patch: ProductMetadataPatch,
): Promise<{ ok: true; posId: string }> {
  await apiFetch(`/admin/products/meta`, {
    method: "POST",
    body: JSON.stringify({
      product_id: posId,
      short_description: patch.shortDescription,
      full_description: patch.description,
      warranty_info: patch.warranty,
    }),
  });
  if (patch.visible !== undefined) {
    await apiFetch(`/admin/products/visibility`, {
      method: "POST",
      body: JSON.stringify({ product_id: posId, is_visible_online: patch.visible }),
    });
  }
  if (patch.featured !== undefined) {
    await apiFetch(`/admin/products/featured`, {
      method: "POST",
      body: JSON.stringify({ product_id: posId, is_featured: patch.featured }),
    });
  }
  return { ok: true, posId };
}

export async function uploadProductImage(
  productId: string,
  file: File,
): Promise<{ ok: true; productId: string; url: string }> {
  const fd = new FormData();
  fd.append("image", file);
  fd.append("product_id", productId);

  const res = await apiFetch<ApiResponse<any>>(`/admin/products/images`, {
    method: "POST",
    body: fd as any,
  });
  const rawUrl = res.data.url;
  const url = rawUrl.startsWith("http") ? rawUrl : `${ASSET_BASE_URL}${rawUrl}`;
  return { ok: true, productId, url };
}

export async function deleteProductImage(imageId: string): Promise<{ success: boolean }> {
  await apiFetch(`/admin/products/images/delete`, {
    method: "POST",
    body: JSON.stringify({ url: imageId }),
  });
  return { success: true };
}

export async function setPrimaryProductImage(
  productId: string,
  imageId: string,
): Promise<{ success: boolean }> {
  await apiFetch(`/admin/products/images/set-primary`, {
    method: "POST",
    body: JSON.stringify({ product_id: productId, url: imageId }),
  });
  return { success: true };
}

export async function updateProductSpecifications(
  productId: string,
  specs: { spec_name: string; spec_value: string; spec_group?: string; sort_order?: number }[],
): Promise<{ ok: true; productId: string; count: number }> {
  const res = await apiFetch<ApiResponse<any>>(`/admin/products/specifications`, {
    method: "POST",
    body: JSON.stringify({
      product_id: productId,
      specifications: specs,
    }),
  });
  return { ok: true, productId, count: res.data.count || specs.length };
}

export interface StockAdjustmentPayload {
  adjustment_type: "increase" | "decrease" | "correction" | "set";
  quantity: number;
  notes?: string;
}

export async function adjustProductStock(
  productId: string,
  payload: StockAdjustmentPayload,
): Promise<{ ok: true; stock_quantity: number }> {
  if (payload.adjustment_type === "correction" || payload.adjustment_type === "set") {
    const res = await apiFetch<ApiResponse<any>>(`/admin/products/stock-correction`, {
      method: "POST",
      body: JSON.stringify({
        product_id: productId,
        new_stock: payload.quantity,
        note: payload.notes,
      }),
    });
    return { ok: true, stock_quantity: res.data.stock_quantity || res.data.new_stock };
  }

  const quantityDelta = payload.adjustment_type === "decrease" ? -payload.quantity : payload.quantity;

  const res = await apiFetch<ApiResponse<any>>(`/admin/products/stock-adjustment`, {
    method: "POST",
    body: JSON.stringify({
      product_id: productId,
      quantity: quantityDelta,
      note: payload.notes,
    }),
  });
  return { ok: true, stock_quantity: res.data.stock_quantity || res.data.new_stock };
}

/* =========================================================
 * Inventory Movements (global list)
 * ========================================================= */
export type MovementType =
  | "initial_stock"
  | "ecommerce_sale"
  | "pos_sale"
  | "stock_adjustment"
  | "stock_return"
  | "damaged_stock"
  | "correction";

export interface InventoryMovement {
  id: number;
  product_id: string;
  product_name: string;
  product_sku: string;
  movement_type: MovementType;
  quantity: number;
  previous_stock: number;
  new_stock: number;
  reference_type: string | null;
  reference_id: string | null;
  note: string | null;
  created_by: string | null;
  created_by_user_id: number | null;
  recorded_by_name: string | null;
  created_at: string;
}

export interface InventoryMovementsResponse {
  items: InventoryMovement[];
  total: number;
  page: number;
  per_page: number;
}

export async function fetchInventoryMovements(
  filters: {
    page?: number;
    per_page?: number;
    movement_type?: string;
    product_search?: string;
    date_from?: string;
    date_to?: string;
  } = {},
): Promise<InventoryMovementsResponse> {
  try {
    const query = new URLSearchParams();
    if (filters.page) query.set("page", String(filters.page));
    if (filters.per_page) query.set("per_page", String(filters.per_page));
    if (filters.movement_type) query.set("movement_type", filters.movement_type);
    if (filters.product_search) query.set("product_search", filters.product_search);
    if (filters.date_from) query.set("date_from", filters.date_from);
    if (filters.date_to) query.set("date_to", filters.date_to);
    const res = await apiFetch<ApiResponse<InventoryMovementsResponse>>(
      `/admin/inventory/all-movements?${query.toString()}`,
    );
    return res.data;
  } catch {
    return { items: [], total: 0, page: 1, per_page: 20 };
  }
}

/* =========================================================
 * Payments / Reports
 * ========================================================= */
export async function fetchPayments(): Promise<AdminPayment[]> {
  const res = await apiFetch<ApiResponse<any>>("/admin/payments");
  return res.data.items.map((p: any) => ({
    id: p.reference,
    reference: p.reference,
    orderId: p.order_number,
    customerEmail: p.customer_email || "",
    amount: p.amount,
    channel: p.channel || "card",
    status: p.status,
    gatewayResponse: p.gateway_response || "",
    createdAt: apiDateMs(p.created_at),
  }));
}

export type ReportRange = "week" | "month" | "quarter" | "year" | "custom";

export async function fetchReports(
  range: ReportRange = "year",
  startDate?: string,
  endDate?: string,
) {
  const map: Record<Exclude<ReportRange, "custom">, string> = {
    week: "weekly",
    month: "monthly",
    quarter: "quarterly",
    year: "annual",
  };

  let url = "/admin/reports";
  if (range === "custom") {
    url += `?period=monthly`;
    if (startDate) url += `&start_date=${encodeURIComponent(startDate)}`;
    if (endDate) url += `&end_date=${encodeURIComponent(endDate)}`;
  } else {
    url += `?period=${map[range]}`;
  }

  const res = await apiFetch<ApiResponse<any>>(url);
  return res.data;
}

/* =========================================================
 * Support
 * ========================================================= */
export async function fetchSupportMessages(): Promise<SupportMessage[]> {
  const res = await apiFetch<ApiResponse<any>>("/admin/support");
  return res.data.items.map(mapSupportMessage);
}

export async function replySupportMessage(
  id: string,
  reply: string,
): Promise<{
  ok: true;
  id: string;
  message: SupportMessage & { updated_at?: string; emailSent?: boolean; notificationCreated?: boolean };
}> {
  const res = await apiFetch<ApiResponse<any>>(`/admin/support/reply`, {
    method: "POST",
    body: JSON.stringify({ id, reply }),
  });
  return { ok: true, id, message: mapSupportMessage(res.data) };
}

export async function updateSupportStatus(
  id: string,
  status: "new" | "in_review" | "resolved",
): Promise<{ ok: true; id: string; status: typeof status }> {
  const dbStatus = status === "new" ? "open" : status === "in_review" ? "in_progress" : "resolved";

  await apiFetch(`/admin/support/update-status`, {
    method: "POST",
    body: JSON.stringify({ id, status: dbStatus }),
  });
  return { ok: true, id, status };
}

/* =========================================================
 * Settings
 * ========================================================= */
export async function fetchSettings(): Promise<{
  settings: AdminSettings;
  deliveryZones: DeliveryZone[];
}> {
  const res = await apiFetch<ApiResponse<any>>("/admin/settings");

  // The backend returns { items, grouped, frontend: { settings, deliveryZones } }
  const { settings, deliveryZones } = res.data.frontend;

  return {
    settings,
    deliveryZones: deliveryZones.map((z: any) => ({
      ...z,
      id: String(z.id),
      etaDays: String(z.etaDays),
    })),
  };
}

export async function updateDeliveryRate(
  id: string,
  patch: Partial<Pick<DeliveryZone, "baseFee" | "perKgFee" | "etaDays" | "enabled">>,
): Promise<{ ok: true; id: string }> {
  await apiFetch(`/admin/settings/update-delivery-rate`, {
    method: "POST",
    body: JSON.stringify({
      id,
      base_fee: patch.baseFee,
      per_kg_fee: patch.perKgFee,
      eta_text: patch.etaDays,
      is_active: patch.enabled,
    }),
  });
  return { ok: true, id };
}

export async function createDeliveryRate(
  payload: { state: string; city: string; baseFee: number; perKgFee: number; etaDays: string; enabled: boolean },
): Promise<{ ok: true; data: any }> {
  const res = await apiFetch<ApiResponse<any>>(`/admin/settings/update-delivery-rate`, {
    method: "POST",
    body: JSON.stringify({
      id: 0,
      state: payload.state,
      city_or_lga: payload.city,
      base_fee: payload.baseFee,
      extra_fee_per_kg: payload.perKgFee,
      eta_text: payload.etaDays,
      is_active: payload.enabled,
    }),
  });
  return { ok: true, data: res.data };
}

export async function updateBusinessSettings(
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
): Promise<{ ok: true }> {
  const updates: Array<{ key: string; value: string | number | boolean; group: string }> = [];
  const push = (condition: boolean, key: string, value: string | number | boolean, group: string) => {
    if (condition) updates.push({ key, value, group });
  };

  push(patch.allowStaffSales !== undefined, "pos_allow_staff_sales", !!patch.allowStaffSales, "pos_sales");
  push(patch.requireCustomerDetails !== undefined, "pos_require_customer_details", !!patch.requireCustomerDetails, "pos_sales");
  push(patch.defaultPaymentMethod !== undefined, "pos_default_payment_method", String(patch.defaultPaymentMethod ?? ""), "pos_sales");
  push(patch.autoMarkPaidAsCompleted !== undefined, "pos_auto_mark_paid_completed", !!patch.autoMarkPaidAsCompleted, "pos_sales");
  push(patch.holdStockForPendingPosSales !== undefined, "pos_hold_stock_for_pending_sales", !!patch.holdStockForPendingPosSales, "pos_sales");
  push(patch.paystack !== undefined, "pm_paystack", !!patch.paystack, "payment_methods");
  push(patch.cash !== undefined, "pm_cash", !!patch.cash, "payment_methods");
  push(patch.bankTransfer !== undefined, "pm_bank_transfer", !!patch.bankTransfer, "payment_methods");
  push(patch.posTerminal !== undefined, "pm_pos_terminal", !!patch.posTerminal, "payment_methods");
  push(patch.manualCard !== undefined, "pm_manual_card", !!patch.manualCard, "payment_methods");
  push(patch.other !== undefined, "pm_other", !!patch.other, "payment_methods");
  push(patch.enforceStockGuard !== undefined, "inventory_enforce_stock_guard", !!patch.enforceStockGuard, "inventory");
  push(patch.allowNegativeStock !== undefined, "inventory_allow_negative_stock", !!patch.allowNegativeStock, "inventory");
  push(patch.lowStockThreshold !== undefined, "low_stock_threshold", Number(patch.lowStockThreshold ?? 0), "inventory");
  push(patch.trackMovementNotes !== undefined, "inventory_track_notes", !!patch.trackMovementNotes, "inventory");
  push(patch.prefix !== undefined, "receipt_prefix", String(patch.prefix ?? ""), "receipt");
  push(patch.showLogo !== undefined, "receipt_show_logo", !!patch.showLogo, "receipt");
  push(patch.footerNote !== undefined, "receipt_footer_note", String(patch.footerNote ?? ""), "receipt");
  push(patch.printCustomerPhone !== undefined, "receipt_print_customer_phone", !!patch.printCustomerPhone, "receipt");
  push(patch.vatEnabled !== undefined, "vat_enabled", !!patch.vatEnabled, "tax");
  if (patch.vatPercent !== undefined) {
    updates.push({ key: "vat_rate", value: Number(patch.vatPercent ?? 0) / 100, group: "tax" });
  }
  push(patch.pricesIncludeVat !== undefined, "prices_include_vat", !!patch.pricesIncludeVat, "tax");
  push(patch.canCreatePosSales !== undefined, "staff_can_create_pos_sales", !!patch.canCreatePosSales, "staff_permissions");
  push(patch.canEditPosPrice !== undefined, "staff_can_edit_pos_price", !!patch.canEditPosPrice, "staff_permissions");
  push(patch.canApplyDiscount !== undefined, "staff_can_apply_discount", !!patch.canApplyDiscount, "staff_permissions");
  push(patch.canProcessReturns !== undefined, "staff_can_process_returns", !!patch.canProcessReturns, "staff_permissions");
  push(patch.maxDiscountPercent !== undefined, "staff_max_discount_percent", Number(patch.maxDiscountPercent ?? 0), "staff_permissions");
  push(patch.notifyOnNewOrder !== undefined, "notify_on_new_order", !!patch.notifyOnNewOrder, "preferences");
  push(patch.notifyOnLowStock !== undefined, "notify_on_low_stock", !!patch.notifyOnLowStock, "preferences");
  // Company / store identity
  push(patch.storeName    !== undefined, "store_name",    String(patch.storeName    ?? ""), "general");
  push(patch.storeAddress !== undefined, "store_address", String(patch.storeAddress ?? ""), "general");
  push(patch.storePhone   !== undefined, "store_phone",   String(patch.storePhone   ?? ""), "general");
  push(patch.storeEmail   !== undefined, "store_email",   String(patch.storeEmail   ?? ""), "general");
  push(patch.supportEmail !== undefined, "support_email", String(patch.supportEmail ?? ""), "general");
  push(patch.currency     !== undefined, "currency",      String(patch.currency     ?? "NGN"), "general");

  for (const u of updates) {
    await apiFetch(`/admin/settings/update`, {
      method: "POST",
      body: JSON.stringify({ setting_key: u.key, setting_value: String(u.value), setting_group: u.group }),
    });
  }
  return { ok: true };
}

/* =========================================================
 * Notifications, activity, email logs
 * ========================================================= */
import { useAdminNotificationStore } from "@/stores/admin-notifications";

export async function fetchAdminNotifications() {
  try {
    const res = await apiFetch<ApiResponse<any>>("/admin/notifications");
    const mapped = res.data.items.map((n: any) => ({
      id: String(n.id),
      kind: n.type || "system",
      title: n.title,
      body: n.message || "",
      createdAt: apiDateMs(n.created_at),
      read: !!n.is_read,
      href: n.data?.link_url || "#",
    }));
    useAdminNotificationStore.getState().hydrate(mapped);
    return mapped;
  } catch {
    return [];
  }
}

export async function markNotificationRead(id: string) {
  try {
    await apiFetch(`/admin/notifications/mark-read`, {
      method: "POST",
      body: JSON.stringify({ id }),
    });
    useAdminNotificationStore.getState().markRead(id);
    return { ok: true as const, id };
  } catch {
    return { ok: false as const, id };
  }
}

export async function markAllNotificationsRead() {
  try {
    await apiFetch(`/admin/notifications/mark-all-read`, {
      method: "POST",
    });
    useAdminNotificationStore.getState().markAllRead();
    return { ok: true as const };
  } catch {
    return { ok: false as const };
  }
}

/* =========================================================
 * Reviews
 * ========================================================= */
export interface AdminReview {
  id: string;
  productId: string;
  userName: string;
  rating: number;
  reviewText: string;
  status: "pending" | "approved" | "rejected";
  createdAt: number;
}

export async function fetchAdminReviews(status?: string): Promise<AdminReview[]> {
  try {
    const query = status ? `?status=${encodeURIComponent(status)}` : "";
    const res = await apiFetch<ApiResponse<any>>(`/admin/reviews${query}`);
    if (!res.data?.items) return [];
    
    return res.data.items.map((r: any) => ({
      id: String(r.id),
      productId: r.product_id,
      userName: r.user_name,
      rating: Number(r.rating),
      reviewText: r.review_text,
      status: r.status,
      createdAt: apiDateMs(r.created_at),
    }));
  } catch {
    return [];
  }
}

export async function updateAdminReviewStatus(
  id: string,
  status: "pending" | "approved" | "rejected"
): Promise<{ ok: true }> {
  await apiFetch(`/admin/reviews/update-status`, {
    method: "POST",
    body: JSON.stringify({ id: Number(id), status }),
  });
  return { ok: true };
}

export async function deleteAdminReview(id: string): Promise<{ ok: true }> {
  await apiFetch(`/admin/reviews/delete`, {
    method: "POST",
    body: JSON.stringify({ id: Number(id) }),
  });
  return { ok: true };
}

export async function fetchEmailLogs() {
  const res = await apiFetch<ApiResponse<any>>("/admin/email-logs");
  return res.data.items.map((e: any) => ({
    id: String(e.id),
    to: e.recipient_email,
    subject: e.subject,
    template: e.template_name,
    status: e.status,
    sentAt: apiDateMs(e.created_at),
  }));
}

export async function fetchUserActivityLogs() {
  const res = await apiFetch<ApiResponse<any>>("/admin/audit/user-activity");
  return res.data.items.map((a: any) => ({
    id: String(a.id),
    userId: String(a.user_id),
    userName: a.user_name || "Guest",
    action: a.action_type,
    context: JSON.stringify(a.metadata) || a.status,
    createdAt: apiDateMs(a.created_at),
  }));
}

export async function fetchAdminStats() {
  const { stats } = await fetchAdminDashboard();
  return stats;
}

/* =========================================================
 * Admin Invoice (POS / Order Desk)
 * ========================================================= */

export interface AdminInvoiceData {
  invoice_number: string;
  issued_at: string;
  valid_until: string;
  order: {
    order_number: string;
    order_status: string;
    payment_status: string;
    fulfillment_method: string;
    customer_name: string;
    customer_email: string;
    customer_phone: string;
    subtotal: number;
    tax_amount: number;
    delivery_fee: number;
    total_amount: number;
    currency: string;
    created_at: string;
    delivery_state?: string;
    delivery_city?: string;
    delivery_address?: string;
    delivery_landmark?: string;
  };
  items: Array<{
    product_name_snapshot: string;
    sku_snapshot: string;
    quantity: number;
    unit_price_snapshot: number;
    line_total: number;
  }>;
  payment: { reference: string; status: string; amount: number } | null;
  tracking: unknown[];
}

export async function fetchAdminInvoiceData(orderId: string): Promise<AdminInvoiceData | null> {
  try {
    const res = await apiFetch<ApiResponse<AdminInvoiceData>>(
      `/admin/orders/invoice-data?id=${encodeURIComponent(orderId)}`,
    );
    return res.data;
  } catch {
    return null;
  }
}

export async function downloadAdminInvoicePdf(orderId: string): Promise<void> {
  let authToken: string | null = null;
  try {
    const state = JSON.parse(localStorage.getItem("yarotech-auth") || "{}");
    if (state?.state?.token) {
      authToken = state.state.token;
    }
  } catch {
    // ignore
  }

  const url = `${(await import("./client")).API_BASE_URL}/admin/orders/invoice-pdf?id=${encodeURIComponent(orderId)}`;
  const res = await fetch(url, {
    headers: authToken ? { Authorization: `Bearer ${authToken}` } : {},
  });

  if (!res.ok) {
    throw new Error(`Failed to download invoice (${res.status})`);
  }

  const blob = await res.blob();
  const blobUrl = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = blobUrl;
  a.download = `YAROTECH-Invoice-${orderId}.pdf`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(blobUrl);
}
