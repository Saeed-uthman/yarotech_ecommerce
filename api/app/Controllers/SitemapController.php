<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Services\ProductService;

final class SitemapController extends BaseController
{
    public function index(): never
    {
        $productsService = new ProductService();
        // Fetch up to 1000 products for the sitemap
        $data = $productsService->publicList(['per_page' => 1000, 'page' => 1]);
        
        $baseUrl = 'https://shop.y.yarotech.com.ng';
        $date = date('Y-m-d\TH:i:sP');

        $xml = '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
        $xml .= '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' . "\n";

        // Static Pages
        $staticPages = ['/', '/shop', '/about', '/contact', '/services'];
        foreach ($staticPages as $page) {
            $xml .= "  <url>\n";
            $xml .= "    <loc>" . htmlspecialchars($baseUrl . $page) . "</loc>\n";
            $xml .= "    <lastmod>{$date}</lastmod>\n";
            $xml .= "    <changefreq>weekly</changefreq>\n";
            if ($page === '/') {
                $xml .= "    <priority>1.0</priority>\n";
            } else {
                $xml .= "    <priority>0.8</priority>\n";
            }
            $xml .= "  </url>\n";
        }

        // Dynamic Product Pages
        if (!empty($data['items'])) {
            foreach ($data['items'] as $product) {
                $slug = $product['slug'] ?? '';
                if ($slug) {
                    $productDate = $product['updatedAt'] ?: ($product['createdAt'] ?: $date);
                    // Ensure valid format if the database returns a raw datetime
                    if (strlen($productDate) === 19) {
                        $productDate = str_replace(' ', 'T', $productDate) . '+00:00';
                    }
                    
                    $xml .= "  <url>\n";
                    $xml .= "    <loc>" . htmlspecialchars($baseUrl . '/shop/' . $slug) . "</loc>\n";
                    $xml .= "    <lastmod>" . htmlspecialchars($productDate) . "</lastmod>\n";
                    $xml .= "    <changefreq>daily</changefreq>\n";
                    $xml .= "    <priority>0.9</priority>\n";
                    $xml .= "  </url>\n";
                }
            }
        }

        $xml .= '</urlset>';

        header('Content-Type: application/xml; charset=utf-8');
        echo $xml;
        exit;
    }
}
