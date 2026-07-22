<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Product;
use App\Models\ProductImage;
use App\Models\ProductRelated;
use App\Models\ProductReview;
use App\Models\ProductSpecification;

/**
 * ProductService provides listing and detail views for products.
 * Fully standalone, decoupled from POS.
 */
final class ProductService
{
    private Product $productModel;
    private ProductImage $imageModel;
    private ProductSpecification $specModel;
    private ProductReview $reviewModel;
    private ProductRelated $relatedModel;

    public function __construct(
        ?Product $productModel = null,
        ?ProductImage $imageModel = null,
        ?ProductSpecification $specModel = null,
        ?ProductReview $reviewModel = null,
        ?ProductRelated $relatedModel = null
    ) {
        $this->productModel = $productModel ?? new Product();
        $this->imageModel = $imageModel ?? new ProductImage();
        $this->specModel = $specModel ?? new ProductSpecification();
        $this->reviewModel = $reviewModel ?? new ProductReview();
        $this->relatedModel = $relatedModel ?? new ProductRelated();
    }

    // -----------------------------------------------------------------
    // Public listing - filtered + paginated
    // -----------------------------------------------------------------
    public function publicList(array $params): array
    {
        $products = $this->productModel->listAll();
        
        $ids = array_column($products, 'id');
        $primaryMap  = $this->imageModel->primaryMap($ids);
        $statsMap    = $this->reviewModel->statsMap($ids);

        $merged = [];
        foreach ($products as $p) {
            if (strtolower((string) ($p['status'] ?? 'active')) !== 'active') {
                continue;
            }
            if (!(bool) ($p['is_visible_online'] ?? true)) {
                continue;
            }

            $merged[] = $this->buildSummary($p, $primaryMap, $statsMap);
        }

        $merged = $this->applyFilters($merged, $params);
        $merged = $this->applySort($merged, $params['sort'] ?? 'newest');

        $page    = max(1, (int) ($params['page'] ?? 1));
        $perPage = min(60, max(1, (int) ($params['per_page'] ?? 12)));
        $total   = count($merged);
        $items   = array_slice($merged, ($page - 1) * $perPage, $perPage);

        return [
            'items'      => array_values($items),
            'pagination' => [
                'page'        => $page,
                'per_page'    => $perPage,
                'total'       => $total,
                'total_pages' => (int) ceil($total / $perPage),
            ],
        ];
    }

    // -----------------------------------------------------------------
    // Admin listing - every internal product, including hidden/draft
    // -----------------------------------------------------------------
    public function adminList(array $params): array
    {
        $products    = $this->productModel->listAll();
        $ids         = array_column($products, 'id');
        $primaryMap  = $this->imageModel->primaryMap($ids);
        $statsMap    = $this->reviewModel->statsMap($ids);

        $merged = [];
        foreach ($products as $p) {
            $row  = $this->buildSummary($p, $primaryMap, $statsMap);

            $row['is_visible_online'] = (bool) ($p['is_visible_online'] ?? true);
            $row['visible'] = $row['is_visible_online'];
            $row['is_featured'] = (bool) ($p['is_featured'] ?? false);
            $row['featured'] = $row['is_featured'];
            $row['warranty'] = (string) ($p['warranty_info'] ?? '');
            $row['description'] = (string) ($p['full_description'] ?? '');
            $row['image_url'] = $row['primary_image'] ?? '';
            $row['pos_status'] = (string) ($p['status'] ?? 'active');
            $row['specs_count'] = count($this->specModel->listFor((string) $p['id']));

            $merged[] = $row;
        }

        $merged = $this->applyFilters($merged, $params);

        return ['items' => $merged, 'total' => count($merged)];
    }

    // -----------------------------------------------------------------
    // Detail
    // -----------------------------------------------------------------
    public function detailBySlug(string $slug): ?array
    {
        $p = $this->productModel->findBySlug($slug);
        if (!$p) return null;
        if (!(bool) ($p['is_visible_online'] ?? true)) return null;
        if (strtolower((string) ($p['status'] ?? 'active')) !== 'active') return null;
        
        return $this->buildDetail($p);
    }

