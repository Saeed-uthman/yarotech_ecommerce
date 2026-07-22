import { Link } from "@tanstack/react-router";
import { ShoppingCart, Eye, Star } from "lucide-react";
import type { Product } from "@/api/products";
import { NGN } from "@/lib/format";
import { StatusBadge } from "@/components/common/StatusBadge";
import { useCartStore } from "@/stores/cart";
import { toast } from "sonner";

export function ProductCard({ product }: { product: Product }) {
  const add = useCartStore((s) => s.add);

  const handleAdd = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (product.stockStatus === "out_of_stock") return;
    add({
      productId: product.id,
      slug: product.slug,
      name: product.name,
      sku: product.sku,
      price: product.price,
      image: product.image,
    });
    toast.success("Added to cart", { description: product.name });
  };

  return (
    <article className="group flex flex-col overflow-hidden rounded-md border border-border bg-surface transition-shadow hover:shadow-md">
      <Link
        to="/shop/$slug"
        params={{ slug: product.slug }}
        className="relative block aspect-[4/3] overflow-hidden bg-muted"
      >
        <img
          src={product.image}
          alt={product.name}
          loading="lazy"
          className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-[1.04]"
        />
        <span className="absolute left-2 top-2 inline-flex items-center rounded-sm bg-primary px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-primary-foreground">
          {product.category}
        </span>
        <span className="absolute right-2 top-2">
          {product.stockStatus === "in_stock" && (
            <StatusBadge variant="success">In Stock</StatusBadge>
          )}
          {product.stockStatus === "low_stock" && (
            <StatusBadge variant="warning">Low Stock</StatusBadge>
          )}
          {product.stockStatus === "out_of_stock" && (
            <StatusBadge variant="danger">Out of Stock</StatusBadge>
          )}
        </span>
      </Link>

      <div className="flex flex-1 flex-col gap-2 border-t border-border p-3">
        <Link
          to="/shop/$slug"
          params={{ slug: product.slug }}
          className="line-clamp-2 text-sm font-semibold text-primary hover:text-secondary"
        >
          {product.name}
        </Link>
        <p className="line-clamp-2 text-xs text-muted-foreground">{product.shortDescription}</p>

        <div className="flex items-center gap-1 text-xs text-muted-foreground">
          <Star className="h-3 w-3 fill-secondary text-secondary" />
          <span className="font-semibold text-foreground">{product.rating.toFixed(1)}</span>
          <span>({product.reviewCount})</span>
        </div>

        <div className="mt-1 flex items-baseline gap-2">
          <p className="font-display text-lg font-bold text-primary">{NGN(product.price)}</p>
          {product.compareAtPrice && (
            <p className="text-xs text-muted-foreground line-through">
              {NGN(product.compareAtPrice)}
            </p>
          )}
        </div>

        <div className="mt-2 grid grid-cols-2 gap-2">
          <button
            type="button"
            onClick={handleAdd}
            disabled={product.stockStatus === "out_of_stock"}
            className="inline-flex h-9 items-center justify-center gap-1.5 rounded-sm bg-secondary text-xs font-bold uppercase tracking-wide text-secondary-foreground transition-opacity hover:opacity-90 disabled:opacity-50"
          >
            <ShoppingCart className="h-3.5 w-3.5" /> Add
          </button>
          <Link
            to="/shop/$slug"
            params={{ slug: product.slug }}
            className="inline-flex h-9 items-center justify-center gap-1.5 rounded-sm border border-border bg-surface text-xs font-bold uppercase tracking-wide text-primary hover:bg-accent"
          >
            <Eye className="h-3.5 w-3.5" /> Details
          </Link>
        </div>
      </div>
    </article>
  );
}
