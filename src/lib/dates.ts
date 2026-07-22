/**
 * The PHP API stores MySQL DATETIME values in UTC and returns them as
 * "YYYY-MM-DD HH:mm:ss". Browsers parse those bare strings as local time,
 * which makes fresh records look an hour old in Lagos.
 */
export function parseApiDate(value: string | number | Date | null | undefined): Date {
  if (value instanceof Date) return value;
  if (typeof value === "number") return new Date(value);
  if (!value) return new Date(NaN);

  const raw = String(value).trim();
  if (!raw) return new Date(NaN);

  const normalized = raw.includes("T") ? raw : raw.replace(" ", "T");
  const hasTimezone = /(?:Z|[+-]\d{2}:?\d{2})$/i.test(normalized);
  return new Date(hasTimezone ? normalized : `${normalized}Z`);
}

export function apiDateMs(value: string | number | Date | null | undefined): number {
  return parseApiDate(value).getTime();
}
