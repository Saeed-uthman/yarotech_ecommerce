<?php

$products = [
    ['name' => 'Starlink Standard Kit', 'cat' => 'Networking', 'price' => 450000, 'cost' => 400000],
    ['name' => 'Starlink High Performance Kit', 'cat' => 'Networking', 'price' => 1200000, 'cost' => 1100000],
    ['name' => 'Hikvision 4-Channel CCTV System', 'cat' => 'Security', 'price' => 120000, 'cost' => 95000],
    ['name' => 'Dahua 8-Channel NVR System', 'cat' => 'Security', 'price' => 180000, 'cost' => 150000],
    ['name' => 'Felicity 5KVA Hybrid Inverter', 'cat' => 'Solar', 'price' => 750000, 'cost' => 650000],
    ['name' => 'Luminous 3.5KVA Solar Inverter', 'cat' => 'Solar', 'price' => 450000, 'cost' => 380000],
    ['name' => 'Mikrotik hEX RB750Gr3 Router', 'cat' => 'Networking', 'price' => 65000, 'cost' => 50000],
    ['name' => 'Mikrotik Cloud Router Switch CRS326', 'cat' => 'Networking', 'price' => 250000, 'cost' => 210000],
    ['name' => 'Ubiquiti UniFi U6 Lite AP', 'cat' => 'Networking', 'price' => 140000, 'cost' => 120000],
    ['name' => 'Ubiquiti UniFi Dream Machine Pro', 'cat' => 'Networking', 'price' => 650000, 'cost' => 580000],
    ['name' => 'Cisco Catalyst 2960-X Switch', 'cat' => 'Networking', 'price' => 850000, 'cost' => 700000],
    ['name' => 'TP-Link 24-Port Gigabit Switch', 'cat' => 'Networking', 'price' => 55000, 'cost' => 45000],
    ['name' => 'APC Smart-UPS 1500VA', 'cat' => 'Power', 'price' => 350000, 'cost' => 300000],
    ['name' => 'Mercury 2KVA Offline UPS', 'cat' => 'Power', 'price' => 85000, 'cost' => 70000],
    ['name' => 'CAT6 UTP Ethernet Cable (305m)', 'cat' => 'Networking', 'price' => 110000, 'cost' => 90000],
    ['name' => 'Fiber Optic Patch Cord SC/APC', 'cat' => 'Networking', 'price' => 5000, 'cost' => 2500],
    ['name' => 'Canadian Solar 450W Panel', 'cat' => 'Solar', 'price' => 145000, 'cost' => 125000],
    ['name' => 'Jinko 550W Mono Solar Panel', 'cat' => 'Solar', 'price' => 165000, 'cost' => 140000],
    ['name' => 'Tubular Battery 200Ah 12V', 'cat' => 'Power', 'price' => 280000, 'cost' => 250000],
    ['name' => 'Lithium Ion Battery 48V 100Ah', 'cat' => 'Power', 'price' => 1350000, 'cost' => 1200000],
];

$sql = "SET FOREIGN_KEY_CHECKS = 0;\n\n";

// 1. PRODUCTS (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- PRODUCTS\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE products;\n";
$sql .= "INSERT INTO products (id, name, sku, category, slug, short_description, full_description, cost_price, selling_price, stock_quantity, minimum_stock, status) VALUES\n";
$pVals = [];
foreach ($products as $i => $p) {
    $idx = $i + 1;
    $id = "PRD-" . str_pad((string)$idx, 3, '0', STR_PAD_LEFT);
    $sku = "SKU-YARO-" . $idx;
    $slug = strtolower(str_replace([' ', '/'], '-', $p['name']));
    $pVals[] = "('$id', '{$p['name']}', '$sku', '{$p['cat']}', '$slug', 'High quality {$p['name']}', 'Full details for {$p['name']}. Ideal for professional deployments.', {$p['cost']}, {$p['price']}, 50, 5, 'active')";
}
$sql .= implode(",\n", $pVals) . ";\n\n";

// 2. PRODUCT IMAGES (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- PRODUCT IMAGES\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE product_images;\n";
$sql .= "INSERT INTO product_images (product_id, image_path, alt_text, is_primary) VALUES\n";
$imgVals = [];
foreach ($products as $i => $p) {
    $idx = $i + 1;
    $id = "PRD-" . str_pad((string)$idx, 3, '0', STR_PAD_LEFT);
    $imgVals[] = "('$id', '/uploads/products/placeholder.jpg', '{$p['name']}', 1)";
}
$sql .= implode(",\n", $imgVals) . ";\n\n";

