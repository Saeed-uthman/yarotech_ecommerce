-- Migration to update the settings table from the old schema to the new schema without losing data.

-- 1. Rename 'key_name' to 'setting_key' (if it hasn't been renamed already)
ALTER TABLE settings CHANGE key_name setting_key VARCHAR(120) NOT NULL;

-- 2. Add 'setting_group' column
ALTER TABLE settings ADD COLUMN setting_group VARCHAR(50) NOT NULL DEFAULT 'general' AFTER setting_key;

-- 3. Rename 'value_json' to 'setting_value' (if it hasn't been renamed already)
ALTER TABLE settings CHANGE value_json setting_value JSON NULL;
