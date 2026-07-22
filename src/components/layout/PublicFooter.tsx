import { Link } from "@tanstack/react-router";
import {
  Instagram,
  Linkedin,
  Mail,
  MapPin,
  Phone,
  ArrowUpRight,
} from "lucide-react";
import { Logo } from "@/components/brand/Logo";

const Tiktok = (props: React.SVGProps<SVGSVGElement>) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
    {...props}
  >
    <path d="M9 12a4 4 0 1 0 4 4V4a5 5 0 0 0 5 5" />
  </svg>
);

const Whatsapp = (props: React.SVGProps<SVGSVGElement>) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
    {...props}
  >
    <path d="M3 21l1.65-3.8a9 9 0 1 1 3.4 2.9L3 21" />
    <path d="M9 10a.5.5 0 0 0 1 0V9a.5.5 0 0 0-1 0v1a5 5 0 0 0 5 5h1a.5.5 0 0 0 0-1h-1a.5.5 0 0 0 0 1" />
  </svg>
);

const EXPLORE_LINKS = [
  { to: "/", label: "Home" },
  { to: "/shop", label: "Shop" },
  { to: "/services", label: "Services" },
  { to: "/about", label: "About Us" },
  { to: "/contact", label: "Contact" },
  { to: "/terms", label: "Terms & Conditions" },
  { to: "/privacy", label: "Privacy Policy" },
];

const SERVICES = [
  "IT Equipment Supply",
  "Networking & Infrastructure",
  "CCTV & Surveillance",
  "Solar & Power Systems",
  "Smart Home Automation",
  "Server & Cloud Setup",
  "POS & Billing Systems",
  "On-site Tech Support",
];

const SOCIAL_LINKS = [
  { href: "https://wa.me/2347075373603", label: "WhatsApp", icon: Whatsapp },
  { href: "https://www.tiktok.com/@yarotechgroup", label: "TikTok", icon: Tiktok },
  { href: "https://www.instagram.com/yarotech", label: "Instagram", icon: Instagram },
  { href: "https://www.linkedin.com/company/yarotech-group", label: "LinkedIn", icon: Linkedin },
];

