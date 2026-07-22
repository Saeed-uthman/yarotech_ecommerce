import { createFileRoute } from "@tanstack/react-router";
import { Target, Eye, Award, Users, ShieldCheck, Zap } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import { canonicalMeta } from "@/lib/seo";

export const Route = createFileRoute("/_public/about")({
  head: () => ({
    meta: [
      { title: "About — YAROTECH" },
      {
        name: "description",
        content:
          "YAROTECH is a Nigerian technology company providing solar, security, networking, and IT products and services nationwide.",
      },
      { property: "og:title", content: "About YAROTECH" },
      {
        property: "og:description",
        content: "Our story, mission, vision, and the values that drive YAROTECH across Nigeria.",
      },
      ...canonicalMeta("/about"),
    ],
  }),
  component: AboutPage,
});

const VALUES = [
  {
    icon: ShieldCheck,
    title: "Integrity",
    body: "We supply only verified, OEM-sourced equipment with full warranty coverage.",
  },
  {
    icon: Award,
    title: "Excellence",
    body: "Engineering-grade installations and post-deployment support across every project.",
  },
  {
    icon: Users,
    title: "Customer First",
    body: "We design solutions around your needs, your environment, and your budget.",
  },
  {
    icon: Zap,
    title: "Innovation",
    body: "Modern, efficient technology stacks built to scale with your operations.",
  },
];

const STATS = [
  { value: "500+", label: "Projects Delivered" },
  { value: "200+", label: "Business Clients" },
  { value: "36", label: "States Served" },
  { value: "24/7", label: "Technical Support" },
];

const TEAM = [
  { name: "Abubakar Sammani Yaro", role: "Chief Executive Officer", image: "/team/ceo.png" },
  { name: "Abubakar Alhassan", role: "Network Engineer", image: "/team/network_engineer.png" },
  { name: "Abubakar Ashiru", role: "Senior Devloper", image: "/team/senior_developer.png" },
  { name: "Saeed usman abdullahi", role: "Junior Developr", image: "/team/junior_developer.png" },
  { name: "Auwal Shehu", role: "Marketing manager", image: "/team/solar_installer.png" },
];

function AboutPage() {
  return (
    <div className="bg-blueprint">
      <div className="mx-auto max-w-5xl px-4 py-10">
        <PageHeader
          eyebrow="Who We Are"
          title="About YAROTECH"
          description="A technology ecommerce and solutions company powering homes, businesses, and institutions across Nigeria."
        />

        {/* Our Story */}
        <section className="mt-10 rounded-md border border-border bg-surface p-6 md:p-8">
          <h2 className="font-display text-2xl font-bold text-primary">Our Story</h2>
          <div className="mt-4 space-y-4 text-sm leading-relaxed text-muted-foreground">
            <p>
              YAROTECH was founded to bridge the gap between premium technology equipment and the
              engineering expertise needed to deploy it reliably. From rural solar microgrids to
              enterprise data rooms in Lagos and Abuja, we combine direct-from-OEM sourcing with
              on-the-ground delivery and installation capacity.
            </p>
            <p>
              Today we serve households, SMEs, integrators, and public institutions with a single
              promise: every component we ship is verified, warranted, and ready for
              mission-critical deployment.
            </p>
          </div>
        </section>

        {/* Mission & Vision */}
        <div className="mt-6 grid gap-6 md:grid-cols-2">
          <Pillar
            icon={Target}
            title="Our Mission"
            body="To deliver dependable, future-ready technology — solar, security, networking, and IT — backed by world-class engineering and support, to every corner of Nigeria."
          />
          <Pillar
            icon={Eye}
            title="Our Vision"
            body="To be the most trusted technology partner in West Africa, enabling resilient power, secure spaces, and connected operations for everyone we serve."
          />
        </div>

        {/* Core Values */}
        <section className="mt-10">
          <h2 className="font-display text-2xl font-bold text-primary">Core Values</h2>
          <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {VALUES.map((v) => (
              <div key={v.title} className="rounded-md border border-border bg-surface p-5">
                <div className="flex h-10 w-10 items-center justify-center rounded-sm bg-secondary/10 text-secondary">
                  <v.icon className="h-5 w-5" />
                </div>
                <h3 className="mt-3 font-display text-base font-bold text-primary">{v.title}</h3>
                <p className="mt-1 text-sm text-muted-foreground">{v.body}</p>
              </div>
            ))}
          </div>
        </section>

        {/* Stats */}
        <section className="mt-10 rounded-md border border-border bg-primary p-6 text-primary-foreground md:p-8">
          <div className="grid gap-6 sm:grid-cols-2 md:grid-cols-4">
            {STATS.map((s) => (
              <div key={s.label} className="text-center">
                <p className="font-display text-3xl font-bold text-secondary md:text-4xl">
                  {s.value}
                </p>
                <p className="mt-1 text-xs font-semibold uppercase tracking-widest text-primary-foreground/80">
                  {s.label}
                </p>
              </div>
            ))}
          </div>
        </section>

        {/* Our Team */}
        <section className="mt-16">
          <div className="text-center">
            <h2 className="font-display text-3xl font-bold text-primary">Meet Our Team</h2>
            <p className="mt-2 text-sm text-muted-foreground max-w-2xl mx-auto">
              The dedicated experts and engineers powering YAROTECH's vision across Nigeria.
            </p>
          </div>
          <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-5">
            {TEAM.map((member) => (
              <div key={member.role} className="flex flex-col items-center text-center group">
                <div className="h-32 w-32 overflow-hidden rounded-full border-4 border-surface shadow-sm mb-4 transition-transform duration-300 group-hover:scale-105 group-hover:border-secondary">
                  <img src={member.image} alt={member.name} className="h-full w-full object-cover" />
                </div>
                <h3 className="font-display text-base font-bold text-primary leading-tight mt-1">{member.name}</h3>
                <p className="text-[10px] font-semibold uppercase tracking-widest text-secondary mt-1">
                  {member.role}
                </p>
              </div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
}

function Pillar({
  icon: Icon,
  title,
  body,
}: {
  icon: React.ComponentType<{ className?: string }>;
  title: string;
  body: string;
}) {
  return (
    <div className="rounded-md border border-border bg-surface p-6">
      <div className="flex h-10 w-10 items-center justify-center rounded-sm bg-primary text-primary-foreground">
        <Icon className="h-5 w-5" />
      </div>
      <h3 className="mt-3 font-display text-xl font-bold text-primary">{title}</h3>
      <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{body}</p>
    </div>
  );
}
