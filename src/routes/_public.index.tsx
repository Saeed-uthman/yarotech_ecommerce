import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import {
  ArrowRight,
  ArrowUpRight,
  ShieldCheck,
  Truck,
  MapPin,
  Headset,
  Sun,
  Cpu,
  BatteryCharging,
  Camera,
  Wifi,
  Server,
  Wrench,
  Network,
  Settings2,
} from "lucide-react";
import { listProducts, type Product } from "@/api/products";
import { ProductCard } from "@/components/product/ProductCard";
import { LoadingState } from "@/components/common/EmptyState";
import { JsonLd } from "@/components/seo/JsonLd";
import { canonicalMeta, SITE_URL, DEFAULT_OG_IMAGE } from "@/lib/seo";
import heroImage from "@/assets/home-hero.jpg";

export const Route = createFileRoute("/_public/")({
  head: () => ({
    meta: [
      {
        title: "YAROTECH - Solar, CCTV, Networking and IT Equipment in Nigeria",
      },
      {
        name: "description",
        content:
          "Premium solar, CCTV, networking and IT systems for homes and businesses across Nigeria.",
      },
      {
        property: "og:title",
        content: "YAROTECH - Powering Smarter Homes and Businesses with Reliable Tech",
      },
      {
        property: "og:description",
        content:
          "Shop quality solar, CCTV, networking, inverters, batteries and IT solutions across Nigeria.",
      },
      { property: "og:image", content: heroImage },
      { name: "twitter:image", content: heroImage },
      ...canonicalMeta("/"),
    ],
  }),
  component: HomePage,
});

const TRUST_ITEMS = [
  {
    icon: ShieldCheck,
    title: "Procurement Confidence",
    body: "Verified products and protected checkout for every order.",
  },
  {
    icon: Truck,
    title: "Nationwide Delivery",
    body: "Tracked fulfillment to all 36 states and the FCT.",
  },
  {
    icon: MapPin,
    title: "Nigeria Focused",
    body: "Local support, locally aware recommendations, local reach.",
  },
  {
    icon: Headset,
    title: "Technical Advisory",
    body: "Engineers available to guide product and deployment decisions.",
  },
];

const CATEGORIES = [
  {
    label: "Solar Products",
    icon: Sun,
    hint: "Panels, accessories and integrated kits",
  },
  {
    label: "Inverters",
    icon: Cpu,
    hint: "Hybrid and pure sine wave systems",
  },
  {
    label: "Batteries",
    icon: BatteryCharging,
    hint: "Lithium and deep-cycle storage",
  },
  {
    label: "CCTV Cameras",
    icon: Camera,
    hint: "IP, NVR and DVR security stacks",
  },
  {
    label: "Networking Devices",
    icon: Wifi,
    hint: "Routers, switches and access points",
  },
  {
    label: "IT Equipment",
    icon: Server,
    hint: "Servers, systems and accessories",
  },
] as const;

const SERVICES = [
  {
    title: "Solar Installation",
    description:
      "Site assessment, load sizing and complete installation for homes and business facilities.",
    icon: Sun,
  },
  {
    title: "CCTV Installation",
    description:
      "Professional surveillance deployment with recording, remote access and handover support.",
    icon: Camera,
  },
  {
    title: "Internet Networking",
    description:
      "Structured cabling, WiFi design and resilient connectivity for multi-room environments.",
    icon: Network,
  },
  {
    title: "IT Services",
    description:
      "Managed IT support, hardware lifecycle guidance and operational technology assistance.",
    icon: Settings2,
  },
];

