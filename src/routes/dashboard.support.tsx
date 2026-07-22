import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import {
  Send,
  CheckCircle2,
  AlertCircle,
  HelpCircle,
  Package,
  Calendar,
  Clock,
  ArrowRight,
  MessageSquare,
  ShieldAlert,
} from "lucide-react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { StatusBadge } from "@/components/common/StatusBadge";
import { Skeleton } from "@/components/ui/skeleton";
import { submitContact, fetchMyTickets } from "@/api/contact";
import { listMyOrders, type Order } from "@/api/orders";
import { useAuthStore } from "@/stores/auth";
import { formatDistanceToNow } from "date-fns";
import { parseApiDate } from "@/lib/dates";

export const Route = createFileRoute("/dashboard/support")({
  component: DashboardSupport,
  head: () => ({ meta: [{ title: "Help & Support — YAROTECH" }] }),
});

const INQUIRY_TYPES = [
  "General Inquiry",
  "Product Support",
  "Delivery Support",
  "Payment Issue",
  "Complaint",
] as const;

type FormState =
  | { kind: "idle" }
  | { kind: "loading" }
  | { kind: "success"; ticketId: string }
  | { kind: "error"; message: string };

function DashboardSupport() {
  const user = useAuthStore((s) => s.user);
  const [tickets, setTickets] = useState<any[] | null>(null);
  const [orders, setOrders] = useState<Order[]>([]);
  const [formState, setFormState] = useState<FormState>({ kind: "idle" });

  // Ticket selection for detailed chat view
  const [selectedTicket, setSelectedTicket] = useState<any | null>(null);

  // Form states
  const [inquiryType, setInquiryType] = useState<string>("General Inquiry");
  const [linkedOrder, setLinkedOrder] = useState<string>("");
  const [messageText, setMessageText] = useState<string>("");

  const loadData = () => {
    fetchMyTickets()
      .then((data) => {
        setTickets(data);
        // Sync selected ticket reference if open
        if (selectedTicket) {
          const fresh = data.find((t: any) => t.id === selectedTicket.id);
          if (fresh) setSelectedTicket(fresh);
        }
      })
      .catch(() => setTickets([]));
  };

  useEffect(() => {
    loadData();
    listMyOrders()
      .then(setOrders)
      .catch(() => setOrders([]));
  }, []);

  const handleSubmitTicket = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!messageText.trim()) return;

    setFormState({ kind: "loading" });
    try {
      // If linked order is selected, prepend it to the message details
      const finalMessage = linkedOrder
        ? `[Linked Order ID: ${linkedOrder}]\n\n${messageText.trim()}`
        : messageText.trim();

      const res = await submitContact({
        name: user?.fullName || "Registered Customer",
        email: user?.email || "",
        phone: user?.phone || "+234",
        inquiryType: inquiryType as any,
        serviceType: "Not applicable",
        message: finalMessage,
      });

      setFormState({ kind: "success", ticketId: res.ticketId });
      toast.success("Support ticket created successfully!", {
        description: `Reference: ${res.ticketId}. Check your email for status alerts.`,
      });

      // Reset form states
      setMessageText("");
      setLinkedOrder("");
      setInquiryType("General Inquiry");

      // Reload ticket list
      loadData();
    } catch (err) {
      const msg = (err as Error).message || "Failed to submit support ticket";
      setFormState({ kind: "error", message: msg });
      toast.error(msg);
    }
  };

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Help & Assistance"
        title="Help & Support Hub"
        description="Lodge complaints, ask about payments or orders, and review responses from the customer success team."
      />

      <div className="grid gap-8 lg:grid-cols-[1fr_400px]">
        {/* Left Column: Form / Live Chat View */}
        <div className="space-y-6">
          {selectedTicket ? (
            /* Conversational Chat Thread Pane */
            <div className="rounded-md border border-border bg-surface overflow-hidden">
              <header className="flex items-center justify-between border-b border-border bg-muted/10 px-5 py-4">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-[10px] font-bold uppercase tracking-widest text-secondary">
                      Ticket Conversation
                    </span>
                    <StatusBadge
                      variant={
                        selectedTicket.status === "new"
                          ? "warning"
                          : selectedTicket.status === "in_review"
                            ? "navy"
                            : "success"
                      }
                    >
                      {selectedTicket.status.replace("_", " ")}
                    </StatusBadge>
                  </div>
                  <h3 className="font-display text-base font-bold text-primary mt-0.5">
                    {selectedTicket.subject}
                  </h3>
                </div>
                <button
                  onClick={() => setSelectedTicket(null)}
                  className="text-xs font-semibold uppercase tracking-wider text-muted-foreground hover:text-primary transition cursor-pointer"
                >
                  Back to Form
                </button>
              </header>

              <div className="p-5 space-y-6">
                {/* Chat Timeline */}
                <div className="space-y-4 flex flex-col">
                  {/* Customer message */}
                  <div className="flex items-start gap-3 self-end max-w-[85%] flex-row-reverse">
                    <div className="h-8 w-8 shrink-0 flex items-center justify-center rounded-full bg-secondary/20 text-secondary font-bold text-xs uppercase">
                      ME
                    </div>
                    <div className="bg-secondary/5 border border-secondary/20 p-3.5 rounded-l-lg rounded-br-lg text-sm text-foreground">
                      <p className="whitespace-pre-wrap leading-relaxed text-foreground/90">
                        {selectedTicket.body}
                      </p>
                      <p className="mt-2 text-[9px] uppercase tracking-wider text-muted-foreground font-semibold text-right">
                        {formatDistanceToNow(new Date(selectedTicket.createdAt), {
                          addSuffix: true,
                        })}
                      </p>
                    </div>
                  </div>

                  {/* Admin Reply */}
                  {selectedTicket.reply ? (
                    <div className="flex items-start gap-3 self-start max-w-[85%]">
                      <div className="h-8 w-8 shrink-0 flex items-center justify-center rounded-full bg-primary text-primary-foreground font-bold text-xs uppercase shadow-sm">
                        YR
                      </div>
                      <div className="bg-accent/40 border border-border p-3.5 rounded-r-lg rounded-bl-lg text-sm text-foreground">
                        <div className="flex items-center gap-1.5 mb-1">
                          <span className="font-bold text-xs text-primary">YAROTECH Agent</span>
                          <span className="text-[9px] bg-emerald-500/10 text-emerald-600 px-1 rounded-sm uppercase tracking-wider font-bold">
                            Verified
                          </span>
                        </div>
                        <p className="whitespace-pre-wrap leading-relaxed text-foreground/90">
                          {selectedTicket.reply}
                        </p>
                        <p className="mt-2 text-[9px] uppercase tracking-wider text-muted-foreground font-semibold">
                          {selectedTicket.updated_at
                            ? formatDistanceToNow(parseApiDate(selectedTicket.updated_at), {
                                addSuffix: true,
                              })
                            : "recently"}
                        </p>
                      </div>
                    </div>
                  ) : (
                    <div className="flex items-start gap-3 self-start max-w-[85%]">
                      <div className="h-8 w-8 shrink-0 flex items-center justify-center rounded-full bg-accent text-muted-foreground font-bold text-xs uppercase">
                        YR
                      </div>
                      <div className="bg-accent/20 border border-border/50 p-4 rounded-r-lg rounded-bl-lg text-sm text-muted-foreground flex items-center gap-2">
                        <Clock className="h-4 w-4 animate-pulse text-amber-500" />
                        <span>
                          Our technical desk is reviewing your ticket and will update you shortly.
                        </span>
                      </div>
                    </div>
                  )}
                </div>

                {/* Footnote */}
                {selectedTicket.status === "resolved" && (
                  <div className="flex items-center gap-2 rounded-sm border border-emerald-500/20 bg-emerald-500/5 p-3 text-xs text-emerald-600 font-semibold">
                    <CheckCircle2 className="h-4 w-4" />
                    <span>
                      This ticket has been marked as resolved. If you have additional questions,
                      please open a new ticket.
                    </span>
                  </div>
                )}
              </div>
            </div>
          ) : (
            /* Support Intake Form Card */
            <form
              onSubmit={handleSubmitTicket}
              className="rounded-md border border-border bg-surface p-5 md:p-6 space-y-4"
            >
              <h2 className="font-display text-lg font-bold text-primary">Open a Support Ticket</h2>
              <p className="text-xs text-muted-foreground">
                Need help with a payment failure, order delay, or product specifications? Let us
                know below!
              </p>

              {formState.kind === "error" && (
                <div className="flex items-start gap-2 rounded-sm border border-destructive/30 bg-destructive/5 p-3 text-xs text-destructive">
                  <AlertCircle className="mt-0.5 h-4 w-4 flex-shrink-0" />
                  <span>{formState.message}</span>
                </div>
              )}

              {formState.kind === "success" && (
                <div className="flex items-start gap-2 rounded-sm border border-emerald-500/30 bg-emerald-500/5 p-3 text-xs text-emerald-600">
                  <CheckCircle2 className="mt-0.5 h-4 w-4 flex-shrink-0" />
                  <div>
                    <span className="font-bold">Ticket Submitted successfully!</span>
                    <p className="mt-0.5 text-[10px] uppercase tracking-wider text-muted-foreground font-semibold">
                      Reference Code: {formState.ticketId}
                    </p>
                  </div>
                </div>
              )}

              <div className="grid gap-4 md:grid-cols-2">
                <div>
                  <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Inquiry Type / Category *
                  </label>
                  <select
                    value={inquiryType}
                    onChange={(e) => setInquiryType(e.target.value)}
                    className="mt-1 h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm text-primary focus:border-secondary focus:outline-none"
                  >
                    {INQUIRY_TYPES.map((t) => (
                      <option key={t} value={t}>
                        {t}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Link to Order (Optional)
                  </label>
                  <select
                    value={linkedOrder}
                    onChange={(e) => setLinkedOrder(e.target.value)}
                    className="mt-1 h-10 w-full rounded-sm border border-border bg-surface px-3 text-sm text-primary focus:border-secondary focus:outline-none"
                  >
                    <option value="">-- No linked order --</option>
                    {orders.map((o) => (
                      <option key={o.id} value={o.id}>
                        Order #{o.id} - {o.itemCount} item(s) (₦{o.total?.toLocaleString()})
                      </option>
                    ))}
                  </select>
                </div>

                <div className="md:col-span-2">
                  <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                    Detailed Complaint / Inquiry Details *
                  </label>
                  <textarea
                    value={messageText}
                    onChange={(e) => setMessageText(e.target.value)}
                    rows={6}
                    required
                    maxLength={2000}
                    placeholder="Provide details about your query (e.g. Paystack transaction reference, product issues, or shipping concerns)..."
                    className="mt-1 w-full rounded-sm border border-border bg-surface p-3 text-sm text-primary focus:border-secondary focus:outline-none leading-relaxed"
                  />
                  <div className="mt-1 flex items-center justify-between text-[10px] text-muted-foreground font-semibold">
                    <span>At least 10 characters required</span>
                    <span>{messageText.length} / 2000 chars</span>
                  </div>
                </div>
              </div>

              <button
                type="submit"
                disabled={formState.kind === "loading" || messageText.trim().length < 10}
                className="inline-flex h-10 items-center gap-2 rounded-sm bg-cta px-5 text-xs font-bold uppercase tracking-wide text-cta-foreground hover:bg-cta/90 disabled:cursor-not-allowed disabled:opacity-50 cursor-pointer transition"
              >
                <Send className="h-3.5 w-3.5" />
                {formState.kind === "loading" ? "Submitting Ticket..." : "Submit Support Ticket"}
              </button>
            </form>
          )}
        </div>

        {/* Right Column: Ticket Logs History */}
        <div className="space-y-4">
          <div className="rounded-md border border-border bg-surface p-5">
            <h3 className="font-display text-sm font-bold text-primary flex items-center gap-2">
              <MessageSquare className="h-4 w-4 text-secondary" /> Support Ticket Log
            </h3>
            <p className="mt-1 text-xs text-muted-foreground leading-relaxed">
              Below is a record of all support tickets or contact inquiries submitted using this
              account.
            </p>

            <div className="mt-4 border-t border-border pt-4">
              {!tickets ? (
                <div className="space-y-3">
                  <Skeleton className="h-12 w-full" />
                  <Skeleton className="h-12 w-full" />
                </div>
              ) : tickets.length === 0 ? (
                <div className="py-8 text-center">
                  <HelpCircle className="h-8 w-8 text-muted-foreground/30 mx-auto mb-2" />
                  <p className="text-xs text-muted-foreground font-semibold">
                    No tickets logged yet
                  </p>
                  <p className="text-[10px] text-muted-foreground mt-0.5">
                    Use the form to send support requests to admin.
                  </p>
                </div>
              ) : (
                <ul className="divide-y divide-border -mx-5 -mb-5">
                  {tickets.map((t) => (
                    <li key={t.id}>
                      <button
                        onClick={() => {
                          setSelectedTicket(t);
                          // Reset form messages
                          setFormState({ kind: "idle" });
                        }}
                        className={`block w-full px-5 py-3.5 text-left transition-colors hover:bg-accent/40 cursor-pointer ${
                          selectedTicket?.id === t.id
                            ? "bg-accent/50 border-l-2 border-secondary"
                            : ""
                        }`}
                      >
                        <div className="flex items-center justify-between gap-2">
                          <span className="text-[10px] font-bold text-primary uppercase tracking-wider">
                            TKT-{t.id}
                          </span>
                          <StatusBadge
                            variant={
                              t.status === "new"
                                ? "warning"
                                : t.status === "in_review"
                                  ? "navy"
                                  : "success"
                            }
                          >
                            {t.status.replace("_", " ")}
                          </StatusBadge>
                        </div>
                        <p className="font-bold text-xs text-primary mt-1 truncate">{t.subject}</p>
                        <p className="text-[10px] text-muted-foreground mt-1 line-clamp-1">
                          {t.body}
                        </p>
                        <p className="text-[9px] uppercase tracking-wider text-muted-foreground font-bold mt-2">
                          {formatDistanceToNow(new Date(t.createdAt), { addSuffix: true })}
                        </p>
                      </button>
                    </li>
                  ))}
                </ul>
              )}
            </div>
          </div>

          <div className="rounded-md border border-dashed border-border p-4 bg-accent/20 flex gap-3">
            <ShieldAlert className="h-5 w-5 text-secondary shrink-0 mt-0.5" />
            <div>
              <h4 className="text-xs font-bold text-primary uppercase tracking-wider">
                Verification Guarantee
              </h4>
              <p className="text-[10px] text-muted-foreground mt-1 leading-relaxed">
                Tickets are monitored 24/7. When an agent replies, you'll receive an email dispatch
                notification and an in-app alert inside your account dashboard.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
