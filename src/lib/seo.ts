/**
 * SEO constants & helpers shared across all routes.
 */

export const SITE_URL = "https://shop.y.yarotech.com.ng";
export const SITE_NAME = "YAROTECH";
export const DEFAULT_OG_IMAGE =
  "https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/29a6f1a9-c893-446f-94ca-d31affd6f0f7/id-preview-dc9a53a2--8630b828-feca-429d-bfe1-0cc96a0c0e95.lovable.app-1777356662981.png";

/**
 * Build the canonical + og:url meta entries for a given path.
 * Always returns absolute URLs so crawlers get consistent signals.
 *
 * @param path – e.g. "/shop" or "/shop/solar-panel-200w"
 */
export function canonicalMeta(path: string) {
  const url = `${SITE_URL}${path}`;
  return [
    { rel: "canonical", href: url },
    { property: "og:url", content: url },
    { property: "og:site_name", content: SITE_NAME },
    { property: "og:locale", content: "en_NG" },
  ] as const;
}
