import { Link } from "@tanstack/react-router";
import logo from "@/assets/yarotech-logo.jpg";

export function Logo({
  size = 32,
  showWordmark = true,
  className = "",
  light = false,
}: {
  size?: number;
  showWordmark?: boolean;
  className?: string;
  light?: boolean;
}) {
  return (
    <Link to="/" className={`flex items-center gap-2.5 ${className}`}>
      <img
        src={logo}
        alt="Yarotech Logo"
        width={size}
        height={size}
        className="rounded-md object-contain shrink-0"
        style={{ width: size, height: size }}
      />
      {showWordmark && (
        <div className="flex flex-col justify-center select-none">
          <span
            className={`font-display text-[15px] font-extrabold tracking-wide uppercase leading-none ${
              light ? "text-primary-foreground" : "text-primary"
            }`}
          >
            yarotech
          </span>
          <span
            className={`font-sans text-[8px] font-bold tracking-[0.16em] uppercase leading-none mt-1 ${
              light ? "text-primary-foreground/70" : "text-muted-foreground"
            }`}
          >
            network limited
          </span>
        </div>
      )}
    </Link>
  );
}
