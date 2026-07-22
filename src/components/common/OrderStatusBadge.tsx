import { StatusBadge } from "@/components/common/StatusBadge";

type Status =
  | "pending"
  | "awaiting_payment"
  | "paid"
  | "processing"
  | "shipped"
  | "delivered"
  | "cancelled"
  | "refunded"
  | "failed";

const VARIANT: Record<Status, "default" | "success" | "warning" | "danger" | "muted" | "navy"> = {
  pending: "warning",
  awaiting_payment: "warning",
  paid: "success",
  processing: "navy",
  shipped: "warning",
  delivered: "success",
  cancelled: "danger",
  refunded: "muted",
  failed: "danger",
};

const LABELS: Record<Status, string> = {
  pending: "Pending",
  awaiting_payment: "Awaiting Payment",
  paid: "Paid",
  processing: "Processing",
  shipped: "Shipped",
  delivered: "Delivered",
  cancelled: "Cancelled",
  refunded: "Refunded",
  failed: "Failed",
};

export function OrderStatusBadge({ status }: { status: any }) {
  const normStatus = String(status || "awaiting_payment").toLowerCase() as Status;
  const variant = VARIANT[normStatus] || "default";
  const label = LABELS[normStatus] || normStatus;
  return <StatusBadge variant={variant}>{label}</StatusBadge>;
}
