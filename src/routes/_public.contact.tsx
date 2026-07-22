import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { Mail, Phone, MapPin, Send, CheckCircle2, AlertCircle } from "lucide-react";
import { PageHeader } from "@/components/common/PageHeader";
import {
  submitContact,
  INQUIRY_TYPES,
  SERVICE_TYPES,
  type InquiryType,
  type ServiceType,
} from "@/api/contact";
import { useNotificationStore } from "@/stores/notifications";
import { JsonLd } from "@/components/seo/JsonLd";
import { canonicalMeta, SITE_URL } from "@/lib/seo";
import { toast } from "sonner";

export const Route = createFileRoute("/_public/contact")({
  head: () => ({
    meta: [
      { title: "Contact — YAROTECH" },
      {
        name: "description",
        content:
          "Reach YAROTECH for product, service, delivery, and technical inquiries. We respond within one business day.",
      },
      { property: "og:title", content: "Contact YAROTECH" },
      ...canonicalMeta("/contact"),
    ],
  }),
  validateSearch: (s: Record<string, unknown>): { service?: string } =>
    typeof s.service === "string" ? { service: s.service } : {},
  component: ContactPage,
});

type FormState =
  | { kind: "idle" }
  | { kind: "loading" }
  | { kind: "success"; ticketId: string }
  | { kind: "error"; message: string };

