-- =====================================================================
-- YAROTECH — Unified Schema (Standalone Ecommerce)
-- Engine: InnoDB, charset utf8mb4 (full unicode + emoji safe).
--
-- This schema represents the fully decoupled, standalone ecommerce platform.
-- All external POS logic has been removed. Products, orders, and inventory
-- are completely self-contained.
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- USERS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(150)    NOT NULL,
    email           VARCHAR(190)    NOT NULL,
    phone           VARCHAR(30)         NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    role            ENUM('user','admin','staff') NOT NULL DEFAULT 'user',
    account_type    ENUM('individual','business') NULL,
    company_name    VARCHAR(190)        NULL,
    email_verified_at DATETIME          NULL,
    last_login_at     DATETIME          NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- AUTH OTPS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS auth_otps (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    email       VARCHAR(190)    NOT NULL,
    code_hash   VARCHAR(255)    NOT NULL,
    purpose     ENUM('verify_email','reset_password') NOT NULL,
    expires_at  DATETIME        NOT NULL,
    used_at     DATETIME            NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_auth_otps_email_purpose (email, purpose)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- USER ADDRESSES
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_addresses (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id     BIGINT UNSIGNED NOT NULL,
    label       VARCHAR(60)         NULL,
    full_name   VARCHAR(150)    NOT NULL,
    phone       VARCHAR(30)     NOT NULL,
    address_line1 VARCHAR(255)  NOT NULL,
    address_line2 VARCHAR(255)      NULL,
    city        VARCHAR(100)    NOT NULL,
    state       VARCHAR(100)    NOT NULL,
    country     VARCHAR(100)    NOT NULL DEFAULT 'Nigeria',
    is_default  TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_addresses_user (user_id),
    CONSTRAINT fk_addresses_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PRODUCTS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
    id                VARCHAR(64)     NOT NULL, -- PRD-...
    name              VARCHAR(190)    NOT NULL,
    sku               VARCHAR(80)     NOT NULL,
    category          VARCHAR(100)    NOT NULL DEFAULT 'Uncategorized',
    slug              VARCHAR(190)    NOT NULL,
    short_description TEXT                NULL,
    full_description  LONGTEXT            NULL,
    cost_price        DECIMAL(14,2)   NOT NULL DEFAULT 0,
    selling_price     DECIMAL(14,2)   NOT NULL DEFAULT 0,
    stock_quantity    INT             NOT NULL DEFAULT 0,
    minimum_stock     INT             NOT NULL DEFAULT 5,
    -- Added for POS compatibility
    vat_enabled       TINYINT(1)      NOT NULL DEFAULT 1,
    max_markup        DECIMAL(14,2)   NOT NULL DEFAULT 0,
    -- End POS compatibility
    warranty_info     VARCHAR(255)        NULL,
    is_visible_online TINYINT(1)      NOT NULL DEFAULT 1,
    is_featured       TINYINT(1)      NOT NULL DEFAULT 0,
    status            ENUM('active','inactive','archived') NOT NULL DEFAULT 'active',
    created_at        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_products_sku (sku),
    UNIQUE KEY uniq_products_slug (slug),
    KEY idx_products_category (category),
    KEY idx_products_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PRODUCT IMAGES
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_images (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id      VARCHAR(64)     NOT NULL,
    image_path      VARCHAR(255)    NOT NULL,
    alt_text        VARCHAR(150)        NULL,
    is_primary      TINYINT(1)      NOT NULL DEFAULT 0,
    sort_order      SMALLINT        NOT NULL DEFAULT 0,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_images_product (product_id, is_primary, sort_order),
    CONSTRAINT fk_images_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PRODUCT SPECIFICATIONS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_specifications (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id      VARCHAR(64)     NOT NULL,
    spec_group      VARCHAR(100)        NULL,
    spec_name       VARCHAR(100)    NOT NULL,
    spec_value      VARCHAR(255)    NOT NULL,
    sort_order      SMALLINT        NOT NULL DEFAULT 0,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_specs_product (product_id, sort_order),
    CONSTRAINT fk_specs_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PRODUCT REVIEWS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_reviews (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id      VARCHAR(64)     NOT NULL,
    user_id         BIGINT UNSIGNED     NULL,
    user_name       VARCHAR(150)        NULL,
    rating          TINYINT UNSIGNED NOT NULL,
    review_text     TEXT                NULL,
    status          ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_reviews_product (product_id, status),
    KEY idx_reviews_user (user_id),
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PRODUCT RELATED
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_related (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id          VARCHAR(64)     NOT NULL,
    related_product_id  VARCHAR(64)     NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_related_pair (product_id, related_product_id),
    KEY idx_related_product (product_id),
    CONSTRAINT fk_related_p1 FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_related_p2 FOREIGN KEY (related_product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- INVENTORY MOVEMENTS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS inventory_movements (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id      VARCHAR(64)     NOT NULL,
    movement_type   VARCHAR(60)     NOT NULL,
    quantity        INT             NOT NULL,
    previous_stock  INT             NOT NULL DEFAULT 0,
    new_stock       INT             NOT NULL,
    reference_type  VARCHAR(40)         NULL,
    reference_id    VARCHAR(120)        NULL,
    note            VARCHAR(255)        NULL,
    created_by      VARCHAR(64)         NULL,
    created_by_user_id BIGINT UNSIGNED  NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_inv_mov_product (product_id, created_at),
    CONSTRAINT fk_inv_mov_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- CART
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS carts (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id     BIGINT UNSIGNED     NULL,
    session_token VARCHAR(64)       NULL,
    status      VARCHAR(20)     NOT NULL DEFAULT 'active',
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_carts_user (user_id),
    KEY idx_carts_session (session_token),
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cart_items (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    cart_id         BIGINT UNSIGNED NOT NULL,
    product_id      VARCHAR(64)     NOT NULL,
    quantity        INT UNSIGNED    NOT NULL DEFAULT 1,
    unit_price      DECIMAL(12,2)       NULL,
    snapshot_name   VARCHAR(190)        NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_cart_product (cart_id, product_id),
    KEY idx_cart_items_cart (cart_id),
    CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- ORDERS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_number        VARCHAR(40)     NOT NULL,
    user_id             BIGINT UNSIGNED     NULL,
    customer_id         BIGINT UNSIGNED     NULL,
    customer_name       VARCHAR(150)    NOT NULL,
    customer_email      VARCHAR(190)        NULL,
    customer_phone      VARCHAR(40)         NULL,
    notes               TEXT                NULL,
    fulfillment_method  VARCHAR(40)     NOT NULL DEFAULT 'delivery',
    delivery_state      VARCHAR(100)        NULL,
    delivery_city       VARCHAR(100)        NULL,
    delivery_address    TEXT                NULL,
    delivery_landmark   VARCHAR(255)        NULL,
    delivery_phone      VARCHAR(40)         NULL,
    subtotal            DECIMAL(12,2)   NOT NULL,
    tax_amount          DECIMAL(12,2)   NOT NULL DEFAULT 0,
    discount            DECIMAL(14,2)   NOT NULL DEFAULT 0,
    tax                 DECIMAL(14,2)   NOT NULL DEFAULT 0,
    delivery_fee        DECIMAL(12,2)   NOT NULL DEFAULT 0,
    total_amount        DECIMAL(12,2)   NOT NULL,
    currency            CHAR(3)         NOT NULL DEFAULT 'NGN',
    order_status        ENUM('pending','paid','processing','ready_for_pickup','shipped','delivered','picked_up','cancelled','refunded','failed') NOT NULL DEFAULT 'pending',
    payment_status      VARCHAR(40)     NOT NULL DEFAULT 'pending',
    sale_channel        VARCHAR(40)     NOT NULL DEFAULT 'ecommerce',
    pos_sync_status     VARCHAR(40)     NOT NULL DEFAULT 'pending',
    payment_method      VARCHAR(40)         NULL,
    created_by          VARCHAR(40)     NOT NULL DEFAULT 'user',
    created_by_user_id  BIGINT UNSIGNED     NULL,
    inventory_reduced_at DATETIME           NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_orders_number (order_number),
    KEY idx_orders_user (user_id),
    KEY idx_orders_status (order_status, payment_status),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS order_items (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id        BIGINT UNSIGNED NOT NULL,
    product_id      VARCHAR(64)     NOT NULL,
    product_name_snapshot VARCHAR(190)    NOT NULL,
    sku_snapshot    VARCHAR(80)         NULL,
    unit_price_snapshot DECIMAL(12,2)   NOT NULL DEFAULT 0,
    quantity        INT UNSIGNED    NOT NULL,
    line_total      DECIMAL(12,2)   NOT NULL,
    PRIMARY KEY (id),
    KEY idx_order_items_order (order_id),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- DELIVERY ZONES
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS delivery_zones (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    state VARCHAR(100) NOT NULL,
    city_or_lga VARCHAR(100) NOT NULL,
    zone_name VARCHAR(150) NOT NULL,
    base_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
    extra_fee_per_kg DECIMAL(12,2) NOT NULL DEFAULT 0,
    eta_text VARCHAR(100) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_zone_state_city (state, city_or_lga)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PAYMENTS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id        BIGINT UNSIGNED NOT NULL,
    provider        VARCHAR(40)     NOT NULL DEFAULT 'paystack',
    channel         VARCHAR(40)         NULL,
    payment_method  VARCHAR(40)         NULL,
    reference       VARCHAR(120)    NOT NULL,
    amount          DECIMAL(12,2)   NOT NULL,
    currency        CHAR(3)         NOT NULL DEFAULT 'NGN',
    status          ENUM('initialized','processing','success','failed','refunded') NOT NULL DEFAULT 'initialized',
    raw_response    JSON                NULL,
    gateway_response VARCHAR(255)       NULL,
    paid_at         DATETIME            NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_payments_reference (reference),
    KEY idx_payments_order (order_id),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- STAFF ACTIVITY LOGS (Eye in the Sky)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS activity_logs (
    id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    staff_id      BIGINT UNSIGNED     NULL,
    action_type   VARCHAR(64)     NOT NULL,
    description   TEXT            NOT NULL,
    reference_id  BIGINT UNSIGNED     NULL,
    is_read       TINYINT(1)      NOT NULL DEFAULT 0,
    created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_activity_logs_staff (staff_id),
    KEY idx_activity_logs_read (is_read),
    CONSTRAINT fk_activity_logs_staff FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- NOTIFICATIONS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS notifications (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id     BIGINT UNSIGNED     NULL,
    role_target VARCHAR(20)     NOT NULL DEFAULT 'user',
    type        VARCHAR(80)     NOT NULL,
    title       VARCHAR(190)    NOT NULL,
    message     TEXT                NULL,
    data        JSON                NULL,
    is_read     TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_notifications_role (role_target, is_read),
    KEY idx_notifications_user (user_id, is_read),
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- CONTACT MESSAGES
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contact_messages (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(150)    NOT NULL,
    email       VARCHAR(190)    NOT NULL,
    phone       VARCHAR(30)         NULL,
    subject         VARCHAR(190)        NULL,
    inquiry_type    ENUM('General Inquiry', 'Product Support', 'Delivery Support', 'Service Inquiry', 'Payment Issue', 'Complaint') NOT NULL DEFAULT 'General Inquiry',
    service_type    ENUM('Not applicable', 'Solar Installation', 'CCTV Installation', 'Internet Networking', 'IT Services') NULL,
    message         TEXT            NOT NULL,
    status          ENUM('open','in_progress','resolved') NOT NULL DEFAULT 'open',
    admin_reply     TEXT                NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_contact_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- USER ACTIVITY AUDIT
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_activity_logs (
    id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id       BIGINT UNSIGNED     NULL,
    activity_type VARCHAR(80)     NOT NULL,
    status        ENUM('success','failed') NOT NULL DEFAULT 'success',
    ip_address    VARCHAR(45)         NULL,
    user_agent    VARCHAR(255)        NULL,
    metadata      JSON                NULL,
    created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_user_activity (user_id, activity_type),
    CONSTRAINT fk_user_activity_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- SETTINGS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS settings (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    setting_key     VARCHAR(120)    NOT NULL,
    setting_group   VARCHAR(50)     NOT NULL DEFAULT 'general',
    setting_value   JSON                NULL,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_settings_key (setting_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- EMAIL LOGS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS email_logs (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    recipient_email     VARCHAR(190)    NOT NULL,
    subject             VARCHAR(255)    NOT NULL,
    email_type          VARCHAR(80)     NOT NULL DEFAULT 'generic',
    status              ENUM('sent','failed') NOT NULL DEFAULT 'sent',
    error_message       TEXT                NULL,
    related_entity_type VARCHAR(80)         NULL,
    related_entity_id   VARCHAR(80)         NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_email_logs_status (status),
    KEY idx_email_logs_type (email_type),
    KEY idx_email_logs_recipient (recipient_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- ORDER TRACKING
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_tracking (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id    BIGINT UNSIGNED NOT NULL,
    status      VARCHAR(64)     NOT NULL,
    title       VARCHAR(150)    NOT NULL,
    description TEXT                NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_tracking_order (order_id),
    CONSTRAINT fk_tracking_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PAYMENT EVENTS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payment_events (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    payment_id  BIGINT UNSIGNED     NULL,
    reference   VARCHAR(120)    NOT NULL,
    event_type  VARCHAR(64)     NOT NULL,
    payload     JSON                NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_payment_events_ref (reference),
    KEY idx_payment_events_pid (payment_id),
    CONSTRAINT fk_payment_events_payment FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
 

-- =====================================================================
-- SEEDS
-- =====================================================================


-- =====================================================================
-- YAROTECH — base seed (Phase 1 placeholder)
--
-- Real seed data (admin user, baseline settings, sample notifications,
-- demo product metadata) will be added in later phases as those
-- modules come online. For now we only insert a default admin row
-- and a couple of settings rows so the dashboard has something to read.
--
-- The password hash below corresponds to the password 'admin123'
-- (PASSWORD_BCRYPT, cost 10) — change immediately in production.
-- =====================================================================

INSERT INTO users (full_name, email, phone, password_hash, role, email_verified_at)
VALUES (
    'YAROTECH Admin',
    'admin@yarotech.ng',
    '+2348000000000',
    '$2y$10$wH8Qw7s3pQ9p1lU3M0o0cuJv1n8X3xH7qFq3sQ1mC8aB1uYy3lM4y',
    'admin',
    NOW()
)
ON DUPLICATE KEY UPDATE role = VALUES(role);

INSERT INTO settings (key_name, value_json) VALUES
    ('store_name',  JSON_QUOTE('YAROTECH')),
    ('vat_percent', CAST('7.5' AS JSON)),
    ('currency',    JSON_QUOTE('NGN'))
ON DUPLICATE KEY UPDATE value_json = VALUES(value_json);
SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------
-- PRODUCTS
-- --------------------------------------------------------
TRUNCATE TABLE products;
INSERT INTO products (id, name, sku, category, slug, short_description, full_description, cost_price, selling_price, stock_quantity, minimum_stock, status) VALUES
('PRD-001', 'Starlink Standard Kit', 'SKU-YARO-1', 'Networking', 'starlink-standard-kit', 'High quality Starlink Standard Kit', 'Full details for Starlink Standard Kit. Ideal for professional deployments.', 400000, 450000, 50, 5, 'active'),
('PRD-002', 'Starlink High Performance Kit', 'SKU-YARO-2', 'Networking', 'starlink-high-performance-kit', 'High quality Starlink High Performance Kit', 'Full details for Starlink High Performance Kit. Ideal for professional deployments.', 1100000, 1200000, 50, 5, 'active'),
('PRD-003', 'Hikvision 4-Channel CCTV System', 'SKU-YARO-3', 'Security', 'hikvision-4-channel-cctv-system', 'High quality Hikvision 4-Channel CCTV System', 'Full details for Hikvision 4-Channel CCTV System. Ideal for professional deployments.', 95000, 120000, 50, 5, 'active'),
('PRD-004', 'Dahua 8-Channel NVR System', 'SKU-YARO-4', 'Security', 'dahua-8-channel-nvr-system', 'High quality Dahua 8-Channel NVR System', 'Full details for Dahua 8-Channel NVR System. Ideal for professional deployments.', 150000, 180000, 50, 5, 'active'),
('PRD-005', 'Felicity 5KVA Hybrid Inverter', 'SKU-YARO-5', 'Solar', 'felicity-5kva-hybrid-inverter', 'High quality Felicity 5KVA Hybrid Inverter', 'Full details for Felicity 5KVA Hybrid Inverter. Ideal for professional deployments.', 650000, 750000, 50, 5, 'active'),
('PRD-006', 'Luminous 3.5KVA Solar Inverter', 'SKU-YARO-6', 'Solar', 'luminous-3.5kva-solar-inverter', 'High quality Luminous 3.5KVA Solar Inverter', 'Full details for Luminous 3.5KVA Solar Inverter. Ideal for professional deployments.', 380000, 450000, 50, 5, 'active'),
('PRD-007', 'Mikrotik hEX RB750Gr3 Router', 'SKU-YARO-7', 'Networking', 'mikrotik-hex-rb750gr3-router', 'High quality Mikrotik hEX RB750Gr3 Router', 'Full details for Mikrotik hEX RB750Gr3 Router. Ideal for professional deployments.', 50000, 65000, 50, 5, 'active'),
('PRD-008', 'Mikrotik Cloud Router Switch CRS326', 'SKU-YARO-8', 'Networking', 'mikrotik-cloud-router-switch-crs326', 'High quality Mikrotik Cloud Router Switch CRS326', 'Full details for Mikrotik Cloud Router Switch CRS326. Ideal for professional deployments.', 210000, 250000, 50, 5, 'active'),
('PRD-009', 'Ubiquiti UniFi U6 Lite AP', 'SKU-YARO-9', 'Networking', 'ubiquiti-unifi-u6-lite-ap', 'High quality Ubiquiti UniFi U6 Lite AP', 'Full details for Ubiquiti UniFi U6 Lite AP. Ideal for professional deployments.', 120000, 140000, 50, 5, 'active'),
('PRD-010', 'Ubiquiti UniFi Dream Machine Pro', 'SKU-YARO-10', 'Networking', 'ubiquiti-unifi-dream-machine-pro', 'High quality Ubiquiti UniFi Dream Machine Pro', 'Full details for Ubiquiti UniFi Dream Machine Pro. Ideal for professional deployments.', 580000, 650000, 50, 5, 'active'),
('PRD-011', 'Cisco Catalyst 2960-X Switch', 'SKU-YARO-11', 'Networking', 'cisco-catalyst-2960-x-switch', 'High quality Cisco Catalyst 2960-X Switch', 'Full details for Cisco Catalyst 2960-X Switch. Ideal for professional deployments.', 700000, 850000, 50, 5, 'active'),
('PRD-012', 'TP-Link 24-Port Gigabit Switch', 'SKU-YARO-12', 'Networking', 'tp-link-24-port-gigabit-switch', 'High quality TP-Link 24-Port Gigabit Switch', 'Full details for TP-Link 24-Port Gigabit Switch. Ideal for professional deployments.', 45000, 55000, 50, 5, 'active'),
('PRD-013', 'APC Smart-UPS 1500VA', 'SKU-YARO-13', 'Power', 'apc-smart-ups-1500va', 'High quality APC Smart-UPS 1500VA', 'Full details for APC Smart-UPS 1500VA. Ideal for professional deployments.', 300000, 350000, 50, 5, 'active'),
('PRD-014', 'Mercury 2KVA Offline UPS', 'SKU-YARO-14', 'Power', 'mercury-2kva-offline-ups', 'High quality Mercury 2KVA Offline UPS', 'Full details for Mercury 2KVA Offline UPS. Ideal for professional deployments.', 70000, 85000, 50, 5, 'active'),
('PRD-015', 'CAT6 UTP Ethernet Cable (305m)', 'SKU-YARO-15', 'Networking', 'cat6-utp-ethernet-cable-(305m)', 'High quality CAT6 UTP Ethernet Cable (305m)', 'Full details for CAT6 UTP Ethernet Cable (305m). Ideal for professional deployments.', 90000, 110000, 50, 5, 'active'),
('PRD-016', 'Fiber Optic Patch Cord SC/APC', 'SKU-YARO-16', 'Networking', 'fiber-optic-patch-cord-sc-apc', 'High quality Fiber Optic Patch Cord SC/APC', 'Full details for Fiber Optic Patch Cord SC/APC. Ideal for professional deployments.', 2500, 5000, 50, 5, 'active'),
('PRD-017', 'Canadian Solar 450W Panel', 'SKU-YARO-17', 'Solar', 'canadian-solar-450w-panel', 'High quality Canadian Solar 450W Panel', 'Full details for Canadian Solar 450W Panel. Ideal for professional deployments.', 125000, 145000, 50, 5, 'active'),
('PRD-018', 'Jinko 550W Mono Solar Panel', 'SKU-YARO-18', 'Solar', 'jinko-550w-mono-solar-panel', 'High quality Jinko 550W Mono Solar Panel', 'Full details for Jinko 550W Mono Solar Panel. Ideal for professional deployments.', 140000, 165000, 50, 5, 'active'),
('PRD-019', 'Tubular Battery 200Ah 12V', 'SKU-YARO-19', 'Power', 'tubular-battery-200ah-12v', 'High quality Tubular Battery 200Ah 12V', 'Full details for Tubular Battery 200Ah 12V. Ideal for professional deployments.', 250000, 280000, 50, 5, 'active'),
('PRD-020', 'Lithium Ion Battery 48V 100Ah', 'SKU-YARO-20', 'Power', 'lithium-ion-battery-48v-100ah', 'High quality Lithium Ion Battery 48V 100Ah', 'Full details for Lithium Ion Battery 48V 100Ah. Ideal for professional deployments.', 1200000, 1350000, 50, 5, 'active');

-- --------------------------------------------------------
-- PRODUCT IMAGES
-- --------------------------------------------------------
TRUNCATE TABLE product_images;
INSERT INTO product_images (product_id, image_path, alt_text, is_primary) VALUES
('PRD-001', '/uploads/products/placeholder.jpg', 'Starlink Standard Kit', 1),
('PRD-002', '/uploads/products/placeholder.jpg', 'Starlink High Performance Kit', 1),
('PRD-003', '/uploads/products/placeholder.jpg', 'Hikvision 4-Channel CCTV System', 1),
('PRD-004', '/uploads/products/placeholder.jpg', 'Dahua 8-Channel NVR System', 1),
('PRD-005', '/uploads/products/placeholder.jpg', 'Felicity 5KVA Hybrid Inverter', 1),
('PRD-006', '/uploads/products/placeholder.jpg', 'Luminous 3.5KVA Solar Inverter', 1),
('PRD-007', '/uploads/products/placeholder.jpg', 'Mikrotik hEX RB750Gr3 Router', 1),
('PRD-008', '/uploads/products/placeholder.jpg', 'Mikrotik Cloud Router Switch CRS326', 1),
('PRD-009', '/uploads/products/placeholder.jpg', 'Ubiquiti UniFi U6 Lite AP', 1),
('PRD-010', '/uploads/products/placeholder.jpg', 'Ubiquiti UniFi Dream Machine Pro', 1),
('PRD-011', '/uploads/products/placeholder.jpg', 'Cisco Catalyst 2960-X Switch', 1),
('PRD-012', '/uploads/products/placeholder.jpg', 'TP-Link 24-Port Gigabit Switch', 1),
('PRD-013', '/uploads/products/placeholder.jpg', 'APC Smart-UPS 1500VA', 1),
('PRD-014', '/uploads/products/placeholder.jpg', 'Mercury 2KVA Offline UPS', 1),
('PRD-015', '/uploads/products/placeholder.jpg', 'CAT6 UTP Ethernet Cable (305m)', 1),
('PRD-016', '/uploads/products/placeholder.jpg', 'Fiber Optic Patch Cord SC/APC', 1),
('PRD-017', '/uploads/products/placeholder.jpg', 'Canadian Solar 450W Panel', 1),
('PRD-018', '/uploads/products/placeholder.jpg', 'Jinko 550W Mono Solar Panel', 1),
('PRD-019', '/uploads/products/placeholder.jpg', 'Tubular Battery 200Ah 12V', 1),
('PRD-020', '/uploads/products/placeholder.jpg', 'Lithium Ion Battery 48V 100Ah', 1);

-- --------------------------------------------------------
-- PRODUCT SPECIFICATIONS
-- --------------------------------------------------------
TRUNCATE TABLE product_specifications;
INSERT INTO product_specifications (product_id, spec_group, spec_name, spec_value) VALUES
('PRD-001', 'General', 'Brand', 'Yarotech Certified'),
('PRD-002', 'General', 'Brand', 'Yarotech Certified'),
('PRD-003', 'General', 'Brand', 'Yarotech Certified'),
('PRD-004', 'General', 'Brand', 'Yarotech Certified'),
('PRD-005', 'General', 'Brand', 'Yarotech Certified'),
('PRD-006', 'General', 'Brand', 'Yarotech Certified'),
('PRD-007', 'General', 'Brand', 'Yarotech Certified'),
('PRD-008', 'General', 'Brand', 'Yarotech Certified'),
('PRD-009', 'General', 'Brand', 'Yarotech Certified'),
('PRD-010', 'General', 'Brand', 'Yarotech Certified'),
('PRD-011', 'General', 'Brand', 'Yarotech Certified'),
('PRD-012', 'General', 'Brand', 'Yarotech Certified'),
('PRD-013', 'General', 'Brand', 'Yarotech Certified'),
('PRD-014', 'General', 'Brand', 'Yarotech Certified'),
('PRD-015', 'General', 'Brand', 'Yarotech Certified'),
('PRD-016', 'General', 'Brand', 'Yarotech Certified'),
('PRD-017', 'General', 'Brand', 'Yarotech Certified'),
('PRD-018', 'General', 'Brand', 'Yarotech Certified'),
('PRD-019', 'General', 'Brand', 'Yarotech Certified'),
('PRD-020', 'General', 'Brand', 'Yarotech Certified');

-- --------------------------------------------------------
-- INVENTORY MOVEMENTS
-- --------------------------------------------------------
TRUNCATE TABLE inventory_movements;
INSERT INTO inventory_movements (product_id, movement_type, quantity, previous_stock, new_stock, created_by) VALUES
('PRD-001', 'initial_stock', 50, 0, 50, 'system'),
('PRD-002', 'initial_stock', 50, 0, 50, 'system'),
('PRD-003', 'initial_stock', 50, 0, 50, 'system'),
('PRD-004', 'initial_stock', 50, 0, 50, 'system'),
('PRD-005', 'initial_stock', 50, 0, 50, 'system'),
('PRD-006', 'initial_stock', 50, 0, 50, 'system'),
('PRD-007', 'initial_stock', 50, 0, 50, 'system'),
('PRD-008', 'initial_stock', 50, 0, 50, 'system'),
('PRD-009', 'initial_stock', 50, 0, 50, 'system'),
('PRD-010', 'initial_stock', 50, 0, 50, 'system'),
('PRD-011', 'initial_stock', 50, 0, 50, 'system'),
('PRD-012', 'initial_stock', 50, 0, 50, 'system'),
('PRD-013', 'initial_stock', 50, 0, 50, 'system'),
('PRD-014', 'initial_stock', 50, 0, 50, 'system'),
('PRD-015', 'initial_stock', 50, 0, 50, 'system'),
('PRD-016', 'initial_stock', 50, 0, 50, 'system'),
('PRD-017', 'initial_stock', 50, 0, 50, 'system'),
('PRD-018', 'initial_stock', 50, 0, 50, 'system'),
('PRD-019', 'initial_stock', 50, 0, 50, 'system'),
('PRD-020', 'initial_stock', 50, 0, 50, 'system');

-- --------------------------------------------------------
-- ORDERS & ORDER ITEMS
-- --------------------------------------------------------
TRUNCATE TABLE orders;
TRUNCATE TABLE order_items;
INSERT INTO orders (id, order_number, customer_name, customer_email, shipping_json, subtotal, tax_amount, delivery_fee, total_amount, order_status, payment_status, sale_channel) VALUES
(1, 'ORD-2026-0001', 'Customer 1', 'customer1@example.com', '{}', 240000, 18000, 5000, 263000, 'delivered', 'success', 'ecommerce'),
(2, 'ORD-2026-0002', 'Customer 2', 'customer2@example.com', '{}', 1500000, 112500, 5000, 1617500, 'delivered', 'success', 'ecommerce'),
(3, 'ORD-2026-0003', 'Customer 3', 'customer3@example.com', '{}', 65000, 4875, 5000, 74875, 'delivered', 'success', 'ecommerce'),
(4, 'ORD-2026-0004', 'Customer 4', 'customer4@example.com', '{}', 140000, 10500, 5000, 155500, 'delivered', 'success', 'ecommerce'),
(5, 'ORD-2026-0005', 'Customer 5', 'customer5@example.com', '{}', 1700000, 127500, 5000, 1832500, 'delivered', 'success', 'ecommerce'),
(6, 'ORD-2026-0006', 'Customer 6', 'customer6@example.com', '{}', 700000, 52500, 5000, 757500, 'delivered', 'success', 'ecommerce'),
(7, 'ORD-2026-0007', 'Customer 7', 'customer7@example.com', '{}', 220000, 16500, 5000, 241500, 'delivered', 'success', 'ecommerce'),
(8, 'ORD-2026-0008', 'Customer 8', 'customer8@example.com', '{}', 435000, 32625, 5000, 472625, 'delivered', 'success', 'ecommerce'),
(9, 'ORD-2026-0009', 'Customer 9', 'customer9@example.com', '{}', 560000, 42000, 5000, 607000, 'delivered', 'success', 'ecommerce'),
(10, 'ORD-2026-0010', 'Customer 10', 'customer10@example.com', '{}', 450000, 33750, 5000, 488750, 'delivered', 'success', 'ecommerce'),
(11, 'ORD-2026-0011', 'Customer 11', 'customer11@example.com', '{}', 240000, 18000, 5000, 263000, 'delivered', 'success', 'ecommerce'),
(12, 'ORD-2026-0012', 'Customer 12', 'customer12@example.com', '{}', 1500000, 112500, 5000, 1617500, 'delivered', 'success', 'ecommerce'),
(13, 'ORD-2026-0013', 'Customer 13', 'customer13@example.com', '{}', 65000, 4875, 5000, 74875, 'delivered', 'success', 'ecommerce'),
(14, 'ORD-2026-0014', 'Customer 14', 'customer14@example.com', '{}', 420000, 31500, 5000, 456500, 'delivered', 'success', 'ecommerce'),
(15, 'ORD-2026-0015', 'Customer 15', 'customer15@example.com', '{}', 1700000, 127500, 5000, 1832500, 'delivered', 'success', 'ecommerce'),
(16, 'ORD-2026-0016', 'Customer 16', 'customer16@example.com', '{}', 700000, 52500, 5000, 757500, 'delivered', 'success', 'ecommerce'),
(17, 'ORD-2026-0017', 'Customer 17', 'customer17@example.com', '{}', 220000, 16500, 5000, 241500, 'delivered', 'success', 'ecommerce'),
(18, 'ORD-2026-0018', 'Customer 18', 'customer18@example.com', '{}', 290000, 21750, 5000, 316750, 'delivered', 'success', 'ecommerce'),
(19, 'ORD-2026-0019', 'Customer 19', 'customer19@example.com', '{}', 560000, 42000, 5000, 607000, 'delivered', 'success', 'ecommerce'),
(20, 'ORD-2026-0020', 'Customer 20', 'customer20@example.com', '{}', 900000, 67500, 5000, 972500, 'delivered', 'success', 'ecommerce');

INSERT INTO order_items (id, order_id, product_id, product_name_snapshot, sku_snapshot, unit_price_snapshot, quantity, line_total) VALUES
(1, 1, 'PRD-003', 'Hikvision 4-Channel CCTV System', 'SKU-YARO-3', 120000, 2, 240000),
(2, 2, 'PRD-005', 'Felicity 5KVA Hybrid Inverter', 'SKU-YARO-5', 750000, 2, 1500000),
(3, 3, 'PRD-007', 'Mikrotik hEX RB750Gr3 Router', 'SKU-YARO-7', 65000, 1, 65000),
(4, 4, 'PRD-009', 'Ubiquiti UniFi U6 Lite AP', 'SKU-YARO-9', 140000, 1, 140000),
(5, 5, 'PRD-011', 'Cisco Catalyst 2960-X Switch', 'SKU-YARO-11', 850000, 2, 1700000),
(6, 6, 'PRD-013', 'APC Smart-UPS 1500VA', 'SKU-YARO-13', 350000, 2, 700000),
(7, 7, 'PRD-015', 'CAT6 UTP Ethernet Cable (305m)', 'SKU-YARO-15', 110000, 2, 220000),
(8, 8, 'PRD-017', 'Canadian Solar 450W Panel', 'SKU-YARO-17', 145000, 3, 435000),
(9, 9, 'PRD-019', 'Tubular Battery 200Ah 12V', 'SKU-YARO-19', 280000, 2, 560000),
(10, 10, 'PRD-001', 'Starlink Standard Kit', 'SKU-YARO-1', 450000, 1, 450000),
(11, 11, 'PRD-003', 'Hikvision 4-Channel CCTV System', 'SKU-YARO-3', 120000, 2, 240000),
(12, 12, 'PRD-005', 'Felicity 5KVA Hybrid Inverter', 'SKU-YARO-5', 750000, 2, 1500000),
(13, 13, 'PRD-007', 'Mikrotik hEX RB750Gr3 Router', 'SKU-YARO-7', 65000, 1, 65000),
(14, 14, 'PRD-009', 'Ubiquiti UniFi U6 Lite AP', 'SKU-YARO-9', 140000, 3, 420000),
(15, 15, 'PRD-011', 'Cisco Catalyst 2960-X Switch', 'SKU-YARO-11', 850000, 2, 1700000),
(16, 16, 'PRD-013', 'APC Smart-UPS 1500VA', 'SKU-YARO-13', 350000, 2, 700000),
(17, 17, 'PRD-015', 'CAT6 UTP Ethernet Cable (305m)', 'SKU-YARO-15', 110000, 2, 220000),
(18, 18, 'PRD-017', 'Canadian Solar 450W Panel', 'SKU-YARO-17', 145000, 2, 290000),
(19, 19, 'PRD-019', 'Tubular Battery 200Ah 12V', 'SKU-YARO-19', 280000, 2, 560000),
(20, 20, 'PRD-001', 'Starlink Standard Kit', 'SKU-YARO-1', 450000, 2, 900000);

-- --------------------------------------------------------
-- PAYMENTS
-- --------------------------------------------------------
TRUNCATE TABLE payments;
INSERT INTO payments (order_id, provider, reference, amount, status) VALUES
(1, 'paystack', 'PAY_6a129bc50074f', 392000, 'success'),
(2, 'paystack', 'PAY_6a129bc500755', 811250, 'success'),
(3, 'paystack', 'PAY_6a129bc500756', 144750, 'success'),
(4, 'paystack', 'PAY_6a129bc500757', 155500, 'success'),
(5, 'paystack', 'PAY_6a129bc500758', 2746250, 'success'),
(6, 'paystack', 'PAY_6a129bc500759', 1133750, 'success'),
(7, 'paystack', 'PAY_6a129bc50075a', 241500, 'success'),
(8, 'paystack', 'PAY_6a129bc50075b', 160875, 'success'),
(9, 'paystack', 'PAY_6a129bc50075c', 306000, 'success'),
(10, 'paystack', 'PAY_6a129bc50075d', 972500, 'success'),
(11, 'paystack', 'PAY_6a129bc50075e', 134000, 'success'),
(12, 'paystack', 'PAY_6a129bc50075f', 2423750, 'success'),
(13, 'paystack', 'PAY_6a129bc500760', 144750, 'success'),
(14, 'paystack', 'PAY_6a129bc500761', 456500, 'success'),
(15, 'paystack', 'PAY_6a129bc500762', 1832500, 'success'),
(16, 'paystack', 'PAY_6a129bc500763', 757500, 'success'),
(17, 'paystack', 'PAY_6a129bc500764', 241500, 'success'),
(18, 'paystack', 'PAY_6a129bc500765', 160875, 'success'),
(19, 'paystack', 'PAY_6a129bc500766', 607000, 'success'),
(20, 'paystack', 'PAY_6a129bc500767', 972500, 'success');

-- --------------------------------------------------------
-- SETTINGS
-- --------------------------------------------------------
TRUNCATE TABLE settings;
INSERT INTO settings (setting_key, setting_group, setting_value) VALUES
('dummy_setting_1', 'general', '"value_1"'),
('dummy_setting_2', 'general', '"value_2"'),
('dummy_setting_3', 'general', '"value_3"'),
('dummy_setting_4', 'general', '"value_4"'),
('dummy_setting_5', 'general', '"value_5"'),
('dummy_setting_6', 'general', '"value_6"'),
('dummy_setting_7', 'general', '"value_7"'),
('dummy_setting_8', 'general', '"value_8"'),
('dummy_setting_9', 'general', '"value_9"'),
('dummy_setting_10', 'general', '"value_10"'),
('dummy_setting_11', 'general', '"value_11"'),
('dummy_setting_12', 'general', '"value_12"'),
('dummy_setting_13', 'general', '"value_13"'),
('dummy_setting_14', 'general', '"value_14"'),
('dummy_setting_15', 'general', '"value_15"'),
('dummy_setting_16', 'general', '"value_16"'),
('dummy_setting_17', 'general', '"value_17"'),
('dummy_setting_18', 'general', '"value_18"'),
('dummy_setting_19', 'general', '"value_19"'),
('dummy_setting_20', 'general', '"value_20"');

-- --------------------------------------------------------
-- DELIVERY ZONES
-- --------------------------------------------------------
TRUNCATE TABLE delivery_zones;
INSERT INTO delivery_zones (state, city_or_lga, zone_name, base_fee) VALUES
('Abuja', 'City 1', 'Abuja Zone 1', 1000),
('Kano', 'City 2', 'Kano Zone 2', 2000),
('Rivers', 'City 3', 'Rivers Zone 3', 3000),
('Oyo', 'City 4', 'Oyo Zone 4', 4000),
('Lagos', 'City 5', 'Lagos Zone 5', 5000),
('Abuja', 'City 6', 'Abuja Zone 6', 6000),
('Kano', 'City 7', 'Kano Zone 7', 7000),
('Rivers', 'City 8', 'Rivers Zone 8', 8000),
('Oyo', 'City 9', 'Oyo Zone 9', 9000),
('Lagos', 'City 10', 'Lagos Zone 10', 10000),
('Abuja', 'City 11', 'Abuja Zone 11', 11000),
('Kano', 'City 12', 'Kano Zone 12', 12000),
('Rivers', 'City 13', 'Rivers Zone 13', 13000),
('Oyo', 'City 14', 'Oyo Zone 14', 14000),
('Lagos', 'City 15', 'Lagos Zone 15', 15000),
('Abuja', 'City 16', 'Abuja Zone 16', 16000),
('Kano', 'City 17', 'Kano Zone 17', 17000),
('Rivers', 'City 18', 'Rivers Zone 18', 18000),
('Oyo', 'City 19', 'Oyo Zone 19', 19000),
('Lagos', 'City 20', 'Lagos Zone 20', 20000);

SET FOREIGN_KEY_CHECKS = 1;
