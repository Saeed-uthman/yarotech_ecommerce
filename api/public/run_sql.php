<?php
/**
 * Raw PHP script to alter orders table to make customer_email and customer_phone columns nullable.
 */
header('Content-Type: text/plain; charset=utf-8');

$host = '127.0.0.1';
$db   = 'yarotech_db';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
     $pdo = new PDO($dsn, $user, $pass, $options);
     echo "Connected to the database successfully!\n";

     echo "Altering customer_email in orders table...\n";
     $pdo->exec("ALTER TABLE orders MODIFY customer_email VARCHAR(190) NULL");
     echo "customer_email altered successfully!\n";

     echo "Altering customer_phone in orders table...\n";
     $pdo->exec("ALTER TABLE orders MODIFY customer_phone VARCHAR(40) NULL");
     echo "customer_phone altered successfully!\n";

     echo "SUCCESS! Both columns are now nullable.\n";
} catch (\PDOException $e) {
     echo "ERROR: " . $e->getMessage() . "\n";
}
