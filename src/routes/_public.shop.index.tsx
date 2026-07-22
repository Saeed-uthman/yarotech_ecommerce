import { createFileRoute, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Search, ChevronLeft, ChevronRight, SlidersHorizontal } from "lucide-react";
import { fetchMergedProducts, type ListResult, type ListParams } from "@/api/products";
import { ProductCard } from "@/components/product/ProductCard";
import { PageHeader } from "@/components/common/PageHeader";
import { EmptyState, LoadingState } from "@/components/common/EmptyState";
import { canonicalMeta } from "@/lib/seo";

const CATEGORIES = [
  "All",
  "Solar Products",
  "Inverters",
  "Batteries",
  "CCTV Cameras",
  "Networking Devices",
  "IT Equipment",
] as const;

const STOCK_OPTIONS = [
  { value: "all", label: "All stock" },
  { value: "in_stock", label: "In stock" },
  { value: "low_stock", label: "Low stock" },
  { value: "out_of_stock", label: "Out of stock" },
] as const;

const SORT_OPTIONS = [
  { value: "featured", label: "Featured" },
  { value: "newest", label: "Newest" },
  { value: "price_asc", label: "Price: Low to High" },
  { value: "price_desc", label: "Price: High to Low" },
  { value: "rating_desc", label: "Top Rated" },
] as const;

interface ShopSearch {
  category?: string;
  q?: string;
  stock?: ListParams["stock"];
  sort?: ListParams["sort"];
  page?: number;
}

export const Route = createFileRoute("/_public/shop/")({
  head: () => ({
    meta: [
      { title: "Shop Technology Products — YAROTECH" },
      {
        name: "description",
        content:
          "Browse solar products, security devices, networking equipment, power systems, and IT accessories. Verified stock, secure checkout, nationwide delivery.",
      },
      { property: "og:title", content: "Shop — YAROTECH" },
      {
        property: "og:description",
        content:
          "Browse solar products, security devices, networking equipment, power systems, and IT accessories.",
      },
      ...canonicalMeta("/shop"),
    ],
  }),
  validateSearch: (s: Record<string, unknown>): ShopSearch => {
    const stock = s.stock;
    const sort = s.sort;
    return {
      category: typeof s.category === "string" ? s.category : undefined,
      q: typeof s.q === "string" && s.q ? s.q : undefined,
      stock:
        typeof stock === "string" &&
        ["in_stock", "low_stock", "out_of_stock", "all"].includes(stock)
          ? (stock as ShopSearch["stock"])
          : undefined,
      sort:
        typeof sort === "string" &&
        ["featured", "price_asc", "price_desc", "rating_desc", "newest"].includes(sort)
          ? (sort as ShopSearch["sort"])
          : undefined,
      page:
        typeof s.page === "number"
          ? s.page
          : typeof s.page === "string"
            ? Number(s.page) || undefined
            : undefined,
    };
  },
  component: ShopPage,
});

