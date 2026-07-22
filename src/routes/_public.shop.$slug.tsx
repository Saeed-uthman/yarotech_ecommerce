import { createFileRoute, Link, notFound, useNavigate } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import {
  ArrowLeft,
  ShoppingCart,
  ShieldCheck,
  Truck,
  Headset,
  Star,
  Check,
  Minus,
  Plus,
  MapPin,
  Share2,
} from "lucide-react";
import { fetchMergedProductDetail, type Product } from "@/api/products";
import { fetchProductReviews, submitProductReview, type Review } from "@/api/reviews";
import { DELIVERY_STATES, calculateDeliveryFee } from "@/api/checkout";
import { NGN } from "@/lib/format";
import { StatusBadge } from "@/components/common/StatusBadge";
import { ProductCard } from "@/components/product/ProductCard";
import { JsonLd } from "@/components/seo/JsonLd";
import { canonicalMeta, SITE_URL } from "@/lib/seo";
import { useCartStore } from "@/stores/cart";
import { useAuthStore } from "@/stores/auth";
import { toast } from "sonner";

export const Route = createFileRoute("/_public/shop/$slug")({
  loader: async ({ params }) => {
    const data = await fetchMergedProductDetail(params.slug);
    if (!data) throw notFound();
    return data;
  },
  head: ({ loaderData }) => ({
    meta: loaderData
      ? [
          { title: `${loaderData.product.name} — YAROTECH` },
          { name: "description", content: loaderData.product.shortDescription },
          { property: "og:title", content: loaderData.product.name },
          { property: "og:description", content: loaderData.product.shortDescription },
          { property: "og:image", content: loaderData.product.image },
          { name: "twitter:image", content: loaderData.product.image },
          ...canonicalMeta(`/shop/${loaderData.product.slug}`),
        ]
      : [],
  }),
  component: ProductPage,
  errorComponent: ({ error }) => (
    <div className="mx-auto max-w-md p-10 text-center">
      <p className="text-destructive">{error.message}</p>
      <Link to="/shop" className="mt-4 inline-block text-secondary hover:underline">
        ← Back to Shop
      </Link>
    </div>
  ),
  notFoundComponent: () => (
    <div className="mx-auto max-w-md p-10 text-center">
      <h1 className="font-display text-2xl font-bold">Product not found</h1>
      <Link to="/shop" className="mt-4 inline-block text-secondary hover:underline">
        ← Back to Shop
      </Link>
    </div>
  ),
});

/* =========================================================
 * Helpers
 * ========================================================= */

/* =========================================================
 * Page
 * ========================================================= */

