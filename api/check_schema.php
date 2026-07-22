<?php
require 'vendor/autoload.php';
$db = \App\Core\Database::connection();
try {
    $stmt = $db->query('DESCRIBE orders');
    print_r($stmt->fetchAll(PDO::FETCH_ASSOC));
} catch (Exception $e) {
    echo "Orders error: " . $e->getMessage() . "\n";
}

try {
    $stmt2 = $db->query('DESCRIBE user_activity_logs');
    print_r($stmt2->fetchAll(PDO::FETCH_ASSOC));
} catch (Exception $e) {
    echo "Logs error: " . $e->getMessage() . "\n";
}
