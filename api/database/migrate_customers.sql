-- =====================================================================
-- CUSTOMERS TABLE
-- Standalone customer records — not linked to any user account.
-- Created manually via the admin Customers page or auto-created
-- from POS sales (walk-in or named customers).
-- =====================================================================

CREATE TABLE IF NOT EXISTS customers (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(150)    NOT NULL,
    phone           VARCHAR(30)     NOT NULL,
    email           VARCHAR(190)        NULL,
    total_orders    INT UNSIGNED    NOT NULL DEFAULT 0,
    total_spent     DECIMAL(14,2)   NOT NULL DEFAULT 0.00,
    first_order_at  DATETIME            NULL,
    last_order_at   DATETIME            NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_customers_phone (phone),
    KEY idx_customers_email (email),
    KEY idx_customers_name (full_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