function HomePage() {
  const [featured, setFeatured] = useState<Product[] | null>(null);

  useEffect(() => {
    listProducts({ featured: true }).then((items) => setFeatured(items.slice(0, 6)));
  }, []);

  return (
    <div className="bg-background">
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@type": "Organization",
          name: "YAROTECH",
          url: SITE_URL,
          logo: `${SITE_URL}/favicon.ico`,
          description:
            "YAROTECH supplies professional-grade solar, CCTV, networking, and IT equipment across Nigeria.",
          contactPoint: {
            "@type": "ContactPoint",
            telephone: "+234-707-537-3603",
            contactType: "customer service",
            areaServed: "NG",
            availableLanguage: "English",
          },
          sameAs: [],
        }}
      />
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@type": "WebSite",
          name: "YAROTECH",
          url: SITE_URL,
          potentialAction: {
            "@type": "SearchAction",
            target: {
              "@type": "EntryPoint",
              urlTemplate: `${SITE_URL}/shop?q={search_term_string}`,
            },
            "query-input": "required name=search_term_string",
          },
        }}
      />
      <section className="relative isolate overflow-hidden">
        <img
          src={heroImage}
          alt="Solar panel array, hybrid inverter system, batteries, CCTV and networking equipment."
          className="absolute inset-0 -z-20 h-full w-full object-cover"
        />
        <div className="absolute inset-0 -z-10 bg-gradient-to-r from-primary/95 via-primary/80 to-primary/45" />
        <div className="absolute inset-0 -z-10 bg-[radial-gradient(circle_at_20%_20%,color-mix(in_oklab,var(--secondary)_18%,transparent),transparent_45%)]" />

        <div className="mx-auto flex min-h-[calc(100svh-3.5rem)] max-w-7xl items-center px-4 py-16 md:py-24">
          <div className="max-w-3xl">
            <p className="text-xs font-semibold uppercase tracking-[0.22em] text-secondary/95">
              Trusted Energy and Security Infrastructure
            </p>
            <h1 className="mt-4 font-display text-4xl font-bold leading-[1.02] text-primary-foreground text-balance md:text-6xl">
              Technology procurement and deployment built for modern Nigerian operations.
            </h1>
            <p className="mt-6 max-w-2xl text-base leading-relaxed text-primary-foreground/82 md:text-lg">
              From solar power continuity to CCTV security and business networking, YAROTECH helps
              homes and organizations procure dependable systems with technical confidence.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                to="/shop"
                className="inline-flex h-12 items-center gap-2 rounded-sm bg-secondary px-6 text-sm font-bold uppercase tracking-wide text-secondary-foreground transition-transform duration-300 hover:-translate-y-0.5 hover:opacity-95"
              >
                Browse Product Catalog <ArrowRight className="h-4 w-4" />
              </Link>
              <Link
                to="/contact"
                className="inline-flex h-12 items-center rounded-sm border border-primary-foreground/40 bg-primary-foreground/10 px-6 text-sm font-bold uppercase tracking-wide text-primary-foreground transition-colors hover:bg-primary-foreground/20"
              >
                Talk to an Engineer
              </Link>
            </div>
            <div className="mt-8 grid max-w-2xl grid-cols-2 gap-3 text-sm md:grid-cols-4">
              <HeroMetric value="36+" label="States Covered" />
              <HeroMetric value="24/7" label="Support Access" />
              <HeroMetric value="100%" label="Verified Stock" />
              <HeroMetric value="B2C+B2B" label="Service Scope" />
            </div>
          </div>
        </div>
      </section>

      <section className="border-y border-border bg-surface">
        <div className="mx-auto grid max-w-7xl gap-5 px-4 py-8 md:grid-cols-2 lg:grid-cols-4">
          {TRUST_ITEMS.map((t) => {
            const Icon = t.icon;
            return (
              <div key={t.title} className="flex items-start gap-3">
                <div className="mt-0.5 flex h-10 w-10 shrink-0 items-center justify-center rounded-sm bg-accent text-primary">
                  <Icon className="h-5 w-5" />
                </div>
                <div>
                  <p className="text-sm font-semibold text-primary">{t.title}</p>
                  <p className="mt-1 text-sm leading-relaxed text-muted-foreground">{t.body}</p>
                </div>
              </div>
            );
          })}
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-4 py-14 md:py-16">
        <SectionHeader
          eyebrow="Product Segments"
          title="Choose by system category"
          description="Navigate quickly by business need, then compare detailed products within each segment."
        />
        <div className="mt-8 border-y border-border">
          {CATEGORIES.map((c) => {
            const Icon = c.icon;
            return (
              <Link
                key={c.label}
                to="/shop"
                search={{ category: c.label }}
                className="group grid gap-3 border-b border-border py-5 transition-colors last:border-b-0 md:grid-cols-[2.2fr_1fr] md:items-center"
              >
                <div className="flex items-start gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-sm bg-accent text-primary transition-colors group-hover:bg-secondary group-hover:text-secondary-foreground">
                    <Icon className="h-5 w-5" />
                  </div>
                  <div>
                    <p className="text-lg font-semibold text-primary transition-colors group-hover:text-secondary">
                      {c.label}
                    </p>
                    <p className="mt-1 text-sm text-muted-foreground">{c.hint}</p>
                  </div>
                </div>
                <div className="inline-flex items-center justify-start gap-2 text-sm font-semibold text-primary md:justify-end">
                  Explore category
                  <ArrowUpRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5" />
                </div>
              </Link>
            );
          })}
        </div>
      </section>

      <section className="border-y border-border bg-surface-muted">
        <div className="mx-auto max-w-7xl px-4 py-14 md:py-16">
          <SectionHeader
            eyebrow="Featured Inventory"
            title="Current high-demand products"
            description="Popular products selected by customers planning new installations and upgrades."
            action={
              <Link
                to="/shop"
                className="inline-flex h-10 items-center gap-1 rounded-sm border border-border bg-surface px-4 text-xs font-bold uppercase tracking-wider text-primary hover:bg-accent"
              >
                View all <ArrowRight className="h-3 w-3" />
              </Link>
            }
          />
          <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {featured === null ? (
              <div className="col-span-full">
                <LoadingState />
              </div>
            ) : (
              featured.map((p) => <ProductCard key={p.id} product={p} />)
            )}
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-4 py-14 md:py-16">
        <SectionHeader
          eyebrow="Implementation Services"
          title="From procurement to deployment"
          description="When you need more than product supply, our technical team can handle project execution and ongoing support."
          action={
            <Link
              to="/services"
              className="inline-flex h-10 items-center gap-1 rounded-sm border border-border bg-surface px-4 text-xs font-bold uppercase tracking-wider text-primary hover:bg-accent"
            >
              All services <ArrowRight className="h-3 w-3" />
            </Link>
          }
        />
        <div className="mt-8 divide-y divide-border border-y border-border">
          {SERVICES.map((s) => {
            const Icon = s.icon;
            return (
              <div
                key={s.title}
                className="grid gap-3 py-5 md:grid-cols-[1.4fr_2fr_auto] md:items-center md:gap-6"
              >
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-sm bg-primary text-primary-foreground">
                    <Icon className="h-5 w-5" />
                  </div>
                  <h3 className="font-display text-xl font-semibold text-primary">{s.title}</h3>
                </div>
                <p className="text-sm leading-relaxed text-muted-foreground">{s.description}</p>
                <Link
                  to="/contact"
                  search={{ service: s.title }}
                  className="inline-flex h-10 items-center justify-center rounded-sm border border-border px-4 text-xs font-bold uppercase tracking-wider text-primary hover:bg-accent md:justify-self-end"
                >
                  Request Service
                </Link>
              </div>
            );
          })}
        </div>
      </section>

      <section className="border-y border-border bg-primary text-primary-foreground">
        <div className="mx-auto grid max-w-7xl gap-10 px-4 py-14 md:grid-cols-[1.35fr_1fr] md:items-center md:py-16">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.22em] text-secondary">
              About YAROTECH
            </p>
            <h2 className="mt-3 font-display text-3xl font-bold leading-tight text-balance md:text-4xl">
              Reliable technology for homes and businesses across Nigeria.
            </h2>
            <p className="mt-5 max-w-xl text-base leading-relaxed text-primary-foreground/82">
              We combine product sourcing, engineering advisory and dependable delivery to help
              organizations build resilient power, security and networking systems.
            </p>
            <div className="mt-6 flex flex-wrap gap-3">
              <Link
                to="/about"
                className="inline-flex h-11 items-center rounded-sm bg-secondary px-5 text-sm font-bold uppercase tracking-wide text-secondary-foreground hover:opacity-90"
              >
                Learn more
              </Link>
              <Link
                to="/contact"
                className="inline-flex h-11 items-center rounded-sm border border-primary-foreground/30 px-5 text-sm font-bold uppercase tracking-wide text-primary-foreground hover:bg-primary-foreground/10"
              >
                Talk to us
              </Link>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <Stat number="36" label="States we serve" />
            <Stat number="6" label="Product categories" />
            <Stat number="100%" label="Verified equipment" icon={ShieldCheck} />
            <Stat number="24/7" label="Support access" icon={Wrench} />
          </div>
        </div>
      </section>

      <section className="bg-blueprint-soft">
        <div className="mx-auto max-w-4xl px-4 py-16 text-center md:py-20">
          <h2 className="font-display text-3xl font-bold text-primary text-balance md:text-5xl">
            Plan your next technology upgrade with confidence.
          </h2>
          <p className="mx-auto mt-4 max-w-2xl text-base leading-relaxed text-muted-foreground">
            Start with product selection or contact our team for advisory support on your power,
            security and networking requirements.
          </p>
          <div className="mt-7 flex flex-wrap justify-center gap-3">
            <Link
              to="/shop"
              className="inline-flex h-12 items-center gap-2 rounded-sm bg-secondary px-7 text-sm font-bold uppercase tracking-wide text-secondary-foreground hover:opacity-90"
            >
              Shop products <ArrowRight className="h-4 w-4" />
            </Link>
            <Link
              to="/contact"
              className="inline-flex h-12 items-center rounded-sm border border-primary bg-surface px-7 text-sm font-bold uppercase tracking-wide text-primary hover:bg-accent"
            >
              Request consultation
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}

