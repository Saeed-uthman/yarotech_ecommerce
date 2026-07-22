<?php
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(__DIR__ . '/.env');

try {
    $db = Database::connection();
    $res = $db->query("SELECT setting_key, setting_value FROM settings WHERE setting_key LIKE '%tax%' OR setting_key LIKE '%vat%'")->fetchAll();
    echo "Tax/VAT Settings:\n";
    print_r($res);
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
