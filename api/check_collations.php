<?php
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/.env');

try {
    $db = Database::connection();
    $tables = ['products', 'orders', 'order_items', 'payments', 'ecommerce_product_meta'];
    foreach ($tables as $table) {
        echo "--- Table: $table ---\n";
        $stmt = $db->query("SHOW FULL COLUMNS FROM $table");
        while ($row = $stmt->fetch()) {
            if ($row['Collation']) {
                echo "{$row['Field']}: {$row['Collation']}\n";
            }
        }
        echo "\n";
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
