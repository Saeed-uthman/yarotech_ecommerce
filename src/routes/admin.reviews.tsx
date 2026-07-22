import { useState, useEffect } from "react";
import { createFileRoute } from "@tanstack/react-router";
import { fetchAdminReviews, updateAdminReviewStatus, deleteAdminReview, AdminReview } from "@/api/admin";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Check, X, Trash2, Search, AlertCircle, MessageSquare } from "lucide-react";
import { toast } from "sonner";
import { format } from "date-fns";

export const Route = createFileRoute("/admin/reviews")({
  component: AdminReviewsPage,
});

function AdminReviewsPage() {
  const [reviews, setReviews] = useState<AdminReview[]>([]);
  const [loading, setLoading] = useState(true);
  const [statusFilter, setStatusFilter] = useState<string>("all");
  const [search, setSearch] = useState("");

  const loadData = async () => {
    setLoading(true);
    try {
      const data = await fetchAdminReviews(statusFilter !== "all" ? statusFilter : undefined);
      setReviews(data);
    } catch (err) {
      toast.error("Failed to load reviews");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, [statusFilter]);

  const handleUpdateStatus = async (id: string, newStatus: "approved" | "rejected") => {
    try {
      await updateAdminReviewStatus(id, newStatus);
      toast.success(`Review ${newStatus} successfully`);
      loadData();
    } catch (err) {
      toast.error("Failed to update status");
    }
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm("Are you sure you want to delete this review?")) return;
    try {
      await deleteAdminReview(id);
      toast.success("Review deleted successfully");
      loadData();
    } catch (err) {
      toast.error("Failed to delete review");
    }
  };

  const filteredReviews = reviews.filter(
    (r) =>
      r.userName.toLowerCase().includes(search.toLowerCase()) ||
      r.reviewText.toLowerCase().includes(search.toLowerCase()) ||
      r.productId.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="font-display text-2xl font-bold text-gray-900 tracking-tight flex items-center gap-2">
            <MessageSquare className="h-6 w-6 text-[#FEA619]" />
            Review Management
          </h1>
          <p className="text-sm text-gray-500 mt-1">Approve, reject, or delete customer product reviews.</p>
        </div>
      </div>

      <div className="flex flex-col gap-4 sm:flex-row sm:items-center justify-between bg-white p-4 rounded-xl shadow-sm border border-gray-100">
        <div className="flex items-center gap-4 flex-1">
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search reviews or authors..."
              className="w-full rounded-md border-gray-300 pl-10 pr-4 py-2 text-sm focus:border-[#0D1C32] focus:ring-[#0D1C32]"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>
          
          <Select value={statusFilter} onValueChange={setStatusFilter}>
            <SelectTrigger className="w-[180px]">
              <SelectValue placeholder="Filter by status" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Reviews</SelectItem>
              <SelectItem value="pending">Pending</SelectItem>
              <SelectItem value="approved">Approved</SelectItem>
              <SelectItem value="rejected">Rejected</SelectItem>
            </SelectContent>
          </Select>
        </div>
        <Button onClick={loadData} variant="outline" size="sm">Refresh</Button>
      </div>

      {loading ? (
        <div className="flex items-center justify-center h-64 bg-white rounded-xl border border-gray-100 shadow-sm">
          <div className="flex flex-col items-center gap-3">
            <div className="h-8 w-8 animate-spin rounded-full border-4 border-[#0D1C32] border-t-transparent" />
            <p className="text-sm text-gray-500 font-medium">Loading reviews...</p>
          </div>
        </div>
      ) : filteredReviews.length === 0 ? (
        <div className="flex flex-col items-center justify-center bg-white p-12 rounded-xl shadow-sm border border-gray-100 text-center">
          <div className="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mb-4">
            <AlertCircle className="h-8 w-8 text-gray-400" />
          </div>
          <h3 className="text-lg font-bold text-gray-900 mb-1">No reviews found</h3>
          <p className="text-sm text-gray-500 max-w-md">
            {search || statusFilter !== 'all' 
              ? "There are no reviews matching your current filters."
              : "No reviews have been submitted yet."}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm text-left">
              <thead className="bg-[#0D1C32] text-white">
                <tr>
                  <th className="px-6 py-4 font-semibold tracking-wider uppercase text-xs">Author & Product</th>
                  <th className="px-6 py-4 font-semibold tracking-wider uppercase text-xs">Rating</th>
                  <th className="px-6 py-4 font-semibold tracking-wider uppercase text-xs">Review</th>
                  <th className="px-6 py-4 font-semibold tracking-wider uppercase text-xs">Status</th>
                  <th className="px-6 py-4 font-semibold tracking-wider uppercase text-xs">Date</th>
                  <th className="px-6 py-4 font-semibold tracking-wider uppercase text-xs text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                  {filteredReviews.map((r) => (
                    <tr 
                      key={r.id}
                      className="hover:bg-gray-50/50 transition-colors"
                    >
                      <td className="px-6 py-4">
                        <div className="font-medium text-gray-900">{r.userName}</div>
                        <div className="text-xs text-gray-500 mt-0.5 max-w-[150px] truncate" title={r.productId}>
                          ID: {r.productId}
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-1">
                          <span className="font-bold text-[#FEA619]">{r.rating}</span>
                          <span className="text-gray-400 text-xs">/ 5</span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="max-w-xs md:max-w-md lg:max-w-lg">
                          <p className="text-gray-700 line-clamp-2" title={r.reviewText}>
                            {r.reviewText || <span className="italic text-gray-400">No text provided</span>}
                          </p>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span
                          className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium uppercase tracking-wide ${
                            r.status === "approved"
                              ? "bg-green-100 text-green-800"
                              : r.status === "rejected"
                                ? "bg-red-100 text-red-800"
                                : "bg-yellow-100 text-yellow-800"
                          }`}
                        >
                          {r.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-gray-500 whitespace-nowrap">
                        {format(r.createdAt, "MMM d, yyyy")}
                      </td>
                      <td className="px-6 py-4 text-right whitespace-nowrap">
                        <div className="flex items-center justify-end gap-2">
                          {r.status !== "approved" && (
                            <Button
                              size="sm"
                              variant="outline"
                              className="h-8 border-green-200 text-green-700 hover:bg-green-50 hover:border-green-300"
                              onClick={() => handleUpdateStatus(r.id, "approved")}
                              title="Approve"
                            >
                              <Check className="h-4 w-4" />
                            </Button>
                          )}
                          {r.status !== "rejected" && (
                            <Button
                              size="sm"
                              variant="outline"
                              className="h-8 border-yellow-200 text-yellow-700 hover:bg-yellow-50 hover:border-yellow-300"
                              onClick={() => handleUpdateStatus(r.id, "rejected")}
                              title="Reject"
                            >
                              <X className="h-4 w-4" />
                            </Button>
                          )}
                          <Button
                            size="sm"
                            variant="outline"
                            className="h-8 border-red-200 text-red-700 hover:bg-red-50 hover:border-red-300"
                            onClick={() => handleDelete(r.id)}
                            title="Delete"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </td>
                    </tr>
                  ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
