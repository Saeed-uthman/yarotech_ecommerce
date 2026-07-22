/**
 * Products service.
 *
 * Products are now owned directly by the YAROTECH backend. The API
 * still returns compatibility keys (`product_id`) so existing UI
 * modules remain stable during migration.
 */
import { apiFetch, ASSET_BASE_URL } from "./client";

export type ProductCategory = string;
export type StockStatus = "in_stock" | "low_stock" | "out_of_stock";

export interface Product {
  id: string;
  posId: string;
  sku: string;
  name: string;
  category: ProductCategory;
  price: number;
  stock: number;
  stockStatus: StockStatus;
  status: "active" | "draft";
  slug: string;
  shortDescription: string;
  description: string;
  warranty: string;
  featured: boolean;
  visible: boolean;
  image: string;
  gallery: string[];
  badges: string[];
  specs: { label: string; value: string }[];
  relatedSlugs: string[];
  rating: number;
  reviewCount: number;
  compareAtPrice?: number;
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

// Map the backend product response to the frontend Product type
function mapBackendProduct(bp: any): Product {
  const image = bp.primary_image
    ? bp.primary_image.startsWith("http")
      ? bp.primary_image
      : `${ASSET_BASE_URL}${bp.primary_image}`
    : "";
  const gallery = bp.images
    ? bp.images.map((img: any) =>
        img.image_path.startsWith("http") ? img.image_path : `${ASSET_BASE_URL}${img.image_path}`,
      )
    : image
      ? [image]
      : [];
  const productId = bp.product_id || bp.product_id;
  const sellingPrice = Number(bp.selling_price ?? bp.price ?? 0);
  const normalizedStatus: "active" | "draft" = bp.status === "active" ? "active" : "draft";

  return {
    id: productId,
    posId: productId,
    sku: bp.sku,
    name: bp.name,
    category: bp.category,
    price: sellingPrice,
    stock: Number(bp.stock_quantity ?? 0),
    stockStatus: bp.stock_status,
    status: normalizedStatus,
    slug: bp.slug,
    shortDescription: bp.short_description || "",
    description: bp.full_description || "",
    warranty: bp.warranty_info || "",
    featured: bp.is_featured,
    visible: bp.is_visible_online ?? true,
    image,
    gallery,
    badges: bp.is_featured ? ["Featured"] : [],
    specs: bp.specifications
      ? bp.specifications.map((s: any) => ({ label: s.spec_name, value: s.spec_value }))
      : [],
    relatedSlugs: bp.related_products ? bp.related_products.map((r: any) => r.slug) : [],
    rating: bp.rating_average || 0,
    reviewCount: bp.review_count || 0,
  };
}

export interface ListParams {
  category?: string;
  q?: string;
  featured?: boolean;
  stock?: "all" | "in_stock" | "low_stock" | "out_of_stock";
  sort?: "featured" | "price_asc" | "price_desc" | "rating_desc" | "newest";
  page?: number;
  perPage?: number;
}

export interface ListResult {
  items: Product[];
  total: number;
  page: number;
  perPage: number;
  pageCount: number;
}

export async function fetchMergedProducts(params: ListParams = {}): Promise<ListResult> {
  const query = new URLSearchParams();
  if (params.category && params.category !== "All") query.set("category", params.category);
  if (params.q) query.set("search", params.q);
  if (params.stock && params.stock !== "all") query.set("stock_status", params.stock);
  // Sort: pass through as-is (backend supports all ListParams sort values)
  const sort = params.sort;
  if (sort) query.set("sort", sort);
  if (params.page) query.set("page", params.page.toString());
  if (params.perPage) query.set("per_page", params.perPage.toString());

  const res = await apiFetch<ApiResponse<{ items: any[]; pagination: any }>>(
    `/products?${query.toString()}`,
  );

  let items = res.data.items.map(mapBackendProduct);

  // Client-side filtering for 'featured' if requested (backend doesn't explicitly filter by featured in publicList)
  if (params.featured) {
    items = items.filter((p) => p.featured);
  }

  return {
    items,
    total: res.data.pagination.total,
    page: res.data.pagination.page,
    perPage: res.data.pagination.per_page,
    pageCount: res.data.pagination.total_pages,
  };
}

export async function fetchMergedProductDetail(
  slug: string,
): Promise<{ product: Product; related: Product[] } | null> {
  try {
    const res = await apiFetch<ApiResponse<any>>(`/products/${slug}`);
    const bp = res.data;
    const product = mapBackendProduct(bp);
    const related = bp.related_products ? bp.related_products.map(mapBackendProduct) : [];
    return { product, related };
  } catch (err: any) {
    if (err.status === 404) return null;
    throw err;
  }
}

export async function listProducts(
  params?: Pick<ListParams, "category" | "q" | "featured">,
): Promise<Product[]> {
  const res = await fetchMergedProducts({ ...params, perPage: 100 });
  return res.items;
}

export async function getProductBySlug(slug: string): Promise<Product | null> {
  const res = await fetchMergedProductDetail(slug);
  return res?.product ?? null;
}

export async function listCategories(): Promise<ProductCategory[]> {
  const res = await apiFetch<ApiResponse<{ items: string[] }>>(`/categories`);
  return res.data.items;
}
