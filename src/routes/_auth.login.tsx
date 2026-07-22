import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { CircleAlert, Eye, EyeOff } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";
import { useAuthStore } from "@/stores/auth";
import { login, googleLogin } from "@/api/auth";
import {
  AuthFormShell,
  Divider,
  FieldLabel,
  FieldMessage,
  TextInput,
} from "@/components/auth/AuthFormShell";
import { GoogleButton } from "@/components/auth/GoogleButton";
import { isValidEmail, MIN_PASSWORD_LENGTH } from "@/lib/auth-validation";

export const Route = createFileRoute("/_auth/login")({
  component: LoginPage,
  validateSearch: (s: Record<string, unknown>): { redirect?: string } => ({
    redirect: typeof s.redirect === "string" ? s.redirect : undefined,
  }),
  head: () => ({
    meta: [{ title: "Sign in - YAROTECH" }],
  }),
});

function LoginPage() {
  const navigate = useNavigate();
  const { redirect: redirectTo } = Route.useSearch();
  const setSession = useAuthStore((s) => s.setSession);

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [submitAttempted, setSubmitAttempted] = useState(false);
  const [serverError, setServerError] = useState<string | null>(null);
  const [touched, setTouched] = useState({ email: false, password: false });

  const emailError = !email.trim()
    ? "Email is required."
    : !isValidEmail(email)
      ? "Enter a valid email address."
      : "";

  const passwordError = !password
    ? "Password is required."
    : password.length < MIN_PASSWORD_LENGTH
      ? `Password must be at least ${MIN_PASSWORD_LENGTH} characters.`
      : "";

  const hasErrors = Boolean(emailError || passwordError);

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
      const res = await login({ email: email.trim(), password });
      setSession(res.user, res.token);
      toast.success(`Welcome back, ${res.user.fullName.split(" ")[0]}`);

      if (redirectTo) {
        navigate({ to: redirectTo });
      } else if (res.user.role === "admin" || res.user.role === "staff") {
        navigate({ to: "/admin" });
      } else {
        navigate({ to: "/dashboard" });
      }
    } catch (err) {
      if (typeof err === "object" && err !== null && "status" in err) {
        const apiErr = err as { status: number; data?: any };
        if (apiErr.data?.errors?.requires_verification) {
          toast.info("Please verify your email to continue.", {
            description: "A new verification code has been sent to your email.",
          });
          navigate({
            to: "/verify-email",
            search: { email: apiErr.data.errors.email || email.trim() },
          });
          return;
        }
      }

      const message = err instanceof Error ? err.message : "Login failed";
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
      toast.success(`Welcome back, ${res.user.fullName.split(" ")[0]}`);

      if (redirectTo) {
        navigate({ to: redirectTo });
      } else if (res.user.role === "admin" || res.user.role === "staff") {
        navigate({ to: "/admin" });
      } else {
        navigate({ to: "/dashboard" });
      }
    } catch (err) {
      if (typeof err === "object" && err !== null && "status" in err) {
        const apiErr = err as { status: number; data?: any };
        if (apiErr.data?.errors?.requires_verification) {
          toast.info("Please verify your email to continue.", {
            description: "A new verification code has been sent to your email.",
          });
          navigate({
            to: "/verify-email",
            search: { email: apiErr.data.errors.email || email.trim() },
          });
          return;
        }
      }

      const message = err instanceof Error ? err.message : "Google sign-in failed";
      setServerError(message);
      toast.error(message);
    } finally {
      setGoogleLoading(false);
    }
  }

  const showEmailError = (touched.email || submitAttempted) && Boolean(emailError);
  const showPasswordError = (touched.password || submitAttempted) && Boolean(passwordError);

  return (
    <AuthFormShell
      eyebrow="Welcome back"
      title="Sign in to YAROTECH"
      subtitle="Access your orders, saved equipment, and procurement history from one secure workspace."
      footer={
        <div className="mt-6 flex flex-col items-center gap-4">
          <span className="text-muted-foreground text-sm font-medium">New to YAROTECH?</span>
          <Link
            to="/register"
            className="flex h-12 w-full items-center justify-center rounded-md bg-emerald-500 px-6 text-sm font-bold uppercase tracking-wider text-white shadow-lg shadow-emerald-500/30 transition-all hover:-translate-y-0.5 hover:bg-emerald-600 hover:shadow-emerald-500/40 active:translate-y-0"
          >
            Create an account
          </Link>
        </div>
      }
    >
      <GoogleButton
        label="Sign in with Google"
        loading={googleLoading || loading}
        onSuccess={onGoogleSuccess}
      />
      <Divider>or use your email</Divider>

      <form onSubmit={onSubmit} className="space-y-4" noValidate>
        <div>
          <FieldLabel>Email address</FieldLabel>
          <TextInput
            type="email"
            required
            autoComplete="email"
            value={email}
            invalid={showEmailError}
            onBlur={() => setTouched((p) => ({ ...p, email: true }))}
            onChange={(e) => {
              setEmail(e.target.value);
              setServerError(null);
            }}
            placeholder="you@company.com"
          />
          {showEmailError ? (
            <FieldMessage tone="error">{emailError}</FieldMessage>
          ) : (
            <FieldMessage>Use the email linked to your account.</FieldMessage>
          )}
        </div>

        <div>
          <div className="mb-1.5 flex items-center justify-between">
            <FieldLabel>Password</FieldLabel>
            <Link
              to="/forgot-password"
              className="text-xs font-semibold text-primary hover:underline"
            >
              Forgot password?
            </Link>
          </div>
          <TextInput
            type={showPassword ? "text" : "password"}
            required
            autoComplete="current-password"
            value={password}
            invalid={showPasswordError}
            onBlur={() => setTouched((p) => ({ ...p, password: true }))}
            onChange={(e) => {
              setPassword(e.target.value);
              setServerError(null);
            }}
            placeholder="Enter your password"
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
          {showPasswordError ? (
            <FieldMessage tone="error">{passwordError}</FieldMessage>
          ) : (
            <FieldMessage>Minimum {MIN_PASSWORD_LENGTH} characters.</FieldMessage>
          )}
        </div>

        {serverError && (
          <div className="flex items-start gap-2 rounded-sm border border-destructive/30 bg-destructive/5 p-3 text-xs text-destructive">
            <CircleAlert className="mt-0.5 h-4 w-4 flex-shrink-0" />
            <span>
              We could not sign you in. Check your credentials or reset your password if needed.
            </span>
          </div>
        )}

        <button
          type="submit"
          disabled={loading}
          className="flex h-12 w-full items-center justify-center rounded-md bg-blue-600 px-6 text-sm font-bold uppercase tracking-wider text-white shadow-lg shadow-blue-600/30 transition-all hover:-translate-y-0.5 hover:bg-blue-700 hover:shadow-blue-600/40 active:translate-y-0 disabled:opacity-70 disabled:hover:translate-y-0"
        >
          {loading ? "Please wait..." : "Sign in"}
        </button>
      </form>
    </AuthFormShell>
  );
}
