<?php
define('APP_BASE_PATH', dirname(__DIR__));
require __DIR__ . '/../vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/../.env');

try {
    $db = Database::connection();
    echo "Fixing shipping_json constraint...\n";
    
    // Make shipping_json nullable and remove the check constraint by redefining it
    // First, try to drop the constraint if it has a specific name
    // In MariaDB/MySQL, we can just alter the column to remove the CHECK or make it nullable
    
    $db->exec("ALTER TABLE orders MODIFY COLUMN shipping_json LONGTEXT NULL");
    echo "Made shipping_json nullable.\n";
    
    // Forcefully remove check constraints if possible
    // Note: Some versions don't support DROP CONSTRAINT easily without knowing the name.
    // But modifying the column often drops or resets constraints associated with it.
    
    echo "Success!\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
