<?php
/**
 * YAROTECH - Schema Synchronization Fix
 * This script adds missing columns required for the Admin Dashboard and Reports.
 */
define('APP_BASE_PATH', dirname(__DIR__));
require APP_BASE_PATH . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

Env::load(APP_BASE_PATH . '/.env');

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
    
    if (!in_array('delivery_fee', $cols)) {
        if (in_array('shipping_fee', $cols)) {
            echo " - Renaming 'shipping_fee' to 'delivery_fee'...<br>";
            $db->exec("ALTER TABLE orders CHANGE shipping_fee delivery_fee DECIMAL(14,2) NOT NULL DEFAULT 0");
        } else {
            echo " - Adding 'delivery_fee'...<br>";
            $db->exec("ALTER TABLE orders ADD COLUMN delivery_fee DECIMAL(14,2) NOT NULL DEFAULT 0");
        }
    }

    if (!in_array('payment_status', $cols)) {
        echo " - Adding 'payment_status'...<br>";
        $db->exec("ALTER TABLE orders ADD COLUMN payment_status ENUM('pending','success','failed','abandoned') NOT NULL DEFAULT 'pending'");
        // If we have old 'paid' orders (from the renamed order_status or old status), mark them as 'success' in payment_status
        $checkCol = in_array('order_status', $cols) ? 'order_status' : (in_array('status', $cols) ? 'status' : null);
        if ($checkCol) {
            $db->exec("UPDATE orders SET payment_status = 'success' WHERE $checkCol = 'paid'");
        }
    }

    // 2. Fix order_items table
    echo "Checking 'order_items' table...<br>";
    $stmt = $db->query("DESCRIBE order_items");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    if (!in_array('product_name_snapshot', $cols) && in_array('snapshot_name', $cols)) {
        echo " - Renaming 'snapshot_name' to 'product_name_snapshot'...<br>";
        $db->exec("ALTER TABLE order_items CHANGE snapshot_name product_name_snapshot VARCHAR(200) NOT NULL");
    }
    if (!in_array('unit_price_snapshot', $cols) && in_array('unit_price', $cols)) {
        echo " - Renaming 'unit_price' to 'unit_price_snapshot'...<br>";
        $db->exec("ALTER TABLE order_items CHANGE unit_price unit_price_snapshot DECIMAL(14,2) NOT NULL DEFAULT 0");
    }
    if (!in_array('sku_snapshot', $cols) && in_array('snapshot_sku', $cols)) {
        echo " - Renaming 'snapshot_sku' to 'sku_snapshot'...<br>";
        $db->exec("ALTER TABLE order_items CHANGE snapshot_sku sku_snapshot VARCHAR(80) NULL");
    }

    // 3. Fix Payments table
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

    // 4. Fix POS Sync Logs
    echo "Checking 'pos_sync_logs' table...<br>";
    $stmt = $db->query("DESCRIBE pos_sync_logs");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    if (!in_array('sync_type', $cols)) {
        echo " - Adding 'sync_type' to pos_sync_logs...<br>";
        $db->exec("ALTER TABLE pos_sync_logs ADD COLUMN sync_type VARCHAR(40) NOT NULL DEFAULT 'order_push'");
    }

    // 5. Fix Settings table
    echo "Checking 'settings' table...<br>";
    $stmt = $db->query("DESCRIBE settings");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    if (!in_array('setting_group', $cols)) {
        echo " - Adding 'setting_group' to settings...<br>";
        $db->exec("ALTER TABLE settings ADD COLUMN setting_group VARCHAR(50) NOT NULL DEFAULT 'general' AFTER setting_key");
    }

    // 6. Fix Orders table for sale_channel
    echo "Checking 'orders' table for missing channels...<br>";
    $stmt = $db->query("DESCRIBE orders");
    $cols = $stmt->fetchAll(PDO::FETCH_COLUMN);
    if (!in_array('sale_channel', $cols)) {
        echo " - Adding 'sale_channel' to orders...<br>";
        $db->exec("ALTER TABLE orders ADD COLUMN sale_channel VARCHAR(40) NOT NULL DEFAULT 'ecommerce'");
    }

    // 7. Create Notifications table
    echo "Checking 'notifications' table...<br>";
    $db->exec("CREATE TABLE IF NOT EXISTS notifications (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        user_id BIGINT UNSIGNED NULL,
        role_target VARCHAR(20) NOT NULL DEFAULT 'user',
        type VARCHAR(80) NOT NULL,
        title VARCHAR(190) NOT NULL,
        message TEXT NULL,
        data JSON NULL,
        is_read TINYINT(1) NOT NULL DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    echo " - Notifications table ensured.<br>";

    // 8. Create delivery_zones table
    echo "Checking 'delivery_zones' table...<br>";
    $db->exec("CREATE TABLE IF NOT EXISTS delivery_zones (
        id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        state VARCHAR(100) NOT NULL,
        city_or_lga VARCHAR(100) NOT NULL,
        zone_name VARCHAR(150) NOT NULL,
        base_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
        extra_fee_per_kg DECIMAL(12,2) NOT NULL DEFAULT 0,
        eta_text VARCHAR(100) NULL,
        is_active TINYINT(1) NOT NULL DEFAULT 1,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_zone_state_city (state, city_or_lga)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    echo " - delivery_zones table ensured.<br>";

    // 9. Alter order_items columns
    echo "Checking 'order_items' table...<br>";
    try {
        $db->exec("ALTER TABLE order_items CHANGE snapshot_name product_name_snapshot VARCHAR(190) NOT NULL");
        echo " - Renamed snapshot_name to product_name_snapshot.<br>";
    } catch (\PDOException $e) { /* Ignore if already renamed or doesn't exist */ }
    
    try {
        $db->exec("ALTER TABLE order_items CHANGE snapshot_sku sku_snapshot VARCHAR(80) NULL");
        echo " - Renamed snapshot_sku to sku_snapshot.<br>";
    } catch (\PDOException $e) { /* Ignore */ }
    
    try {
        $db->exec("ALTER TABLE order_items CHANGE unit_price unit_price_snapshot DECIMAL(12,2) NOT NULL DEFAULT 0");
        echo " - Renamed unit_price to unit_price_snapshot.<br>";
    } catch (\PDOException $e) { /* Ignore */ }

    echo "<br><strong style='color:green;'>Success! Schema updated.</strong>";
    echo "<br>Please refresh your Admin Dashboard.";

} catch (Exception $e) {
    echo "<br><strong style='color:red;'>Error: " . $e->getMessage() . "</strong>";
}