function ContactPage() {
  const { service } = Route.useSearch();
  const presetService: ServiceType =
    service && (SERVICE_TYPES as readonly string[]).includes(service)
      ? (service as ServiceType)
      : "Not applicable";
  const presetInquiry: InquiryType =
    presetService !== "Not applicable" ? "Service Inquiry" : "General Inquiry";

  const [state, setState] = useState<FormState>({ kind: "idle" });
  const pushNotification = useNotificationStore((s) => s.push);

  const onSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    setState({ kind: "loading" });
    try {
      const res = await submitContact({
        name: String(fd.get("name") ?? ""),
        email: String(fd.get("email") ?? ""),
        phone: String(fd.get("phone") ?? ""),
        inquiryType: String(fd.get("inquiryType") ?? "") as InquiryType,
        serviceType: String(fd.get("serviceType") ?? "") as ServiceType,
        message: String(fd.get("message") ?? ""),
      });
      setState({ kind: "success", ticketId: res.ticketId });
      toast.success("Your inquiry has been submitted.", {
        description: `Reference: ${res.ticketId}. We'll email you shortly.`,
      });
      // Customer-facing confirmation notification (in-app).
      // Backend will additionally: send SMTP ack to customer, SMTP notify
      // admin, and create an admin notification record server-side.
      pushNotification({
        kind: "support",
        title: "Inquiry submitted",
        body: `We received your message (${res.ticketId}) and will reply soon.`,
      });
      (e.target as HTMLFormElement).reset();
    } catch (err) {
      const msg = (err as Error).message;
      setState({ kind: "error", message: msg });
      toast.error(msg);
    }
  };

  return (
    <div className="bg-blueprint">
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@type": "LocalBusiness",
          name: "YAROTECH",
          url: SITE_URL,
          telephone: "+234-707-537-3603",
          email: "support@yarotech.com.ng",
          address: {
            "@type": "PostalAddress",
            addressCountry: "NG",
            addressLocality: "Nigeria",
          },
          openingHoursSpecification: [
            {
              "@type": "OpeningHoursSpecification",
              dayOfWeek: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
              opens: "08:00",
              closes: "18:00",
            },
            {
              "@type": "OpeningHoursSpecification",
              dayOfWeek: "Saturday",
              opens: "09:00",
              closes: "14:00",
            },
          ],
        }}
      />
      <div className="mx-auto max-w-6xl px-4 py-10">
        <PageHeader
          eyebrow="Get In Touch"
          title="Contact YAROTECH"
          description="For product, service, delivery, or technical inquiries — our team responds within one business day."
        />

        <div className="mt-8 grid gap-6 lg:grid-cols-[340px_1fr]">
          {/* Contact details */}
          <aside className="space-y-4">
            <div className="space-y-4 rounded-md border border-border bg-surface p-5">
              <Info icon={MapPin} label="Location" value="Nigeria — serving nationwide" />
              <Info
                icon={Phone}
                label="Phone"
                value="+234 707 537 3603"
                href="tel:+2347075373603"
              />
              <Info
                icon={Phone}
                label="Phone"
                value="+234 814 150 6547"
                href="tel:+2348141506547"
              />
              <Info
                icon={Phone}
                label="Phone"
                value="+234 814 024 4774"
                href="tel:+2348140244774"
              />
              <Info
                icon={Mail}
                label="Email"
                value="support@yarotech.com.ng"
                href="mailto:support@yarotech.com.ng"
              />
            </div>
            <div className="rounded-md border border-border bg-primary p-5 text-primary-foreground">
              <p className="text-xs font-bold uppercase tracking-widest text-secondary">
                Business Hours
              </p>
              <p className="mt-2 text-sm">Mon – Fri: 8:00 AM – 6:00 PM</p>
              <p className="text-sm">Saturday: 9:00 AM – 2:00 PM</p>
              <p className="text-sm text-primary-foreground/70">Sunday: Closed</p>
            </div>
          </aside>

          {/* Form */}
          <form
            onSubmit={onSubmit}
            className="rounded-md border border-border bg-surface p-5 md:p-6"
          >
            {state.kind === "success" ? (
              <SuccessPanel
                ticketId={state.ticketId}
                onAnother={() => setState({ kind: "idle" })}
              />
            ) : (
              <>
                <h2 className="font-display text-xl font-bold text-primary">Send us a message</h2>
                <p className="mt-1 text-sm text-muted-foreground">
                  All fields marked * are required.
                </p>

                {state.kind === "error" && (
                  <div className="mt-4 flex items-start gap-2 rounded-sm border border-destructive/30 bg-destructive/5 p-3 text-sm text-destructive">
                    <AlertCircle className="mt-0.5 h-4 w-4 flex-shrink-0" />
                    <span>{state.message}</span>
                  </div>
                )}

                <div className="mt-5 grid gap-4 md:grid-cols-2">
                  <Field name="name" label="Full Name *" required />
                  <Field name="phone" label="Phone Number *" type="tel" required />
                  <Field name="email" label="Email Address *" type="email" required />
                  <SelectField
                    name="inquiryType"
                    label="Inquiry Type *"
                    defaultValue={presetInquiry}
                    required
                    options={INQUIRY_TYPES as readonly string[]}
                  />
                  <div className="md:col-span-2">
                    <SelectField
                      name="serviceType"
                      label="Service Type (if applicable)"
                      defaultValue={presetService}
                      options={SERVICE_TYPES as readonly string[]}
                    />
                  </div>
                  <div className="md:col-span-2">
                    <label className="text-xs font-bold uppercase tracking-widest text-muted-foreground">
                      Message Details *
                    </label>
                    <textarea
                      name="message"
                      rows={6}
                      required
                      maxLength={2000}
                      defaultValue={
                        presetService !== "Not applicable"
                          ? `Hello YAROTECH team,\n\nI'd like to enquire about your ${presetService} service.\n\n`
                          : ""
                      }
                      className="mt-1 w-full rounded-sm border border-border bg-surface px-3 py-2 text-sm text-primary focus:border-primary focus:outline-none"
                      placeholder="Tell us about your project, location, scope, and timeline."
                    />
                  </div>
                </div>

                <button
                  type="submit"
                  disabled={state.kind === "loading"}
                  className="mt-5 inline-flex h-11 items-center gap-2 rounded-sm bg-secondary px-6 text-sm font-bold text-secondary-foreground hover:opacity-90 disabled:cursor-not-allowed disabled:opacity-60"
                >
                  {state.kind === "loading" ? (
                    "Sending…"
                  ) : (
                    <>
                      <Send className="h-4 w-4" /> Submit Inquiry
                    </>
                  )}
                </button>
              </>
            )}
          </form>
        </div>

        {/* FAQs Section */}
        <div className="mt-16 mb-10">
          <div className="text-center mb-8">
            <h2 className="font-display text-2xl font-bold text-primary">Frequently Asked Questions</h2>
            <p className="mt-2 text-sm text-muted-foreground">Quick answers to common inquiries.</p>
          </div>
          <div className="grid gap-4 md:grid-cols-2">
            <div className="rounded-md border border-border bg-surface p-5 transition-colors hover:border-secondary">
              <h3 className="font-bold text-primary text-sm">How fast do you respond to inquiries?</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">We aim to respond to all inquiries within 1 business day. For urgent technical support or ongoing project matters, please call our phone line directly.</p>
            </div>
            <div className="rounded-md border border-border bg-surface p-5 transition-colors hover:border-secondary">
              <h3 className="font-bold text-primary text-sm">Do you offer nationwide delivery?</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">Yes, we deploy projects and deliver products to all 36 states in Nigeria. Delivery times and field installation schedules may vary slightly by location.</p>
            </div>
            <div className="rounded-md border border-border bg-surface p-5 transition-colors hover:border-secondary">
              <h3 className="font-bold text-primary text-sm">Can I request a custom solar or network quote?</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">Absolutely. Please select your required "Service Type" in the form above, and describe your property size, energy, or data needs in the message details.</p>
            </div>
            <div className="rounded-md border border-border bg-surface p-5 transition-colors hover:border-secondary">
              <h3 className="font-bold text-primary text-sm">Are your products and installations warrantied?</h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">All our enterprise networking gear, CCTV cameras, and solar components come with strict OEM warranties ranging from 1 to 25 years, alongside our installation guarantee.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function SuccessPanel({ ticketId, onAnother }: { ticketId: string; onAnother: () => void }) {
  return (
    <div className="flex flex-col items-center py-8 text-center">
      <div className="flex h-14 w-14 items-center justify-center rounded-full bg-secondary/15 text-secondary">
        <CheckCircle2 className="h-7 w-7" />
      </div>
      <h2 className="mt-4 font-display text-2xl font-bold text-primary">Inquiry submitted</h2>
      <p className="mt-2 max-w-md text-sm text-muted-foreground">
        Thank you for reaching out. A confirmation email is on its way to your inbox, and our team
        will respond within one business day.
      </p>
      <p className="mt-3 rounded-sm border border-border bg-accent px-3 py-1.5 text-xs font-bold uppercase tracking-widest text-primary">
        Reference: {ticketId}
      </p>
      <button
        type="button"
        onClick={onAnother}
        className="mt-6 inline-flex h-10 items-center rounded-sm border border-border bg-surface px-5 text-sm font-bold text-primary hover:bg-accent"
      >
        Send another message
      </button>
    </div>
  );
}

