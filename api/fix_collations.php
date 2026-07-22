<?php
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/.env');

try {
    $db = Database::connection();
    $dbName = env('DB_NAME', 'yarotech_db');
    
    echo "Fixing database collation for $dbName...\n";
    $db->exec("ALTER DATABASE `$dbName` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    
    $stmt = $db->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    foreach ($tables as $table) {
        echo "Converting table $table to utf8mb4_unicode_ci...\n";
        $db->exec("ALTER TABLE `$table` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    }
    
    echo "Success! All tables converted to utf8mb4_unicode_ci.\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
