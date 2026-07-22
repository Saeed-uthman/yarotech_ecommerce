import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { toast } from "sonner";
import { forgotPassword } from "@/api/auth";
import {
  AuthFormShell,
  FieldLabel,
  TextInput,
  PrimaryButton,
} from "@/components/auth/AuthFormShell";

export const Route = createFileRoute("/_auth/forgot-password")({
  component: ForgotPasswordPage,
  head: () => ({
    meta: [{ title: "Forgot password - YAROTECH" }],
  }),
});

function ForgotPasswordPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    try {
      await forgotPassword(email);
      toast.success("Password reset OTP sent to your email.");
      navigate({ to: "/forgot-otp", search: { email } });
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Could not send code");
    } finally {
      setLoading(false);
    }
  }

  return (
    <AuthFormShell
      eyebrow="Account recovery"
      title="Forgot your password?"
      subtitle="Enter the email linked to your account and we will send a 6-digit reset code."
      footer={
        <Link to="/login" className="font-semibold text-primary hover:underline">
          Back to sign in
        </Link>
      }
    >
      <form onSubmit={onSubmit} className="space-y-4">
        <div>
          <FieldLabel>Email address</FieldLabel>
          <TextInput
            type="email"
            required
            autoComplete="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="you@company.com"
          />
        </div>
        <PrimaryButton type="submit" loading={loading}>
          Send reset code
        </PrimaryButton>
      </form>
    </AuthFormShell>
  );
}
