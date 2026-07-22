<?php
$env = parse_ini_file('.env');
$dsn = "mysql:host={$env['DB_HOST']};dbname={$env['DB_NAME']};charset={$env['DB_CHARSET']}";
try {
    $pdo = new PDO($dsn, $env['DB_USER'], $env['DB_PASS']);
    $stmt = $pdo->query("DESCRIBE orders");
    echo "Columns in 'orders' table:\n";
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "- {$row['Field']} ({$row['Type']})\n";
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
