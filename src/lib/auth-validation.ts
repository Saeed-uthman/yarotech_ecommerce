export const MIN_PASSWORD_LENGTH = 6;

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function isValidEmail(value: string): boolean {
  return EMAIL_PATTERN.test(value.trim());
}

export function getPasswordChecks(password: string): {
  minLength: boolean;
  hasLetter: boolean;
  hasNumber: boolean;
  hasSymbol: boolean;
} {
  return {
    minLength: password.length >= MIN_PASSWORD_LENGTH,
    hasLetter: /[a-z]/i.test(password),
    hasNumber: /\d/.test(password),
    hasSymbol: /[^a-z0-9]/i.test(password),
  };
}

export function getPasswordStrength(password: string): {
  score: number;
  label: "Very weak" | "Weak" | "Fair" | "Strong";
} {
  if (!password) return { score: 0, label: "Very weak" };

  const checks = getPasswordChecks(password);
  const score =
    Number(checks.minLength) +
    Number(checks.hasLetter) +
    Number(checks.hasNumber) +
    Number(checks.hasSymbol);

  if (score <= 1) return { score, label: "Very weak" };
  if (score === 2) return { score, label: "Weak" };
  if (score === 3) return { score, label: "Fair" };
  return { score, label: "Strong" };
}
