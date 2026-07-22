import { Outlet, Link, createFileRoute } from "@tanstack/react-router";
import { ArrowLeft, CircleCheck, ShieldCheck, Truck } from "lucide-react";
import { Logo } from "@/components/brand/Logo";

export const Route = createFileRoute("/_auth")({
  component: AuthLayout,
});

function AuthLayout() {
  return (
    <div className="grid min-h-screen grid-cols-1 bg-background lg:grid-cols-2">
      {/* ── Left panel (desktop only) ── */}
      <div className="relative hidden overflow-hidden bg-primary text-primary-foreground lg:flex lg:flex-col lg:justify-between lg:p-10">
        <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_85%_10%,color-mix(in_oklab,var(--secondary)_24%,transparent),transparent_44%)]" />

        <div className="relative flex items-center justify-between">
          <Logo showWordmark={false} />
          <span className="font-display text-xl font-bold tracking-wide">YAROTECH</span>
        </div>

        <div className="relative max-w-md">
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-secondary">
            Trusted Procurement Platform
          </p>
          <h2 className="mt-3 font-display text-4xl font-bold leading-tight">
            Build resilient power, security, and network infrastructure with confidence.
          </h2>
          <p className="mt-4 text-sm leading-relaxed text-primary-foreground/75">
            Join organizations across Nigeria using YAROTECH to source verified equipment and deploy
            technical projects with expert guidance.
          </p>

          <ul className="mt-7 space-y-3 text-sm text-primary-foreground/80">
            <li className="flex items-center gap-2">
              <ShieldCheck className="h-4 w-4 text-secondary" />
              Secure account and checkout flow
            </li>
            <li className="flex items-center gap-2">
              <Truck className="h-4 w-4 text-secondary" />
              Nationwide delivery support
            </li>
            <li className="flex items-center gap-2">
              <CircleCheck className="h-4 w-4 text-secondary" />
              Verified catalog and technical advisory
            </li>
          </ul>
        </div>

        <p className="relative text-xs text-primary-foreground/50">
          &copy; {new Date().getFullYear()} YAROTECH
        </p>
      </div>

      {/* ── Right panel (form side) ── */}
      <div className="flex min-h-screen flex-col bg-background">
        {/* Mobile top bar */}
        <header className="flex shrink-0 items-center justify-between border-b border-border px-4 py-3 lg:hidden">
          <Logo className="gap-1.5" />
          <Link
            to="/"
            className="inline-flex items-center gap-1 rounded-sm px-2 py-1.5 text-xs font-semibold text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
          >
            <ArrowLeft className="h-3.5 w-3.5" />
            Back to site
          </Link>
        </header>

        {/* Scrollable form area */}
        <div className="flex flex-1 items-start justify-center overflow-y-auto px-4 py-6 sm:items-center sm:px-6 sm:py-10">
          <div className="w-full max-w-md rounded-xl border border-border bg-surface p-5 shadow-sm sm:p-7">
            <Outlet />
          </div>
        </div>

        {/* Mobile bottom trust badge */}
        <footer className="shrink-0 border-t border-border px-4 py-3 lg:hidden">
          <p className="text-center text-[10px] text-muted-foreground">
            🔒 Your data is encrypted &amp; secure · YAROTECH &copy; {new Date().getFullYear()}
          </p>
        </footer>
      </div>
    </div>
  );
}
