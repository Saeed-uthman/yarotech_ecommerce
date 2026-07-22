import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useCallback, useEffect, useRef, useState } from "react";
import { toast } from "sonner";
import { resendOtp, verifyOtp } from "@/api/auth";
import { AuthFormShell, PrimaryButton } from "@/components/auth/AuthFormShell";

export const Route = createFileRoute("/_auth/verify-email")({
  component: VerifyEmailPage,
  validateSearch: (s: Record<string, unknown>) => ({
    email: typeof s.email === "string" ? s.email : "",
  }),
  head: () => ({
    meta: [{ title: "Verify email - YAROTECH" }],
  }),
});

function VerifyEmailPage() {
  const { email } = Route.useSearch();
  const navigate = useNavigate();
  const [digits, setDigits] = useState<string[]>(Array(6).fill(""));
  const [loading, setLoading] = useState(false);
  const [resending, setResending] = useState(false);
  const [cooldown, setCooldown] = useState(60);
  const verifyingRef = useRef(false);
  const refs = useRef<(HTMLInputElement | null)[]>([]);

  useEffect(() => {
    if (cooldown <= 0) return;
    const t = setTimeout(() => setCooldown((c) => c - 1), 1000);
    return () => clearTimeout(t);
  }, [cooldown]);

  function setDigit(i: number, v: string) {
    const c = v.replace(/\D/g, "").slice(-1);
    setDigits((d) => {
      const next = [...d];
      next[i] = c;
      return next;
    });
    if (c && i < 5) refs.current[i + 1]?.focus();
  }

  function onPaste(e: React.ClipboardEvent) {
    const text = e.clipboardData.getData("text").replace(/\D/g, "").slice(0, 6);
    if (!text) return;
    e.preventDefault();
    const next = Array(6).fill("");
    for (let i = 0; i < text.length; i++) next[i] = text[i];
    setDigits(next);
    refs.current[Math.min(text.length, 5)]?.focus();
  }

  const submitCode = useCallback(
    async (code: string) => {
      if (verifyingRef.current) return;
      if (code.length < 6) {
        toast.error("Enter the 6-digit code");
        return;
      }

      verifyingRef.current = true;
      setLoading(true);
      try {
        await verifyOtp(email, code);
        toast.success("Account verified", {
          description: "You can now sign in.",
        });
        navigate({ to: "/login" });
      } catch (err) {
        toast.error(err instanceof Error ? err.message : "Invalid code");
      } finally {
        verifyingRef.current = false;
        setLoading(false);
      }
    },
    [email, navigate],
  );

  useEffect(() => {
    const code = digits.join("");
    if (code.length === 6) {
      void submitCode(code);
    }
  }, [digits, submitCode]);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    const code = digits.join("");
    if (code.length < 6) {
      toast.error("Enter the 6-digit code");
      return;
    }
    await submitCode(code);
  }

  async function onResend() {
    if (cooldown > 0 || resending) return;
    setResending(true);
    try {
      await resendOtp(email);
      toast.success("New verification OTP sent to your email.");
      setCooldown(60);
    } catch {
      toast.error("Could not resend code");
    } finally {
      setResending(false);
    }
  }

  return (
    <AuthFormShell
      eyebrow="One more step"
      title="Verify your email"
      subtitle={
        email
          ? `Enter the 6-digit code sent to ${email}.`
          : "Enter the 6-digit code we sent to your inbox."
      }
      footer={
        <Link to="/login" className="font-semibold text-primary hover:underline">
          Back to sign in
        </Link>
      }
    >
      <form onSubmit={onSubmit} className="space-y-5">
        {/* OTP boxes — fluid, always fill the container */}
        <div
          className="flex w-full items-center justify-between gap-2 sm:gap-3"
          onPaste={onPaste}
        >
          {digits.map((d, i) => (
            <input
              key={i}
              ref={(el) => {
                refs.current[i] = el;
              }}
              inputMode="numeric"
              pattern="[0-9]*"
              maxLength={1}
              value={d}
              autoComplete="one-time-code"
              onChange={(e) => setDigit(i, e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Backspace" && !digits[i] && i > 0) {
                  refs.current[i - 1]?.focus();
                }
              }}
              className="aspect-square min-w-0 flex-1 rounded-lg border border-border bg-surface text-center font-display text-xl font-bold text-primary outline-none transition-colors focus:border-secondary focus:ring-2 focus:ring-secondary/25 sm:text-2xl"
            />
          ))}
        </div>

        <p className="text-center text-xs text-muted-foreground">
          Code verifies automatically once all 6 digits are entered.
        </p>

        <PrimaryButton type="submit" loading={loading}>
          Verify email
        </PrimaryButton>

        {/* Resend row — stacked on very small screens */}
        <div className="flex flex-col items-center gap-1 text-xs text-muted-foreground sm:flex-row sm:justify-between">
          <span>Didn&apos;t receive the code?</span>
          <button
            type="button"
            onClick={onResend}
            disabled={cooldown > 0 || resending}
            className="font-semibold text-primary hover:underline disabled:cursor-not-allowed disabled:text-muted-foreground disabled:no-underline"
          >
            {cooldown > 0 ? `Resend in ${cooldown}s` : resending ? "Sending…" : "Resend OTP"}
          </button>
        </div>
      </form>
    </AuthFormShell>
  );
}
