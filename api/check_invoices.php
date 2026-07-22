<?php
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;

if (file_exists(__DIR__ . '/.env')) {
    Env::load(__DIR__ . '/.env');
}

$host = env('DB_HOST', 'localhost');
$port = env('DB_PORT', '3306');
$dbName = env('DB_NAME', 'yarotech_pos_e-commerce');
$user = env('DB_USER', 'yarotech_yarotech');
$pass = env('DB_PASS', 'yarotechinvoicedb');
$charset = env('DB_CHARSET', 'utf8mb4');

$dsn = "mysql:host={$host};port={$port};dbname={$dbName};charset={$charset}";
try {
    $db = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);

    echo "Tables containing 'invoice':\n";
    $stmt = $db->query("SHOW TABLES LIKE '%invoice%'");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    foreach ($tables as $table) {
        echo "\nTable: $table\n";
        $stmt = $db->query("SHOW CREATE TABLE `$table`");
        $create = $stmt->fetch();
        echo $create['Create Table'] . "\n";
        
        $count = $db->query("SELECT count(*) FROM `$table`")->fetchColumn();
        echo "Row count: $count\n";
        
        if ($count > 0) {
            echo "First 2 rows:\n";
            $stmt = $db->query("SELECT * FROM `$table` LIMIT 2");
            print_r($stmt->fetchAll());
        }
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
