<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Models\InventoryMovement;
use App\Models\Product;
use App\Models\ProductImage;
use App\Models\ProductRelated;
use App\Models\ProductSpecification;
use App\Services\ImageUploadService;
use App\Services\InventoryService;
use App\Services\ProductService;
use App\Services\AdminActivityLogService;

/**
 * Admin product management.
 *
 * Product ownership is now internal. Existing enrichment endpoints are
 * preserved for compatibility and now also synchronize relevant fields
 * to the internal `products` table.
 */
final class AdminProductController extends BaseController
{
    private ProductService $products;
    private Product $productModel;
    private InventoryService $inventory;
    private AdminActivityLogService $activity;
    private InventoryMovement $movementModel;

    public function __construct(
        ?ProductService $products = null,
        ?Product $productModel = null,
        ?InventoryService $inventory = null,
        ?AdminActivityLogService $activity = null,
        ?InventoryMovement $movementModel = null
    ) {
        $this->products = $products ?? new ProductService();
        $this->productModel = $productModel ?? new Product();
        $this->inventory = $inventory ?? new InventoryService();
        $this->activity = $activity ?? new AdminActivityLogService();
        $this->movementModel = $movementModel ?? new InventoryMovement();
    }

    public function index(): never
    {
        $this->ok($this->products->adminList([
            'missing_meta' => Request::query('missing_meta'),
            'search' => Request::query('search'),
            'category' => Request::query('category'),
            'stock_status' => Request::query('stock_status'),
            'is_visible_online' => Request::query('is_visible_online'),
            'is_featured' => Request::query('is_featured'),
            'status' => Request::query('status'),
        ]), 'Admin product list');
    }

    /** GET /api/admin/products/missing-meta */
    public function missingMeta(): never
    {
        $this->ok($this->products->missingMeta(), 'Products missing ecommerce metadata');
    }

    /** GET /api/admin/products/:posId */
    public function show(string $posId): never
    {
        $detail = $this->products->detailByPosId($posId);
        if (!$detail) $this->fail('Product not found', 404);
        $this->ok($detail, 'Admin product detail');
    }

