import { useState } from "react";
import { Loader2 } from "lucide-react";
import { useGoogleLogin } from "@react-oauth/google";

export function GoogleButton({
  label = "Continue with Google",
  onSuccess,
  loading = false,
}: {
  label?: string;
  onSuccess: (email: string, fullName: string) => void;
  loading?: boolean;
}) {
  const [localLoading, setLocalLoading] = useState(false);

  const googleLogin = useGoogleLogin({
    onSuccess: async (tokenResponse) => {
      setLocalLoading(true);
      try {
        const userInfoRes = await fetch("https://www.googleapis.com/oauth2/v3/userinfo", {
          headers: { Authorization: `Bearer ${tokenResponse.access_token}` },
        });
        const userInfo = await userInfoRes.json();
        
        if (userInfo.email && userInfo.name) {
          onSuccess(userInfo.email, userInfo.name);
        } else {
          console.error("Missing email or name from Google UserInfo", userInfo);
        }
      } catch (error) {
        console.error("Failed to fetch Google UserInfo", error);
      } finally {
        setLocalLoading(false);
      }
    },
    onError: (error) => {
      console.error("Google Login Failed", error);
    }
  });

  return (
    <button
      type="button"
      disabled={loading || localLoading}
      onClick={() => googleLogin()}
      className="flex h-11 w-full items-center justify-center gap-3 rounded-sm border border-border bg-surface text-sm font-semibold text-foreground transition-colors hover:bg-accent disabled:opacity-75"
    >
      {loading || localLoading ? (
        <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
      ) : (
        <svg className="h-5 w-5" viewBox="0 0 24 24" aria-hidden>
          <path
            fill="#EA4335"
            d="M12 10.2v3.9h5.5c-.24 1.4-1.7 4.1-5.5 4.1-3.3 0-6-2.7-6-6.1s2.7-6.1 6-6.1c1.9 0 3.1.8 3.8 1.5l2.6-2.5C16.8 3.4 14.6 2.4 12 2.4 6.7 2.4 2.4 6.7 2.4 12s4.3 9.6 9.6 9.6c5.5 0 9.2-3.9 9.2-9.4 0-.6-.1-1.1-.1-1.6H12z"
          />
        </svg>
      )}
      {label}
    </button>
  );
}
