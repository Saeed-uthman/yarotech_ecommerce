<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\Request;
use App\Services\PosService;
use App\Services\ProductService;

final class ProductController extends BaseController
{
    private ProductService $products;
    public function __construct()
    {
        $this->products = new ProductService();
    }

    /** GET /api/products — merged list with filters + pagination */
    public function index(): never
    {
        $data = $this->products->publicList([
            'search'       => Request::query('search'),
            'category'     => Request::query('category'),
            'stock_status' => Request::query('stock_status'),
            'sort'         => Request::query('sort', 'newest'),
            'page'         => Request::query('page', 1),
            'per_page'     => Request::query('per_page', 12),
        ]);
        $this->ok($data, 'Products fetched successfully');
    }

    /** GET /api/products/:slug — merged detail */
    public function show(string $slug): never
    {
        $detail = $this->products->detailBySlug($slug);
        if (!$detail) $this->fail('Product not found', 404);
        $this->ok($detail, 'Product fetched successfully');
    }

    public function categories(): never
    {
        $this->ok(['items' => (new \App\Models\Product())->categories()], 'Categories fetched');
    }
}
