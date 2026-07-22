<?php
define('APP_BASE_PATH', dirname(__DIR__));
require __DIR__ . '/../vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/../.env');

try {
    $db = Database::connection();
    echo "Adding missing columns to orders table...\n";
    
    $cols = [
        "fulfillment_method VARCHAR(40) DEFAULT 'pickup'",
        "delivery_state VARCHAR(100) NULL",
        "delivery_city VARCHAR(100) NULL",
        "delivery_address TEXT NULL",
        "delivery_landmark VARCHAR(255) NULL",
        "delivery_phone VARCHAR(30) NULL",
        "notes TEXT NULL"
    ];
    
    foreach ($cols as $col) {
        try {
            $db->exec("ALTER TABLE orders ADD COLUMN $col");
            echo "Added $col\n";
        } catch (Exception $e) {
            echo "Skipped (might exist): " . $e->getMessage() . "\n";
        }
    }
    
    echo "Success!\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
