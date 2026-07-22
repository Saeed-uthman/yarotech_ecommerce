ALTER TABLE orders MODIFY COLUMN order_status ENUM('pending','paid','processing','ready_for_pickup','shipped','delivered','picked_up','cancelled','refunded','failed') NOT NULL DEFAULT 'pending';
