import { cn } from "@/lib/format";

type Variant = "default" | "success" | "warning" | "danger" | "muted" | "navy";
const map: Record<Variant, string> = {
  default: "bg-accent text-accent-foreground",
  success: "bg-success/15 text-success",
  warning: "bg-warning/20 text-warning-foreground",
  danger: "bg-destructive/15 text-destructive",
  muted: "bg-muted text-muted-foreground",
  navy: "bg-primary text-primary-foreground",
};

export function StatusBadge({
  children,
  variant = "default",
  className,
}: {
  children: React.ReactNode;
  variant?: Variant;
  className?: string;
}) {
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1 rounded-sm px-2 py-0.5 text-[11px] font-semibold uppercase tracking-wider",
        map[variant],
        className,
      )}
    >
      {children}
    </span>
  );
}
