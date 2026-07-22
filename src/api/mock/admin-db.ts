/**
 * Admin-only mock data.
 *
 * Real production sources (PHP + MySQL):
 *   GET  /api/admin/orders.php
 *   GET  /api/admin/users.php
 *   GET  /api/admin/payments.php
 *   GET  /api/admin/reports.php
 *   GET  /api/admin/support.php
 *   GET  /api/admin/settings.php
 *   GET  /api/admin/pos/sync-logs.php
 *   GET  /api/admin/notifications.php
 *   GET  /api/admin/activity.php
 *   GET  /api/admin/email-logs.php
 *
 * Phase 7: realistic seed data for the admin operations console.
 */

const HOUR = 60 * 60 * 1000;
const DAY = 24 * HOUR;

/* =========================================================
 * Admin orders (richer than buyer-facing mockOrders)
 * ========================================================= */
export type AdminOrderStatus =
  | "pending"
  | "paid"
  | "processing"
  | "ready_for_pickup"
  | "shipped"
  | "delivered"
  | "picked_up"
  | "cancelled"
  | "refunded"
  | "failed";

export type DeliveryMethod = "delivery" | "pickup";
export type PosSyncState = "synced" | "pending" | "failed" | "n/a";

export interface AdminOrderItem {
  posId: string;
  name: string;
  sku: string;
  qty: number;
  price: number;
}

export interface AdminOrder {
  id: string;
  reference: string; // Paystack reference
  customer: { id: string; name: string; email: string; phone: string };
  items: AdminOrderItem[];
  subtotal: number;
  deliveryFee: number;
  vat: number;
  total: number;
  status: AdminOrderStatus;
  paymentStatus: "pending" | "paid" | "failed";
  deliveryMethod: DeliveryMethod;
  deliveryAddress?: string;
  posSync: PosSyncState;
  createdAt: number;
}

export const mockAdminOrders: AdminOrder[] = [
  {
    id: "ORD-9088",
    reference: "PSK_REF_9088",
    customer: {
      id: "U-021",
      name: "Adaeze Okafor",
      email: "adaeze@example.com",
      phone: "+234 803 111 2233",
    },
    items: [
      {
        posId: "POS-1001",
        name: "YT-Pro 550W Mono Panel",
        sku: "YT-SP550M",
        qty: 4,
        price: 185000,
      },
      {
        posId: "POS-1002",
        name: "Growatt 5KW Hybrid Inverter",
        sku: "YT-INV5K",
        qty: 1,
        price: 1200000,
      },
    ],
    subtotal: 1940000,
    deliveryFee: 25000,
    vat: 145500,
    total: 2110500,
    status: "paid",
    paymentStatus: "paid",
    deliveryMethod: "delivery",
    deliveryAddress: "12 Adeola Odeku, Victoria Island, Lagos",
    posSync: "synced",
    createdAt: Date.now() - 2 * HOUR,
  },
  {
    id: "ORD-9087",
    reference: "PSK_REF_9087",
    customer: {
      id: "U-019",
      name: "Bola Akin",
      email: "bola@example.com",
      phone: "+234 805 444 7788",
    },
    items: [
      { posId: "POS-1004", name: "Hikvision 4MP Dome", sku: "HKV-DS2CD", qty: 6, price: 95000 },
    ],
    subtotal: 570000,
    deliveryFee: 12000,
    vat: 42750,
    total: 624750,
    status: "processing",
    paymentStatus: "paid",
    deliveryMethod: "delivery",
    deliveryAddress: "Plot 4 Aminu Kano Cres., Wuse 2, Abuja",
    posSync: "pending",
    createdAt: Date.now() - 8 * HOUR,
  },
  {
    id: "ORD-9085",
    reference: "PSK_REF_9085",
    customer: {
      id: "U-014",
      name: "Chinedu Iroha",
      email: "chinedu@example.com",
      phone: "+234 802 222 0099",
    },
    items: [
      { posId: "POS-1006", name: "Dell OptiPlex 7010", sku: "DELL-OP70", qty: 2, price: 720000 },
    ],
    subtotal: 1440000,
    deliveryFee: 0,
    vat: 108000,
    total: 1548000,
    status: "shipped",
    paymentStatus: "paid",
    deliveryMethod: "pickup",
    posSync: "synced",
    createdAt: Date.now() - 1 * DAY,
  },
  {
    id: "ORD-9080",
    reference: "PSK_REF_9080",
    customer: {
      id: "U-009",
      name: "Hauwa Sani",
      email: "hauwa@example.com",
      phone: "+234 807 333 1010",
    },
    items: [
      {
        posId: "POS-1010",
        name: "Felicity 3.5KVA Inverter",
        sku: "YT-INV3K",
        qty: 1,
        price: 480000,
      },
    ],
    subtotal: 480000,
    deliveryFee: 18000,
    vat: 36000,
    total: 534000,
    status: "delivered",
    paymentStatus: "paid",
    deliveryMethod: "delivery",
    deliveryAddress: "Kano Industrial Estate, Kano",
    posSync: "synced",
    createdAt: Date.now() - 3 * DAY,
  },
  {
    id: "ORD-9078",
    reference: "PSK_REF_9078",
    customer: {
      id: "U-025",
      name: "Femi Adeyemi",
      email: "femi@example.com",
      phone: "+234 909 555 2244",
    },
    items: [
      { posId: "POS-1005", name: "Ubiquiti UDM Pro", sku: "UBNT-UDM", qty: 1, price: 380000 },
    ],
    subtotal: 380000,
    deliveryFee: 12000,
    vat: 28500,
    total: 420500,
    status: "pending",
    paymentStatus: "failed",
    deliveryMethod: "delivery",
    deliveryAddress: "Lekki Phase 1, Lagos",
    posSync: "failed",
    createdAt: Date.now() - 4 * DAY,
  },
  {
    id: "ORD-9070",
    reference: "PSK_REF_9070",
    customer: {
      id: "U-006",
      name: "Tunde Bello",
      email: "tunde@example.com",
      phone: "+234 811 666 7777",
    },
    items: [
      {
        posId: "POS-1007",
        name: "YT-Pro 400W Mono Panel",
        sku: "YT-SP400M",
        qty: 10,
        price: 120000,
      },
    ],
    subtotal: 1200000,
    deliveryFee: 35000,
    vat: 90000,
    total: 1325000,
    status: "delivered",
    paymentStatus: "paid",
    deliveryMethod: "delivery",
    deliveryAddress: "Ibadan, Oyo State",
    posSync: "synced",
    createdAt: Date.now() - 7 * DAY,
  },
];

