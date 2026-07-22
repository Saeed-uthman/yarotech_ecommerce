/**
 * Mock POS-merged product catalog.
 *
 * Real production sources (PHP + MySQL):
 *   GET /api/pos/products.php              -> POS-owned fields
 *   GET /api/products/meta.php             -> ecommerce-owned fields
 *   GET /api/products/merged.php           -> merged view (server-side join)
 *   GET /api/products/by-slug.php?slug=…   -> merged single product
 *
 * In Phase 1–3 the data is split logically below (PosRecord + EcomMeta) and
 * merged in src/api/products.ts so the frontend mirrors the real backend
 * contract exactly.
 */

export type StockStatus = "in_stock" | "low_stock" | "out_of_stock";

export type ProductCategory =
  | "Solar Products"
  | "Inverters"
  | "Batteries"
  | "CCTV Cameras"
  | "Networking Devices"
  | "IT Equipment";

/* =========================================================
 * POS-owned record (mirrors yarotech_pos.products)
 * ========================================================= */
export interface PosRecord {
  posId: string;
  sku: string;
  name: string;
  category: ProductCategory;
  price: number;
  stock: number;
  status: "active" | "draft";
}

export const mockPosRecords: PosRecord[] = [
  {
    posId: "POS-1001",
    sku: "YT-SP550M",
    name: "YT-Pro 550W Monocrystalline Solar Panel",
    category: "Solar Products",
    price: 185000,
    stock: 124,
    status: "active",
  },
  {
    posId: "POS-1002",
    sku: "YT-INV5K",
    name: "Growatt 5KW Hybrid Inverter",
    category: "Inverters",
    price: 1200000,
    stock: 6,
    status: "active",
  },
  {
    posId: "POS-1003",
    sku: "YT-LFP200",
    name: "YT LiFePO4 48V 200Ah Battery",
    category: "Batteries",
    price: 1450000,
    stock: 18,
    status: "active",
  },
  {
    posId: "POS-1004",
    sku: "HKV-DS2CD",
    name: "Hikvision 4MP IP Dome CCTV Camera",
    category: "CCTV Cameras",
    price: 95000,
    stock: 42,
    status: "active",
  },
  {
    posId: "POS-1005",
    sku: "UBNT-UDM",
    name: "Ubiquiti UniFi Dream Machine Pro",
    category: "Networking Devices",
    price: 380000,
    stock: 22,
    status: "active",
  },
  {
    posId: "POS-1006",
    sku: "DELL-OP70",
    name: "Dell OptiPlex 7010 Business Desktop",
    category: "IT Equipment",
    price: 720000,
    stock: 14,
    status: "active",
  },
  {
    posId: "POS-1007",
    sku: "YT-SP400M",
    name: "YT-Pro 400W Monocrystalline Panel",
    category: "Solar Products",
    price: 120000,
    stock: 240,
    status: "active",
  },
  {
    posId: "POS-1008",
    sku: "HKV-NVR8",
    name: "Hikvision 8-Channel 4K NVR",
    category: "CCTV Cameras",
    price: 240000,
    stock: 8,
    status: "active",
  },
  {
    posId: "POS-1009",
    sku: "TPL-AX73",
    name: "TP-Link Archer AX73 WiFi 6 Router",
    category: "Networking Devices",
    price: 75000,
    stock: 0,
    status: "active",
  },
  {
    posId: "POS-1010",
    sku: "YT-INV3K",
    name: "Felicity 3.5KVA Pure Sine Wave Inverter",
    category: "Inverters",
    price: 480000,
    stock: 11,
    status: "active",
  },
  {
    posId: "POS-1011",
    sku: "YT-AGM200",
    name: "Trojan AGM 12V 200Ah Deep Cycle Battery",
    category: "Batteries",
    price: 320000,
    stock: 26,
    status: "active",
  },
  {
    posId: "POS-1012",
    sku: "HP-LJ1102",
    name: "HP LaserJet Pro M404dn Mono Printer",
    category: "IT Equipment",
    price: 285000,
    stock: 9,
    status: "active",
  },
];