function ProductPage() {
  const { product, related } = Route.useLoaderData();
  const add = useCartStore((s) => s.add);
  const navigate = useNavigate();
  const [activeImg, setActiveImg] = useState(product.image);
  const [qty, setQty] = useState(1);

  useEffect(() => {
    setActiveImg(product.image);
    setQty(1);
  }, [product.id, product.image]);

  const isOut = product.stockStatus === "out_of_stock";

  const handleAdd = () => {
    if (isOut) {
      toast.error("Out of stock", { description: "This product is currently unavailable." });
      return;
    }
    add(
      {
        productId: product.id,
        slug: product.slug,
        name: product.name,
        sku: product.sku,
        price: product.price,
        image: product.image,
      },
      qty,
    );
    toast.success("Product added to cart", { description: `${qty} × ${product.name}` });
  };

  const handleBuyNow = () => {
    if (isOut) {
      toast.error("Out of stock");
      return;
    }
    add(
      {
        productId: product.id,
        slug: product.slug,
        name: product.name,
        sku: product.sku,
        price: product.price,
        image: product.image,
      },
      qty,
    );
    navigate({ to: "/checkout" });
  };

  const handleShare = async () => {
    const url = typeof window !== "undefined" ? window.location.href : "";
    try {
      if (typeof navigator !== "undefined" && navigator.share) {
        await navigator.share({ title: product.name, text: product.shortDescription, url });
      } else {
        await navigator.clipboard.writeText(url);
        toast.success("Product link copied to clipboard");
      }
    } catch {
      /* user dismissed share */
    }
  };

  const stockMap: Record<string, string> = {
    in_stock: "https://schema.org/InStock",
    low_stock: "https://schema.org/LimitedAvailability",
    out_of_stock: "https://schema.org/OutOfStock",
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-6 pb-28 md:pb-8">
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@type": "Product",
          name: product.name,
          image: product.gallery?.length ? product.gallery : [product.image],
          description: product.shortDescription || product.description,
          sku: product.sku,
          brand: { "@type": "Brand", name: "YAROTECH" },
          offers: {
            "@type": "Offer",
            url: `${SITE_URL}/shop/${product.slug}`,
            priceCurrency: "NGN",
            price: product.price,
            availability: stockMap[product.stockStatus] || "https://schema.org/InStock",
            seller: { "@type": "Organization", name: "YAROTECH" },
          },
          aggregateRating:
            product.reviewCount > 0
              ? {
                  "@type": "AggregateRating",
                  ratingValue: product.rating,
                  reviewCount: product.reviewCount,
                }
              : undefined,
        }}
      />
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@type": "BreadcrumbList",
          itemListElement: [
            { "@type": "ListItem", position: 1, name: "Home", item: SITE_URL },
            { "@type": "ListItem", position: 2, name: "Shop", item: `${SITE_URL}/shop` },
            {
              "@type": "ListItem",
              position: 3,
              name: product.category,
              item: `${SITE_URL}/shop?category=${encodeURIComponent(product.category)}`,
            },
            { "@type": "ListItem", position: 4, name: product.name },
          ],
        }}
      />
      {/* Breadcrumb / back */}
      <div className="flex items-center justify-between">
        <Link
          to="/shop"
          className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-primary hover:text-secondary"
        >
          <ArrowLeft className="h-4 w-4" /> Back to Shop
        </Link>
        <button
          type="button"
          onClick={handleShare}
          className="inline-flex items-center gap-1.5 text-xs font-semibold text-muted-foreground hover:text-primary"
          aria-label="Share product"
        >
          <Share2 className="h-3.5 w-3.5" /> Share
        </button>
      </div>

      <nav aria-label="Breadcrumb" className="mt-3 text-xs text-muted-foreground">
        <Link to="/" className="hover:text-primary">
          Home
        </Link>
        <span className="mx-1.5">/</span>
        <Link to="/shop" className="hover:text-primary">
          Shop
        </Link>
        <span className="mx-1.5">/</span>
        <Link to="/shop" search={{ category: product.category }} className="hover:text-primary">
          {product.category}
        </Link>
        <span className="mx-1.5">/</span>
        <span className="text-primary">{product.name}</span>
      </nav>

      <div className="mt-5 grid gap-8 md:grid-cols-2">
        {/* Gallery */}
        <div>
          <div className="relative aspect-[4/3] overflow-hidden rounded-md border border-border bg-muted">
            <img src={activeImg} alt={product.name} className="h-full w-full object-cover" />
            <div className="absolute left-3 top-3 flex flex-wrap gap-1">
              {product.badges.slice(0, 3).map((b: string) => (
                <StatusBadge key={b} variant="navy">
                  {b}
                </StatusBadge>
              ))}
            </div>
          </div>
          {product.gallery.length > 1 && (
            <div className="mt-3 flex gap-2 overflow-x-auto">
              {product.gallery.map((g: string) => (
                <button
                  key={g}
                  type="button"
                  onClick={() => setActiveImg(g)}
                  className={`h-16 w-20 shrink-0 overflow-hidden rounded-sm border-2 ${
                    activeImg === g ? "border-primary" : "border-border"
                  }`}
                >
                  <img src={g} alt="" className="h-full w-full object-cover" />
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Info */}
        <div>
          <div className="flex flex-wrap items-center gap-2">
            <span className="inline-flex items-center rounded-sm bg-primary px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-primary-foreground">
              {product.category}
            </span>
            {product.stockStatus === "in_stock" && (
              <StatusBadge variant="success">In Stock</StatusBadge>
            )}
            {product.stockStatus === "low_stock" && (
              <StatusBadge variant="warning">Only {product.stock} left</StatusBadge>
            )}
            {product.stockStatus === "out_of_stock" && (
              <StatusBadge variant="danger">Out of Stock</StatusBadge>
            )}
            <span className="text-xs text-muted-foreground">SKU: {product.sku}</span>
          </div>

          <h1 className="mt-3 font-display text-3xl font-bold leading-tight text-primary md:text-4xl">
            {product.name}
          </h1>

          <div className="mt-2 flex items-center gap-2 text-sm text-muted-foreground">
            <Stars value={product.rating} />
            <span className="font-semibold text-foreground">{product.rating.toFixed(1)}</span>
            <span>({product.reviewCount} reviews)</span>
          </div>

          <p className="mt-3 text-sm text-muted-foreground">{product.shortDescription}</p>

          {/* Price block */}
          <div className="mt-5 flex items-baseline gap-3">
            <p className="font-display text-3xl font-bold text-secondary">{NGN(product.price)}</p>
            {product.compareAtPrice && (
              <p className="text-sm text-muted-foreground line-through">
                {NGN(product.compareAtPrice)}
              </p>
            )}
          </div>
          <DeliveryEstimator price={product.price} />

          {/* Quantity + actions (Add to Cart + Buy Now ONLY — no Quote per strict rules) */}
          <div className="mt-5 flex items-center gap-3">
            <div className="flex items-center rounded-sm border border-border">
              <button
                type="button"
                onClick={() => setQty((q) => Math.max(1, q - 1))}
                className="flex h-11 w-10 items-center justify-center text-primary"
                aria-label="Decrease"
              >
                <Minus className="h-4 w-4" />
              </button>
              <span className="w-10 text-center text-sm font-bold text-primary">{qty}</span>
              <button
                type="button"
                onClick={() => setQty((q) => Math.min(product.stock || 99, q + 1))}
                disabled={isOut}
                className="flex h-11 w-10 items-center justify-center text-primary disabled:opacity-40"
                aria-label="Increase"
              >
                <Plus className="h-4 w-4" />
              </button>
            </div>
            <button
              type="button"
              onClick={handleAdd}
              disabled={isOut}
              className="inline-flex h-11 flex-1 items-center justify-center gap-2 rounded-sm border border-primary bg-surface text-sm font-bold uppercase tracking-wide text-primary hover:bg-accent disabled:opacity-50"
            >
              <ShoppingCart className="h-4 w-4" /> Add to Cart
            </button>
            <button
              type="button"
              onClick={handleBuyNow}
              disabled={isOut}
              className="inline-flex h-11 flex-1 items-center justify-center rounded-sm bg-secondary text-sm font-bold uppercase tracking-wide text-secondary-foreground hover:opacity-90 disabled:opacity-50"
            >
              Buy Now
            </button>
          </div>
        </div>
      </div>

      {/* Description + Specs */}
      <div className="mt-10 grid gap-6 md:grid-cols-[1fr_1.2fr]">
        <section className="rounded-md border border-border bg-surface p-5">
          <h2 className="font-display text-xl font-bold text-primary">Product description</h2>
          <p className="mt-3 text-sm leading-relaxed text-muted-foreground">
            {product.description}
          </p>
          <ul className="mt-5 space-y-2 text-sm">
            <Bullet>OEM-certified equipment</Bullet>
            <Bullet>Warranty: {product.warranty}</Bullet>
            <Bullet>Secure Paystack checkout</Bullet>
            <Bullet>Nationwide tracked delivery</Bullet>
          </ul>
        </section>

        <SpecificationsPanel specs={product.specs} />
      </div>

      {/* Delivery & Support strip */}
      <section className="mt-6 grid gap-3 rounded-md border border-border bg-surface p-5 md:grid-cols-3">
        <Info
          icon={Truck}
          title="Nationwide delivery"
          body="Tracked shipping to all 36 states. 2–7 business days."
        />
        <Info
          icon={ShieldCheck}
          title={`Warranty: ${product.warranty}`}
          body="Manufacturer-backed, registered to your YAROTECH account."
        />
        <Info
          icon={Headset}
          title="Professional support"
          body="Talk to certified engineers via the Contact page."
        />
      </section>

      {/* Reviews */}
      <ReviewsSection productId={product.posId} />

      {/* Related */}
      {related.length > 0 && (
        <section className="mt-12">
          <h2 className="font-display text-2xl font-bold text-primary">Related products</h2>
          <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {related.slice(0, 4).map((r: any) => (
              <ProductCard key={(r as { id: string }).id} product={r} />
            ))}
          </div>
        </section>
      )}

      {/* Sticky mobile action bar */}
      <div className="fixed inset-x-0 bottom-16 z-30 border-t border-border bg-surface/95 px-4 py-3 backdrop-blur md:hidden">
        <div className="flex items-center gap-3">
          <div>
            <p className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
              Total
            </p>
            <p className="font-display text-lg font-bold text-secondary">
              {NGN(product.price * qty)}
            </p>
          </div>
          <button
            type="button"
            onClick={handleBuyNow}
            disabled={isOut}
            className="ml-auto inline-flex h-11 flex-1 items-center justify-center rounded-sm bg-secondary text-xs font-bold uppercase tracking-wide text-secondary-foreground hover:opacity-90 disabled:opacity-50"
          >
            Buy Now
          </button>
          <button
            type="button"
            onClick={handleAdd}
            disabled={isOut}
            className="inline-flex h-11 items-center justify-center rounded-sm border border-primary bg-surface px-3 text-primary disabled:opacity-50"
            aria-label="Add to cart"
          >
            <ShoppingCart className="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
  );
}

/* =========================================================
 * Delivery estimator (replaces removed "Calculate delivery" link with
 * an inline picker that shows expected zone fee + ETA before checkout)
 * ========================================================= */

function DeliveryEstimator({ price }: { price: number }) {
  const [open, setOpen] = useState(false);
  const [state, setState] = useState("Lagos");

  const estimate = useMemo(() => calculateDeliveryFee("delivery", state), [state]);
  const vat = +(price * 0.075).toFixed(2);

  return (
    <div className="mt-2">
      <p className="text-xs text-muted-foreground">
        Excludes VAT &amp; shipping.{" "}
        <button
          type="button"
          onClick={() => setOpen((o) => !o)}
          className="font-semibold text-secondary underline-offset-2 hover:underline"
        >
          {open ? "Hide delivery" : "Calculate delivery"}
        </button>
      </p>
      {open && (
        <div className="mt-2 rounded-sm border border-border bg-accent/30 p-3 text-xs">
          <div className="flex items-center gap-2">
            <MapPin className="h-3.5 w-3.5 text-primary" />
            <label className="font-semibold text-primary">Deliver to</label>
            <select
              value={state}
              onChange={(e) => setState(e.target.value)}
              className="h-7 rounded-sm border border-border bg-surface px-2 text-xs focus:border-primary focus:outline-none"
            >
              {DELIVERY_STATES.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
            <span className="text-muted-foreground">· {estimate.eta}</span>
          </div>
          <div className="mt-2 grid grid-cols-3 gap-2 border-t border-border pt-2 text-[11px]">
            <div>
              <p className="text-muted-foreground">Delivery</p>
              <p className="font-semibold text-primary">{NGN(estimate.fee)}</p>
            </div>
            <div>
              <p className="text-muted-foreground">VAT (7.5%)</p>
              <p className="font-semibold text-primary">{NGN(vat)}</p>
            </div>
            <div>
              <p className="text-muted-foreground">Total est.</p>
              <p className="font-bold text-secondary">{NGN(price + vat + estimate.fee)}</p>
            </div>
          </div>
          <p className="mt-2 text-[10px] text-muted-foreground">
            Final fee verified at checkout based on zone &amp; weight.
          </p>
        </div>
      )}
    </div>
  );
}

/* =========================================================
 * Sub-components
 * ========================================================= */

/**
 * SpecificationsPanel
 * Shows the admin-curated spec list that was set on the product via the
 * admin "Specs" tab. If the admin has not added any specs the panel renders
 * a tasteful empty state so the layout is never broken.
 */
function SpecificationsPanel({ specs }: { specs: { label: string; value: string }[] }) {
  if (!specs || specs.length === 0) {
    return (
      <section className="relative overflow-hidden rounded-md border border-dashed border-border bg-surface p-5">
        <h2 className="font-display text-xl font-bold text-primary">Specifications</h2>
        <p className="mt-3 text-sm text-muted-foreground">
          No specifications have been added for this product yet.
        </p>
      </section>
    );
  }

  return (
    <section
      className="relative overflow-hidden rounded-md border border-border bg-surface p-5"
      style={{
        backgroundImage: "radial-gradient(circle, rgba(10,23,51,0.06) 1px, transparent 1px)",
        backgroundSize: "14px 14px",
      }}
    >
      <h2 className="font-display text-xl font-bold text-primary">Specifications</h2>
      <div className="mt-3 overflow-hidden rounded-sm border border-border bg-surface">
        <table className="w-full text-sm">
          <tbody>
            {specs.map((s, i) => (
              <tr key={s.label} className={i % 2 === 1 ? "bg-muted/40" : ""}>
                <td className="w-1/2 px-4 py-2.5 text-muted-foreground">{s.label}</td>
                <td className="px-4 py-2.5 font-semibold text-primary">{s.value}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}

function Stars({ value, size = 14 }: { value: number; size?: number }) {
  return (
    <div className="flex">
      {[1, 2, 3, 4, 5].map((i) => (
        <Star
          key={i}
          width={size}
          height={size}
          className={i <= Math.round(value) ? "fill-secondary text-secondary" : "text-muted"}
        />
      ))}
    </div>
  );
}

function Bullet({ children }: { children: React.ReactNode }) {
  return (
    <li className="flex items-start gap-2 text-muted-foreground">
      <Check className="mt-0.5 h-4 w-4 shrink-0 text-success" />
      <span>{children}</span>
    </li>
  );
}

function Info({
  icon: Icon,
  title,
  body,
}: {
  icon: React.ComponentType<{ className?: string }>;
  title: string;
  body: string;
}) {
  return (
    <div className="flex items-start gap-3">
      <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-sm bg-accent text-primary">
        <Icon className="h-4 w-4" />
      </div>
      <div>
        <p className="text-sm font-bold text-primary">{title}</p>
        <p className="text-xs text-muted-foreground">{body}</p>
      </div>
    </div>
  );
}

function ReviewsSection({ productId }: { productId: string }) {
  const isAuth = useAuthStore((s) => s.isAuthenticated);
  const user = useAuthStore((s) => s.user);
  const [reviews, setReviews] = useState<Review[] | null>(null);
  const [average, setAverage] = useState(0);
  const [count, setCount] = useState(0);
  const [busy, setBusy] = useState(false);
  const [form, setForm] = useState({ rating: 5, title: "", body: "", author: "" });

  const load = () => {
    fetchProductReviews(productId).then((r) => {
      setReviews(r.reviews);
      setAverage(r.average);
      setCount(r.count);
    });
  };

  useEffect(() => {
    setReviews(null);
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [productId]);

  // Star distribution
  const distribution = useMemo(() => {
    const buckets = [0, 0, 0, 0, 0];
    if (!reviews) return buckets;
    for (const r of reviews) {
      const idx = Math.max(1, Math.min(5, Math.round(r.rating))) - 1;
      buckets[idx] += 1;
    }
    return buckets;
  }, [reviews]);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!isAuth) {
      toast.error("Please login to continue.");
      return;
    }
    setBusy(true);
    try {
      await submitProductReview(productId, {
        ...form,
        author: form.author || user?.fullName || "Customer",
      });
      toast.success("Review submitted. Thanks!");
      setForm({ rating: 5, title: "", body: "", author: "" });
      load();
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Could not submit review");
    } finally {
      setBusy(false);
    }
  };

  return (
    <section className="mt-12">
      <div className="grid gap-4 rounded-md border border-border bg-surface p-5 md:grid-cols-[260px_1fr] md:items-center">
        <div className="text-center md:text-left">
          <h2 className="font-display text-2xl font-bold text-primary">Customer reviews</h2>
          <div className="mt-2 flex items-center gap-2 md:justify-start">
            <Stars value={average} size={18} />
            <span className="font-display text-2xl font-bold text-primary">
              {average.toFixed(1)}
            </span>
          </div>
          <p className="mt-1 text-xs text-muted-foreground">Based on {count} verified reviews</p>
        </div>
        <div className="space-y-1.5">
          {[5, 4, 3, 2, 1].map((star) => {
            const c = distribution[star - 1] ?? 0;
            const pct = count > 0 ? (c / count) * 100 : 0;
            return (
              <div key={star} className="flex items-center gap-2 text-xs">
                <span className="w-6 font-semibold text-primary">{star}★</span>
                <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-muted">
                  <div className="h-full bg-secondary" style={{ width: `${pct}%` }} />
                </div>
                <span className="w-6 text-right text-muted-foreground">{c}</span>
              </div>
            );
          })}
        </div>
      </div>

      <div className="mt-5 grid gap-6 md:grid-cols-[1fr_1.2fr]">
        {/* Write Review */}
        <form onSubmit={onSubmit} className="rounded-md border border-border bg-surface p-5">
          <h3 className="font-display text-lg font-bold text-primary">Write a review</h3>
          {!isAuth && (
            <p className="mt-1 text-xs text-muted-foreground">
              You'll need to{" "}
              <Link to="/login" className="font-semibold text-primary hover:underline">
                sign in
              </Link>{" "}
              to publish your review.
            </p>
          )}
          <div className="mt-4 space-y-3">
            <div>
              <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Your rating
              </label>
              <div className="mt-1 flex gap-1">
                {[1, 2, 3, 4, 5].map((n) => (
                  <button
                    key={n}
                    type="button"
                    onClick={() => setForm((f) => ({ ...f, rating: n }))}
                    aria-label={`${n} stars`}
                  >
                    <Star
                      className={`h-6 w-6 ${
                        n <= form.rating ? "fill-secondary text-secondary" : "text-muted"
                      }`}
                    />
                  </button>
                ))}
              </div>
            </div>
            <div>
              <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Display name
              </label>
              <input
                value={form.author || user?.fullName || ""}
                onChange={(e) => setForm((f) => ({ ...f, author: e.target.value }))}
                className="mt-1 h-10 w-full rounded-sm border border-border bg-background px-3 text-sm focus:border-primary focus:outline-none"
                placeholder="How should we credit you?"
              />
            </div>
            <div>
              <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Title
              </label>
              <input
                required
                value={form.title}
                onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))}
                className="mt-1 h-10 w-full rounded-sm border border-border bg-background px-3 text-sm focus:border-primary focus:outline-none"
                placeholder="Sums up your experience"
              />
            </div>
            <div>
              <label className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">
                Your review
              </label>
              <textarea
                required
                rows={4}
                value={form.body}
                onChange={(e) => setForm((f) => ({ ...f, body: e.target.value }))}
                className="mt-1 w-full rounded-sm border border-background px-3 py-2 text-sm focus:border-primary focus:outline-none"
                placeholder="Share details about how the product worked for you."
              />
            </div>
            <button
              type="submit"
              disabled={busy}
              className="inline-flex h-11 items-center rounded-sm bg-secondary px-5 text-sm font-bold uppercase tracking-wide text-secondary-foreground hover:opacity-90 disabled:opacity-60"
            >
              {busy ? "Submitting…" : "Submit review"}
            </button>
          </div>
        </form>

        {/* Reviews list */}
        <div className="space-y-3">
          {reviews === null ? (
            <p className="text-sm text-muted-foreground">Loading reviews…</p>
          ) : reviews.length === 0 ? (
            <div className="rounded-md border border-dashed border-border bg-surface p-6 text-center text-sm text-muted-foreground">
              No reviews yet — be the first to write one.
            </div>
          ) : (
            reviews.map((r) => (
              <article key={r.id} className="rounded-md border border-border bg-surface p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Stars value={r.rating} />
                    <span className="text-xs font-semibold text-primary">{r.title}</span>
                  </div>
                  {r.verifiedPurchase && <StatusBadge variant="success">Verified</StatusBadge>}
                </div>
                <p className="mt-2 text-sm text-muted-foreground">{r.body}</p>
                <p className="mt-2 text-[10px] uppercase tracking-widest text-muted-foreground">
                  {r.author} · {new Date(r.createdAt).toLocaleDateString()}
                </p>
              </article>
            ))
          )}
        </div>
      </div>
    </section>
  );
}
