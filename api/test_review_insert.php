<?php
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$dbConfig = config('database');
$dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['name']};charset={$dbConfig['charset']}";
$pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['password'], [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);

App\Core\Database::init($dbConfig);

try {
    $model = new App\Models\ProductReview();
    $id = $model->insert([
        'product_id' => 'test_product',
        'user_id'    => null, // Try null first
        'rating'     => 5,
        'review_text'=> 'Testing 123',
        'status'     => 'pending',
    ]);
    echo "Success: Inserted ID $id\n";
} catch (\Exception $e) {
    echo "Error inserting with null user_id: " . $e->getMessage() . "\n";
}

try {
    $model = new App\Models\ProductReview();
    $id = $model->insert([
        'product_id' => 'test_product',
        'user_id'    => 1, // Try valid user id
        'rating'     => 5,
        'review_text'=> 'Testing 123',
        'status'     => 'pending',
    ]);
    echo "Success: Inserted ID $id\n";
} catch (\Exception $e) {
    echo "Error inserting with user_id 1: " . $e->getMessage() . "\n";
}
