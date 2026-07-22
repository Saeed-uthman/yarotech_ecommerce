import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { Search, Send, Megaphone, X, CheckCircle, Clock, AlertCircle } from "lucide-react";
import { toast } from "sonner";
import { PageHeader } from "@/components/common/PageHeader";
import { StatusBadge } from "@/components/common/StatusBadge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  fetchSupportMessages,
  replySupportMessage,
  updateSupportStatus,
  type SupportMessage,
} from "@/api/admin";
import { formatDistanceToNow } from "date-fns";

export const Route = createFileRoute("/admin/support")({
  component: SupportAdmin,
  head: () => ({ meta: [{ title: "Support Inbox — Admin" }] }),
});

const CATS: { value: "all" | SupportMessage["category"]; label: string }[] = [
  { value: "all", label: "All Tickets" },
  { value: "general", label: "General" },
  { value: "product", label: "Products" },
  { value: "delivery", label: "Delivery" },
  { value: "payment", label: "Payments" },
  { value: "complaint", label: "Complaints" },
];

function SupportAdmin() {
  const [items, setItems] = useState<SupportMessage[] | null>(null);
  const [search, setSearch] = useState("");
  const [cat, setCat] = useState<"all" | SupportMessage["category"]>("all");
  const [active, setActive] = useState<SupportMessage | null>(null);

  // Pagination states
  const [page, setPage] = useState(1);
  const itemsPerPage = 10;

  useEffect(() => {
    fetchSupportMessages().then(setItems);
  }, []);

  // Auto-reset page on filter updates
  useEffect(() => {
    setPage(1);
  }, [search, cat]);

  const filtered = useMemo(() => {
    if (!items) return [];
    return items.filter((m) => {
      if (cat !== "all" && m.category !== cat) return false;
      if (!search) return true;
      const q = search.toLowerCase();
      return (
        (m.subject || "").toLowerCase().includes(q) ||
        (m.name || "").toLowerCase().includes(q) ||
        (m.email || "").toLowerCase().includes(q)
      );
    });
  }, [items, search, cat]);

  const totalPages = Math.ceil(filtered.length / itemsPerPage);
  const startIndex = (page - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const paginated = useMemo(() => {
    return filtered.slice(startIndex, endIndex);
  }, [filtered, startIndex, endIndex]);

  const handleUpdateStatusLocal = (id: string, status: "new" | "in_review" | "resolved") => {
    setItems((prev) => prev?.map((m) => (m.id === id ? { ...m, status } : m)) ?? prev);
    if (active && active.id === id) {
      setActive((prev) => (prev ? { ...prev, status } : null));
    }
  };

  const handleRepliedLocal = (message: SupportMessage) => {
    setItems(
      (prev) =>
        prev?.map((m) => (m.id === message.id ? { ...m, ...message } : m)) ?? prev,
    );
    setActive((prev) => (prev && prev.id === message.id ? { ...prev, ...message } : prev));
  };

  return (
    <div className="space-y-8">
      <PageHeader
        eyebrow="Customer Success"
        title="Support Inbox"
        description="Monitor contact requests, resolve buyer inquiries, and update support ticket statuses."
        actions={
          <button
            onClick={() => toast.info("Announcement composer coming soon")}
            className="inline-flex h-10 items-center gap-2 rounded-sm border border-border bg-surface px-4 text-xs font-semibold uppercase tracking-wide text-primary hover:bg-accent cursor-pointer transition"
          >
            <Megaphone className="h-4 w-4" /> New Announcement
          </button>
        }
      />

      <div className="space-y-4">
        {/* Search & Category Pills */}
        <div className="flex flex-col gap-4">
          <div className="relative">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search subject, sender name, email..."
              className="h-10 w-full rounded-sm border border-border bg-surface pl-9 pr-3 text-sm focus:outline-none focus:ring-1 focus:ring-secondary focus:border-secondary"
            />
          </div>

          <div className="flex flex-wrap gap-2 items-center">
            <span className="text-xs font-semibold uppercase tracking-wider text-muted-foreground mr-1">
              Filter:
            </span>
            {CATS.map((c) => (
              <button
                key={c.value}
                onClick={() => setCat(c.value)}
                className={`px-3 py-1.5 rounded-full text-xs font-semibold uppercase tracking-wider transition cursor-pointer ${
                  cat === c.value
                    ? "bg-secondary text-primary shadow-sm"
                    : "bg-surface border border-border text-muted-foreground hover:text-primary"
                }`}
              >
                {c.label}
              </button>
            ))}
          </div>
        </div>

        {/* Tickets List */}
        {!items ? (
          <Skeleton className="h-64" />
        ) : (
          <div className="rounded-md border border-border bg-surface">
            {paginated.length === 0 ? (
              <div className="px-4 py-16 text-center">
                <AlertCircle className="h-10 w-10 text-muted-foreground/30 mx-auto mb-2" />
                <h3 className="font-semibold text-muted-foreground">No matching tickets</h3>
                <p className="text-xs text-muted-foreground mt-1">
                  Try modifying your search keywords or category filters.
                </p>
              </div>
            ) : (
              <ul className="divide-y divide-border">
                {paginated.map((m) => (
                  <li key={m.id}>
                    <button
                      onClick={() => setActive(m)}
                      className="block w-full px-5 py-4 text-left transition-colors hover:bg-accent/35 cursor-pointer"
                    >
                      <div className="flex items-start justify-between gap-4">
                        <div className="min-w-0 flex-1">
                          <div className="flex flex-wrap items-center gap-2">
                            <p className="font-bold text-primary text-sm">{m.subject}</p>
                            <StatusBadge
                              variant={
                                m.status === "new"
                                  ? "warning"
                                  : m.status === "in_review"
                                    ? "navy"
                                    : "success"
                              }
                            >
                              {m.status.replace("_", " ")}
                            </StatusBadge>
                            <StatusBadge variant="muted" className="lowercase">
                              {m.category}
                            </StatusBadge>
                          </div>
                          <p className="mt-1.5 line-clamp-1 text-xs text-muted-foreground">
                            {m.body}
                          </p>
                          <p className="mt-2 text-[10px] uppercase tracking-wider text-muted-foreground font-semibold">
                            {m.name} • {m.email} •{" "}
                            {formatDistanceToNow(m.createdAt, { addSuffix: true })}
                          </p>
                        </div>
                      </div>
                    </button>
                  </li>
                ))}
              </ul>
            )}

            {/* Pagination Controls */}
            {filtered.length > 0 && (
              <div className="flex flex-col sm:flex-row items-center justify-between gap-4 border-t border-border bg-surface px-5 py-4 rounded-b-md">
                <span className="text-xs text-muted-foreground">
                  Showing {startIndex + 1} to {Math.min(endIndex, filtered.length)} of{" "}
                  {filtered.length} tickets
                </span>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setPage((p) => Math.max(1, p - 1))}
                    disabled={page === 1}
                    className="inline-flex h-8 items-center gap-1 rounded-sm border border-border px-3 text-xs font-semibold uppercase tracking-wider text-primary hover:bg-accent disabled:opacity-50 cursor-pointer disabled:cursor-not-allowed transition"
                  >
                    Previous
                  </button>
                  {Array.from({ length: totalPages }).map((_, i) => {
                    const pageNum = i + 1;
                    return (
                      <button
                        key={pageNum}
                        onClick={() => setPage(pageNum)}
                        className={`h-8 w-8 rounded-sm text-xs font-bold transition cursor-pointer ${
                          page === pageNum
                            ? "bg-secondary text-primary"
                            : "border border-border hover:bg-accent"
                        }`}
                      >
                        {pageNum}
                      </button>
                    );
                  })}
                  <button
                    onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                    disabled={page === totalPages}
                    className="inline-flex h-8 items-center gap-1 rounded-sm border border-border px-3 text-xs font-semibold uppercase tracking-wider text-primary hover:bg-accent disabled:opacity-50 cursor-pointer disabled:cursor-not-allowed transition"
                  >
                    Next
                  </button>
                </div>
              </div>
            )}
          </div>
        )}
      </div>

      <p className="rounded-sm border border-dashed border-border bg-accent/20 p-4 text-[11px] text-muted-foreground leading-relaxed">
        Incoming customer enquiries from the storefront contact form are ingested into this support
        inbox. The system forwards a copy to <strong>support@yarotech.ng</strong> and alerts active
        administrators via the System Alerts feed.
      </p>

      {active && (
        <ReplyDrawer
          message={active}
          onClose={() => setActive(null)}
          onUpdateStatus={handleUpdateStatusLocal}
          onReplied={handleRepliedLocal}
        />
      )}
    </div>
  );
}