function ShopPage() {
  const search = Route.useSearch();
  const navigate = Route.useNavigate();
  const [result, setResult] = useState<ListResult | null>(null);
  const [searchInput, setSearchInput] = useState(search.q ?? "");

  // Sync local input when URL param changes externally
  useEffect(() => {
    setSearchInput(search.q ?? "");
  }, [search.q]);

  // Debounced search
  useEffect(() => {
    const t = setTimeout(() => {
      if ((searchInput || undefined) !== search.q) {
        navigate({
          search: (prev: ShopSearch) => ({
            ...prev,
            q: searchInput || undefined,
            page: 1,
          }),
          replace: true,
        });
      }
    }, 300);
    return () => clearTimeout(t);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchInput]);

  useEffect(() => {
    setResult(null);
    fetchMergedProducts({
      category: search.category,
      q: search.q,
      stock: search.stock,
      sort: search.sort,
      page: search.page ?? 1,
      perPage: 12,
    }).then(setResult);
  }, [search.category, search.q, search.stock, search.sort, search.page]);

  const setParam = <K extends keyof ShopSearch>(key: K, value: ShopSearch[K]) => {
    navigate({
      search: (prev: ShopSearch) => ({ ...prev, [key]: value, page: 1 }),
      replace: true,
    });
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-8">
      <PageHeader
        eyebrow="Shop"
        title="Shop Technology Products"
        description="Browse solar products, security devices, networking equipment, power systems, and IT accessories."
      />

      {/* Toolbar */}
      <div className="mt-6 flex flex-col gap-3 rounded-md border border-border bg-surface p-3 md:flex-row md:items-center md:justify-between">
        <div className="relative w-full md:max-w-sm">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <input
            type="search"
            value={searchInput}
            placeholder="Search products, SKU or category…"
            onChange={(e) => setSearchInput(e.target.value)}
            className="h-10 w-full rounded-sm border border-border bg-background pl-9 pr-3 text-sm focus:border-primary focus:outline-none"
          />
        </div>
        <div className="flex flex-wrap gap-2">
          <label className="flex items-center gap-2 rounded-sm border border-border bg-background px-2 text-xs">
            <SlidersHorizontal className="h-3.5 w-3.5 text-muted-foreground" />
            <select
              value={search.stock ?? "all"}
              onChange={(e) =>
                setParam(
                  "stock",
                  e.target.value === "all" ? undefined : (e.target.value as ShopSearch["stock"]),
                )
              }
              className="h-10 cursor-pointer bg-transparent text-xs font-semibold text-primary focus:outline-none"
              aria-label="Stock filter"
            >
              {STOCK_OPTIONS.map((o) => (
                <option key={o.value} value={o.value}>
                  {o.label}
                </option>
              ))}
            </select>
          </label>
          <select
            value={search.sort ?? "featured"}
            onChange={(e) => setParam("sort", e.target.value as ShopSearch["sort"])}
            className="h-10 cursor-pointer rounded-sm border border-border bg-background px-3 text-xs font-semibold text-primary focus:outline-none"
            aria-label="Sort"
          >
            {SORT_OPTIONS.map((o) => (
              <option key={o.value} value={o.value}>
                Sort: {o.label}
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* Category chips */}
      <div className="mt-4 flex flex-wrap gap-2">
        {CATEGORIES.map((c) => {
          const active = (search.category ?? "All") === c;
          return (
            <button
              key={c}
              type="button"
              onClick={() => setParam("category", c === "All" ? undefined : c)}
              className={`rounded-sm border px-3 py-1.5 text-xs font-bold uppercase tracking-wider transition-colors ${
                active
                  ? "border-primary bg-primary text-primary-foreground"
                  : "border-border bg-surface text-muted-foreground hover:bg-accent hover:text-primary"
              }`}
            >
              {c}
            </button>
          );
        })}
      </div>

      {/* Results meta */}
      {result && (
        <div className="mt-6 flex items-center justify-between text-xs text-muted-foreground">
          <p>
            Showing <span className="font-semibold text-foreground">{result.items.length}</span> of{" "}
            <span className="font-semibold text-foreground">{result.total}</span> products
          </p>
          <p>
            Page {result.page} of {result.pageCount}
          </p>
        </div>
      )}

      {/* Grid */}
      <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {result === null ? (
          <div className="col-span-full">
            <LoadingState label="Loading products…" />
          </div>
        ) : result.items.length === 0 ? (
          <div className="col-span-full">
            <EmptyState
              title="No products found"
              description="Try adjusting filters or clearing your search."
              action={
                <Link
                  to="/shop"
                  className="inline-flex h-10 items-center rounded-sm border border-border bg-surface px-4 text-xs font-bold uppercase tracking-wider text-primary hover:bg-accent"
                >
                  Reset filters
                </Link>
              }
            />
          </div>
        ) : (
          result.items.map((p) => <ProductCard key={p.id} product={p} />)
        )}
      </div>

      {/* Pagination */}
      {result && result.pageCount > 1 && (
        <Pagination
          page={result.page}
          pageCount={result.pageCount}
          onChange={(p) => setParam("page", p)}
        />
      )}
    </div>
  );
}

function Pagination({
  page,
  pageCount,
  onChange,
}: {
  page: number;
  pageCount: number;
  onChange: (p: number) => void;
}) {
  // Compact range with first/last
  const pages: (number | "…")[] = [];
  for (let i = 1; i <= pageCount; i++) {
    if (i === 1 || i === pageCount || Math.abs(i - page) <= 1) pages.push(i);
    else if (pages[pages.length - 1] !== "…") pages.push("…");
  }

  return (
    <nav className="mt-8 flex items-center justify-center gap-1">
      <button
        onClick={() => onChange(Math.max(1, page - 1))}
        disabled={page === 1}
        className="flex h-9 items-center gap-1 rounded-sm border border-border bg-surface px-3 text-xs font-semibold text-primary hover:bg-accent disabled:opacity-40"
      >
        <ChevronLeft className="h-3.5 w-3.5" /> Prev
      </button>
      {pages.map((p, i) =>
        p === "…" ? (
          <span key={`e${i}`} className="px-2 text-xs text-muted-foreground">
            …
          </span>
        ) : (
          <button
            key={p}
            onClick={() => onChange(p)}
            className={`h-9 w-9 rounded-sm border text-xs font-bold ${
              p === page
                ? "border-primary bg-primary text-primary-foreground"
                : "border-border bg-surface text-primary hover:bg-accent"
            }`}
          >
            {p}
          </button>
        ),
      )}
      <button
        onClick={() => onChange(Math.min(pageCount, page + 1))}
        disabled={page === pageCount}
        className="flex h-9 items-center gap-1 rounded-sm border border-border bg-surface px-3 text-xs font-semibold text-primary hover:bg-accent disabled:opacity-40"
      >
        Next <ChevronRight className="h-3.5 w-3.5" />
      </button>
    </nav>
  );
}
