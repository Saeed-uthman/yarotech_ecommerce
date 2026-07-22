import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { Check, CircleAlert, Eye, EyeOff } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { useAuthStore } from "@/stores/auth";
import { register, googleLogin } from "@/api/auth";
import {
  AuthFormShell,
  Divider,
  FieldLabel,
  FieldMessage,
  PrimaryButton,
  TextInput,
} from "@/components/auth/AuthFormShell";
import { GoogleButton } from "@/components/auth/GoogleButton";
import {
  getPasswordChecks,
  getPasswordStrength,
  isValidEmail,
  MIN_PASSWORD_LENGTH,
} from "@/lib/auth-validation";

export const Route = createFileRoute("/_auth/register")({
  component: RegisterPage,
  head: () => ({
    meta: [{ title: "Create account - YAROTECH" }],
  }),
});

function RegisterPage() {
  const navigate = useNavigate();
  const setSession = useAuthStore((s) => s.setSession);

  const [form, setForm] = useState({
    fullName: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
  });
  const [acceptTerms, setAcceptTerms] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [submitAttempted, setSubmitAttempted] = useState(false);
  const [serverError, setServerError] = useState<string | null>(null);
  const [touched, setTouched] = useState({
    fullName: false,
    email: false,
    phone: false,
    password: false,
    confirmPassword: false,
  });

  function setField<K extends keyof typeof form>(key: K, value: string) {
    setForm((f) => ({ ...f, [key]: value }));
    setServerError(null);
  }

  const passwordChecks = useMemo(() => getPasswordChecks(form.password), [form.password]);
  const passwordStrength = useMemo(() => getPasswordStrength(form.password), [form.password]);

  const errors = {
    fullName: form.fullName.trim().length < 2 ? "Full name is required." : "",
    email: !form.email.trim()
      ? "Email is required."
      : !isValidEmail(form.email)
        ? "Enter a valid email address."
        : "",
    phone: form.phone.replace(/\D/g, "").length < 7 ? "Enter a valid phone number." : "",
    password: !form.password
      ? "Password is required."
      : form.password.length < MIN_PASSWORD_LENGTH
        ? `Password must be at least ${MIN_PASSWORD_LENGTH} characters.`
        : "",
    confirmPassword: !form.confirmPassword
      ? "Confirm your password."
      : form.password !== form.confirmPassword
        ? "Passwords do not match."
        : "",
    terms: acceptTerms ? "" : "Please accept the terms and privacy policy.",
  };

  const hasErrors = Object.values(errors).some(Boolean);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSubmitAttempted(true);
    setServerError(null);

    if (hasErrors) {
      toast.error("Please correct the highlighted fields.");
      return;
    }

    setLoading(true);
    try {
      await register({ ...form, acceptTerms });
      toast.success("Account created", {
        description: "Verification OTP sent to your email.",
      });
      navigate({
        to: "/verify-email",
        search: { email: form.email.trim() },
      });
    } catch (err) {
      const message = err instanceof Error ? err.message : "Registration failed";
      setServerError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  }

  async function onGoogleSuccess(email: string, fullName: string) {
    setGoogleLoading(true);
    setServerError(null);
    try {
      const res = await googleLogin({ email, fullName });
      setSession(res.user, res.token);
      toast.success("Account created successfully!");
      if (res.user.role === "admin") {
        navigate({ to: "/admin" });
      } else {
        navigate({ to: "/dashboard" });
      }
    } catch (err) {
      if (typeof err === "object" && err !== null && "status" in err) {
        const apiErr = err as { status: number; data?: any };
        if (apiErr.data?.errors?.requires_verification) {
          toast.info("Please verify your email to continue.", {
            description: "A verification code has been sent to your email.",
          });
          navigate({
            to: "/verify-email",
            search: { email: apiErr.data.errors.email || email.trim() },
          });
          return;
        }
      }

      const message = err instanceof Error ? err.message : "Google registration failed";
      setServerError(message);
      toast.error(message);
    } finally {
      setGoogleLoading(false);
    }
  }

  const strengthToneClass =
    passwordStrength.score <= 1
      ? "text-destructive"
      : passwordStrength.score === 2
        ? "text-warning"
        : passwordStrength.score === 3
          ? "text-secondary"
          : "text-success";

  return (
    <AuthFormShell
      eyebrow="Get started"
      title="Create your account"
      subtitle="Join engineers and businesses procuring trusted technology with secure account access."
      footer={
        <>
          Already have an account?{" "}
          <Link to="/login" className="font-semibold text-primary hover:underline">
            Sign in
          </Link>
        </>
      }
    >
      <GoogleButton
        label="Sign up with Google"
        loading={googleLoading || loading}
        onSuccess={onGoogleSuccess}
      />
      <Divider>or use your email</Divider>

      <form onSubmit={onSubmit} className="space-y-4" noValidate>
        <div>
          <FieldLabel>Full name</FieldLabel>
          <TextInput
            required
            autoComplete="name"
            value={form.fullName}
            invalid={(touched.fullName || submitAttempted) && Boolean(errors.fullName)}
            onBlur={() => setTouched((p) => ({ ...p, fullName: true }))}
            onChange={(e) => setField("fullName", e.target.value)}
            placeholder="Adaeze Okeke"
          />
          {(touched.fullName || submitAttempted) && errors.fullName && (
            <FieldMessage tone="error">{errors.fullName}</FieldMessage>
          )}
        </div>

        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          <div>
            <FieldLabel>Email address</FieldLabel>
            <TextInput
              type="email"
              required
              autoComplete="email"
              value={form.email}
              invalid={(touched.email || submitAttempted) && Boolean(errors.email)}
              onBlur={() => setTouched((p) => ({ ...p, email: true }))}
              onChange={(e) => setField("email", e.target.value)}
              placeholder="you@company.com"
            />
            {(touched.email || submitAttempted) && errors.email && (
              <FieldMessage tone="error">{errors.email}</FieldMessage>
            )}
          </div>

          <div>
            <FieldLabel>Phone number</FieldLabel>
            <TextInput
              type="tel"
              required
              autoComplete="tel"
              value={form.phone}
              invalid={(touched.phone || submitAttempted) && Boolean(errors.phone)}
              onBlur={() => setTouched((p) => ({ ...p, phone: true }))}
              onChange={(e) => setField("phone", e.target.value)}
              placeholder="+234 800 000 0000"
            />
            {(touched.phone || submitAttempted) && errors.phone && (
              <FieldMessage tone="error">{errors.phone}</FieldMessage>
            )}
          </div>
        </div>

        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          <div>
            <FieldLabel>Password</FieldLabel>
            <TextInput
              type={showPassword ? "text" : "password"}
              required
              minLength={MIN_PASSWORD_LENGTH}
              autoComplete="new-password"
              value={form.password}
              invalid={(touched.password || submitAttempted) && Boolean(errors.password)}
              onBlur={() => setTouched((p) => ({ ...p, password: true }))}
              onChange={(e) => setField("password", e.target.value)}
              placeholder={`At least ${MIN_PASSWORD_LENGTH} characters`}
              rightSlot={
                <button
                  type="button"
                  aria-label={showPassword ? "Hide password" : "Show password"}
                  onClick={() => setShowPassword((v) => !v)}
                  className="rounded-sm p-1 text-muted-foreground hover:bg-accent hover:text-primary"
                >
                  {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              }
            />

            {(touched.password || submitAttempted) && errors.password && (
              <FieldMessage tone="error">{errors.password}</FieldMessage>
            )}

            <div className="mt-2 space-y-1.5">
              <div className="flex items-center justify-between">
                <p className="text-xs text-muted-foreground">Password strength</p>
                <p className={`text-xs font-semibold ${strengthToneClass}`}>
                  {passwordStrength.label}
                </p>
              </div>
              <div className="grid grid-cols-4 gap-1">
                {[1, 2, 3, 4].map((step) => (
                  <span
                    key={step}
                    className={`h-1.5 rounded-full ${
                      passwordStrength.score >= step ? "bg-secondary" : "bg-border"
                    }`}
                  />
                ))}
              </div>
              <div className="space-y-1">
                <Rule
                  ok={passwordChecks.minLength}
                  label={`At least ${MIN_PASSWORD_LENGTH} characters`}
                />
                <Rule ok={passwordChecks.hasLetter} label="Contains a letter" />
                <Rule
                  ok={passwordChecks.hasNumber || passwordChecks.hasSymbol}
                  label="Contains a number or symbol"
                />
              </div>
            </div>
          </div>

          <div>
            <FieldLabel>Confirm password</FieldLabel>
            <TextInput
              type={showConfirmPassword ? "text" : "password"}
              required
              minLength={MIN_PASSWORD_LENGTH}
              autoComplete="new-password"
              value={form.confirmPassword}
              invalid={
                (touched.confirmPassword || submitAttempted) && Boolean(errors.confirmPassword)
              }
              onBlur={() => setTouched((p) => ({ ...p, confirmPassword: true }))}
              onChange={(e) => setField("confirmPassword", e.target.value)}
              placeholder="Re-enter password"
              rightSlot={
                <button
                  type="button"
                  aria-label={showConfirmPassword ? "Hide password" : "Show password"}
                  onClick={() => setShowConfirmPassword((v) => !v)}
                  className="rounded-sm p-1 text-muted-foreground hover:bg-accent hover:text-primary"
                >
                  {showConfirmPassword ? (
                    <EyeOff className="h-4 w-4" />
                  ) : (
                    <Eye className="h-4 w-4" />
                  )}
                </button>
              }
            />

            {(touched.confirmPassword || submitAttempted) && errors.confirmPassword && (
              <FieldMessage tone="error">{errors.confirmPassword}</FieldMessage>
            )}

            {!errors.confirmPassword && form.confirmPassword && (
              <FieldMessage tone="success">Passwords match.</FieldMessage>
            )}
          </div>
        </div>

        <label className="flex cursor-pointer items-start gap-2 rounded-sm border border-border bg-background p-3 text-xs text-muted-foreground">
          <input
            type="checkbox"
            checked={acceptTerms}
            onChange={(e) => {
              setAcceptTerms(e.target.checked);
              setServerError(null);
            }}
            className="mt-0.5 h-4 w-4 cursor-pointer accent-secondary"
          />
          <span>
            I agree to YAROTECH's{" "}
            <Link to="/terms" className="font-semibold text-primary hover:underline">
              Terms and Conditions
            </Link>{" "}
            and{" "}
            <Link to="/privacy" className="font-semibold text-primary hover:underline">
              Privacy Policy
            </Link>
            .
          </span>
        </label>

        {(submitAttempted || !acceptTerms) && errors.terms && (
          <FieldMessage tone="error">{errors.terms}</FieldMessage>
        )}

        {serverError && (
          <div className="flex items-start gap-2 rounded-sm border border-destructive/30 bg-destructive/5 p-3 text-xs text-destructive">
            <CircleAlert className="mt-0.5 h-4 w-4 flex-shrink-0" />
            <span>{serverError}</span>
          </div>
        )}

        <PrimaryButton type="submit" loading={loading} disabled={!acceptTerms}>
          Create account
        </PrimaryButton>
      </form>
    </AuthFormShell>
  );
}

function Rule({ ok, label }: { ok: boolean; label: string }) {
  return (
    <div
      className={`flex items-center gap-1.5 text-xs ${ok ? "text-success" : "text-muted-foreground"}`}
    >
      <Check className="h-3.5 w-3.5" />
      {label}
    </div>
  );
}