interface ReplyDrawerProps {
  message: SupportMessage;
  onClose: () => void;
  onUpdateStatus: (id: string, status: "new" | "in_review" | "resolved") => void;
  onReplied: (message: SupportMessage) => void;
}

function ReplyDrawer({ message, onClose, onUpdateStatus, onReplied }: ReplyDrawerProps) {
  const [reply, setReply] = useState(message.reply || "");
  const [sending, setSending] = useState(false);
  const [updating, setUpdating] = useState<string | null>(null);

  const handleStatusChange = async (newStatus: "new" | "in_review" | "resolved") => {
    setUpdating(newStatus);
    try {
      await updateSupportStatus(message.id, newStatus);
      onUpdateStatus(message.id, newStatus);
      toast.success(`Ticket status marked as ${newStatus.replace("_", " ")}`);
    } catch {
      toast.error("Failed to update ticket status.");
    } finally {
      setUpdating(null);
    }
  };

  const handleSendReply = async () => {
    if (!reply.trim()) return;
    setSending(true);
    try {
      const result = await replySupportMessage(message.id, reply.trim());
      onReplied(result.message);
      if (result.message.emailSent) {
        toast.success("Reply saved and emailed to customer");
      } else {
        toast.warning("Reply saved, but email delivery failed");
      }
      onClose();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Failed to send support reply.");
    } finally {
      setSending(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex animate-in fade-in duration-150">
      <div className="flex-1 bg-black/50 backdrop-blur-xs" onClick={onClose} />
      <aside className="flex w-full max-w-lg flex-col overflow-y-auto bg-surface shadow-2xl animate-in slide-in-from-right duration-200">
        {/* Header */}
        <header className="sticky top-0 flex items-center justify-between border-b border-border bg-surface px-5 py-4 z-10">
          <div>
            <p className="text-[10px] font-bold uppercase tracking-widest text-secondary">
              Ticket Details
            </p>
            <h2 className="font-display text-lg font-bold text-primary truncate max-w-[280px]">
              {message.subject}
            </h2>
          </div>
          <button
            onClick={onClose}
            className="flex h-8 w-8 items-center justify-center rounded-sm hover:bg-accent cursor-pointer transition"
          >
            <X className="h-4 w-4" />
          </button>
        </header>

        <div className="flex-1 space-y-6 p-5">
          {/* Status Controls */}
          <div className="border border-border rounded-md bg-muted/20 p-4 space-y-2">
            <label className="block text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
              Manage Ticket Status
            </label>
            <div className="flex gap-2">
              {(["new", "in_review", "resolved"] as const).map((s) => (
                <button
                  key={s}
                  onClick={() => handleStatusChange(s)}
                  disabled={updating !== null}
                  className={`flex-1 py-1.5 rounded-sm text-[10px] font-bold uppercase tracking-wider transition cursor-pointer ${
                    message.status === s
                      ? s === "new"
                        ? "bg-amber-500 text-white shadow-xs"
                        : s === "in_review"
                          ? "bg-blue-600 text-white shadow-xs"
                          : "bg-emerald-600 text-white shadow-xs"
                      : "bg-accent hover:bg-accent/80 text-muted-foreground"
                  }`}
                >
                  {updating === s ? "Updating..." : s.replace("_", " ")}
                </button>
              ))}
            </div>
          </div>

          {/* Interactive Chat Timeline */}
          <div className="space-y-4">
            <label className="block text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
              Conversation Thread
            </label>

            <div className="space-y-4 flex flex-col">
              {/* Customer Initial Inquiry Bubble */}
              <div className="flex items-start gap-3 self-start max-w-[85%]">
                <div className="h-8 w-8 shrink-0 flex items-center justify-center rounded-full bg-secondary/15 text-secondary font-bold text-xs uppercase">
                  {message.name.slice(0, 2)}
                </div>
                <div className="bg-accent/40 border border-border p-3.5 rounded-r-lg rounded-bl-lg text-sm text-foreground">
                  <div className="flex items-center gap-1.5 mb-1 flex-wrap">
                    <span className="font-bold text-xs text-primary">{message.name}</span>
                    <span className="text-[10px] text-muted-foreground font-medium">
                      ({message.email})
                    </span>
                  </div>
                  <p className="whitespace-pre-wrap leading-relaxed text-foreground/95">
                    {message.body}
                  </p>
                  <p className="mt-2 text-[9px] uppercase tracking-wider text-muted-foreground font-semibold">
                    {formatDistanceToNow(message.createdAt, { addSuffix: true })}
                  </p>
                </div>
              </div>

              {/* Admin Reply Bubble */}
              {message.reply && (
                <div className="flex items-start gap-3 self-end max-w-[85%] flex-row-reverse">
                  <div className="h-8 w-8 shrink-0 flex items-center justify-center rounded-full bg-primary text-primary-foreground font-bold text-xs uppercase shadow-sm">
                    AD
                  </div>
                  <div className="bg-primary/5 border border-primary/20 p-3.5 rounded-l-lg rounded-br-lg text-sm text-foreground">
                    <div className="flex items-center gap-1.5 mb-1 justify-end">
                      <span className="font-bold text-xs text-secondary">Support Agent</span>
                      <span className="text-[10px] text-muted-foreground font-medium">
                        (support@yarotech.ng)
                      </span>
                    </div>
                    <p className="whitespace-pre-wrap leading-relaxed text-foreground/95">
                      {message.reply}
                    </p>
                    <div className="flex items-center gap-1.5 justify-end mt-2">
                      <CheckCircle className="h-3 w-3 text-emerald-500" />
                      <span className="text-[9px] uppercase tracking-wider text-muted-foreground font-bold">
                        Reply saved
                      </span>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Reply Form */}
          <div className="space-y-2 pt-4 border-t border-border">
            <label className="block text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
              {message.reply ? "Draft a New Follow-up Reply" : "Compose Support Response"}
            </label>
            <textarea
              value={reply}
              onChange={(e) => setReply(e.target.value)}
              rows={5}
              placeholder="Type your response here..."
              className="w-full rounded-sm border border-border bg-background p-3 text-sm focus:outline-none focus:ring-1 focus:ring-secondary focus:border-secondary"
            />
          </div>
        </div>

        {/* Reply Footer */}
        <footer className="sticky bottom-0 border-t border-border bg-surface p-4 z-10">
          <button
            onClick={handleSendReply}
            disabled={sending || !reply.trim()}
            className="inline-flex w-full items-center justify-center gap-2 rounded-sm bg-cta px-4 py-2.5 text-sm font-bold uppercase tracking-wide text-cta-foreground hover:bg-cta/90 disabled:opacity-50 cursor-pointer disabled:cursor-not-allowed transition"
          >
            <Send className="h-4 w-4" /> {sending ? "Sending Reply..." : "Send Reply"}
          </button>
        </footer>
      </aside>
    </div>
  );
}
