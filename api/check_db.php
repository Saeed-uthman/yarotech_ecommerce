<?php
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/.env');

try {
    $db = Database::connection();
    
    echo "--- Table: orders ---\n";
    $stmt = $db->query("DESCRIBE orders");
    while ($row = $stmt->fetch()) {
        echo "{$row['Field']} ({$row['Type']})\n";
    }
    
    echo "\n--- Table: payments ---\n";
    $stmt = $db->query("DESCRIBE payments");
    while ($row = $stmt->fetch()) {
        echo "{$row['Field']} ({$row['Type']})\n";
    }

    echo "\n--- Table: order_items ---\n";
    $stmt = $db->query("DESCRIBE order_items");
    while ($row = $stmt->fetch()) {
        echo "{$row['Field']} ({$row['Type']})\n";
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
