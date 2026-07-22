import { createFileRoute } from "@tanstack/react-router";
import { PageHeader } from "@/components/common/PageHeader";
import { Calendar, MapPin } from "lucide-react";

export const Route = createFileRoute("/_public/projects")({
  head: () => ({
    meta: [
      { title: "Our Projects — YAROTECH" },
      {
        name: "description",
        content: "Explore the various installations and projects successfully deployed by YAROTECH across Nigeria.",
      },
    ],
  }),
  component: ProjectsPage,
});

const PROJECTS = [
  {
    id: "solar-commercial-1",
    title: "50kW Commercial Solar Microgrid",
    category: "Renewable Energy",
    location: "Kano State, Nigeria",
    date: "August 2025",
    description: "A complete end-to-end design and deployment of a 50kW solar microgrid for a prominent commercial manufacturing facility, ensuring 24/7 uninterrupted power supply and significantly reducing diesel generator costs.",
    image: "/projects/solar.png",
  },
  {
    id: "network-datacenter-1",
    title: "Enterprise Datacenter Network Overhaul",
    category: "Network Infrastructure",
    location: "Abuja, FCT",
    date: "February 2026",
    description: "Full restructuring of an enterprise server room. We deployed high-capacity switches, reorganized the cabling for optimal airflow and maintenance, and established a redundant fiber backbone.",
    image: "/projects/network.png",
  },
  {
    id: "cctv-estate-1",
    title: "Smart Estate Security Surveillance",
    category: "Security Systems",
    location: "Lagos State, Nigeria",
    date: "November 2025",
    description: "Installation of a 64-channel IP surveillance system across a luxury residential estate. Features include remote monitoring, AI-powered motion detection, and weatherproof outdoor cameras.",
    image: "/projects/cctv.png",
  }
];

function ProjectsPage() {
  return (
    <div className="bg-blueprint min-h-screen">
      <div className="mx-auto max-w-5xl px-4 py-10">
        <PageHeader
          eyebrow="Our Portfolio"
          title="Featured Projects"
          description="Discover how YAROTECH is transforming homes, businesses, and institutions with reliable technology infrastructure."
        />

        <div className="mt-12 space-y-12">
          {PROJECTS.map((project, index) => (
            <div 
              key={project.id} 
              className={`flex flex-col md:flex-row gap-8 items-center bg-surface border border-border rounded-lg overflow-hidden shadow-sm ${index % 2 !== 0 ? 'md:flex-row-reverse' : ''}`}
            >
              <div className="w-full md:w-1/2 h-64 md:h-96 relative">
                <img 
                  src={project.image} 
                  alt={project.title} 
                  className="w-full h-full object-cover absolute inset-0"
                />
              </div>
              <div className="w-full md:w-1/2 p-6 md:p-8 flex flex-col justify-center">
                <span className="text-xs font-bold uppercase tracking-widest text-secondary mb-2 block">
                  {project.category}
                </span>
                <h2 className="font-display text-2xl md:text-3xl font-bold text-primary mb-4">
                  {project.title}
                </h2>
                <p className="text-sm leading-relaxed text-muted-foreground mb-6">
                  {project.description}
                </p>
                <div className="flex flex-col sm:flex-row gap-4 text-xs font-semibold text-primary">
                  <div className="flex items-center gap-2">
                    <MapPin className="h-4 w-4 text-muted-foreground" />
                    {project.location}
                  </div>
                  <div className="flex items-center gap-2">
                    <Calendar className="h-4 w-4 text-muted-foreground" />
                    {project.date}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
