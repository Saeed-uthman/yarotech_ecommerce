import { Link } from "@tanstack/react-router";
import type { LucideIcon } from "lucide-react";
import { ArrowRight } from "lucide-react";

export interface ServiceCardProps {
  icon: LucideIcon;
  title: string;
  description: string;
}

export function ServiceCard({ icon: Icon, title, description }: ServiceCardProps) {
  return (
    <div className="flex flex-col gap-3 rounded-md border border-border bg-surface p-5 transition-shadow hover:shadow-md">
      <div className="flex h-10 w-10 items-center justify-center rounded-sm bg-primary text-primary-foreground">
        <Icon className="h-5 w-5" />
      </div>
      <h3 className="font-display text-lg font-semibold text-primary">{title}</h3>
      <p className="text-sm text-muted-foreground">{description}</p>
      <Link
        to="/contact"
        className="mt-2 inline-flex items-center gap-1 text-sm font-semibold text-secondary hover:underline"
      >
        Contact us about this <ArrowRight className="h-4 w-4" />
      </Link>
    </div>
  );
}