export function PublicFooter() {
  return (
    <footer className="relative overflow-hidden border-t border-primary-foreground/20 bg-primary pb-20 text-primary-foreground md:pb-0">
      {/* Decorative gradient */}
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_80%_0%,color-mix(in_oklab,var(--secondary)_18%,transparent),transparent_45%)]" />
      <div className="pointer-events-none absolute bottom-0 left-0 h-64 w-64 rounded-full bg-[color-mix(in_oklab,var(--secondary)_6%,transparent)] blur-3xl" />

      {/* Main grid */}
      <div className="relative mx-auto grid max-w-7xl gap-12 px-6 py-14 md:grid-cols-12 md:gap-10 lg:py-16">
        {/* ── Col 1: Brand + Contact (left, widest) ── */}
        <div className="md:col-span-5">
          <Logo light={true} />

          <p className="mt-4 max-w-sm text-sm leading-relaxed text-primary-foreground/75">
            Premium technology procurement and deployment support for homes, facilities, and
            businesses across Nigeria.
          </p>

          {/* Contact block */}
          <div className="mt-7">
            <h4 className="mb-4 font-display text-xs font-bold uppercase tracking-[0.16em] text-secondary">
              Contact
            </h4>
            <div className="space-y-3.5 text-sm">
              <ContactItem
                icon={MapPin}
                label="Address"
                value="Lokoro plaza A farm center Kano, Nigeria — serving nationwide"
              />
              <ContactItem
                icon={Phone}
                label="Phone"
                value="+234 707 537 3603"
                href="tel:+2347075373603"
              />
              <ContactItem
                icon={Mail}
                label="Email"
                value="info@yarotech.com.ng"
                href="mailto:info@yarotech.ng"
              />
            </div>
          </div>

          {/* Social icons */}
          <div className="mt-7 flex items-center gap-2">
            {SOCIAL_LINKS.map(({ href, label, icon: Icon }) => (
              <a
                key={label}
                href={href}
                target="_blank"
                rel="noreferrer"
                aria-label={label}
                className="inline-flex h-9 w-9 items-center justify-center rounded-md border border-primary-foreground/25 bg-primary-foreground/5 text-primary-foreground/80 transition-all hover:border-secondary hover:bg-secondary hover:text-secondary-foreground"
              >
                <Icon className="h-4 w-4" />
              </a>
            ))}
          </div>
        </div>

        {/* ── Divider (vertical, desktop only) ── */}
        <div className="hidden self-stretch border-r border-primary-foreground/10 md:col-span-1 md:block" />

        {/* ── Col 2: Explore ── */}
        <div className="md:col-span-3">
          <h4 className="font-display text-xs font-bold uppercase tracking-[0.16em] text-secondary">
            Explore
          </h4>
          <ul className="mt-5 space-y-2.5">
            {EXPLORE_LINKS.map((l) => (
              <li key={l.to}>
                <Link
                  to={l.to}
                  className="group flex items-center gap-1.5 text-sm text-primary-foreground/72 transition-colors hover:text-primary-foreground"
                >
                  <span
                    className="h-1 w-1 rounded-full bg-secondary opacity-0 transition-opacity group-hover:opacity-100"
                    aria-hidden
                  />
                  {l.label}
                </Link>
              </li>
            ))}
          </ul>
        </div>

        {/* ── Col 3: Our Services ── */}
        <div className="md:col-span-3">
          <h4 className="font-display text-xs font-bold uppercase tracking-[0.16em] text-secondary">
            Our Services
          </h4>
          <ul className="mt-5 space-y-2.5">
            {SERVICES.map((service) => (
              <li key={service}>
                <Link
                  to="/services"
                  className="group flex items-center gap-1.5 text-sm text-primary-foreground/72 transition-colors hover:text-primary-foreground"
                >
                  <span
                    className="h-1 w-1 rounded-full bg-secondary opacity-0 transition-opacity group-hover:opacity-100"
                    aria-hidden
                  />
                  {service}
                </Link>
              </li>
            ))}
          </ul>

          {/* CTA chip */}
          <Link
            to="/services"
            className="mt-6 inline-flex items-center gap-1.5 rounded-full border border-secondary/50 bg-secondary/10 px-3.5 py-1.5 text-[11px] font-semibold uppercase tracking-wider text-secondary transition-all hover:bg-secondary hover:text-secondary-foreground"
          >
            View all services
            <ArrowUpRight className="h-3 w-3" />
          </Link>
        </div>
      </div>

      {/* ── Bottom bar ── */}
      <div className="relative border-t border-primary-foreground/10 px-6 py-5">
        <div className="mx-auto flex max-w-7xl flex-col items-center justify-between gap-2 text-xs text-primary-foreground/55 sm:flex-row">
          <span>
            &copy; {new Date().getFullYear()} YAROTECH Engineering Procurement. All rights reserved.
          </span>
          <div className="flex items-center gap-4">
            <Link to="/terms" className="transition-colors hover:text-primary-foreground">
              Terms
            </Link>
            <span className="opacity-30">·</span>
            <Link to="/privacy" className="transition-colors hover:text-primary-foreground">
              Privacy
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}

/* ─── helpers ─────────────────────────────────────────────────────────────── */

function ContactItem({
  icon: Icon,
  label,
  value,
  href,
}: {
  icon: React.ComponentType<{ className?: string }>;
  label: string;
  value: string;
  href?: string;
}) {
  const content = (
    <div className="flex items-start gap-3">
      <div className="mt-0.5 flex h-7 w-7 shrink-0 items-center justify-center rounded-md bg-secondary/15">
        <Icon className="h-3.5 w-3.5 text-secondary" />
      </div>
      <div>
        <p className="text-[10px] uppercase tracking-[0.14em] text-primary-foreground/50">
          {label}
        </p>
        <p className="text-sm text-primary-foreground/85">{value}</p>
      </div>
    </div>
  );

  if (!href) return content;

  return (
    <a href={href} className="block transition-opacity hover:opacity-85">
      {content}
    </a>
  );
}
