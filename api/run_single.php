<?php
define('APP_BASE_PATH', __DIR__);
require __DIR__ . '/vendor/autoload.php';
\App\Helpers\Env::load(__DIR__ . '/.env');
$db = \App\Core\Database::connection();

try {
    echo "Fixing orders table delivery columns...\n";
    $queries = [
        "ALTER TABLE orders ADD COLUMN delivery_state VARCHAR(100) NULL AFTER fulfillment_method",
        "ALTER TABLE orders ADD COLUMN delivery_city VARCHAR(100) NULL AFTER delivery_state",
        "ALTER TABLE orders ADD COLUMN delivery_landmark VARCHAR(255) NULL AFTER delivery_address",
        "ALTER TABLE orders ADD COLUMN delivery_phone VARCHAR(40) NULL AFTER delivery_landmark"
    ];

    foreach ($queries as $q) {
        try {
            $db->exec($q);
            echo "Success: $q\n";
        } catch (\PDOException $e) {
            echo "Skipped (probably exists): $q\n";
        }
    }
    
    echo "orders delivery columns updated.\n";
} catch (\Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
