<?php
define('APP_BASE_PATH', dirname(__DIR__));
require __DIR__ . '/../vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/../.env');

try {
    $db = Database::connection();
    echo "Adding missing columns to payments table...\n";
    
    $cols = [
        "user_id BIGINT(20) UNSIGNED NULL",
        "payment_method VARCHAR(40) NULL",
        "sale_channel ENUM('ecommerce','pos') DEFAULT 'ecommerce'",
        "authorization_url VARCHAR(255) NULL",
        "updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
    ];
    
    foreach ($cols as $col) {
        try {
            $db->exec("ALTER TABLE payments ADD COLUMN $col");
            echo "Added $col\n";
        } catch (Exception $e) {
            echo "Skipped: " . $e->getMessage() . "\n";
        }
    }
    
    echo "Success!\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
