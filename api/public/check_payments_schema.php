<?php
define('APP_BASE_PATH', dirname(__DIR__));
require __DIR__ . '/../vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/../.env');

try {
    $db = Database::connection();
    $stmt = $db->query("SHOW CREATE TABLE payments");
    $row = $stmt->fetch();
    echo "Create Table Statement:\n";
    echo $row['Create Table'];
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