/* =========================================================
 * Ecommerce-owned metadata (mirrors yarotech_ecom.product_meta)
 * Keyed by posId — enriches POS records with online-only fields.
 * ========================================================= */
export interface EcomMeta {
  posId: string;
  slug: string;
  shortDescription: string;
  description: string;
  warranty: string;
  featured: boolean;
  visible: boolean;
  image: string;
  gallery: string[];
  badges: string[];
  specs: { label: string; value: string }[];
  relatedSlugs: string[];
  /** ratings/reviewCount are aggregates derived from reviews — kept here for list views */
  rating: number;
  reviewCount: number;
  compareAtPrice?: number;
  /** Optional override; usually null because POS owns price */
  priceOverride?: number;
}

const UNSPLASH = (id: string) =>
  `https://images.unsplash.com/photo-${id}?auto=format&fit=crop&w=1200&q=80`;

export const mockEcomMeta: EcomMeta[] = [
  {
    posId: "POS-1001",
    slug: "yt-pro-550w-mono-panel",
    shortDescription:
      "Tier-1 monocrystalline PERC module engineered for high-temperature performance.",
    description:
      "The YT-Pro 550W Series delivers industry-leading 21.5% efficiency with PERC monocrystalline cells. Engineered for high-temperature performance with a -0.34%/°C temperature coefficient and IP68 weatherproofing — ideal for both residential rooftops and commercial solar farms across Nigeria.",
    warranty: "25 Years Linear Output",
    featured: true,
    visible: true,
    compareAtPrice: 210000,
    image: UNSPLASH("1509391366360-2e959784a276"),
    gallery: [
      UNSPLASH("1509391366360-2e959784a276"),
      UNSPLASH("1466611653911-95081537e5b7"),
      UNSPLASH("1497435334941-8c899ee9e8e9"),
    ],
    badges: ["550W", "MONO PERC", "IP68"],
    specs: [
      { label: "Maximum Power (Pmax)", value: "550 W" },
      { label: "Efficiency", value: "21.5%" },
      { label: "Maximum System Voltage", value: "1500V DC (IEC)" },
      { label: "Open Circuit Voltage (Voc)", value: "49.9 V ± 3%" },
      { label: "Temperature Coefficient", value: "-0.34%/°C" },
      { label: "Cell Type", value: "Monocrystalline PERC" },
      { label: "Weight", value: "27.5 kg" },
      { label: "Warranty", value: "25 Years Linear" },
    ],
    relatedSlugs: [
      "yt-pro-400w-mono-panel",
      "growatt-5kw-hybrid-inverter",
      "yt-lfp-48v-200ah-battery",
    ],
    rating: 4.8,
    reviewCount: 24,
  },
  {
    posId: "POS-1002",
    slug: "growatt-5kw-hybrid-inverter",
    shortDescription: "Pure sine wave hybrid inverter with smart MPPT and lithium battery support.",
    description:
      "5KVA hybrid inverter with 48V DC battery support, dual MPPT trackers and pure sine wave output. Ideal for residential and small commercial backup systems with grid-tie and off-grid modes.",
    warranty: "5 Years Manufacturer",
    featured: true,
    visible: true,
    image: UNSPLASH("1581094794329-c8112a89af12"),
    gallery: [UNSPLASH("1581094794329-c8112a89af12")],
    badges: ["5KVA", "48V DC", "HYBRID"],
    specs: [
      { label: "Capacity", value: "5KVA / 5000W" },
      { label: "Battery Voltage", value: "48V DC" },
      { label: "Output Waveform", value: "Pure Sine Wave" },
      { label: "MPPT Trackers", value: "Dual" },
      { label: "Max PV Input", value: "6000W" },
      { label: "Surge Capacity", value: "10000W (5 sec)" },
      { label: "Dimensions", value: "440 × 580 × 130 mm" },
      { label: "Weight", value: "18 kg" },
    ],
    relatedSlugs: [
      "yt-lfp-48v-200ah-battery",
      "yt-pro-550w-mono-panel",
      "felicity-3.5kva-inverter",
    ],
    rating: 4.7,
    reviewCount: 14,
  },
  {
    posId: "POS-1003",
    slug: "yt-lfp-48v-200ah-battery",
    shortDescription: "Rack-mount LiFePO4 battery with built-in BMS and 6000+ deep-cycle life.",
    description:
      "10kWh lithium iron phosphate battery for solar and backup systems. Integrated battery management system, RS485/CAN communication, and parallel scaling up to 16 units for commercial installations.",
    warranty: "10 Years",
    featured: true,
    visible: true,
    compareAtPrice: 1600000,
    image: UNSPLASH("1620714223084-8fcacc6dfd8d"),
    gallery: [UNSPLASH("1620714223084-8fcacc6dfd8d")],
    badges: ["10kWh", "LiFePO4", "RACK-MOUNT"],
    specs: [
      { label: "Chemistry", value: "LiFePO4 (Lithium Iron Phosphate)" },
      { label: "Capacity", value: "200Ah / 10.24 kWh" },
      { label: "Voltage", value: "48V Nominal" },
      { label: "Cycle Life", value: ">6000 @ 80% DoD" },
      { label: "Communication", value: "RS485 / CAN" },
      { label: "Form Factor", value: 'Rack-mount, 19"' },
      { label: "Weight", value: "92 kg" },
    ],
    relatedSlugs: [
      "growatt-5kw-hybrid-inverter",
      "yt-pro-550w-mono-panel",
      "trojan-agm-200ah-battery",
    ],
    rating: 4.9,
    reviewCount: 21,
  },
  {
    posId: "POS-1004",
    slug: "hikvision-4mp-dome-camera",
    shortDescription: "4MP fixed dome with 30m IR night vision, IP67, and PoE support.",
    description:
      "Hikvision DS-2CD2143G2-I 4MP AcuSense dome with motion detection, H.265+ compression, and weatherproof IP67 housing for indoor or outdoor surveillance. Compatible with most NVR platforms.",
    warranty: "2 Years",
    featured: true,
    visible: true,
    image: UNSPLASH("1557597774-9d273605dfa9"),
    gallery: [UNSPLASH("1557597774-9d273605dfa9")],
    badges: ["4MP", "PoE", "IP67"],
    specs: [
      { label: "Resolution", value: "4MP (2560 × 1440)" },
      { label: "IR Range", value: "30 metres" },
      { label: "Power", value: "PoE (802.3af) / 12V DC" },
      { label: "Rating", value: "IP67" },
      { label: "Compression", value: "H.265+ / H.264+" },
      { label: "Lens", value: "2.8mm fixed" },
    ],
    relatedSlugs: ["hikvision-8ch-nvr", "ubiquiti-unifi-dream-machine", "tp-link-archer-ax73"],
    rating: 4.7,
    reviewCount: 33,
  },
  {
    posId: "POS-1005",
    slug: "ubiquiti-unifi-dream-machine",
    shortDescription: "All-in-one enterprise router and UniFi controller in a 1U appliance.",
    description:
      "UDM-Pro integrates routing, switching, IDS/IPS, and the UniFi controller in a 1U rack appliance with 10G SFP+ WAN. Designed for small-to-medium business networks.",
    warranty: "1 Year",
    featured: true,
    visible: true,
    image: UNSPLASH("1606904825846-647eb07f5be2"),
    gallery: [UNSPLASH("1606904825846-647eb07f5be2")],
    badges: ["1U", "10G SFP+", "ENTERPRISE"],
    specs: [
      { label: "Form Factor", value: "1U Rack" },
      { label: "WAN", value: "1× SFP+, 1× RJ45" },
      { label: "Throughput", value: "3.5 Gbps (IDS off)" },
      { label: "LAN Ports", value: "8× Gigabit" },
      { label: "Storage", value: "128GB SSD" },
    ],
    relatedSlugs: ["tp-link-archer-ax73", "hikvision-8ch-nvr", "dell-optiplex-7010-desktop"],
    rating: 4.8,
    reviewCount: 18,
  },
  {
    posId: "POS-1006",
    slug: "dell-optiplex-7010-desktop",
    shortDescription:
      "Compact business desktop with 13th-gen Intel Core i5, 16GB RAM and 512GB SSD.",
    description:
      "Reliable office workstation built for productivity. Intel Core i5-13500, 16GB DDR5, 512GB NVMe SSD, Windows 11 Pro pre-installed.",
    warranty: "3 Years ProSupport",
    featured: true,
    visible: true,
    image: UNSPLASH("1593640408182-31c70c8268f5"),
    gallery: [UNSPLASH("1593640408182-31c70c8268f5")],
    badges: ["i5", "16GB", "512GB SSD"],
    specs: [
      { label: "CPU", value: "Intel Core i5-13500" },
      { label: "RAM", value: "16GB DDR5" },
      { label: "Storage", value: "512GB NVMe SSD" },
      { label: "GPU", value: "Intel UHD 770" },
      { label: "OS", value: "Windows 11 Pro" },
      { label: "Form Factor", value: "Mini Tower" },
    ],
    relatedSlugs: ["hp-laserjet-m404dn", "ubiquiti-unifi-dream-machine"],
    rating: 4.6,
    reviewCount: 11,
  },
  {
    posId: "POS-1007",
    slug: "yt-pro-400w-mono-panel",
    shortDescription: "Compact 400W panel ideal for residential rooftop installations.",
    description:
      "Lightweight 400W monocrystalline module suited for residential rooftop arrays with a 25-year linear warranty.",
    warranty: "25 Years Linear",
    featured: false,
    visible: true,
    image: UNSPLASH("1473341304170-971dccb5ac1e"),
    gallery: [UNSPLASH("1473341304170-971dccb5ac1e")],
    badges: ["400W", "TIER 1"],
    specs: [
      { label: "Maximum Power", value: "400 W" },
      { label: "Efficiency", value: "20.4%" },
      { label: "Cell Type", value: "Monocrystalline" },
      { label: "Warranty", value: "25 Years Linear" },
    ],
    relatedSlugs: ["yt-pro-550w-mono-panel", "growatt-5kw-hybrid-inverter"],
    rating: 4.6,
    reviewCount: 12,
  },
  {
    posId: "POS-1008",
    slug: "hikvision-8ch-nvr",
    shortDescription: "8-channel network video recorder with PoE switch and 2TB HDD.",
    description:
      "DS-7608NI-K1/8P 8-channel NVR with built-in 8-port PoE switch, 4K resolution support, and a pre-installed 2TB surveillance-grade HDD.",
    warranty: "2 Years",
    featured: false,
    visible: true,
    image: UNSPLASH("1563770660941-20978e870e26"),
    gallery: [UNSPLASH("1563770660941-20978e870e26")],
    badges: ["8CH", "4K", "PoE"],
    specs: [
      { label: "Channels", value: "8" },
      { label: "Storage", value: "2TB HDD (pre-installed)" },
      { label: "Resolution", value: "Up to 4K" },
      { label: "PoE Ports", value: "8" },
    ],
    relatedSlugs: ["hikvision-4mp-dome-camera", "ubiquiti-unifi-dream-machine"],
    rating: 4.7,
    reviewCount: 9,
  },
  {
    posId: "POS-1009",
    slug: "tp-link-archer-ax73",
    shortDescription: "AX5400 dual-band WiFi 6 router with OFDMA and 1024-QAM.",
    description:
      "AX5400 WiFi 6 router with 4× Gigabit LAN, OneMesh support, and HomeShield protection. Currently out of stock — restocking soon.",
    warranty: "2 Years",
    featured: false,
    visible: true,
    image: UNSPLASH("1606904825846-647eb07f5be2"),
    gallery: [UNSPLASH("1606904825846-647eb07f5be2")],
    badges: ["WiFi 6", "AX5400"],
    specs: [
      { label: "Standard", value: "WiFi 6 (802.11ax)" },
      { label: "Speed", value: "AX5400 (4804 + 574 Mbps)" },
      { label: "LAN Ports", value: "4× Gigabit" },
      { label: "Antennas", value: "6 fixed external" },
    ],
    relatedSlugs: ["ubiquiti-unifi-dream-machine", "hikvision-4mp-dome-camera"],
    rating: 4.5,
    reviewCount: 7,
  },
  {
    posId: "POS-1010",
    slug: "felicity-3.5kva-inverter",
    shortDescription: "3.5KVA pure sine wave inverter perfect for small homes and offices.",
    description:
      "Felicity 3.5KVA / 24V inverter with intelligent battery charger and overload protection. Ideal entry-level backup for small homes.",
    warranty: "2 Years",
    featured: false,
    visible: true,
    image: UNSPLASH("1581094794329-c8112a89af12"),
    gallery: [UNSPLASH("1581094794329-c8112a89af12")],
    badges: ["3.5KVA", "24V"],
    specs: [
      { label: "Capacity", value: "3.5KVA / 3500W" },
      { label: "Battery Voltage", value: "24V DC" },
      { label: "Output", value: "Pure Sine Wave" },
      { label: "Charger", value: "70A intelligent" },
    ],
    relatedSlugs: ["growatt-5kw-hybrid-inverter", "trojan-agm-200ah-battery"],
    rating: 4.4,
    reviewCount: 5,
  },
  {
    posId: "POS-1011",
    slug: "trojan-agm-200ah-battery",
    shortDescription: "Trojan-grade 12V 200Ah AGM deep-cycle battery for backup systems.",
    description:
      "Sealed maintenance-free AGM deep cycle battery with 200Ah capacity. Suitable for inverter backup, solar storage, and UPS applications.",
    warranty: "18 Months",
    featured: false,
    visible: true,
    image: UNSPLASH("1620714223084-8fcacc6dfd8d"),
    gallery: [UNSPLASH("1620714223084-8fcacc6dfd8d")],
    badges: ["12V", "200Ah", "AGM"],
    specs: [
      { label: "Chemistry", value: "AGM Sealed Lead Acid" },
      { label: "Capacity", value: "200Ah" },
      { label: "Voltage", value: "12V" },
      { label: "Cycles", value: "~500 @ 50% DoD" },
    ],
    relatedSlugs: ["yt-lfp-48v-200ah-battery", "felicity-3.5kva-inverter"],
    rating: 4.3,
    reviewCount: 6,
  },
  {
    posId: "POS-1012",
    slug: "hp-laserjet-m404dn",
    shortDescription: "Compact mono laser printer with duplex, network and 38ppm.",
    description:
      "HP LaserJet Pro M404dn mono laser printer with auto duplex, Ethernet networking and 38 ppm output. Built for busy offices.",
    warranty: "1 Year",
    featured: false,
    visible: true,
    image: UNSPLASH("1612815154858-60aa4c59eaa6"),
    gallery: [UNSPLASH("1612815154858-60aa4c59eaa6")],
    badges: ["38PPM", "DUPLEX", "ETHERNET"],
    specs: [
      { label: "Type", value: "Mono Laser" },
      { label: "Speed", value: "38 ppm" },
      { label: "Duplex", value: "Automatic" },
      { label: "Connectivity", value: "USB, Ethernet" },
    ],
    relatedSlugs: ["dell-optiplex-7010-desktop"],
    rating: 4.5,
    reviewCount: 4,
  },
];

