<?php
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/.env');

try {
    $db = Database::connection();
    $id = 'PRD-1004';
    $res = $db->query("SELECT id, name, status FROM products WHERE id = " . $db->quote($id))->fetch();
    echo "Product $id:\n";
    print_r($res);
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
