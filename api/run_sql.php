<?php
/**
 * YAROTECH - Schema Synchronization Fix V3
 * This script adds missing columns required for the Admin Dashboard and Reports.
 * It catches individual errors so one failure doesn't stop the rest.
 */
require __DIR__ . '/vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;

if (!defined('APP_BASE_PATH')) {
    define('APP_BASE_PATH', __DIR__);
}

if (file_exists(__DIR__ . '/.env')) {
    Env::load(__DIR__ . '/.env');
} elseif (file_exists(dirname(__DIR__) . '/.env')) {
    Env::load(dirname(__DIR__) . '/.env');
}

header('Content-Type: text/html; charset=utf-8');

try {
    $host = env('DB_HOST', 'localhost');
    $port = env('DB_PORT', '3306');
    $dbName = env('DB_NAME', 'yarotech_pos_e-commerce');
    $user = env('DB_USER', 'yarotech_yarotech');
    $pass = env('DB_PASS', 'yarotechinvoicedb');
    $charset = env('DB_CHARSET', 'utf8mb4');

    echo "<h1>YAROTECH Schema Fix V3</h1>";
    echo "<b>Attempting to connect to database:</b><br>";
    echo "Host: $host<br>";
    echo "Database: $dbName<br>";
    echo "User: $user<br><hr>";

    $dsn = "mysql:host={$host};port={$port};dbname={$dbName};charset={$charset}";
    $db = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    echo "<h1>YAROTECH Schema Fix V3</h1>";

    $queries = [
        "ALTER TABLE orders ADD COLUMN payment_status VARCHAR(40) NOT NULL DEFAULT 'pending'",
        "ALTER TABLE orders ADD COLUMN sale_channel VARCHAR(40) NOT NULL DEFAULT 'ecommerce'",
        "ALTER TABLE orders ADD COLUMN pos_sync_status VARCHAR(40) NOT NULL DEFAULT 'pending'",
        "ALTER TABLE orders ADD COLUMN payment_method VARCHAR(40) NULL",
        "ALTER TABLE orders ADD COLUMN created_by VARCHAR(40) NOT NULL DEFAULT 'user'",
        "ALTER TABLE orders ADD COLUMN delivery_method VARCHAR(40) NOT NULL DEFAULT 'delivery'",
        "ALTER TABLE orders ADD COLUMN delivery_address TEXT NULL",
        "ALTER TABLE payments ADD COLUMN channel VARCHAR(40) NULL",
        "ALTER TABLE payments ADD COLUMN gateway_response VARCHAR(255) NULL",
        "ALTER TABLE products ADD COLUMN slug VARCHAR(190) NULL",
        "ALTER TABLE products ADD COLUMN short_description TEXT NULL",
        "ALTER TABLE products ADD COLUMN full_description LONGTEXT NULL",
        "ALTER TABLE products ADD COLUMN cost_price DECIMAL(14,2) NOT NULL DEFAULT 0",
        "ALTER TABLE products ADD COLUMN minimum_stock INT NOT NULL DEFAULT 5",
        "ALTER TABLE products ADD COLUMN warranty_info VARCHAR(255) NULL",
        "ALTER TABLE products ADD COLUMN is_visible_online TINYINT(1) NOT NULL DEFAULT 1",
        "ALTER TABLE products ADD COLUMN is_featured TINYINT(1) NOT NULL DEFAULT 0",
        "ALTER TABLE products ADD COLUMN selling_price DECIMAL(14,2) NOT NULL DEFAULT 0",
        "ALTER TABLE pos_sync_logs ADD COLUMN sync_type VARCHAR(40) NOT NULL DEFAULT 'order_push'",
        "ALTER TABLE carts ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'active'",
        "ALTER TABLE carts ADD COLUMN session_token VARCHAR(64) NULL",
        "ALTER TABLE orders MODIFY customer_email VARCHAR(190) NULL",
        "ALTER TABLE orders MODIFY customer_phone VARCHAR(40) NULL",
        "ALTER TABLE cart_items MODIFY unit_price DECIMAL(12,2) NULL",
        "ALTER TABLE cart_items MODIFY snapshot_name VARCHAR(190) NULL",
        "ALTER TABLE settings ADD COLUMN setting_group VARCHAR(50) NOT NULL DEFAULT 'general' AFTER setting_key",
        "CREATE TABLE IF NOT EXISTS notifications (
            id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            user_id BIGINT UNSIGNED NULL,
            role_target VARCHAR(20) NOT NULL DEFAULT 'user',
            type VARCHAR(80) NOT NULL,
            title VARCHAR(190) NOT NULL,
            message TEXT NULL,
            data JSON NULL,
            is_read TINYINT(1) NOT NULL DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    ];

    foreach ($queries as $sql) {
        try {
            $db->exec($sql);
            echo "<div style='color:green'>Success: $sql</div>";
        } catch (PDOException $e) {
            // Error 1060 is "Duplicate column name", which is fine if it already exists.
            if ($e->errorInfo[1] == 1060) {
                echo "<div style='color:gray'>Already exists (ignored): $sql</div>";
            } else {
                echo "<div style='color:red'>Error running '$sql': " . $e->getMessage() . "</div>";
            }
        }
    }

    // Try to create the uploads directory to fix the image upload 422 error
    echo "<h3>Fixing Upload Directories</h3>";
    $uploadDir = __DIR__ . '/public/uploads/products';
    if (!is_dir($uploadDir)) {
        if (@mkdir($uploadDir, 0777, true)) {
            echo "<div style='color:green'>Successfully created uploads directory: public/uploads/products</div>";
        } else {
            echo "<div style='color:red'>Failed to create uploads directory. Please manually create 'public/uploads/products' and set permissions to 777.</div>";
        }
    } else {
        @chmod($uploadDir, 0777);
        echo "<div style='color:green'>Uploads directory already exists. Attempted to set permissions to 777.</div>";
    }

    echo "<br><strong style='color:green;'>Finished! Please refresh your Admin Dashboard.</strong>";

} catch (Exception $e) {
    echo "<br><strong style='color:red;'>Fatal Error: " . $e->getMessage() . "</strong>";
}