/* =========================================================
 * Reviews
 * ========================================================= */
export interface MockReview {
  id: string;
  posId: string;
  author: string;
  rating: number; // 1..5
  title: string;
  body: string;
  createdAt: number;
  verifiedPurchase: boolean;
}

const day = 1000 * 60 * 60 * 24;

export const mockReviews: MockReview[] = [
  {
    id: "r1",
    posId: "POS-1001",
    author: "Adaeze O.",
    rating: 5,
    title: "Exceeds spec sheet",
    body: "Output stayed within 2% of rated power even at 38°C ambient. Build quality is excellent.",
    createdAt: Date.now() - 3 * day,
    verifiedPurchase: true,
  },
  {
    id: "r2",
    posId: "POS-1001",
    author: "Engineer K.",
    rating: 5,
    title: "Strong choice for rooftops",
    body: "Bought 12 panels for a 6.6kW system. Installation was straightforward and yields are great.",
    createdAt: Date.now() - 14 * day,
    verifiedPurchase: true,
  },
  {
    id: "r3",
    posId: "POS-1001",
    author: "Tunde A.",
    rating: 4,
    title: "Solid panel",
    body: "Quality is great, only wish delivery to Abuja was a bit faster.",
    createdAt: Date.now() - 30 * day,
    verifiedPurchase: false,
  },
  {
    id: "r4",
    posId: "POS-1002",
    author: "Chinedu I.",
    rating: 5,
    title: "Reliable hybrid",
    body: "Powering my home office for 3 months with no hiccups. MPPT tuning was easy.",
    createdAt: Date.now() - 7 * day,
    verifiedPurchase: true,
  },
  {
    id: "r5",
    posId: "POS-1002",
    author: "Hauwa S.",
    rating: 4,
    title: "Good but fan is loud",
    body: "Performance is excellent but the cooling fan kicks in often during the day.",
    createdAt: Date.now() - 21 * day,
    verifiedPurchase: true,
  },
  {
    id: "r6",
    posId: "POS-1003",
    author: "Bayo F.",
    rating: 5,
    title: "Best LFP I've used",
    body: "Paired with the Growatt 5kW — system runs my whole house overnight.",
    createdAt: Date.now() - 5 * day,
    verifiedPurchase: true,
  },
  {
    id: "r7",
    posId: "POS-1004",
    author: "Security Co.",
    rating: 5,
    title: "Crisp footage",
    body: "Night vision is sharp and the AcuSense filter cuts false alerts.",
    createdAt: Date.now() - 12 * day,
    verifiedPurchase: true,
  },
  {
    id: "r8",
    posId: "POS-1005",
    author: "IT Lead",
    rating: 5,
    title: "All-in-one perfection",
    body: "Replaced three boxes with this. Controller UI is very polished.",
    createdAt: Date.now() - 9 * day,
    verifiedPurchase: true,
  },
  {
    id: "r9",
    posId: "POS-1006",
    author: "Office Mgr.",
    rating: 4,
    title: "Great everyday workstation",
    body: "Boots fast, handles Office and Teams without breaking a sweat.",
    createdAt: Date.now() - 17 * day,
    verifiedPurchase: true,
  },
];

