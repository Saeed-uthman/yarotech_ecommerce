<?php
$pdo = new PDO('mysql:host=127.0.0.1;dbname=yarotech_db', 'root', '');
try {
    $pdo->exec('ALTER TABLE products ADD COLUMN vat_enabled TINYINT(1) NOT NULL DEFAULT 1;');
    $pdo->exec('ALTER TABLE products ADD COLUMN max_markup DECIMAL(14,2) NOT NULL DEFAULT 0;');
    echo "Columns added successfully.\n";
} catch (PDOException $e) {
    if ($e->getCode() == '42S21') {
        echo "Columns already exist.\n";
    } else {
        echo "Error: " . $e->getMessage() . "\n";
    }
}
