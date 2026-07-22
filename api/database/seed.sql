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
