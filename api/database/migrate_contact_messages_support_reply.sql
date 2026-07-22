-- Normalize support/contact tickets for the admin reply workflow.
-- Run against the application database before testing /api/admin/support/reply.

CREATE TABLE IF NOT EXISTS contact_messages_backup_20260615 AS
SELECT * FROM contact_messages;

ALTER TABLE contact_messages
  ADD COLUMN IF NOT EXISTS full_name VARCHAR(150) NULL AFTER id,
  ADD COLUMN IF NOT EXISTS admin_reply TEXT NULL AFTER status,
  ADD COLUMN IF NOT EXISTS updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

ALTER TABLE contact_messages
  MODIFY inquiry_type VARCHAR(120) NOT NULL DEFAULT 'General Inquiry',
  MODIFY service_type VARCHAR(120) NULL,
  MODIFY status VARCHAR(32) NOT NULL DEFAULT 'open';

UPDATE contact_messages
SET full_name = COALESCE(NULLIF(full_name, ''), 'Customer')
WHERE full_name IS NULL OR full_name = '';

UPDATE contact_messages
SET inquiry_type = 'Service Inquiry'
WHERE inquiry_type = 'Services Inquiry';

UPDATE contact_messages
SET service_type = 'Not applicable'
WHERE service_type = 'Not Applicable';

UPDATE contact_messages
SET status = CASE
  WHEN status IN ('', 'new', 'read') THEN 'open'
  WHEN status IN ('responded', 'archived') THEN 'resolved'
  WHEN status = 'in_progress' THEN 'in_progress'
  WHEN status = 'resolved' THEN 'resolved'
  ELSE 'open'
END;

ALTER TABLE contact_messages
  MODIFY full_name VARCHAR(150) NOT NULL,
  MODIFY inquiry_type ENUM('General Inquiry', 'Product Support', 'Delivery Support', 'Service Inquiry', 'Payment Issue', 'Complaint') NOT NULL DEFAULT 'General Inquiry',
  MODIFY service_type ENUM('Not applicable', 'Solar Installation', 'CCTV Installation', 'Internet Networking', 'IT Services') NULL,
  MODIFY status ENUM('open','in_progress','resolved') NOT NULL DEFAULT 'open';
