<?php
define('APP_BASE_PATH', dirname(__DIR__));
require __DIR__ . '/../vendor/autoload.php';
use App\Helpers\Env;
use App\Core\Database;
use App\Models\Order;

Env::load(__DIR__ . '/../.env');

try {
    $db = Database::connection();
    $orderModel = new Order();
    
    echo "Testing manual insert into orders table...\n";
    $testId = $orderModel->insert([
        'order_number' => 'TEST-' . time(),
        'customer_email' => 'test@example.com',
        'customer_phone' => '123456789',
        'customer_name' => 'Test User',
        'shipping_json' => json_encode(['method' => 'test']),
        'subtotal' => 0,
        'total_amount' => 0,
        'fulfillment_method' => 'pickup',
        'delivery_fee' => 0,
        'status' => 'pending',
        'sale_channel' => 'pos'
    ]);
    
    echo "Success! Inserted test order with ID: $testId\n";
    
    // Cleanup
    $db->exec("DELETE FROM orders WHERE id = $testId");
    echo "Cleaned up test order.\n";
    
} catch (Exception $e) {
    echo "Error during manual insert: " . $e->getMessage() . "\n";
}