function Info({
  icon: Icon,
  label,
  value,
  href,
}: {
  icon: React.ComponentType<{ className?: string }>;
  label: string;
  value: string;
  href?: string;
}) {
  const inner = (
    <div className="flex items-start gap-3">
      <Icon className="mt-0.5 h-5 w-5 text-secondary" />
      <div>
        <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
          {label}
        </p>
        <p className="font-semibold text-primary">{value}</p>
      </div>
    </div>
  );
  return href ? (
    <a href={href} className="block hover:opacity-80">
      {inner}
    </a>
  ) : (
    inner
  );
}

function Field({
  name,
  label,
  type = "text",
  required,
  defaultValue,
}: {
  name: string;
  label: string;
  type?: string;
  required?: boolean;
  defaultValue?: string;
}) {
  return (
    <div>
      <label className="text-xs font-bold uppercase tracking-widest text-muted-foreground">
        {label}
      </label>
      <input
        name={name}
        type={type}
        required={required}
        defaultValue={defaultValue}
        maxLength={255}
        className="mt-1 h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm text-primary focus:border-primary focus:outline-none"
      />
    </div>
  );
}

function SelectField({
  name,
  label,
  options,
  defaultValue,
  required,
}: {
  name: string;
  label: string;
  options: readonly string[];
  defaultValue?: string;
  required?: boolean;
}) {
  return (
    <div>
      <label className="text-xs font-bold uppercase tracking-widest text-muted-foreground">
        {label}
      </label>
      <select
        name={name}
        required={required}
        defaultValue={defaultValue}
        className="mt-1 h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm text-primary focus:border-primary focus:outline-none"
      >
        {options.map((o) => (
          <option key={o} value={o}>
            {o}
          </option>
        ))}
      </select>
    </div>
  );
}
