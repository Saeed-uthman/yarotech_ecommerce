/**
 * Reviews service.
 *
 * Real production endpoints (PHP):
 *   GET  /api/reviews/list.php?productId=…    List reviews for a product
 *   POST /api/reviews/submit.php              Submit a new review
 *
 * Reviews are ecommerce-owned (POS does not store them).
 */
import { apiFetch } from "./client";
import { apiDateMs } from "@/lib/dates";

export interface Review {
  id: string;
  posId: string;
  author: string;
  rating: number;
  title: string;
  body: string;
  createdAt: number;
  verifiedPurchase: boolean;
}

export interface ReviewSubmission {
  rating: number;
  title: string;
  body: string;
  author: string;
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export async function fetchProductReviews(productId: string): Promise<{
  reviews: Review[];
  average: number;
  count: number;
  distribution: Record<1 | 2 | 3 | 4 | 5, number>;
}> {
  const res = await apiFetch<ApiResponse<{ items: any[] }>>(
    `/reviews?product_id=${encodeURIComponent(productId)}`,
  );

  const reviews: Review[] = res.data.items.map((r: any) => ({
    id: String(r.id),
    posId: productId,
    author: r.user_name || "Customer",
    rating: Number(r.rating),
    title: "", // Backend doesn't currently store title
    body: r.review_text || "",
    createdAt: apiDateMs(r.created_at),
    verifiedPurchase: true, // Assuming verified for now
  }));

  const count = reviews.length;
  const sum = reviews.reduce((s, r) => s + r.rating, 0);
  const average = count > 0 ? sum / count : 0;

  const distribution: Record<1 | 2 | 3 | 4 | 5, number> = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
  };

  for (const r of reviews) {
    const k = Math.max(1, Math.min(5, Math.round(r.rating))) as 1 | 2 | 3 | 4 | 5;
    distribution[k]++;
  }

  return { reviews, average, count, distribution };
}

export async function submitProductReview(
  productId: string,
  payload: ReviewSubmission,
): Promise<Review> {
  if (payload.rating < 1 || payload.rating > 5) {
    throw new Error("Rating must be between 1 and 5");
  }
  if (!payload.body.trim() || !payload.author.trim()) {
    throw new Error("Author and review text are required");
  }

  const res: any = await apiFetch(`/reviews`, {
    method: "POST",
    body: JSON.stringify({
      product_id: productId,
      rating: payload.rating,
      review_text: payload.body,
    }),
  });

  const responseData = (res && typeof res === "object" && "data" in res) ? res.data : res;

  return {
    id: String(responseData?.id || Date.now()),
    posId: productId,
    author: payload.author,
    rating: payload.rating,
    title: payload.title,
    body: payload.body,
    createdAt: Date.now(),
    verifiedPurchase: false,
  };
}
