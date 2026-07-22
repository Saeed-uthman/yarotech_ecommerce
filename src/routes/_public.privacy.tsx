import { createFileRoute } from "@tanstack/react-router";
import { PageHeader } from "@/components/common/PageHeader";

export const Route = createFileRoute("/_public/privacy")({
  head: () => ({
    meta: [
      { title: "Privacy Policy - YAROTECH" },
      {
        name: "description",
        content:
          "Read how YAROTECH collects, uses, and protects personal information shared on this platform.",
      },
    ],
  }),
  component: PrivacyPage,
});

function PrivacyPage() {
  return (
    <div className="bg-background">
      <div className="mx-auto max-w-4xl px-4 py-10 md:py-12">
        <PageHeader
          eyebrow="Legal"
          title="Privacy Policy"
          description="This policy explains how YAROTECH handles personal and transactional data."
        />

        <div className="mt-8 space-y-6 text-sm leading-relaxed text-muted-foreground">
          <Section
            title="1. Information We Collect"
            body="We may collect contact details, delivery details, account credentials, and order-related information required to provide requested services."
          />
          <Section
            title="2. How We Use Information"
            body="Collected information is used to process orders, provide customer support, improve operations, and communicate service updates."
          />
          <Section
            title="3. Data Sharing"
            body="We share necessary information only with payment providers, delivery partners, and service providers involved in fulfilling your request."
          />
          <Section
            title="4. Data Security"
            body="Reasonable technical and organizational safeguards are applied to protect stored data against unauthorized access, alteration, or misuse."
          />
          <Section
            title="5. Your Choices"
            body="You can request account or communication updates by contacting support. Legal retention requirements may still apply for financial records."
          />
          <Section
            title="6. Contact"
            body="For privacy-related inquiries, contact support@yarotech.ng or +234 707 537 3603."
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