/* =========================================================
 * Orders mock (kept for checkout/order summary in later phases)
 * ========================================================= */
export interface MockOrder {
  id: string;
  reference: string;
  status: "pending" | "paid" | "processing" | "shipped" | "delivered" | "cancelled";
  paymentStatus: "pending" | "paid" | "failed";
  total: number;
  subtotal: number;
  vat: number;
  itemCount: number;
  createdAt: number;
  customerEmail: string;
  items: { name: string; sku: string; qty: number; price: number }[];
}

const DAY = 24 * 60 * 60 * 1000;
export const mockOrders: MockOrder[] = [
  {
    id: "YT-2049",
    reference: "PSK_REF_2049",
    status: "delivered",
    paymentStatus: "paid",
    subtotal: 540_000,
    vat: 40_500,
    total: 580_500,
    itemCount: 2,
    createdAt: Date.now() - 18 * DAY,
    customerEmail: "buyer@example.com",
    items: [{ name: "550W Monocrystalline Solar Panel", sku: "SLR-550M", qty: 2, price: 270_000 }],
  },
  {
    id: "YT-2057",
    reference: "PSK_REF_2057",
    status: "shipped",
    paymentStatus: "paid",
    subtotal: 320_000,
    vat: 24_000,
    total: 344_000,
    itemCount: 1,
    createdAt: Date.now() - 4 * DAY,
    customerEmail: "buyer@example.com",
    items: [{ name: "5kVA Hybrid Inverter", sku: "INV-5KH", qty: 1, price: 320_000 }],
  },
  {
    id: "YT-2061",
    reference: "PSK_REF_2061",
    status: "processing",
    paymentStatus: "paid",
    subtotal: 95_000,
    vat: 7_125,
    total: 102_125,
    itemCount: 3,
    createdAt: Date.now() - 1 * DAY,
    customerEmail: "buyer@example.com",
    items: [{ name: "MC4 Solar Connector Pair", sku: "ACC-MC4", qty: 3, price: 31_667 }],
  },
];
