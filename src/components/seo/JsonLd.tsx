/**
 * JsonLd — renders a <script type="application/ld+json"> block.
 *
 * Usage:
 *   <JsonLd data={{ "@type": "Product", name: "Solar Panel", ... }} />
 */

interface JsonLdProps {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  data: Record<string, any>;
}

export function JsonLd({ data }: JsonLdProps) {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(data) }}
    />
  );
}