// 3. PRODUCT SPECIFICATIONS (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- PRODUCT SPECIFICATIONS\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE product_specifications;\n";
$sql .= "INSERT INTO product_specifications (product_id, spec_group, spec_name, spec_value) VALUES\n";
$specVals = [];
foreach ($products as $i => $p) {
    $idx = $i + 1;
    $id = "PRD-" . str_pad((string)$idx, 3, '0', STR_PAD_LEFT);
    $specVals[] = "('$id', 'General', 'Brand', 'Yarotech Certified')";
}
$sql .= implode(",\n", $specVals) . ";\n\n";

// 4. INVENTORY MOVEMENTS (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- INVENTORY MOVEMENTS\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE inventory_movements;\n";
$sql .= "INSERT INTO inventory_movements (product_id, movement_type, quantity, previous_stock, new_stock, created_by) VALUES\n";
$invVals = [];
foreach ($products as $i => $p) {
    $idx = $i + 1;
    $id = "PRD-" . str_pad((string)$idx, 3, '0', STR_PAD_LEFT);
    $invVals[] = "('$id', 'initial_stock', 50, 0, 50, 'system')";
}
$sql .= implode(",\n", $invVals) . ";\n\n";

// 5. ORDERS & ORDER ITEMS (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- ORDERS & ORDER ITEMS\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE orders;\n";
$sql .= "TRUNCATE TABLE order_items;\n";
$sql .= "INSERT INTO orders (id, order_number, customer_name, customer_email, shipping_json, subtotal, tax_amount, delivery_fee, total_amount, order_status, payment_status, sale_channel) VALUES\n";
$oVals = [];
$oiVals = [];
for ($i = 1; $i <= 20; $i++) {
    $orderNo = "ORD-2026-" . str_pad((string)$i, 4, '0', STR_PAD_LEFT);
    $p1 = $products[($i * 2) % 20];
    $p1Id = "PRD-" . str_pad((string)((($i * 2) % 20) + 1), 3, '0', STR_PAD_LEFT);
    $qty = rand(1, 3);
    $subtotal = $p1['price'] * $qty;
    $tax = $subtotal * 0.075;
    $total = $subtotal + $tax + 5000;
    
    $oVals[] = "($i, '$orderNo', 'Customer $i', 'customer$i@example.com', '{}', $subtotal, $tax, 5000, $total, 'delivered', 'success', 'ecommerce')";
    $oiVals[] = "($i, $i, '$p1Id', '{$p1['name']}', 'SKU-YARO-".((($i * 2) % 20) + 1)."', {$p1['price']}, $qty, $subtotal)";
}
$sql .= implode(",\n", $oVals) . ";\n\n";
$sql .= "INSERT INTO order_items (id, order_id, product_id, product_name_snapshot, sku_snapshot, unit_price_snapshot, quantity, line_total) VALUES\n";
$sql .= implode(",\n", $oiVals) . ";\n\n";

// 6. PAYMENTS (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- PAYMENTS\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE payments;\n";
$sql .= "INSERT INTO payments (order_id, provider, reference, amount, status) VALUES\n";
$payVals = [];
for ($i = 1; $i <= 20; $i++) {
    $p1 = $products[($i * 2) % 20];
    $qty = rand(1, 3);
    $subtotal = $p1['price'] * $qty;
    $total = $subtotal + ($subtotal * 0.075) + 5000;
    $ref = "PAY_" . uniqid();
    $payVals[] = "($i, 'paystack', '$ref', $total, 'success')";
}
$sql .= implode(",\n", $payVals) . ";\n\n";

// 7. SETTINGS (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- SETTINGS\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE settings;\n";
$sql .= "INSERT INTO settings (setting_key, setting_group, setting_value) VALUES\n";
$setVals = [];
for ($i = 1; $i <= 20; $i++) {
    $setVals[] = "('dummy_setting_$i', 'general', '\"value_$i\"')";
}
$sql .= implode(",\n", $setVals) . ";\n\n";

// 8. DELIVERY ZONES (20 records)
$sql .= "-- --------------------------------------------------------\n";
$sql .= "-- DELIVERY ZONES\n";
$sql .= "-- --------------------------------------------------------\n";
$sql .= "TRUNCATE TABLE delivery_zones;\n";
$sql .= "INSERT INTO delivery_zones (state, city_or_lga, zone_name, base_fee) VALUES\n";
$delVals = [];
$states = ['Lagos', 'Abuja', 'Kano', 'Rivers', 'Oyo'];
for ($i = 1; $i <= 20; $i++) {
    $st = $states[$i % 5];
    $delVals[] = "('$st', 'City $i', '$st Zone $i', " . (1000 * $i) . ")";
}
$sql .= implode(",\n", $delVals) . ";\n\n";

$sql .= "SET FOREIGN_KEY_CHECKS = 1;\n";

file_put_contents(__DIR__ . '/database/dummy_seed.sql', $sql);
echo "Seed file generated at database/dummy_seed.sql\n";