/* =========================================================
 * Admin users
 * ========================================================= */
export type UserStatus = "active" | "inactive" | "pending" | "suspended" | "deleted";

export interface AdminUser {
  id: string;
  fullName: string;
  email: string;
  phone: string;
  role: "customer" | "admin";
  status: UserStatus;
  emailVerified: boolean;
  ordersCount: number;
  totalSpend: number;
  lastActiveAt: number;
  createdAt: number;
}

export const mockAdminUsers: AdminUser[] = [
  {
    id: "U-021",
    fullName: "Adaeze Okafor",
    email: "adaeze@example.com",
    phone: "+234 803 111 2233",
    role: "customer",
    status: "active",
    emailVerified: true,
    ordersCount: 4,
    totalSpend: 4_120_000,
    lastActiveAt: Date.now() - 1 * HOUR,
    createdAt: Date.now() - 60 * DAY,
  },
  {
    id: "U-019",
    fullName: "Bola Akin",
    email: "bola@example.com",
    phone: "+234 805 444 7788",
    role: "customer",
    status: "active",
    emailVerified: true,
    ordersCount: 2,
    totalSpend: 980_000,
    lastActiveAt: Date.now() - 6 * HOUR,
    createdAt: Date.now() - 90 * DAY,
  },
  {
    id: "U-014",
    fullName: "Chinedu Iroha",
    email: "chinedu@example.com",
    phone: "+234 802 222 0099",
    role: "customer",
    status: "active",
    emailVerified: true,
    ordersCount: 6,
    totalSpend: 5_300_000,
    lastActiveAt: Date.now() - 1 * DAY,
    createdAt: Date.now() - 120 * DAY,
  },
  {
    id: "U-025",
    fullName: "Femi Adeyemi",
    email: "femi@example.com",
    phone: "+234 909 555 2244",
    role: "customer",
    status: "pending",
    emailVerified: false,
    ordersCount: 0,
    totalSpend: 0,
    lastActiveAt: Date.now() - 12 * HOUR,
    createdAt: Date.now() - 2 * DAY,
  },
  {
    id: "U-009",
    fullName: "Hauwa Sani",
    email: "hauwa@example.com",
    phone: "+234 807 333 1010",
    role: "customer",
    status: "active",
    emailVerified: true,
    ordersCount: 3,
    totalSpend: 1_410_000,
    lastActiveAt: Date.now() - 3 * DAY,
    createdAt: Date.now() - 200 * DAY,
  },
  {
    id: "U-006",
    fullName: "Tunde Bello",
    email: "tunde@example.com",
    phone: "+234 811 666 7777",
    role: "customer",
    status: "active",
    emailVerified: true,
    ordersCount: 5,
    totalSpend: 3_775_000,
    lastActiveAt: Date.now() - 7 * DAY,
    createdAt: Date.now() - 240 * DAY,
  },
  {
    id: "U-002",
    fullName: "Yaro Admin",
    email: "admin@yarotech.ng",
    phone: "+234 700 000 0001",
    role: "admin",
    status: "active",
    emailVerified: true,
    ordersCount: 0,
    totalSpend: 0,
    lastActiveAt: Date.now() - 5 * 60 * 1000,
    createdAt: Date.now() - 365 * DAY,
  },
  {
    id: "U-031",
    fullName: "Ifeoma Eze",
    email: "ifeoma@example.com",
    phone: "+234 706 121 9090",
    role: "customer",
    status: "suspended",
    emailVerified: true,
    ordersCount: 1,
    totalSpend: 65_000,
    lastActiveAt: Date.now() - 30 * DAY,
    createdAt: Date.now() - 150 * DAY,
  },
];

