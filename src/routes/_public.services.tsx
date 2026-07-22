import { createFileRoute, Link } from "@tanstack/react-router";
import { Sun, Camera, Wifi, Cpu, Check, ArrowRight } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { canonicalMeta } from "@/lib/seo";

export const Route = createFileRoute("/_public/services")({
  head: () => ({
    meta: [
      { title: "Services — YAROTECH" },
      {
        name: "description",
        content:
          "Solar Installation, CCTV, Internet Networking, and IT Services from YAROTECH. Enquire through our Contact page.",
      },
      { property: "og:title", content: "Services — YAROTECH" },
      {
        property: "og:description",
        content:
          "Professional solar, security, networking and IT services for homes and businesses across Nigeria.",
      },
      ...canonicalMeta("/services"),
    ],
  }),
  component: ServicesPage,
});

interface Service {
  slug: string;
  icon: LucideIcon;
  title: string;
  description: string;
  items: string[];
}

const SERVICES: Service[] = [
  {
    slug: "Solar Installation",
    icon: Sun,
    title: "Solar Installation",
    description: "Sustainable and cost-saving solar energy solutions for homes and businesses.",
    items: [
      "Residential Solar Systems",
      "Commercial Installations",
      "Maintenance & Support",
      "Energy Consultation",
    ],
  },
  {
    slug: "CCTV Installation",
    icon: Camera,
    title: "CCTV Installation",
    description:
      "Advanced security surveillance systems to protect your property with 24/7 monitoring.",
    items: ["HD Security Cameras", "Remote Monitoring", "Motion Detection", "Night Vision Systems"],
  },
  {
    slug: "Internet Networking",
    icon: Wifi,
    title: "Internet Networking",
    description: "Reliable, scalable, and modern network infrastructure for seamless connectivity.",
    items: ["Network Design", "WiFi Installation", "Fiber Optic Cabling", "Network Security"],
  },
  {
    slug: "IT Services",
    icon: Cpu,
    title: "IT Services",
    description:
      "Comprehensive IT support including system maintenance, consultancy, and infrastructure.",
    items: ["System Maintenance", "IT Consultancy", "Hardware Setup", "Technical Support"],
  },
];

function ServicesPage() {
  return (
    <div className="bg-blueprint">
      <div className="mx-auto max-w-7xl px-4 py-10">
        <PageHeader
          eyebrow="What We Offer"
          title="Engineering Services"
          description="Informational overview of services delivered alongside our procurement catalog. To enquire about any service, reach our team through the Contact page."
        />

        <div className="mt-10 grid gap-5 sm:grid-cols-2">
          {SERVICES.map((s) => (
            <ServiceBlock key={s.slug} service={s} />
          ))}
        </div>

        <div className="mt-12 rounded-md border border-border bg-surface p-6 text-center md:p-8">
          <h2 className="font-display text-xl font-bold text-primary md:text-2xl">
            Ready to start a project?
          </h2>
          <p className="mx-auto mt-2 max-w-2xl text-sm text-muted-foreground">
            All service inquiries are handled through our Contact page. Tell us what you need and
            our engineering team will respond within one business day.
          </p>
          <Link
            to="/contact"
            className="mt-5 inline-flex h-11 items-center gap-2 rounded-sm bg-secondary px-6 text-sm font-bold text-secondary-foreground hover:opacity-90"
          >
            Contact Us <ArrowRight className="h-4 w-4" />
          </Link>
        </div>
      </div>
    </div>
  );
}

function ServiceBlock({ service }: { service: Service }) {
  const Icon = service.icon;
  return (
    <article className="flex flex-col rounded-md border border-border bg-surface p-6 transition-shadow hover:shadow-md">
      <div className="flex items-center gap-3">
        <div className="flex h-12 w-12 items-center justify-center rounded-sm bg-primary text-primary-foreground">
          <Icon className="h-6 w-6" />
        </div>
        <h2 className="font-display text-lg font-bold text-primary md:text-xl">{service.title}</h2>
      </div>
      <p className="mt-3 text-sm text-muted-foreground">{service.description}</p>
      <ul className="mt-4 space-y-2">
        {service.items.map((item) => (
          <li key={item} className="flex items-start gap-2 text-sm text-primary">
            <Check className="mt-0.5 h-4 w-4 flex-shrink-0 text-secondary" />
            <span>{item}</span>
          </li>
        ))}
      </ul>
      <div className="mt-5 border-t border-border pt-4">
        <Link
          to="/contact"
          search={{ service: service.slug }}
          className="inline-flex h-10 w-full items-center justify-center gap-2 rounded-sm border border-secondary bg-surface px-4 text-sm font-bold text-secondary hover:bg-secondary hover:text-secondary-foreground"
        >
          Enquire Now <ArrowRight className="h-4 w-4" />
        </Link>
      </div>
    </article>
  );
}
