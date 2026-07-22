/**
 * pdf-generator.ts
 * Generates professional, corporate-grade Yarotech business reports as vector PDFs.
 * Uses jsPDF directly (no html2canvas screenshot — all text is selectable and crisp).
 */
import { jsPDF } from "jspdf";

/* ─── Brand tokens ──────────────────────────────────────────────────── */
const NAVY = "#0D1C32";
const GOLD = "#FEA619";
const WHITE = "#FFFFFF";
const LIGHT_GREY = "#F5F6F8";
const MID_GREY = "#9CA3AF";
const DARK_TEXT = "#1F2937";
const ROW_ALT = "#EEF2FF";

/* ─── Page geometry (A4 landscape = 297 × 210 mm) ──────────────────── */
const PW = 297; // page width
const PH = 210; // page height
const ML = 14; // margin left
const MR = 14; // margin right
const CW = PW - ML - MR; // content width

/* ─── Helpers ────────────────────────────────────────────────────────── */
function ngn(amount: number): string {
  const num = new Intl.NumberFormat("en-NG", {
    style: "decimal",
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
  return `NGN ${num}`;
}

function hex(doc: jsPDF, color: string): void {
  doc.setDrawColor(color);
  doc.setFillColor(color);
  doc.setTextColor(color);
}

function textColor(doc: jsPDF, color: string): void {
  doc.setTextColor(color);
}

function fillRect(doc: jsPDF, x: number, y: number, w: number, h: number, color: string): void {
  doc.setFillColor(color);
  doc.rect(x, y, w, h, "F");
}

function drawLine(
  doc: jsPDF,
  x1: number,
  y1: number,
  x2: number,
  y2: number,
  color: string,
  lw = 0.3,
): void {
  doc.setDrawColor(color);
  doc.setLineWidth(lw);
  doc.line(x1, y1, x2, y2);
}

function rangeLabel(range: string, startDate?: string, endDate?: string): string {
  if (range === "custom" && startDate && endDate) {
    return `Custom: ${startDate} to ${endDate}`;
  }
  const labels: Record<string, string> = {
    week: "Weekly Report",
    month: "Monthly Report",
    quarter: "Quarterly Report",
    year: "Annual Report",
    custom: "Custom Range Report",
  };
  return labels[range] ?? "Business Report";
}

/* ─── Page break guard ───────────────────────────────────────────────── */
function ensureSpace(doc: jsPDF, y: number, needed: number, margin = 195): number {
  if (y + needed > margin) {
    doc.addPage();
    return 20;
  }
  return y;
}

/* ─── Main export function ───────────────────────────────────────────── */
export function generateReportPDF(
  range: string,
  data: any,
  startDate?: string,
  endDate?: string,
): void {
  const doc = new jsPDF({ orientation: "landscape", unit: "mm", format: "a4" });
  const generatedAt = new Date().toLocaleString("en-NG", {
    dateStyle: "long",
    timeStyle: "short",
  });

  let y = 0;

  /* ══════════════════════════════════════════════════════════════════
   * PAGE HEADER — full-width navy banner
   * ══════════════════════════════════════════════════════════════════ */
  fillRect(doc, 0, 0, PW, 38, NAVY);

  // Gold accent bar left edge
  fillRect(doc, 0, 0, 4, 38, GOLD);

  // Company name
  doc.setFont("helvetica", "bold");
  doc.setFontSize(16);
  textColor(doc, GOLD);
  doc.text("YAROTECH GROUP", ML + 4, 13);

  // Sub-name
  doc.setFont("helvetica", "normal");
  doc.setFontSize(9);
  textColor(doc, "#94A3B8");
  doc.text("Network Limited  •  Business Intelligence Report", ML + 4, 20);

  // Report type + date on the right
  doc.setFont("helvetica", "bold");
  doc.setFontSize(10);
  textColor(doc, WHITE);
  const label = rangeLabel(range, startDate, endDate);
  doc.text(label, PW - MR, 13, { align: "right" });

  doc.setFont("helvetica", "normal");
  doc.setFontSize(8);
  textColor(doc, "#94A3B8");
  doc.text(`Generated: ${generatedAt}`, PW - MR, 20, { align: "right" });

  // Horizontal gold separator line under header
  fillRect(doc, 0, 38, PW, 1.5, GOLD);

  y = 46;

  /* ══════════════════════════════════════════════════════════════════
   * KPI TILES — 4-column row
   * ══════════════════════════════════════════════════════════════════ */
  const tiles = [
    { label: "Total Revenue", value: ngn(data?.totals?.revenue ?? 0) },
    { label: "Total Orders", value: String(data?.totals?.orders ?? 0) },
    { label: "VAT Collected", value: ngn(data?.totals?.vat ?? 0) },
    { label: "Avg Order Value", value: ngn(data?.totals?.avgOrderValue ?? 0) },
  ];

  const tileW = (CW - 9) / 4; // 3 gaps of 3mm
  const tileH = 24;

  tiles.forEach((tile, i) => {
    const tx = ML + i * (tileW + 3);

    // Card bg
    fillRect(doc, tx, y, tileW, tileH, LIGHT_GREY);
    // Top gold accent bar on each card
    fillRect(doc, tx, y, tileW, 2, GOLD);
    // Card border
    doc.setDrawColor("#E5E7EB");
    doc.setLineWidth(0.2);
    doc.rect(tx, y, tileW, tileH, "S");

    // Label
    doc.setFont("helvetica", "normal");
    doc.setFontSize(7);
    textColor(doc, MID_GREY);
    doc.text(tile.label.toUpperCase(), tx + 4, y + 9);

    // Value
    doc.setFont("helvetica", "bold");
    doc.setFontSize(13);
    textColor(doc, NAVY);
    doc.text(tile.value, tx + 4, y + 19);
  });

  y += tileH + 10;

  /* ══════════════════════════════════════════════════════════════════
   * SALES OVER TIME — condensed table (left half)
   * ══════════════════════════════════════════════════════════════════ */
  const halfW = (CW - 6) / 2;
  const leftX = ML;
  const rightX = ML + halfW + 6;

  // Section heading
  fillRect(doc, leftX, y, halfW, 8, NAVY);
  doc.setFont("helvetica", "bold");
  doc.setFontSize(8);
  textColor(doc, GOLD);
  doc.text("SALES OVER TIME", leftX + 4, y + 5.5);

  y += 8;

  // Column headers
  fillRect(doc, leftX, y, halfW, 6, "#1E3A5F");
  doc.setFont("helvetica", "bold");
  doc.setFontSize(7);
  textColor(doc, WHITE);
  doc.text("PERIOD", leftX + 3, y + 4.2);
  doc.text("TOTAL SALES", leftX + halfW * 0.4, y + 4.2);
  doc.text("E-COMM", leftX + halfW * 0.62, y + 4.2);
  doc.text("POS", leftX + halfW * 0.8, y + 4.2);
  doc.text("ORDERS", leftX + halfW - 18, y + 4.2, { align: "left" });

  y += 6;

  const series: any[] = Array.isArray(data?.series) ? data.series : [];
  const maxRows = 12;
  const rowH = 5.5;

  series.slice(0, maxRows).forEach((row, i) => {
    const bg = i % 2 === 0 ? WHITE : ROW_ALT;
    fillRect(doc, leftX, y, halfW, rowH, bg);

    doc.setFont("helvetica", "normal");
    doc.setFontSize(7);
    textColor(doc, DARK_TEXT);
    doc.text(String(row.label ?? ""), leftX + 3, y + 3.8);
    doc.text(ngn(row.total_sales ?? 0), leftX + halfW * 0.4, y + 3.8);
    doc.text(ngn(row.ecommerce_sales ?? 0), leftX + halfW * 0.62, y + 3.8);
    doc.text(ngn(row.pos_sales ?? 0), leftX + halfW * 0.8, y + 3.8);
    doc.text(String(row.orders ?? 0), leftX + halfW - 3, y + 3.8, { align: "right" });

    drawLine(doc, leftX, y + rowH, leftX + halfW, y + rowH, "#E5E7EB", 0.1);
    y += rowH;
  });

  if (series.length === 0) {
    fillRect(doc, leftX, y, halfW, 8, "#F9FAFB");
    doc.setFont("helvetica", "italic");
    doc.setFontSize(7);
    textColor(doc, MID_GREY);
    doc.text("No series data for selected period.", leftX + 4, y + 5);
    y += 8;
  }

  /* ══════════════════════════════════════════════════════════════════
   * TOP PRODUCTS — right half (starts at same y as sales table)
   * ══════════════════════════════════════════════════════════════════ */
  let ry = 46 + tileH + 10; // reset to same starting y as left panel

  // Section heading
  fillRect(doc, rightX, ry, halfW, 8, NAVY);
  doc.setFont("helvetica", "bold");
  doc.setFontSize(8);
  textColor(doc, GOLD);
  doc.text("TOP PRODUCTS BY REVENUE", rightX + 4, ry + 5.5);

  ry += 8;

  // Column headers
  fillRect(doc, rightX, ry, halfW, 6, "#1E3A5F");
  doc.setFont("helvetica", "bold");
  doc.setFontSize(7);
  textColor(doc, WHITE);
  doc.text("PRODUCT NAME", rightX + 3, ry + 4.2);
  doc.text("UNITS SOLD", rightX + halfW * 0.62, ry + 4.2);
  doc.text("REVENUE", rightX + halfW - 3, ry + 4.2, { align: "right" });

  ry += 6;

  const products: any[] = Array.isArray(data?.productPerformance) ? data.productPerformance : [];

  products.slice(0, maxRows).forEach((prod, i) => {
    const bg = i % 2 === 0 ? WHITE : ROW_ALT;
    fillRect(doc, rightX, ry, halfW, rowH, bg);

    // Rank badge for top 3
    if (i < 3) {
      fillRect(doc, rightX + 2, ry + 1, 6, 3.5, GOLD);
      doc.setFont("helvetica", "bold");
      doc.setFontSize(6);
      textColor(doc, NAVY);
      doc.text(`#${i + 1}`, rightX + 5, ry + 3.4, { align: "center" });
    }

    doc.setFont("helvetica", "normal");
    doc.setFontSize(7);
    textColor(doc, DARK_TEXT);

    const name = String(prod.name ?? "").slice(0, 36);
    doc.text(name, rightX + (i < 3 ? 10 : 3), ry + 3.8);
    doc.text(String(prod.units ?? prod.unitsSold ?? 0), rightX + halfW * 0.62, ry + 3.8);
    doc.text(ngn(prod.revenue ?? 0), rightX + halfW - 3, ry + 3.8, { align: "right" });

    drawLine(doc, rightX, ry + rowH, rightX + halfW, ry + rowH, "#E5E7EB", 0.1);
    ry += rowH;
  });

  if (products.length === 0) {
    fillRect(doc, rightX, ry, halfW, 8, "#F9FAFB");
    doc.setFont("helvetica", "italic");
    doc.setFontSize(7);
    textColor(doc, MID_GREY);
    doc.text("No product performance data available.", rightX + 4, ry + 5);
    ry += 8;
  }

  /* ══════════════════════════════════════════════════════════════════
   * NEW PAGE — Payment channels & order status summary
   * ══════════════════════════════════════════════════════════════════ */
  doc.addPage();

  // Slim page header
  fillRect(doc, 0, 0, PW, 14, NAVY);
  fillRect(doc, 0, 0, 4, 14, GOLD);
  doc.setFont("helvetica", "bold");
  doc.setFontSize(9);
  textColor(doc, WHITE);
  doc.text("YAROTECH GROUP  •  " + label, ML + 4, 9);
  doc.setFont("helvetica", "normal");
  doc.setFontSize(7);
  textColor(doc, "#94A3B8");
  doc.text(generatedAt, PW - MR, 9, { align: "right" });
  fillRect(doc, 0, 14, PW, 1, GOLD);

  y = 22;

  /* ── Payment channels ──────────────────────────────────────────── */
  const chanW = halfW;
  const chanX = ML;

  fillRect(doc, chanX, y, chanW, 8, NAVY);
  doc.setFont("helvetica", "bold");
  doc.setFontSize(8);
  textColor(doc, GOLD);
  doc.text("PAYMENT CHANNEL MIX", chanX + 4, y + 5.5);
  y += 8;

  fillRect(doc, chanX, y, chanW, 6, "#1E3A5F");
  doc.setFont("helvetica", "bold");
  doc.setFontSize(7);
  textColor(doc, WHITE);
  doc.text("CHANNEL", chanX + 3, y + 4.2);
  doc.text("SHARE %", chanX + chanW * 0.4, y + 4.2);
  doc.text("AMOUNT", chanX + chanW - 3, y + 4.2, { align: "right" });
  y += 6;

  const channels: any[] = Array.isArray(data?.channel_mix)
    ? data.channel_mix
    : Array.isArray(data?.channelMix)
      ? data.channelMix
      : [];

  channels.forEach((ch, i) => {
    const bg = i % 2 === 0 ? WHITE : ROW_ALT;
    fillRect(doc, chanX, y, chanW, rowH, bg);

    const pct = parseFloat(String(ch.percent ?? ch.value ?? 0));
    // Mini bar
    const barMaxW = chanW * 0.28;
    fillRect(doc, chanX + chanW * 0.4, y + 1.5, barMaxW, 2.5, "#E5E7EB");
    fillRect(doc, chanX + chanW * 0.4, y + 1.5, (pct / 100) * barMaxW, 2.5, GOLD);

    doc.setFont("helvetica", "normal");
    doc.setFontSize(7);
    textColor(doc, DARK_TEXT);
    const rawChan = String(ch.channel ?? ch.payment_method ?? "Unknown");
    const displayChan = rawChan.charAt(0).toUpperCase() + rawChan.slice(1).toLowerCase();
    doc.text(displayChan, chanX + 3, y + 3.8);
    doc.text(`${pct.toFixed(1)}%`, chanX + chanW * 0.4 + barMaxW + 2, y + 3.8);
    doc.text(ngn(ch.amount ?? 0), chanX + chanW - 3, y + 3.8, { align: "right" });

    drawLine(doc, chanX, y + rowH, chanX + chanW, y + rowH, "#E5E7EB", 0.1);
    y += rowH;
  });

  if (channels.length === 0) {
    fillRect(doc, chanX, y, chanW, 8, "#F9FAFB");
    doc.setFont("helvetica", "italic");
    doc.setFontSize(7);
    textColor(doc, MID_GREY);
    doc.text("No channel data available.", chanX + 4, y + 5);
    y += 8;
  }

  /* ── Order status summary ─────────────────────────────────────── */
  let sy = 22;
  const statX = ML + halfW + 6;
  const statW = halfW;

  fillRect(doc, statX, sy, statW, 8, NAVY);
  doc.setFont("helvetica", "bold");
  doc.setFontSize(8);
  textColor(doc, GOLD);
  doc.text("ORDER STATUS SUMMARY", statX + 4, sy + 5.5);
  sy += 8;

  fillRect(doc, statX, sy, statW, 6, "#1E3A5F");
  doc.setFont("helvetica", "bold");
  doc.setFontSize(7);
  textColor(doc, WHITE);
  doc.text("STATUS", statX + 3, sy + 4.2);
  doc.text("COUNT", statX + statW - 3, sy + 4.2, { align: "right" });
  sy += 6;

  const statusItems: any[] = Array.isArray(data?.order_status_summary?.items)
    ? data.order_status_summary.items
    : [];

  const STATUS_COLORS: Record<string, string> = {
    delivered: "#16A34A",
    shipped: "#2563EB",
    processing: "#D97706",
    pending: "#9CA3AF",
    cancelled: "#DC2626",
    paid: "#16A34A",
  };

  statusItems.forEach((s, i) => {
    const bg = i % 2 === 0 ? WHITE : ROW_ALT;
    fillRect(doc, statX, sy, statW, rowH, bg);

    const statusKey = String(s.status ?? "").toLowerCase();
    const dotColor = STATUS_COLORS[statusKey] ?? MID_GREY;

    // Status dot
    doc.setFillColor(dotColor);
    doc.circle(statX + 5, sy + rowH / 2, 1.2, "F");

    doc.setFont("helvetica", "normal");
    doc.setFontSize(7);
    textColor(doc, DARK_TEXT);
    doc.text(String(s.status ?? "").toUpperCase(), statX + 9, sy + 3.8);
    doc.setFont("helvetica", "bold");
    doc.text(String(s.count ?? 0), statX + statW - 3, sy + 3.8, { align: "right" });

    drawLine(doc, statX, sy + rowH, statX + statW, sy + rowH, "#E5E7EB", 0.1);
    sy += rowH;
  });

  if (statusItems.length === 0) {
    fillRect(doc, statX, sy, statW, 8, "#F9FAFB");
    doc.setFont("helvetica", "italic");
    doc.setFontSize(7);
    textColor(doc, MID_GREY);
    doc.text("No order status data available.", statX + 4, sy + 5);
    sy += 8;
  }

  /* ══════════════════════════════════════════════════════════════════
   * FOOTER — every page
   * ══════════════════════════════════════════════════════════════════ */
  const totalPages = doc.getNumberOfPages();
  for (let p = 1; p <= totalPages; p++) {
    doc.setPage(p);
    fillRect(doc, 0, PH - 8, PW, 8, NAVY);
    doc.setFont("helvetica", "normal");
    doc.setFontSize(6.5);
    textColor(doc, "#475569");
    doc.text("YAROTECH Group — Network Limited  •  Confidential Internal Report", ML, PH - 3);
    doc.text(`Page ${p} of ${totalPages}`, PW - MR, PH - 3, { align: "right" });
  }

  /* ── Trigger download ─────────────────────────────────────────── */
  const fileName = `yarotech-report-${range}-${new Date().toISOString().slice(0, 10)}.pdf`;
  doc.save(fileName);
}
