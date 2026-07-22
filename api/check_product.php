<?php
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/.env');

$productId = $argv[1] ?? 'PRD-1020';

try {
    $db = Database::connection();
    $stmt = $db->prepare("SELECT id, name, sku, selling_price, cost_price FROM products WHERE id = :id OR sku = :id");
    $stmt->execute([':id' => $productId]);
    $row = $stmt->fetch();
    echo "Product details for $productId:\n";
    print_r($row);
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
