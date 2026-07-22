<?php
/**
 * YAROTECH - Invoice Migration Script
 * Safely migrates data from invoices.sql to orders and order_items.
 */
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

    // 1. Read the invoices.sql file
    $sqlFile = dirname(__DIR__, 2) . '/invoices.sql';
    if (!file_exists($sqlFile)) {
        die("Error: invoices.sql not found at $sqlFile\n");
    }

    $sqlContent = file_get_contents($sqlFile);

    // 2. Modify it to use a TEMPORARY table so we don't temper with DB architecture
    $sqlContent = str_replace('CREATE TABLE `invoices`', 'CREATE TEMPORARY TABLE `tmp_invoices`', $sqlContent);
    $sqlContent = str_replace('INSERT INTO `invoices`', 'INSERT INTO `tmp_invoices`', $sqlContent);
    
    // Remove the CHECK constraint which might cause issues in older MariaDB versions or tmp tables
    $sqlContent = preg_replace('/CHECK \(json_valid\(`products`\)\)/', '', $sqlContent);

    echo "Creating temporary table and loading data...\n";
    $db->exec($sqlContent);

    // 3. Fetch all records from the temporary table
    $stmt = $db->query("SELECT * FROM tmp_invoices");
    $invoices = $stmt->fetchAll();

    echo "Found " . count($invoices) . " invoices to migrate.\n";

    $successCount = 0;
    $errorCount = 0;

    $db->beginTransaction();

    foreach ($invoices as $inv) {
        try {
            // Map to orders table
            $orderInsert = $db->prepare("
                INSERT INTO orders (
                    order_number, 
                    customer_name, 
                    customer_phone,
                    subtotal, 
                    tax_amount, 
                    total_amount, 
                    order_status, 
                    payment_status, 
                    sale_channel,
                    created_by,
                    created_at,
                    updated_at
                ) VALUES (
                    :order_number,
                    :customer_name,
                    :customer_phone,
                    :subtotal,
                    :tax_amount,
                    :total_amount,
                    'delivered',
                    'success',
                    'pos',
                    :created_by,
                    :created_at,
                    :updated_at
                )
            ");

            $orderInsert->execute([
                ':order_number' => $inv['invoice_number'],
                ':customer_name' => $inv['customer_name'] ?: 'Unknown Customer',
                ':customer_phone' => $inv['company_phone'], // Some invoices put customer phone here or company phone, retaining just in case
                ':subtotal' => $inv['subtotal'],
                ':tax_amount' => $inv['tax'],
                ':total_amount' => $inv['total'],
                ':created_by' => $inv['issuer_name'] ?: 'admin',
                ':created_at' => $inv['created_at'],
                ':updated_at' => $inv['created_at']
            ]);

            $orderId = $db->lastInsertId();

            // Map order items
            $productsJson = $inv['products'];
            if (!empty($productsJson)) {
                $products = json_decode($productsJson, true);
                
                if (json_last_error() !== JSON_ERROR_NONE) {
                    throw new Exception("Invalid JSON in products for invoice " . $inv['invoice_number']);
                }

                if (is_array($products)) {
                    $itemInsert = $db->prepare("
                        INSERT INTO order_items (
                            order_id,
                            product_id,
                            product_name_snapshot,
                            unit_price_snapshot,
                            quantity,
                            line_total
                        ) VALUES (
                            :order_id,
                            :product_id,
                            :product_name_snapshot,
                            :unit_price_snapshot,
                            :quantity,
                            :line_total
                        )
                    ");

                    foreach ($products as $prod) {
                        if (!isset($prod['id']) || !isset($prod['name']) || !isset($prod['price']) || !isset($prod['quantity'])) {
                            throw new Exception("Missing required product fields in JSON for invoice " . $inv['invoice_number']);
                        }

                        $itemInsert->execute([
                            ':order_id' => $orderId,
                            ':product_id' => $prod['id'],
                            ':product_name_snapshot' => $prod['name'],
                            ':unit_price_snapshot' => $prod['price'],
                            ':quantity' => $prod['quantity'],
                            ':line_total' => $prod['price'] * $prod['quantity']
                        ]);
                    }
                }
            }

            $successCount++;
        } catch (Exception $e) {
            echo "Error migrating invoice {$inv['invoice_number']}: " . $e->getMessage() . "\n";
            $errorCount++;
        }
    }

    $db->commit();
    echo "\nMigration completed successfully!\n";
    echo "Successfully migrated: $successCount\n";
    if ($errorCount > 0) {
        echo "Failed to migrate: $errorCount\n";
    }

} catch (Exception $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    echo "Fatal Error: " . $e->getMessage() . "\n";
}
