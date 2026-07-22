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