/* =========================================================
 * Payments
 * ========================================================= */
export type PaymentStatus = "success" | "failed" | "pending";
export type PaymentChannel = "card" | "bank_transfer" | "ussd" | "qr";

export interface AdminPayment {
  id: string;
  reference: string;
  orderId: string;
  customerEmail: string;
  amount: number;
  channel: PaymentChannel;
  status: PaymentStatus;
  gatewayResponse: string;
  createdAt: number;
}

export const mockAdminPayments: AdminPayment[] = [
  {
    id: "PAY-5012",
    reference: "PSK_REF_9088",
    orderId: "ORD-9088",
    customerEmail: "adaeze@example.com",
    amount: 2_110_500,
    channel: "card",
    status: "success",
    gatewayResponse: "Approved",
    createdAt: Date.now() - 2 * HOUR,
  },
  {
    id: "PAY-5011",
    reference: "PSK_REF_9087",
    orderId: "ORD-9087",
    customerEmail: "bola@example.com",
    amount: 624_750,
    channel: "card",
    status: "success",
    gatewayResponse: "Approved",
    createdAt: Date.now() - 8 * HOUR,
  },
  {
    id: "PAY-5010",
    reference: "PSK_REF_9085",
    orderId: "ORD-9085",
    customerEmail: "chinedu@example.com",
    amount: 1_548_000,
    channel: "bank_transfer",
    status: "success",
    gatewayResponse: "Transfer received",
    createdAt: Date.now() - 1 * DAY,
  },
  {
    id: "PAY-5009",
    reference: "PSK_REF_9082",
    orderId: "ORD-9082",
    customerEmail: "ngozi@example.com",
    amount: 95_000,
    channel: "ussd",
    status: "pending",
    gatewayResponse: "Awaiting confirmation",
    createdAt: Date.now() - 1.5 * DAY,
  },
  {
    id: "PAY-5008",
    reference: "PSK_REF_9080",
    orderId: "ORD-9080",
    customerEmail: "hauwa@example.com",
    amount: 534_000,
    channel: "card",
    status: "success",
    gatewayResponse: "Approved",
    createdAt: Date.now() - 3 * DAY,
  },
  {
    id: "PAY-5007",
    reference: "PSK_REF_9078",
    orderId: "ORD-9078",
    customerEmail: "femi@example.com",
    amount: 420_500,
    channel: "card",
    status: "failed",
    gatewayResponse: "Card declined by issuer",
    createdAt: Date.now() - 4 * DAY,
  },
];

/* =========================================================
 * POS sync logs
 * ========================================================= */
export interface PosSyncLog {
  id: string;
  ranAt: number;
  durationMs: number;
  productsSynced: number;
  failures: number;
  status: "success" | "partial" | "failed";
  note?: string;
}