    public function detailById(string $id): ?array
    {
        $p = $this->productModel->find($id);
        if (!$p) return null;
        return $this->buildDetail($p);
    }
    
    // Fallback for old callers (optional, but good to keep signature)
    public function detailByPosId(string $id): ?array
    {
        return $this->detailById($id);
    }

    // -----------------------------------------------------------------
    // Builders
    // -----------------------------------------------------------------
    private function buildSummary(array $p, array $primaryMap, array $statsMap): array
    {
        $id = (string) ($p['id'] ?? '');
        $stats = $statsMap[$id] ?? ['average' => 0.0, 'count' => 0];
        $minStock = (int) ($p['minimum_stock'] ?? 5);
        $qty = (int) ($p['stock_quantity'] ?? 0);

        return [
            'product_id'        => $id,
            // Keep product_id temporarily in output to avoid breaking frontend immediately
            'product_id'    => $id,
            'name'              => (string) ($p['name'] ?? ''),
            'sku'               => (string) ($p['sku'] ?? ''),
            'category'          => (string) ($p['category'] ?? ''),
            'price'             => (float) ($p['selling_price'] ?? 0),
            'selling_price'     => (float) ($p['selling_price'] ?? 0),
            'cost_price'        => (float) ($p['cost_price'] ?? 0),
            'stock_quantity'    => $qty,
            'minimum_stock'     => $minStock,
            'stock_status'      => $this->stockStatus($qty, $minStock),
            'status'            => (string) ($p['status'] ?? 'active'),
            'slug'              => (string) ($p['slug'] ?? ''),
            'short_description' => (string) ($p['short_description'] ?? ''),
            'primary_image'     => $primaryMap[$id] ?? '',
            'is_featured'       => (bool) ($p['is_featured'] ?? false),
            'is_visible_online' => (bool) ($p['is_visible_online'] ?? true),
            'rating_average'    => $stats['average'],
            'review_count'      => $stats['count'],
            'createdAt'         => (string) ($p['created_at'] ?? ''),
            'updatedAt'         => (string) ($p['updated_at'] ?? ''),
        ];
    }

    private function buildDetail(array $p): array
    {
        $id = (string) ($p['id'] ?? '');
        $images = array_map(
            fn($img) => [
                'id'         => (int) $img['id'],
                'image_path' => $img['image_path'],
                'alt_text'   => $img['alt_text'],
                'is_primary' => (bool) $img['is_primary'],
            ],
            $this->imageModel->listFor($id)
        );
        $specs = array_map(
            fn($s) => [
                'spec_name'  => $s['spec_name'],
                'spec_value' => $s['spec_value'],
                'spec_group' => $s['spec_group'],
            ],
            $this->specModel->listFor($id)
        );
        $reviews = array_map(
            fn($r) => [
                'id'          => (int) $r['id'],
                'user_name'   => $r['user_name'] ?? 'Customer',
                'rating'      => (int) $r['rating'],
                'review_text' => $r['review_text'],
                'created_at'  => $r['created_at'],
            ],
            $this->reviewModel->approvedFor($id)
        );
        $stats   = $this->reviewModel->statsMap([$id])[$id] ?? ['average' => 0.0, 'count' => 0];
        $related = $this->buildRelated($id);

        $qty = (int) ($p['stock_quantity'] ?? 0);
        $minStock = (int) ($p['minimum_stock'] ?? 5);

        return [
            'product_id'        => $id,
            // Keep product_id temporarily in output to avoid breaking frontend immediately
            'product_id'    => $id,
            'name'              => (string) ($p['name'] ?? ''),
            'sku'               => (string) ($p['sku'] ?? ''),
            'category'          => (string) ($p['category'] ?? ''),
            'price'             => (float) ($p['selling_price'] ?? 0),
            'selling_price'     => (float) ($p['selling_price'] ?? 0),
            'cost_price'        => (float) ($p['cost_price'] ?? 0),
            'stock_quantity'    => $qty,
            'minimum_stock'     => $minStock,
            'stock_status'      => $this->stockStatus($qty, $minStock),
            'status'            => (string) ($p['status'] ?? 'active'),
            'slug'              => (string) ($p['slug'] ?? ''),
            'short_description' => (string) ($p['short_description'] ?? ''),
            'full_description'  => (string) ($p['full_description'] ?? ''),
            'warranty_info'     => (string) ($p['warranty_info'] ?? ''),
            'is_featured'       => (bool) ($p['is_featured'] ?? false),
            'is_visible_online' => (bool) ($p['is_visible_online'] ?? true),
            'images'            => $images,
            'primary_image'     => $images[0]['image_path'] ?? '',
            'specifications'    => $specs,
            'reviews'           => $reviews,
            'rating_average'    => $stats['average'],
            'review_count'      => $stats['count'],
            'related_products'  => $related,
        ];
    }

