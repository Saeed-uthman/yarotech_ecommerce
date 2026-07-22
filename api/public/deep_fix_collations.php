<?php
define('APP_BASE_PATH', dirname(__DIR__));
require __DIR__ . '/../vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/../.env');

try {
    $db = Database::connection();
    $dbName = env('DB_NAME', 'yarotech_db');
    
    echo "Scanning database $dbName for collation mismatches...\n";
    $stmt = $db->query("
        SELECT TABLE_NAME, COLUMN_NAME, COLLATION_NAME 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = '$dbName' 
        AND COLLATION_NAME IS NOT NULL 
        AND COLLATION_NAME <> 'utf8mb4_unicode_ci'
    ");
    $mismatches = $stmt->fetchAll();
    
    if (empty($mismatches)) {
        echo "Perfect! No mismatches found. All columns are utf8mb4_unicode_ci.\n";
    } else {
        echo "Found " . count($mismatches) . " mismatches:\n";
        foreach ($mismatches as $m) {
            echo "{$m['TABLE_NAME']}.{$m['COLUMN_NAME']}: {$m['COLLATION_NAME']}\n";
        }
        
        echo "\nAttempting final forceful conversion...\n";
        $stmt2 = $db->query("SHOW TABLES");
        $tables = $stmt2->fetchAll(PDO::FETCH_COLUMN);
        foreach ($tables as $table) {
            $db->exec("ALTER TABLE `$table` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            echo "Converted $table\n";
        }
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