export const mockPosSyncLogs: PosSyncLog[] = [
  {
    id: "SYN-118",
    ranAt: Date.now() - 12 * 60 * 1000,
    durationMs: 1240,
    productsSynced: 12,
    failures: 0,
    status: "success",
  },
  {
    id: "SYN-117",
    ranAt: Date.now() - 1 * HOUR,
    durationMs: 1420,
    productsSynced: 12,
    failures: 0,
    status: "success",
  },
  {
    id: "SYN-116",
    ranAt: Date.now() - 4 * HOUR,
    durationMs: 1810,
    productsSynced: 11,
    failures: 1,
    status: "partial",
    note: "POS-1009 stock check timed out",
  },
  {
    id: "SYN-115",
    ranAt: Date.now() - 1 * DAY,
    durationMs: 980,
    productsSynced: 12,
    failures: 0,
    status: "success",
  },
];

/* =========================================================
 * Reports / sales chart
 * ========================================================= */
export interface ReportPoint {
  label: string;
  revenue: number;
  orders: number;
}

export const mockMonthlyReport: ReportPoint[] = [
  { label: "Jan", revenue: 4_120_000, orders: 18 },
  { label: "Feb", revenue: 3_980_000, orders: 21 },
  { label: "Mar", revenue: 5_430_000, orders: 26 },
  { label: "Apr", revenue: 6_140_000, orders: 31 },
  { label: "May", revenue: 5_780_000, orders: 28 },
  { label: "Jun", revenue: 7_220_000, orders: 36 },
  { label: "Jul", revenue: 8_100_000, orders: 41 },
  { label: "Aug", revenue: 7_640_000, orders: 38 },
  { label: "Sep", revenue: 9_310_000, orders: 47 },
  { label: "Oct", revenue: 10_240_000, orders: 52 },
  { label: "Nov", revenue: 11_500_000, orders: 58 },
  { label: "Dec", revenue: 12_810_000, orders: 64 },
];

export const mockProductPerformance = [
  { posId: "POS-1001", name: "YT-Pro 550W Mono Panel", unitsSold: 184, revenue: 34_040_000 },
  { posId: "POS-1002", name: "Growatt 5KW Hybrid Inverter", unitsSold: 41, revenue: 49_200_000 },
  { posId: "POS-1003", name: "YT LiFePO4 48V 200Ah Battery", unitsSold: 22, revenue: 31_900_000 },
  { posId: "POS-1004", name: "Hikvision 4MP IP Dome", unitsSold: 156, revenue: 14_820_000 },
  { posId: "POS-1006", name: "Dell OptiPlex 7010", unitsSold: 38, revenue: 27_360_000 },
];

export const mockPaymentChannelMix = [
  { channel: "Card", value: 68 },
  { channel: "Bank Transfer", value: 22 },
  { channel: "USSD", value: 7 },
  { channel: "QR", value: 3 },
];

/* =========================================================
 * Support / contact messages
 * ========================================================= */
export type SupportCategory = "general" | "product" | "delivery" | "payment" | "complaint";
export type SupportStatus = "new" | "in_review" | "resolved";

export interface SupportMessage {
  id: string;
  name: string;
  email: string;
  phone?: string;
  category: SupportCategory;
  subject: string;
  body: string;
  status: SupportStatus;
  createdAt: number;
  reply?: string;
}

export const mockSupportMessages: SupportMessage[] = [
  {
    id: "SUP-3041",
    name: "Olamide Bakare",
    email: "olamide@example.com",
    phone: "+234 802 100 9090",
    category: "product",
    subject: "Compatibility check on 5KW inverter",
    body: "Will the Growatt 5KW work with 4× 550W panels in series?",
    status: "new",
    createdAt: Date.now() - 30 * 60 * 1000,
  },
  {
    id: "SUP-3040",
    name: "Ngozi Okafor",
    email: "ngozi@example.com",
    phone: "+234 803 200 1212",
    category: "delivery",
    subject: "Delivery to Port Harcourt",
    body: "How long does delivery take to PH and what is the fee?",
    status: "in_review",
    createdAt: Date.now() - 4 * HOUR,
  },
  {
    id: "SUP-3039",
    name: "Femi Adeyemi",
    email: "femi@example.com",
    category: "payment",
    subject: "Card declined on checkout",
    body: "My card keeps getting declined. Is Paystack down?",
    status: "new",
    createdAt: Date.now() - 1 * DAY,
  },
  {
    id: "SUP-3038",
    name: "Aisha Yusuf",
    email: "aisha@example.com",
    phone: "+234 906 555 7878",
    category: "complaint",
    subject: "Damaged battery on arrival",
    body: "Battery casing was cracked when delivered. Need a replacement.",
    status: "resolved",
    createdAt: Date.now() - 3 * DAY,
    reply: "Replacement dispatched on 28 Apr.",
  },
  {
    id: "SUP-3037",
    name: "Daniel Eze",
    email: "daniel@example.com",
    category: "general",
    subject: "Bulk order quote for school project",
    body: "We need 24 panels and 4 inverters. Please advise.",
    status: "in_review",
    createdAt: Date.now() - 5 * DAY,
  },
];