    private function buildRelated(string $id): array
    {
        $ids = $this->relatedModel->relatedIds($id);
        if (empty($ids)) return [];

        $primaryMap = $this->imageModel->primaryMap($ids);
        $statsMap   = $this->reviewModel->statsMap($ids);

        $out = [];
        foreach ($ids as $rid) {
            $p = $this->productModel->find($rid);
            if (!$p) continue;
            $out[] = $this->buildSummary($p, $primaryMap, $statsMap);
        }
        return $out;
    }

    // -----------------------------------------------------------------
    // Filters / sort
    // -----------------------------------------------------------------
    private function applyFilters(array $items, array $params): array
    {
        $search   = strtolower(trim((string) ($params['search'] ?? '')));
        $category = trim((string) ($params['category'] ?? ''));
        $stock    = trim((string) ($params['stock_status'] ?? ''));
        $visible  = isset($params['is_visible_online']) ? trim((string) $params['is_visible_online']) : null;
        $featured = isset($params['is_featured']) ? trim((string) $params['is_featured']) : null;
        $status   = trim((string) ($params['status'] ?? ''));

        return array_values(array_filter($items, function ($it) use ($search, $category, $stock, $visible, $featured, $status) {
            if ($search !== '') {
                $hay = strtolower($it['name'] . ' ' . $it['sku'] . ' ' . $it['category']);
                if (strpos($hay, $search) === false) return false;
            }
            if ($category !== '' && strcasecmp($it['category'], $category) !== 0) return false;
            if ($stock !== '' && $it['stock_status'] !== $stock) return false;
            
            if ($visible !== null && $visible !== '') {
                $visBool = $visible === '1' || $visible === 'true';
                if ($it['is_visible_online'] !== $visBool) return false;
            }
            if ($featured !== null && $featured !== '') {
                $featBool = $featured === '1' || $featured === 'true';
                if ($it['is_featured'] !== $featBool) return false;
            }
            if ($status !== '' && strcasecmp($it['status'], $status) !== 0) return false;

            return true;
        }));
    }

    private function applySort(array $items, string $sort): array
    {
        switch ($sort) {
            case 'price_asc':
                $cmp = fn($a, $b) => $a['price'] <=> $b['price'];
                break;
            case 'price_desc':
                $cmp = fn($a, $b) => $b['price'] <=> $a['price'];
                break;
            case 'name_asc':
                $cmp = fn($a, $b) => strcmp($a['name'], $b['name']);
                break;
            case 'rating':
                $cmp = fn($a, $b) => $b['rating_average'] <=> $a['rating_average'];
                break;
            case 'featured':
                $cmp = fn($a, $b) => ((int) $b['is_featured']) <=> ((int) $a['is_featured']);
                break;
            default:
                $cmp = fn($a, $b) => strcmp($b['product_id'], $a['product_id']);
                break;
        }
        usort($items, $cmp);
        return $items;
    }

    private function stockStatus(int $qty, int $minimumStock = 5): string
    {
        if ($qty <= 0) return 'out_of_stock';
        if ($qty <= max(1, $minimumStock)) return 'low_stock';
        return 'in_stock';
    }
}
