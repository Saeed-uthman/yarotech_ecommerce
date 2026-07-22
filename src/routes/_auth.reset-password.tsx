import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { Eye, EyeOff } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";
import { resetPassword } from "@/api/auth";
import {
  AuthFormShell,
  FieldLabel,
  TextInput,
  PrimaryButton,
} from "@/components/auth/AuthFormShell";

export const Route = createFileRoute("/_auth/reset-password")({
  component: ResetPasswordPage,
  validateSearch: (s: Record<string, unknown>) => ({
    email: typeof s.email === "string" ? s.email : "",
    resetToken: typeof s.resetToken === "string" ? s.resetToken : "",
  }),
  head: () => ({
    meta: [{ title: "Reset password - YAROTECH" }],
  }),
});

function ResetPasswordPage() {
  const { email: emailFromSearch, resetToken: tokenFromSearch } = Route.useSearch();
  const navigate = useNavigate();
  const [email] = useState(emailFromSearch);
  const [resetToken] = useState(tokenFromSearch);
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (password !== confirm) {
      toast.error("Passwords do not match");
      return;
    }
    setLoading(true);
    try {
      await resetPassword(email, resetToken, password);
      toast.success("Password updated", {
        description: "You can now sign in with your new password.",
      });
      navigate({ to: "/login" });
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Reset failed");
    } finally {
      setLoading(false);
    }
  }

  return (
    <AuthFormShell
      eyebrow="Account recovery"
      title="Set a new password"
      subtitle="Choose a strong password you will remember."
      footer={
        <Link to="/login" className="font-semibold text-primary hover:underline">
          Back to sign in
        </Link>
      }
    >
      <form onSubmit={onSubmit} className="space-y-4">
        <div>
          <FieldLabel>Email</FieldLabel>
          <TextInput
            type="email"
            readOnly
            required
            value={email}
            className="opacity-70 cursor-not-allowed"
          />
        </div>
        <div>
          <FieldLabel>New password</FieldLabel>
          <TextInput
            type={showPassword ? "text" : "password"}
            required
            minLength={6}
            autoComplete="new-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
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
        </div>
        <div>
          <FieldLabel>Confirm new password</FieldLabel>
          <TextInput
            type={showConfirm ? "text" : "password"}
            required
            minLength={6}
            autoComplete="new-password"
            value={confirm}
            onChange={(e) => setConfirm(e.target.value)}
            rightSlot={
              <button
                type="button"
                aria-label={showConfirm ? "Hide password" : "Show password"}
                onClick={() => setShowConfirm((v) => !v)}
                className="rounded-sm p-1 text-muted-foreground hover:bg-accent hover:text-primary"
              >
                {showConfirm ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
              </button>
            }
          />
        </div>
        <PrimaryButton type="submit" loading={loading}>
          Update password
        </PrimaryButton>
      </form>
    </AuthFormShell>
  );
}
