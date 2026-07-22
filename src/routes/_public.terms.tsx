import { createFileRoute } from "@tanstack/react-router";
import { PageHeader } from "@/components/common/PageHeader";

export const Route = createFileRoute("/_public/terms")({
  head: () => ({
    meta: [
      { title: "Terms and Conditions - YAROTECH" },
      {
        name: "description",
        content:
          "Read the YAROTECH terms and conditions governing purchases, services, and platform usage.",
      },
    ],
  }),
  component: TermsPage,
});

function TermsPage() {
  return (
    <div className="bg-background">
      <div className="mx-auto max-w-4xl px-4 py-10 md:py-12">
        <PageHeader
          eyebrow="Legal"
          title="Terms and Conditions"
          description="These terms govern your use of the YAROTECH platform and related services."
        />

        <div className="mt-8 space-y-6 text-sm leading-relaxed text-muted-foreground">
          <Section
            title="1. Scope"
            body="These terms apply to all visitors, customers, and users accessing YAROTECH services, product catalogs, and support channels."
          />
          <Section
            title="2. Orders and Pricing"
            body="Product availability and pricing may change without prior notice. Orders are confirmed only after successful payment verification and internal order acceptance."
          />
          <Section
            title="3. Delivery"
            body="Delivery timelines are estimates and may vary based on location, inventory movement, or third-party logistics conditions."
          />
          <Section
            title="4. Warranty and Support"
            body="Warranty coverage follows manufacturer policy or a specific service agreement where applicable. Customers should retain proof of purchase for support requests."
          />
          <Section
            title="5. Acceptable Use"
            body="Users must not misuse, disrupt, or attempt unauthorized access to platform infrastructure, accounts, or operational data."
          />
          <Section
            title="6. Contact"
            body="For policy clarifications, contact support@yarotech.ng or +234 707 537 3603."
          />
        </div>
      </div>
    </div>
  );
}

function Section({ title, body }: { title: string; body: string }) {
  return (
    <section>
      <h2 className="font-display text-xl font-semibold text-primary">{title}</h2>
      <p className="mt-2">{body}</p>
    </section>
  );
}
