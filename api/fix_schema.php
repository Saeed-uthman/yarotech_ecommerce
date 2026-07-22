<?php
/**
 * YAROTECH - Schema Synchronization Fix
 * This script adds missing columns required for the Admin Dashboard and Reports.
 */
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

if (!defined('APP_BASE_PATH')) {
    define('APP_BASE_PATH', __DIR__);
}

Env::load(__DIR__ . '/.env');

header('Content-Type: text/html; charset=utf-8');

try {
    $db = Database::connection();
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "<h1>YAROTECH Schema Fix</h1>";

    // 1. Fix Orders table
    echo "Checking 'orders' table...<br>";
    $stmt = $db->query("DESCRIBE orders");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    if (!in_array('total_amount', $cols)) {
        if (in_array('total', $cols)) {
            echo " - Renaming 'total' to 'total_amount'...<br>";
            $db->exec("ALTER TABLE orders CHANGE total total_amount DECIMAL(14,2) NOT NULL DEFAULT 0");
        } else {
            echo " - Adding 'total_amount'...<br>";
            $db->exec("ALTER TABLE orders ADD COLUMN total_amount DECIMAL(14,2) NOT NULL DEFAULT 0");
        }
    }
    
    if (!in_array('tax_amount', $cols)) {
        if (in_array('vat', $cols)) {
            echo " - Renaming 'vat' to 'tax_amount'...<br>";
            $db->exec("ALTER TABLE orders CHANGE vat tax_amount DECIMAL(14,2) NOT NULL DEFAULT 0");
        } else {
             echo " - Adding 'tax_amount'...<br>";
             $db->exec("ALTER TABLE orders ADD COLUMN tax_amount DECIMAL(14,2) NOT NULL DEFAULT 0");
        }
    }

    if (!in_array('order_status', $cols)) {
        if (in_array('status', $cols)) {
            echo " - Renaming 'status' to 'order_status'...<br>";
            $db->exec("ALTER TABLE orders CHANGE status order_status VARCHAR(40) NOT NULL DEFAULT 'awaiting_payment'");
        }
    }

    $addCols = [
        'payment_status' => "VARCHAR(40) NOT NULL DEFAULT 'pending'",
        'sale_channel' => "VARCHAR(40) NOT NULL DEFAULT 'ecommerce'",
        'pos_sync_status' => "VARCHAR(40) NOT NULL DEFAULT 'pending'",
        'payment_method' => "VARCHAR(40) NULL",
        'created_by' => "VARCHAR(40) NOT NULL DEFAULT 'user'",
        'delivery_method' => "VARCHAR(40) NOT NULL DEFAULT 'delivery'",
        'delivery_address' => "TEXT NULL"
    ];

    foreach ($addCols as $col => $def) {
        if (!in_array($col, $cols)) {
            echo " - Adding '$col'...<br>";
            $db->exec("ALTER TABLE orders ADD COLUMN $col $def");
        }
    }

    echo " - Ensuring 'customer_email' and 'customer_phone' are nullable...<br>";
    $db->exec("ALTER TABLE orders MODIFY customer_email VARCHAR(190) NULL");
    $db->exec("ALTER TABLE orders MODIFY customer_phone VARCHAR(40) NULL");

    // 2. Fix Payments table
    echo "Checking 'payments' table...<br>";
    $stmt = $db->query("DESCRIBE payments");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    if (!in_array('channel', $cols)) {
        echo " - Adding 'channel' to payments...<br>";
        $db->exec("ALTER TABLE payments ADD COLUMN channel VARCHAR(40) NULL");
    }
    
    if (!in_array('gateway_response', $cols)) {
        echo " - Adding 'gateway_response' to payments...<br>";
        $db->exec("ALTER TABLE payments ADD COLUMN gateway_response VARCHAR(255) NULL");
    }

    // 3. Fix POS Sync Logs
    echo "Checking 'pos_sync_logs' table...<br>";
    $stmt = $db->query("DESCRIBE pos_sync_logs");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    if (!in_array('sync_type', $cols)) {
        echo " - Adding 'sync_type' to pos_sync_logs...<br>";
        $db->exec("ALTER TABLE pos_sync_logs ADD COLUMN sync_type VARCHAR(40) NOT NULL DEFAULT 'order_push'");
    }

    // 4. Fix Carts table
    echo "Checking 'carts' table...<br>";
    $stmt = $db->query("DESCRIBE carts");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    if (!in_array('status', $cols)) {
        echo " - Adding 'status' to carts...<br>";
        $db->exec("ALTER TABLE carts ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'active'");
    }
    if (in_array('session_key', $cols) && !in_array('session_token', $cols)) {
        echo " - Renaming 'session_key' to 'session_token' in carts...<br>";
        $db->exec("ALTER TABLE carts CHANGE session_key session_token VARCHAR(64) NULL");
    }

    // 5. Fix Cart Items table
    echo "Checking 'cart_items' table...<br>";
    $stmt = $db->query("DESCRIBE cart_items");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    // Make unit_price and snapshot_name nullable as the new service doesn't use them
    echo " - Ensuring cart_items columns are flexible...<br>";
    $db->exec("ALTER TABLE cart_items MODIFY unit_price DECIMAL(12,2) NULL");
    $db->exec("ALTER TABLE cart_items MODIFY snapshot_name VARCHAR(190) NULL");

    // 6. Fix Settings table
    echo "Checking 'settings' table...<br>";
    $stmt = $db->query("DESCRIBE settings");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    if (!in_array('setting_group', $cols)) {
        echo " - Adding 'setting_group' to settings...<br>";
        $db->exec("ALTER TABLE settings ADD COLUMN setting_group VARCHAR(50) NOT NULL DEFAULT 'general' AFTER setting_key");
    }

    echo "<br><strong style='color:green;'>Success! Schema updated.</strong>";
    echo "<br>Please refresh your Admin Dashboard.";

} catch (Exception $e) {
    echo "<br><strong style='color:red;'>Error: " . $e->getMessage() . "</strong>";
}
