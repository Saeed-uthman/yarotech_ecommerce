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
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    echo "Connected to database.\n";

    $sql = file_get_contents(__DIR__ . '/database/migrate_customers.sql');

    $db->exec($sql);

    echo "Customers table created and backfilled successfully.\n";

    $count = $db->query("SELECT COUNT(*) FROM customers")->fetchColumn();
    echo "Total customers: {$count}\n";

} catch (PDOException $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