/* =========================================================
 * Delivery zones / settings
 * ========================================================= */
export interface DeliveryZone {
  id: string;
  region: string;
  baseFee: number;
  perKgFee: number;
  etaDays: string;
  enabled: boolean;
}

export const mockDeliveryZones: DeliveryZone[] = [
  {
    id: "DZ-1",
    region: "Lagos Mainland",
    baseFee: 8_000,
    perKgFee: 250,
    etaDays: "1-2",
    enabled: true,
  },
  {
    id: "DZ-2",
    region: "Lagos Island & VI",
    baseFee: 12_000,
    perKgFee: 250,
    etaDays: "1-2",
    enabled: true,
  },
  {
    id: "DZ-3",
    region: "Abuja FCT",
    baseFee: 18_000,
    perKgFee: 320,
    etaDays: "2-3",
    enabled: true,
  },
  {
    id: "DZ-4",
    region: "Port Harcourt",
    baseFee: 22_000,
    perKgFee: 350,
    etaDays: "3-4",
    enabled: true,
  },
  { id: "DZ-5", region: "Kano", baseFee: 24_000, perKgFee: 380, etaDays: "3-5", enabled: true },
  {
    id: "DZ-6",
    region: "Other South",
    baseFee: 28_000,
    perKgFee: 400,
    etaDays: "4-6",
    enabled: false,
  },
];

export interface AdminSettings {
  general: {
    storeName: string;
    storeAddress: string;
    storePhone: string;
    storeEmail: string;
    supportEmail: string;
    currency: string;
    vatPercent: number;
  };
  paystack: {
    publicKeyMasked: string;
    secretKeyMasked: string;
    webhookUrl: string;
  };
  smtp: {
    host: string;
    port: number;
    fromAddress: string;
    encryption: "tls" | "ssl" | "none";
  };
  posSales: {
    allowStaffSales: boolean;
    requireCustomerDetails: boolean;
    defaultPaymentMethod:
      | "paystack"
      | "cash"
      | "bank_transfer"
      | "pos_terminal"
      | "manual_card"
      | "other";
    autoMarkPaidAsCompleted: boolean;
    holdStockForPendingPosSales: boolean;
  };
  paymentMethods: {
    paystack: boolean;
    cash: boolean;
    bankTransfer: boolean;
    posTerminal: boolean;
    manualCard: boolean;
    other: boolean;
  };
  inventory: {
    enforceStockGuard: boolean;
    allowNegativeStock: boolean;
    lowStockThreshold: number;
    trackMovementNotes: boolean;
  };
  receipt: {
    prefix: string;
    showLogo: boolean;
    footerNote: string;
    printCustomerPhone: boolean;
  };
  tax: {
    vatEnabled: boolean;
    vatPercent: number;
    pricesIncludeVat: boolean;
  };
  staffPermissions: {
    canCreatePosSales: boolean;
    canEditPosPrice: boolean;
    canApplyDiscount: boolean;
    canProcessReturns: boolean;
    maxDiscountPercent: number;
  };
  preferences: {
    notifyOnNewOrder: boolean;
    notifyOnLowStock: boolean;
  };
}

