import type { ReactNode } from "react";

export function AuthFormShell({
  eyebrow,
  title,
  subtitle,
  children,
  footer,
}: {
  eyebrow?: string;
  title: string;
  subtitle?: string;
  children: ReactNode;
  footer?: ReactNode;
}) {
  return (
    <div>
      {eyebrow && (
        <p className="text-[10px] font-semibold uppercase tracking-[0.16em] text-secondary sm:text-xs">
          {eyebrow}
        </p>
      )}
      <h1 className="mt-1.5 font-display text-2xl font-bold leading-tight text-primary sm:mt-2 sm:text-3xl">
        {title}
      </h1>
      {subtitle && (
        <p className="mt-1.5 text-sm leading-relaxed text-muted-foreground sm:mt-2">{subtitle}</p>
      )}
      <div className="mt-5 sm:mt-7">{children}</div>
      {footer && (
        <div className="mt-5 text-center text-sm text-muted-foreground sm:mt-6">{footer}</div>
      )}
    </div>
  );
}

export function FieldLabel({ children }: { children: ReactNode }) {
  return (
    <label className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.12em] text-foreground">
      {children}
    </label>
  );
}

export function FieldMessage({
  children,
  tone = "muted",
}: {
  children: ReactNode;
  tone?: "muted" | "error" | "success";
}) {
  const toneClass =
    tone === "error"
      ? "text-destructive"
      : tone === "success"
        ? "text-success"
        : "text-muted-foreground";
  return <p className={`mt-1.5 text-xs ${toneClass}`}>{children}</p>;
}

type TextInputProps = React.InputHTMLAttributes<HTMLInputElement> & {
  invalid?: boolean;
  rightSlot?: ReactNode;
};

export function TextInput({ invalid, rightSlot, ...props }: TextInputProps) {
  const inputClass = invalid
    ? "border-destructive focus:border-destructive focus:ring-destructive/20"
    : "border-border focus:border-primary focus:ring-primary/20";
  return (
    <div className="relative">
      <input
        {...props}
        className={`h-11 w-full rounded-lg border bg-background px-3 text-base text-foreground outline-none transition-colors focus:ring-2 disabled:cursor-not-allowed disabled:opacity-70 sm:text-sm ${
          rightSlot ? "pr-10" : ""
        } ${inputClass} ${props.className ?? ""}`}
      />
      {rightSlot && <div className="absolute inset-y-0 right-2 flex items-center">{rightSlot}</div>}
    </div>
  );
}

export function PrimaryButton({
  children,
  loading,
  ...props
}: React.ButtonHTMLAttributes<HTMLButtonElement> & { loading?: boolean }) {
  return (
    <button
      {...props}
      disabled={loading || props.disabled}
      className={`h-12 w-full rounded-lg bg-cta text-sm font-bold uppercase tracking-wide text-cta-foreground transition-all hover:bg-cta/90 active:scale-[0.98] disabled:opacity-60 sm:h-11 ${props.className ?? ""}`}
    >
      {loading ? "Please wait..." : children}
    </button>
  );
}

export function Divider({ children }: { children: ReactNode }) {
  return (
    <div className="my-4 flex items-center gap-3 text-[10px] font-semibold uppercase tracking-[0.14em] text-muted-foreground sm:my-5">
      <span className="h-px flex-1 bg-border" />
      {children}
      <span className="h-px flex-1 bg-border" />
    </div>
  );
}
