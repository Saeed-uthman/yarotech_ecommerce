import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useCallback, useEffect, useRef, useState } from "react";
import { toast } from "sonner";
import { resendOtp, verifyForgotOtp } from "@/api/auth";
import { AuthFormShell, PrimaryButton } from "@/components/auth/AuthFormShell";

export const Route = createFileRoute("/_auth/forgot-otp")({
  component: ForgotOtpPage,
  validateSearch: (s: Record<string, unknown>) => ({
    email: typeof s.email === "string" ? s.email : "",
  }),
  head: () => ({
    meta: [{ title: "Verify reset code - YAROTECH" }],
  }),
});

function ForgotOtpPage() {
  const { email } = Route.useSearch();
  const navigate = useNavigate();
  const [digits, setDigits] = useState<string[]>(Array(6).fill(""));
  const [loading, setLoading] = useState(false);
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
        const res = await verifyForgotOtp(email, code);
        toast.success("Code verified", { description: "Choose a new password." });
        navigate({ to: "/reset-password", search: { email, resetToken: res.resetToken } });
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
    if (cooldown > 0) return;
    try {
      await resendOtp(email);
      toast.success("Password reset OTP resent to your email.");
      setCooldown(60);
    } catch {
      toast.error("Could not resend code");
    }
  }

  return (
    <AuthFormShell
      eyebrow="Account recovery"
      title="Verify reset code"
      subtitle={
        email
          ? `Enter the 6-digit code sent to ${email}. Use 123456 in mock mode.`
          : "Enter the 6-digit code we sent to your inbox."
      }
      footer={
        <Link to="/forgot-password" className="font-semibold text-primary hover:underline">
          Use a different email
        </Link>
      }
    >
      <form onSubmit={onSubmit} className="space-y-6">
        <div className="flex justify-between gap-2" onPaste={onPaste}>
          {digits.map((d, i) => (
            <input
              key={i}
              ref={(el) => {
                refs.current[i] = el;
              }}
              inputMode="numeric"
              maxLength={1}
              value={d}
              onChange={(e) => setDigit(i, e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Backspace" && !digits[i] && i > 0) {
                  refs.current[i - 1]?.focus();
                }
              }}
              className="h-14 w-12 rounded-sm border border-border bg-surface text-center font-display text-2xl font-bold text-primary outline-none transition-colors focus:border-secondary focus:ring-2 focus:ring-secondary/25"
            />
          ))}
        </div>
        <p className="text-center text-xs text-muted-foreground">
          Code will verify automatically once all 6 digits are entered.
        </p>
        <PrimaryButton type="submit" loading={loading}>
          Verify code
        </PrimaryButton>
        <div className="flex items-center justify-between text-xs text-muted-foreground">
          <span>Did not receive the code?</span>
          <button
            type="button"
            onClick={onResend}
            disabled={cooldown > 0}
            className="font-semibold text-primary hover:underline disabled:cursor-not-allowed disabled:text-muted-foreground disabled:no-underline"
          >
            {cooldown > 0 ? `Resend in ${cooldown}s` : "Resend OTP"}
          </button>
        </div>
      </form>
    </AuthFormShell>
  );
}
