<?php
require __DIR__ . '/vendor/autoload.php';

$app = require __DIR__ . '/app/Core/bootstrap.php';
$db = \App\Core\Database::connection();

try {
    $db->exec("ALTER TABLE activity_logs MODIFY staff_id BIGINT UNSIGNED NULL");
    
    // Also, update schema.sql for future setups
    $schemaFile = __DIR__ . '/database/schema.sql';
    $schema = file_get_contents($schemaFile);
    $schema = preg_replace(
        '/staff_id\s+BIGINT UNSIGNED\s+NOT NULL,/',
        'staff_id      BIGINT UNSIGNED     NULL,',
        $schema
    );
    file_put_contents($schemaFile, $schema);
    
    echo "Successfully altered activity_logs schema.\n";
} catch (\Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