function SectionHeader({
  eyebrow,
  title,
  description,
  action,
}: {
  eyebrow?: string;
  title: string;
  description?: string;
  action?: React.ReactNode;
}) {
  return (
    <div className="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
      <div>
        {eyebrow && (
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-secondary">
            {eyebrow}
          </p>
        )}
        <h2 className="mt-1 font-display text-3xl font-bold leading-tight text-primary md:text-4xl">
          {title}
        </h2>
        {description && (
          <p className="mt-2 max-w-2xl text-sm leading-relaxed text-muted-foreground">
            {description}
          </p>
        )}
      </div>
      {action}
    </div>
  );
}

function Stat({
  number,
  label,
  icon: Icon,
}: {
  number: string;
  label: string;
  icon?: React.ComponentType<{ className?: string }>;
}) {
  return (
    <div className="rounded-md border border-primary-foreground/20 bg-primary-foreground/5 p-4">
      <div className="flex items-center justify-between">
        <p className="font-display text-2xl font-bold text-secondary md:text-3xl">{number}</p>
        {Icon && <Icon className="h-4 w-4 text-primary-foreground/50" />}
      </div>
      <p className="mt-1 text-xs uppercase tracking-[0.12em] text-primary-foreground/70">{label}</p>
    </div>
  );
}

function HeroMetric({ value, label }: { value: string; label: string }) {
  return (
    <div className="border-l border-primary-foreground/30 pl-3">
      <p className="font-display text-xl font-bold text-secondary">{value}</p>
      <p className="text-xs uppercase tracking-[0.12em] text-primary-foreground/75">{label}</p>
    </div>
  );
}
