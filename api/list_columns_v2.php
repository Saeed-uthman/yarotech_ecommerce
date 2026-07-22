<?php
$host = '127.0.0.1';
$db   = 'yarotech_db';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
try {
    $pdo = new PDO($dsn, $user, $pass);
    $stmt = $pdo->query("DESCRIBE orders");
    echo "Columns in 'orders' table:\n";
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "- {$row['Field']} ({$row['Type']})\n";
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
