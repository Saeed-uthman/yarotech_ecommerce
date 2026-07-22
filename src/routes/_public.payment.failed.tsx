import { createFileRoute, Link } from "@tanstack/react-router";
import { XCircle, RefreshCw, LifeBuoy } from "lucide-react";

interface Search {
  ref?: string;
  orderId?: string;
  reason?: string;
}

export const Route = createFileRoute("/_public/payment/failed")({
  validateSearch: (s: Record<string, unknown>): Search => ({
    ref: typeof s.ref === "string" ? s.ref : undefined,
    orderId: typeof s.orderId === "string" ? s.orderId : undefined,
    reason: typeof s.reason === "string" ? s.reason : undefined,
  }),
  head: () => ({ meta: [{ title: "Payment Failed — YAROTECH" }] }),
  component: FailedPage,
});

function FailedPage() {
  const { ref, orderId, reason } = Route.useSearch();
  return (
    <div className="bg-[radial-gradient(circle,rgba(10,23,51,0.06)_1px,transparent_1px)] bg-[length:16px_16px] py-10">
      <div className="mx-auto max-w-md px-4">
        <div className="rounded-md border border-border bg-surface p-5 sm:p-8 text-center shadow-sm">
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-destructive/10">
            <XCircle className="h-10 w-10 text-destructive" />
          </div>
          <h1 className="mt-4 font-display text-2xl sm:text-3xl font-bold text-primary">Payment Failed</h1>
          <p className="mt-2 text-sm text-muted-foreground">
            {reason ?? "Your transaction could not be completed. No funds were charged."}
          </p>

          <div className="mt-5 grid gap-2 rounded-sm border border-border bg-accent/30 p-3 sm:p-4 text-left text-xs sm:text-sm">
            <Row label="Order" value={orderId ?? "—"} mono />
            <Row label="Reference" value={ref ?? "—"} mono />
          </div>

          <div className="mt-6 flex flex-col gap-2 sm:flex-row sm:justify-center">
            <Link
              to="/checkout"
              className="inline-flex w-full sm:w-auto h-11 items-center justify-center gap-2 rounded-sm bg-secondary px-5 text-sm font-bold text-secondary-foreground hover:opacity-90"
            >
              <RefreshCw className="h-4 w-4" /> Try Again
            </Link>
            <Link
              to="/contact"
              className="inline-flex w-full sm:w-auto h-11 items-center justify-center gap-2 rounded-sm border border-border bg-surface px-5 text-sm font-semibold text-primary hover:bg-accent"
            >
              <LifeBuoy className="h-4 w-4" /> Contact Support
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}

function Row({ label, value, mono = false }: { label: string; value: string; mono?: boolean }) {
  return (
    <div className="flex items-center justify-between gap-2">
      <span className="text-muted-foreground">{label}</span>
      <span className={`font-semibold text-primary ${mono ? "font-mono text-xs" : ""}`}>
        {value}
      </span>
    </div>
  );
}