export const mockAdminSettings: AdminSettings = {
  general: {
    storeName: "YAROTECH NETWORK LIMITED",
    storeAddress: "Lokoro plaza A Farm Center, Kano State, Nigeria",
    storePhone: "+234 800 000 0000",
    storeEmail: "store@yarotech.ng",
    supportEmail: "support@yarotech.ng",
    currency: "NGN",
    vatPercent: 7.5,
  },
  paystack: {
    publicKeyMasked: "pk_live_••••••••••••3a9b",
    secretKeyMasked: "sk_live_••••••••••••f12c",
    webhookUrl: "https://yarotech.ng/api/payments/webhook.php",
  },
  smtp: {
    host: "smtp.zoho.com",
    port: 587,
    fromAddress: "no-reply@yarotech.ng",
    encryption: "tls",
  },
  posSales: {
    allowStaffSales: true,
    requireCustomerDetails: false,
    defaultPaymentMethod: "cash",
    autoMarkPaidAsCompleted: true,
    holdStockForPendingPosSales: false,
  },
  paymentMethods: {
    paystack: true,
    cash: true,
    bankTransfer: true,
    posTerminal: true,
    manualCard: true,
    other: true,
  },
  inventory: {
    enforceStockGuard: true,
    allowNegativeStock: false,
    lowStockThreshold: 5,
    trackMovementNotes: true,
  },
  receipt: {
    prefix: "YT-POS",
    showLogo: true,
    footerNote: "Thank you for choosing YAROTECH.",
    printCustomerPhone: true,
  },
  tax: {
    vatEnabled: true,
    vatPercent: 7.5,
    pricesIncludeVat: false,
  },
  staffPermissions: {
    canCreatePosSales: true,
    canEditPosPrice: false,
    canApplyDiscount: true,
    canProcessReturns: true,
    maxDiscountPercent: 10,
  },
  preferences: {
    notifyOnNewOrder: true,
    notifyOnLowStock: true,
  },
};

/* =========================================================
 * Activity & email logs (read-only previews)
 * ========================================================= */
export interface ActivityLog {
  id: string;
  userId: string;
  userName: string;
  action: string;
  context: string;
  createdAt: number;
}

export const mockActivityLogs: ActivityLog[] = [
  {
    id: "ACT-901",
    userId: "U-021",
    userName: "Adaeze Okafor",
    action: "Placed order",
    context: "ORD-9088 — ₦2,110,500",
    createdAt: Date.now() - 2 * HOUR,
  },
  {
    id: "ACT-900",
    userId: "U-019",
    userName: "Bola Akin",
    action: "Placed order",
    context: "ORD-9087 — ₦624,750",
    createdAt: Date.now() - 8 * HOUR,
  },
  {
    id: "ACT-899",
    userId: "U-025",
    userName: "Femi Adeyemi",
    action: "Registered account",
    context: "Email pending verification",
    createdAt: Date.now() - 12 * HOUR,
  },
  {
    id: "ACT-898",
    userId: "U-014",
    userName: "Chinedu Iroha",
    action: "Updated address",
    context: "Default → Lagos",
    createdAt: Date.now() - 1 * DAY,
  },
  {
    id: "ACT-897",
    userId: "U-009",
    userName: "Hauwa Sani",
    action: "Logged in",
    context: "Web",
    createdAt: Date.now() - 1.2 * DAY,
  },
];

export interface EmailLog {
  id: string;
  to: string;
  subject: string;
  template: "order_paid_admin" | "contact_admin" | "inventory_low_stock" | "order_paid_customer";
  status: "queued" | "sent" | "failed";
  sentAt: number;
}

export const mockEmailLogs: EmailLog[] = [
  {
    id: "EM-771",
    to: "admin@yarotech.ng",
    subject: "New paid order ORD-9088",
    template: "order_paid_admin",
    status: "sent",
    sentAt: Date.now() - 2 * HOUR,
  },
  {
    id: "EM-770",
    to: "adaeze@example.com",
    subject: "Your order ORD-9088 is confirmed",
    template: "order_paid_customer",
    status: "sent",
    sentAt: Date.now() - 2 * HOUR,
  },
  {
    id: "EM-769",
    to: "admin@yarotech.ng",
    subject: "New contact: Compatibility check",
    template: "contact_admin",
    status: "sent",
    sentAt: Date.now() - 30 * 60 * 1000,
  },
  {
    id: "EM-768",
    to: "admin@yarotech.ng",
    subject: "Low stock inventory alert",
    template: "inventory_low_stock",
    status: "sent",
    sentAt: Date.now() - 4 * HOUR,
  },
  {
    id: "EM-767",
    to: "femi@example.com",
    subject: "Verify your email",
    template: "order_paid_customer",
    status: "queued",
    sentAt: Date.now() - 12 * HOUR,
  },
];