    /**
     * POST /api/admin/products/create
     * Create a system-owned product (core + ecommerce-facing fields).
     */
    public function create(): never
    {
        $clean = $this->validate([
            'name'              => 'required|string|max:190',
            'sku'               => 'string|max:80',
            'category'          => 'string|max:120',
            'slug'              => 'string|max:190',
            'short_description' => 'string|max:500',
            'full_description'  => 'string|max:60000',
            'cost_price'        => 'numeric|min:0',
            'selling_price'     => 'numeric|min:0', // Removed required for POS
            'stock_quantity'    => 'integer|min:0',
            'minimum_stock'     => 'integer|min:0',
            'warranty_info'     => 'string|max:255',
            'is_visible_online' => 'boolean',
            'is_featured'       => 'boolean',
            'status'            => 'in:active,inactive,draft,archived',
        ]);

        $slugInput = trim((string) ($clean['slug'] ?? $clean['name']));
        $slug = $this->productModel->ensureUniqueSlug($slugInput);
        $id = $this->productModel->generateProductId();
        
        $sku = trim((string) ($clean['sku'] ?? ''));
        if ($sku === '') {
            $sku = $this->productModel->generateSku();
        }
        
        // Map POS aliases
        $sellingPrice = (float) ($clean['selling_price'] ?? $this->input('price', 0));
        $costPrice = (float) ($clean['cost_price'] ?? $this->input('unit_price', 0));
        $stockQuantity = (int) ($clean['stock_quantity'] ?? $this->input('stock', 0));
        $vatEnabled = filter_var($this->input('vat_enabled', true), FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
        $maxMarkup = (float) $this->input('max_markup', 0);

        $this->productModel->insert([
            'id'                => $id,
            'name'              => (string) $clean['name'],
            'sku'               => $sku,
            'category'          => (string) ($clean['category'] ?? 'Uncategorized'),
            'slug'              => $slug,
            'short_description' => (string) ($clean['short_description'] ?? ''),
            'full_description'  => (string) ($clean['full_description'] ?? ''),
            'cost_price'        => $costPrice,
            'selling_price'     => $sellingPrice,
            'stock_quantity'    => $stockQuantity,
            'minimum_stock'     => (int) ($clean['minimum_stock'] ?? 5),
            'warranty_info'     => (string) ($clean['warranty_info'] ?? ''),
            'is_visible_online' => filter_var($clean['is_visible_online'] ?? true, FILTER_VALIDATE_BOOLEAN) ? 1 : 0,
            'is_featured'       => filter_var($clean['is_featured'] ?? false, FILTER_VALIDATE_BOOLEAN) ? 1 : 0,
            'status'            => (string) ($clean['status'] ?? 'active'),
            'vat_enabled'       => $vatEnabled,
            'max_markup'        => $maxMarkup,
        ]);

        $this->ok($this->productModel->find($id), 'Product created');
    }

    /**
     * POST /api/admin/products/update-core
     * Update internal product core fields without touching UI structure.
     */
    public function updateCore(): never
    {
        $productId = trim((string) $this->input('product_id', $this->input('product_id', $this->input('id', ''))));
        if ($productId === '') $this->fail('product_id is required', 422);

        $existing = $this->productModel->find($productId);
        if (!$existing) $this->fail('Product not found', 404);

        $payload = $this->all();
        $update = [];
        $requestedStock = null;

        if (isset($payload['name'])) $update['name'] = mb_substr(trim((string) $payload['name']), 0, 190);
        if (isset($payload['sku'])) $update['sku'] = mb_substr(trim((string) $payload['sku']), 0, 80);
        if (isset($payload['category'])) $update['category'] = mb_substr(trim((string) $payload['category']), 0, 120);
        if (isset($payload['short_description'])) $update['short_description'] = mb_substr((string) $payload['short_description'], 0, 500);
        if (isset($payload['full_description'])) $update['full_description'] = (string) $payload['full_description'];
        if (isset($payload['warranty_info'])) $update['warranty_info'] = mb_substr((string) $payload['warranty_info'], 0, 255);
        if (isset($payload['cost_price']) && is_numeric($payload['cost_price'])) $update['cost_price'] = max(0, (float) $payload['cost_price']);
        elseif (isset($payload['unit_price']) && is_numeric($payload['unit_price'])) $update['cost_price'] = max(0, (float) $payload['unit_price']);
        
        if (isset($payload['selling_price']) && is_numeric($payload['selling_price'])) $update['selling_price'] = max(0, (float) $payload['selling_price']);
        elseif (isset($payload['price']) && is_numeric($payload['price'])) $update['selling_price'] = max(0, (float) $payload['price']);
        
        if (isset($payload['stock_quantity']) && filter_var($payload['stock_quantity'], FILTER_VALIDATE_INT) !== false) $requestedStock = max(0, (int) $payload['stock_quantity']);
        elseif (isset($payload['stock']) && filter_var($payload['stock'], FILTER_VALIDATE_INT) !== false) $requestedStock = max(0, (int) $payload['stock']);
        
        if (isset($payload['minimum_stock']) && filter_var($payload['minimum_stock'], FILTER_VALIDATE_INT) !== false) $update['minimum_stock'] = max(0, (int) $payload['minimum_stock']);
        if (isset($payload['is_visible_online'])) $update['is_visible_online'] = filter_var($payload['is_visible_online'], FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
        if (isset($payload['is_featured'])) $update['is_featured'] = filter_var($payload['is_featured'], FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
        if (isset($payload['status']) && in_array((string) $payload['status'], ['active', 'inactive', 'draft', 'archived'], true)) $update['status'] = (string) $payload['status'];
        
        if (isset($payload['vat_enabled'])) $update['vat_enabled'] = filter_var($payload['vat_enabled'], FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
        if (isset($payload['max_markup']) && is_numeric($payload['max_markup'])) $update['max_markup'] = max(0, (float) $payload['max_markup']);

        if (isset($payload['slug'])) {
            $update['slug'] = $this->productModel->ensureUniqueSlug((string) $payload['slug'], $productId);
        } elseif (isset($update['name']) && trim((string) $update['name']) !== '' && trim((string) ($existing['slug'] ?? '')) === '') {
            $update['slug'] = $this->productModel->ensureUniqueSlug((string) $update['name'], $productId);
        }

        if (!empty($update)) {
            $this->productModel->update($productId, $update);
        }

        if ($requestedStock !== null) {
            $this->inventory->correction(
                $productId,
                $requestedStock,
                'core-update:' . $productId,
                $this->actorRole(),
                $this->actorUserId(),
                isset($payload['stock_note']) ? mb_substr((string) $payload['stock_note'], 0, 500) : 'Stock correction via product core update'
            );
        }

        $this->ok($this->productModel->find($productId), 'Product updated');
    }

    /** POST /api/admin/products/stock-adjustment */
    public function stockAdjustment(): never
    {
        $productId = trim((string) $this->input('product_id', $this->input('product_id', '')));
        if ($productId === '') $this->fail('product_id is required', 422);

        $quantityDelta = $this->input('quantity', $this->input('quantity_delta', null));
        if (filter_var($quantityDelta, FILTER_VALIDATE_INT) === false) {
            $this->fail('quantity (or quantity_delta) must be an integer', 422);
        }

        $movement = $this->inventory->stockAdjustment(
            $productId,
            (int) $quantityDelta,
            trim((string) $this->input('reference_id', 'admin-adjustment:' . date('YmdHis'))),
            $this->actorRole(),
            $this->actorUserId(),
            mb_substr(trim((string) $this->input('note', '')) ?: 'Manual stock adjustment', 0, 500)
        );

        $this->ok($movement, 'Stock adjustment recorded');
    }

    /** POST /api/admin/products/stock-return */
    public function stockReturn(): never
    {
        $productId = trim((string) $this->input('product_id', $this->input('product_id', '')));
        if ($productId === '') $this->fail('product_id is required', 422);

        $quantity = $this->input('quantity', null);
        if (filter_var($quantity, FILTER_VALIDATE_INT) === false || (int) $quantity <= 0) {
            $this->fail('quantity must be a positive integer', 422);
        }

        $movement = $this->inventory->stockReturn(
            $productId,
            (int) $quantity,
            trim((string) $this->input('reference_id', 'stock-return:' . date('YmdHis'))),
            $this->actorRole(),
            $this->actorUserId(),
            mb_substr(trim((string) $this->input('note', '')) ?: 'Stock return recorded', 0, 500)
        );

        $this->ok($movement, 'Stock return recorded');
    }

    /** POST /api/admin/products/damaged-stock */
    public function damagedStock(): never
    {
        $productId = trim((string) $this->input('product_id', $this->input('product_id', '')));
        if ($productId === '') $this->fail('product_id is required', 422);

        $quantity = $this->input('quantity', null);
        if (filter_var($quantity, FILTER_VALIDATE_INT) === false || (int) $quantity <= 0) {
            $this->fail('quantity must be a positive integer', 422);
        }

        $movement = $this->inventory->damagedStock(
            $productId,
            (int) $quantity,
            trim((string) $this->input('reference_id', 'damage:' . date('YmdHis'))),
            $this->actorRole(),
            $this->actorUserId(),
            mb_substr(trim((string) $this->input('note', '')) ?: 'Damaged stock write-off', 0, 500)
        );

        $this->ok($movement, 'Damaged stock recorded');
    }

    /** POST /api/admin/products/stock-correction */
    public function stockCorrection(): never
    {
        $productId = trim((string) $this->input('product_id', $this->input('product_id', '')));
        if ($productId === '') $this->fail('product_id is required', 422);

        $newStock = $this->input('new_stock', $this->input('stock_quantity', null));
        if (filter_var($newStock, FILTER_VALIDATE_INT) === false || (int) $newStock < 0) {
            $this->fail('new_stock (or stock_quantity) must be an integer >= 0', 422);
        }

        $movement = $this->inventory->correction(
            $productId,
            (int) $newStock,
            trim((string) $this->input('reference_id', 'correction:' . date('YmdHis'))),
            $this->actorRole(),
            $this->actorUserId(),
            mb_substr(trim((string) $this->input('note', '')) ?: 'Manual stock correction', 0, 500)
        );

        $this->ok($movement, 'Stock correction recorded');
    }

    /** GET /api/admin/products/inventory-movements */
    public function inventoryMovements(): never
    {
        $productId = trim((string) Request::query('product_id', Request::query('product_id', '')));
        if ($productId === '') $this->fail('product_id is required', 422);

        $limit = (int) Request::query('limit', 100);
        $items = $this->inventory->movementsForProduct($productId, $limit);

        $this->ok([
            'product_id' => $productId,
            'items' => $items,
            'total' => count($items),
        ], 'Inventory movements fetched');
    }

    /** GET /api/admin/inventory/all-movements */
    public function allMovements(): never
    {
        $result = $this->movementModel->listAll([
            'page'           => Request::query('page', 1),
            'per_page'       => Request::query('per_page', 20),
            'movement_type'  => Request::query('movement_type'),
            'product_search' => Request::query('product_search'),
            'date_from'      => Request::query('date_from'),
            'date_to'        => Request::query('date_to'),
        ]);

        $this->ok($result, 'Stock movements fetched');
    }

    /** GET /api/admin/products/low-stock */
    public function lowStock(): never
    {
        $rows = $this->productModel->listAll();
        $items = array_values(array_map(function (array $p): array {
            return [
                'product_id' => (string) ($p['id'] ?? ''),
                'product_id' => (string) ($p['id'] ?? ''),
                'name' => (string) ($p['name'] ?? ''),
                'sku' => (string) ($p['sku'] ?? ''),
                'stock_quantity' => (int) ($p['stock_quantity'] ?? 0),
                'minimum_stock' => max(0, (int) ($p['minimum_stock'] ?? 5)),
                'status' => (string) ($p['status'] ?? 'active'),
            ];
        }, array_filter($rows, function (array $p): bool {
            $threshold = max(0, (int) ($p['minimum_stock'] ?? 5));
            return (int) ($p['stock_quantity'] ?? 0) <= $threshold;
        })));

        $this->ok([
            'items' => $items,
            'total' => count($items),
        ], 'Low stock alerts fetched');
    }

    /** POST /api/admin/products/meta */
    public function updateMeta(): never
    {
        $clean = $this->validate([
            'product_id'    => 'required|string|max:64',
            'slug'              => 'string|max:190',
            'short_description' => 'string|max:500',
            'full_description'  => 'string|max:60000',
            'warranty_info'     => 'string|max:255',
            'seo_title'         => 'string|max:190',
            'seo_description'   => 'string|max:255',
        ]);

        $productId = (string) $clean['product_id'];
        unset($clean['product_id']);



        // synchronize overlapping fields to internal products table
        $corePatch = [];
        if (isset($clean['slug'])) {
            $corePatch['slug'] = $this->productModel->ensureUniqueSlug((string) $clean['slug'], $productId);
        }
        if (isset($clean['short_description'])) $corePatch['short_description'] = (string) $clean['short_description'];
        if (isset($clean['full_description'])) $corePatch['full_description'] = (string) $clean['full_description'];
        if (isset($clean['warranty_info'])) $corePatch['warranty_info'] = (string) $clean['warranty_info'];

        if (!empty($corePatch) && $this->productModel->find($productId)) {
            $this->productModel->update($productId, $corePatch);
        }

        $this->ok($this->productModel->find($productId), 'Product metadata saved');
    }

    /** POST /api/admin/products/visibility */
    public function setVisibility(): never
    {
        $clean = $this->validate([
            'product_id'    => 'required|string|max:64',
            'is_visible_online' => 'required|boolean',
        ]);

        $visible = filter_var($clean['is_visible_online'], FILTER_VALIDATE_BOOLEAN);

        if ($this->productModel->find((string) $clean['product_id'])) {
            $this->productModel->update((string) $clean['product_id'], [
                'is_visible_online' => $visible ? 1 : 0,
            ]);
        }

        $this->ok(['product_id' => $clean['product_id']], 'Visibility updated');
    }

    /** POST /api/admin/products/featured */
    public function setFeatured(): never
    {
        $clean = $this->validate([
            'product_id' => 'required|string|max:64',
            'is_featured'    => 'required|boolean',
        ]);

        $featured = filter_var($clean['is_featured'], FILTER_VALIDATE_BOOLEAN);

        if ($this->productModel->find((string) $clean['product_id'])) {
            $this->productModel->update((string) $clean['product_id'], [
                'is_featured' => $featured ? 1 : 0,
            ]);
        }

        $this->ok(['product_id' => $clean['product_id']], 'Featured flag updated');
    }

    /** POST /api/admin/products/specifications */
    public function updateSpecifications(): never
    {
        $posId = (string) $this->input('product_id', '');
        $specs = $this->input('specifications', []);
        if ($posId === '')          $this->fail('product_id is required', 422);
        if (!is_array($specs))      $this->fail('specifications must be an array', 422);

        (new ProductSpecification())->replaceAll($posId, $specs);
        $this->ok(['product_id' => $posId, 'count' => count($specs)], 'Specifications saved');
    }

    /** POST /api/admin/products/related */
    public function updateRelated(): never
    {
        $posId = (string) $this->input('product_id', '');
        $ids   = $this->input('related_ids', []);
        if ($posId === '') $this->fail('product_id is required', 422);
        if (!is_array($ids)) $this->fail('related_ids must be an array', 422);

        (new ProductRelated())->replaceAll($posId, array_map('strval', $ids));
        $this->ok(['product_id' => $posId, 'count' => count($ids)], 'Related products updated');
    }

    /** POST /api/admin/products/images */
    public function uploadImage(): never
    {
        $posId = (string) ($_POST['product_id'] ?? '');
        if ($posId === '') $this->fail('product_id is required', 422);

        if (!isset($_FILES['image'])) $this->fail('image file is required', 422);

        try {
            $path = (new ImageUploadService())->store($_FILES['image'], 'products');
        } catch (\Throwable $e) {
            $this->fail($e->getMessage(), 422);
        }

        $isPrimary = filter_var($_POST['is_primary'] ?? false, FILTER_VALIDATE_BOOLEAN);
        $altText   = isset($_POST['alt_text']) ? mb_substr((string) $_POST['alt_text'], 0, 190) : null;

        $imageModel = new ProductImage();
        if ($isPrimary) {
            $imageModel->clearPrimaryFlag($posId);
        }
        $id = $imageModel->insert([
            'product_id' => $posId,
            'image_path'     => $path,
            'alt_text'       => $altText,
            'is_primary'     => $isPrimary ? 1 : 0,
            'sort_order'     => 0,
        ]);

        $this->ok([
            'id'         => (int) $id,
            'image_path' => $path,
            'url'        => $path,
            'is_primary' => $isPrimary,
        ], 'Image uploaded');
    }

    /** POST /api/admin/products/images/delete */
    public function deleteImage(): never
    {
        $url = trim((string) $this->input('url', ''));
        if ($url === '') $this->fail('url is required', 422);

        $path = parse_url($url, PHP_URL_PATH);
        $pos = strpos($path, '/uploads/products/');
        if ($pos !== false) {
            $path = substr($path, $pos);
        }

        $stmt = $this->db()->prepare("SELECT * FROM product_images WHERE image_path = :path LIMIT 1");
        $stmt->execute([':path' => $path]);
        $img = $stmt->fetch();

        if ($img) {
            $absolute = APP_BASE_PATH . '/public' . $img['image_path'];
            if (is_file($absolute)) @unlink($absolute);
            $model = new ProductImage();
            $model->delete((int) $img['id']);
        } else {
            $absolute = APP_BASE_PATH . '/public' . $path;
            if (is_file($absolute)) @unlink($absolute);
        }

        $this->ok(['url' => $url], 'Image removed');
    }

    /** POST /api/admin/products/images/set-primary */
    public function setPrimaryImage(): never
    {
        $productId = trim((string) $this->input('product_id', ''));
        if ($productId === '') $this->fail('product_id is required', 422);

        $url = trim((string) $this->input('url', ''));
        if ($url === '') $this->fail('url is required', 422);

        $path = parse_url($url, PHP_URL_PATH);
        $pos = strpos($path, '/uploads/products/');
        if ($pos !== false) {
            $path = substr($path, $pos);
        }

        $model = new ProductImage();
        
        $stmt = $this->db()->prepare("SELECT id FROM product_images WHERE image_path = :path AND product_id = :pid LIMIT 1");
        $stmt->execute([':path' => $path, ':pid' => $productId]);
        $img = $stmt->fetch();

        if (!$img) {
            $this->fail('Image not found for this product', 404);
        }

        $model->clearPrimaryFlag($productId);
        $this->db()->prepare("UPDATE product_images SET is_primary = 1 WHERE id = :id")->execute([':id' => $img['id']]);

        $this->ok(['url' => $url, 'product_id' => $productId], 'Primary image set');
    }

    /** POST /api/admin/products/archive */
    public function archive(string $id): never
    {
        $id = trim($id);
        if ($id === '') $this->fail('id is required', 422);

        $existing = $this->productModel->find($id);
        if (!$existing) $this->fail('Product not found', 404);

        $this->productModel->update($id, ['status' => 'archived']);
        
        $this->activity->log('product_archived', 'success', [
            'product_id' => $id,
            'name'       => $existing['name'] ?? '',
        ]);

        $this->ok(['id' => $id], 'Product archived successfully');
    }

    /** POST /api/admin/products/delete */
    public function delete(string $id): never
    {
        $id = trim($id);
        if ($id === '') $this->fail('id is required', 422);

        $existing = $this->productModel->find($id);
        if (!$existing) {
            $this->fail('Product not found', 404);
        }

        // 1. Delete associated images (files + db)
        $imageModel = new ProductImage();
        $images = $imageModel->listFor($id);
        foreach ($images as $img) {
            $absolute = APP_BASE_PATH . '/public' . $img['image_path'];
            if (is_file($absolute)) @unlink($absolute);
        }
        $this->db()->exec("DELETE FROM product_images WHERE product_id = " . $this->db()->quote($id));

        // 2. Delete specs, related, meta
        (new ProductSpecification())->replaceAll($id, []);
        (new ProductRelated())->replaceAll($id, []);


        // 3. Delete core product
        $this->productModel->delete($id);

        $this->activity->log('product_deleted', 'success', [
            'product_id' => $id,
            'name'       => $existing['name'] ?? '',
        ]);

        $this->ok(['id' => $id], 'Product deleted permanently');
    }

    private function db(): \PDO
    {
        return \App\Core\Database::connection();
    }

    private function actorRole(): string
    {
        $role = strtolower(trim((string) (Request::header('X-User-Role') ?? 'admin')));
        if (!in_array($role, ['admin', 'staff', 'user'], true)) {
            return 'admin';
        }
        return $role;
    }

    private function actorUserId(): ?int
    {
        $raw = Request::header('X-User-Id') ?? (string) $this->input('created_by_user_id', '');
        if ($raw === '' || filter_var($raw, FILTER_VALIDATE_INT) === false) {
            return null;
        }
        $id = (int) $raw;
        return $id > 0 ? $id : null;
    }
}
