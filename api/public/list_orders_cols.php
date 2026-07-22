<?php
define('APP_BASE_PATH', dirname(__DIR__));
require __DIR__ . '/../vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/../.env');

try {
    $db = Database::connection();
    $stmt = $db->query("SHOW COLUMNS FROM orders");
    while ($row = $stmt->fetch()) {
        echo $row['Field'] . "\n";
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
