<?php

declare(strict_types=1);

namespace App\Services;

use PHPMailer\PHPMailer\Exception as MailException;
use PHPMailer\PHPMailer\PHPMailer;

/**
 * MailService - single SMTP entry point for transactional emails.
 *
 * Phase 6:
 *   - every send attempt is recorded to email_logs
 *   - local/dev mode (no MAIL_HOST) writes HTML files + sent audit log
 */
final class MailService
{
    private array $cfg;
    private EmailLogService $emailLogs;

    public function __construct()
    {
        $this->cfg = config('mail');
        $this->emailLogs = new EmailLogService();
    }

    // ------------------------------------------------------------
    // Public order/payment templates
    // ------------------------------------------------------------

    public function sendVerificationEmail(string $email, string $name, string $otp): bool
    {
        $html = $this->shell('Email Verification', "
            <h2>Hi " . htmlspecialchars($name) . ",</h2>
            <p>Welcome to YAROTECH! Please use the 6-digit code below to verify your email address. The code expires in 10 minutes.</p>
            <div style='background:#f3f4f6;padding:16px;font-size:24px;font-weight:bold;letter-spacing:4px;text-align:center;border-radius:8px;margin:24px 0'>
                $otp
            </div>
            <p>If you didn't request this, please ignore this email.</p>
        ");

        return $this->send($email, "Verify your YAROTECH email", $html, 'email_verification');
    }

    public function sendForgotPasswordEmail(string $email, string $name, string $otp): bool
    {
        $html = $this->shell('Password Reset', "
            <h2>Hi " . htmlspecialchars($name) . ",</h2>
            <p>We received a request to reset your password. Use the 6-digit code below to securely reset it. The code expires in 10 minutes.</p>
            <div style='background:#f3f4f6;padding:16px;font-size:24px;font-weight:bold;letter-spacing:4px;text-align:center;border-radius:8px;margin:24px 0'>
                $otp
            </div>
            <p>If you didn't request a password reset, you can safely ignore this email.</p>
        ");

        return $this->send($email, "YAROTECH Password Reset", $html, 'forgot_password');
    }

    public function sendOrderConfirmationEmail(array $user, array $order, array $items): bool
    {
        $receiptService = new ReceiptPdfService();
        $pdfPath = $receiptService->generateReceiptPdf($order, $user, $items);

        $result = $this->send(
            (string) ($user['email'] ?? $order['customer_email'] ?? ''),
            "Your YAROTECH order {$order['order_number']} is confirmed",
            $this->renderOrderConfirmation($user, $order, $items),
            'order_confirmation',
            'order',
            $order['id'] ?? null,
            [
                ['path' => $pdfPath, 'name' => 'YAROTECH-Receipt-' . ($order['order_number'] ?? time()) . '.pdf']
            ]
        );

        if (file_exists($pdfPath)) {
            @unlink($pdfPath); // Clean up the temporary PDF file
        }

        return $result;
    }

    public function sendPaymentConfirmationEmail(array $user, array $order, array $payment): bool
    {
        return $this->send(
            (string) ($user['email'] ?? $order['customer_email'] ?? ''),
            "Payment received for order {$order['order_number']}",
            $this->renderPaymentConfirmation($user, $order, $payment),
            'payment_confirmation',
            'payment',
            $payment['id'] ?? null,
        );
    }

    public function sendAdminNewOrderEmail(array $order, array $user, array $items, array $payment): bool
    {
        $admin = (string) config('app.order_email');
        return $this->send(
            $admin,
            "New paid order: {$order['order_number']} - NGN " . number_format((float) $order['total_amount'], 2),
            $this->renderAdminNewOrder($order, $user, $items, $payment),
            'admin_new_order',
            'order',
            $order['id'] ?? null,
        );
    }

    public function sendAdminFailedPosSyncEmail(array $order, string $error): bool
    {
        $admin = (string) config('app.admin_email');
        return $this->send(
            $admin,
            "POS sync failed for paid order {$order['order_number']}",
            "<p>Order <b>{$order['order_number']}</b> was paid successfully but failed to sync to POS.</p>"
            . "<p><b>Error:</b> " . htmlspecialchars($error) . "</p>"
            . "<p>Please retry from the admin dashboard.</p>",
            'admin_pos_sync_failed',
            'order',
            $order['id'] ?? null,
        );
    }

    public function sendContactAcknowledgementEmail(array $contact, string $ticketId): bool
    {
        $to = (string) ($contact['email'] ?? '');
        $name = htmlspecialchars((string) ($contact['name'] ?? 'Customer'));

        $html = $this->shell('Contact Received', "
            <h2>Hello $name,</h2>
            <p>We received your inquiry and our team will respond soon.</p>
            <p><b>Ticket:</b> $ticketId<br/>
               <b>Type:</b> " . htmlspecialchars((string) ($contact['inquiry_type'] ?? 'General Inquiry')) . "</p>
            <p>Thank you for contacting YAROTECH.</p>
        ");

        return $this->send(
            $to,
            "YAROTECH support ticket $ticketId received",
            $html,
            'contact_ack',
            'contact_message',
            $contact['id'] ?? null,
        );
    }

    public function sendAdminContactInquiryEmail(array $contact, string $ticketId): bool
    {
        $to = (string) config('app.admin_email');

        $html = $this->shell('New Contact Inquiry', "
            <h2>New support/contact inquiry received</h2>
            <p><b>Ticket:</b> $ticketId</p>
            <p><b>Name:</b> " . htmlspecialchars((string) ($contact['name'] ?? '')) . "<br/>
               <b>Email:</b> " . htmlspecialchars((string) ($contact['email'] ?? '')) . "<br/>
               <b>Phone:</b> " . htmlspecialchars((string) ($contact['phone'] ?? '')) . "</p>
            <p><b>Type:</b> " . htmlspecialchars((string) ($contact['inquiry_type'] ?? 'General Inquiry')) . "<br/>
               <b>Service:</b> " . htmlspecialchars((string) ($contact['service_type'] ?? 'Not applicable')) . "</p>
            <p><b>Message:</b><br/>" . nl2br(htmlspecialchars((string) ($contact['message'] ?? ''))) . "</p>
        ");

        return $this->send(
            $to,
            "New contact inquiry: $ticketId",
            $html,
            'contact_admin',
            'contact_message',
            $contact['id'] ?? null,
        );
    }

    public function sendSupportReplyEmail(array $contact, string $reply, string $ticketId): bool
    {
        $to = (string) ($contact['email'] ?? '');
        $name = htmlspecialchars((string) ($contact['full_name'] ?? $contact['name'] ?? 'Customer'));
        $safeReply = nl2br(htmlspecialchars($reply));

        $html = $this->shell('Support Reply', "
            <h2>Hello $name,</h2>
            <p>Our support team replied to your ticket <b>$ticketId</b>.</p>
            <div style='padding:12px;border:1px solid #e5e7eb;background:#fafafa;border-radius:6px'>
                $safeReply
            </div>
            <p style='margin-top:12px'>If you need more help, reply to this email or submit another contact form entry.</p>
        ");

        return $this->send(
            $to,
            "YAROTECH support reply: $ticketId",
            $html,
            'support_reply',
            'contact_message',
            $contact['id'] ?? null,
        );
    }

    public function sendAdminNewReviewEmail(array $review): bool
    {
        $admin = (string) config('app.admin_email', 'admin@yarotech.ng');
        
        $productId = htmlspecialchars((string) ($review['product_id'] ?? 'Unknown'));
        $rating = (int) ($review['rating'] ?? 0);
        $text = nl2br(htmlspecialchars((string) ($review['review_text'] ?? 'No text provided')));
        $status = htmlspecialchars((string) ($review['status'] ?? 'pending'));

        $html = $this->shell('New Product Review', "
            <h2>New Product Review Submitted</h2>
            <p>A new review was just submitted for product <b>$productId</b>.</p>
            <p><b>Rating:</b> $rating / 5<br/>
               <b>Status:</b> $status</p>
            <div style='padding:12px;border:1px solid #e5e7eb;background:#fafafa;border-radius:6px'>
                $text
            </div>
            <p style='margin-top:12px'>Please log in to the admin dashboard to approve or reject this review.</p>
        ");

        return $this->send(
            $admin,
            "New Review: $productId ($rating/5)",
            $html,
            'admin_new_review',
            'review',
            $review['id'] ?? null,
        );
    }

    // ------------------------------------------------------------
    // Core sender
    // ------------------------------------------------------------

    public function send(
        string $to,
        string $subject,
        string $html,
        string $emailType = 'generic',
        ?string $relatedEntityType = null,
        $relatedEntityId = null,
        array $attachments = []
    ): bool {
        $to = trim($to);

        if ($to === '') {
            $this->emailLogs->record(
                $to,
                $subject,
                $emailType,
                'failed',
                'Recipient email is empty.',
                $relatedEntityType,
                $relatedEntityId,
            );
            return false;
        }

        if (empty($this->cfg['host'])) {
            $this->logToFile($to, $subject, $html);
            $this->emailLogs->record(
                $to,
                $subject,
                $emailType,
                'sent',
                null,
                $relatedEntityType,
                $relatedEntityId,
            );
            return true;
        }

        $smtpDebugLog = '';
        try {
            $mailer = new PHPMailer(true);
            $mailer->isSMTP();
            $mailer->Timeout = 10; // 10 seconds connection timeout
            $isDev = env('APP_ENV', 'local') !== 'production';
            $mailer->SMTPDebug = $isDev ? 3 : 0;
            $mailer->Debugoutput = function ($str) use (&$smtpDebugLog) {
                $smtpDebugLog .= $str . "\n";
            };
            $mailer->Host = (string) $this->cfg['host'];
            $mailer->Port = (int) $this->cfg['port'];
            $mailer->SMTPAuth = !empty($this->cfg['username']);
            $mailer->Username = (string) $this->cfg['username'];
            $mailer->Password = (string) $this->cfg['password'];
            $mailer->SMTPSecure = (string) ($this->cfg['encryption'] ?: PHPMailer::ENCRYPTION_STARTTLS);
            $mailer->CharSet = 'UTF-8';

            $mailer->setFrom((string) ($this->cfg['from']['address'] ?? ''), (string) ($this->cfg['from']['name'] ?? 'YAROTECH'));
            $mailer->addAddress($to);
            $mailer->isHTML(true);
            $mailer->Subject = $subject;
            $mailer->Body = $html;
            $mailer->AltBody = strip_tags($html);

            foreach ($attachments as $attachment) {
                if (isset($attachment['path']) && file_exists($attachment['path'])) {
                    $mailer->addAttachment($attachment['path'], $attachment['name'] ?? '');
                }
            }

            $ok = (bool) $mailer->send();

            $this->emailLogs->record(
                $to,
                $subject,
                $emailType,
                $ok ? 'sent' : 'failed',
                $ok ? null : 'Mailer returned false.',
                $relatedEntityType,
                $relatedEntityId,
            );

            return $ok;
        } catch (\Throwable $e) {
            $errMessage = $e->getMessage() . "\n\n--- SMTP DEBUG TRACE ---\n" . ($smtpDebugLog ?: 'No SMTP trace recorded.');
            $this->logToFile($to, "FAILED: $subject - " . $errMessage, $html);
            $this->emailLogs->record(
                $to,
                $subject,
                $emailType,
                'failed',
                substr($errMessage, 0, 500), // Cap database column size
                $relatedEntityType,
                $relatedEntityId,
            );
            return false;
        }
    }

    private function logToFile(string $to, string $subject, string $html): void
    {
        $dir = base_path('storage/logs/emails');
        if (!is_dir($dir)) {
            @mkdir($dir, 0775, true);
        }

        $safeTo = preg_replace('/[^a-z0-9]/i', '_', $to) ?: 'unknown';
        $file = $dir . '/' . date('Ymd-His') . '-' . $safeTo . '.html';
        @file_put_contents($file, "<!-- TO: $to | SUBJECT: $subject -->\n" . $html);
    }

    // ------------------------------------------------------------
    // Inline templates
    // ------------------------------------------------------------

    private function renderOrderConfirmation(array $user, array $order, array $items): string
    {
        $name = htmlspecialchars((string) ($user['name'] ?? $order['customer_name'] ?? 'Customer'));
        $rows = '';

        foreach ($items as $item) {
            $rows .= sprintf(
                '<tr><td>%s</td><td>%s</td><td align="right">%d</td><td align="right">NGN %s</td><td align="right">NGN %s</td></tr>',
                htmlspecialchars((string) ($item['product_name_snapshot'] ?? '')),
                htmlspecialchars((string) ($item['sku_snapshot'] ?? '')),
                (int) ($item['quantity'] ?? 0),
                number_format((float) ($item['unit_price_snapshot'] ?? 0), 2),
                number_format((float) ($item['line_total'] ?? 0), 2),
            );
        }

        $address = ($order['fulfillment_method'] ?? 'delivery') === 'pickup'
            ? '<p><b>Fulfillment:</b> Pickup at Lokoro plaza A farm center, Kano</p>'
            : sprintf(
                '<p><b>Delivery to:</b> %s, %s, %s%s</p><p><b>Phone:</b> %s</p>',
                htmlspecialchars((string) ($order['delivery_address'] ?? '')),
                htmlspecialchars((string) ($order['delivery_city'] ?? '')),
                htmlspecialchars((string) ($order['delivery_state'] ?? '')),
                !empty($order['delivery_landmark']) ? ' - ' . htmlspecialchars((string) $order['delivery_landmark']) : '',
                htmlspecialchars((string) ($order['delivery_phone'] ?? '')),
            );

        return $this->shell('Order Confirmed', "
            <h2>Hi $name,</h2>
            <p>Thank you for your order. Here are your details:</p>
            <p><b>Order Number:</b> {$order['order_number']}<br/>
               <b>Status:</b> " . ucfirst((string) ($order['order_status'] ?? 'created')) . "</p>
            $address
            <table width='100%' cellpadding='6' style='border-collapse:collapse;border:1px solid #e5e7eb'>
              <thead><tr style='background:#f3f4f6'><th align='left'>Item</th><th align='left'>SKU</th><th align='right'>Qty</th><th align='right'>Price</th><th align='right'>Total</th></tr></thead>
              <tbody>$rows</tbody>
            </table>
            <p style='margin-top:14px'>
              Subtotal: NGN " . number_format((float) ($order['subtotal'] ?? 0), 2) . "<br/>
              VAT: NGN " . number_format((float) ($order['tax_amount'] ?? 0), 2) . "<br/>
              Delivery: NGN " . number_format((float) ($order['delivery_fee'] ?? 0), 2) . "<br/>
              <b>Total Paid: NGN " . number_format((float) ($order['total_amount'] ?? 0), 2) . "</b>
            </p>
            <p>We will notify you as your order moves through processing.</p>
        ");
    }

    private function renderPaymentConfirmation(array $user, array $order, array $payment): string
    {
        $name = htmlspecialchars((string) ($user['name'] ?? $order['customer_name'] ?? 'Customer'));
        return $this->shell('Payment Received', "
            <h2>Thanks, $name</h2>
            <p>We received your payment for order <b>{$order['order_number']}</b>.</p>
            <p><b>Reference:</b> " . htmlspecialchars((string) ($payment['reference'] ?? '')) . "<br/>
               <b>Amount:</b> NGN " . number_format((float) ($payment['amount'] ?? 0), 2) . "<br/>
               <b>Channel:</b> " . htmlspecialchars((string) ($payment['channel'] ?? '-')) . "</p>
            <p>Your order is now being processed.</p>
        ");
    }

    private function renderAdminNewOrder(array $order, array $user, array $items, array $payment): string
    {
        $rows = '';
        foreach ($items as $item) {
            $rows .= '<li>'
                . htmlspecialchars((string) ($item['product_name_snapshot'] ?? ''))
                . ' x ' . (int) ($item['quantity'] ?? 0)
                . ' - NGN ' . number_format((float) ($item['line_total'] ?? 0), 2)
                . '</li>';
        }

        return $this->shell('New Paid Order', "
            <h2>New paid order: {$order['order_number']}</h2>
            <p><b>Customer:</b> " . htmlspecialchars((string) ($user['name'] ?? '')) . " &lt;" . htmlspecialchars((string) ($user['email'] ?? '')) . "&gt;</p>
            <p><b>Total:</b> NGN " . number_format((float) ($order['total_amount'] ?? 0), 2) . "<br/>
               <b>Payment ref:</b> " . htmlspecialchars((string) ($payment['reference'] ?? '')) . "<br/>
               <b>Fulfillment:</b> " . ucfirst((string) ($order['fulfillment_method'] ?? 'delivery')) . "</p>
            <ul>$rows</ul>
        ");
    }

    public function sendOrderFulfilledEmail(array $order, string $status): bool
    {
        $to = trim((string) ($order['customer_email'] ?? ''));
        if ($to === '' || !filter_var($to, FILTER_VALIDATE_EMAIL)) return false;
        
        $action = $status === 'picked_up' ? 'picked up from our store' : 'delivered to your address';
        $title = $status === 'picked_up' ? 'Order Picked Up' : 'Order Delivered';
        $subject = 'Your YAROTECH Order has been ' . ($status === 'picked_up' ? 'Picked Up' : 'Delivered');
        $name = htmlspecialchars((string) ($order['customer_name'] ?? 'Customer'));
        
        $html = $this->shell($title, "
            <h2>Hello $name,</h2>
            <p>Great news! Your order <b>{$order['order_number']}</b> has been successfully {$action}.</p>
            <p>Thank you for shopping with YAROTECH. We hope you enjoy your purchase.</p>
            <p>If you have any questions or issues with your items, please don't hesitate to reach out to our support team.</p>
        ");
        
        return $this->send(
            $to,
            $subject,
            $html,
            'order_fulfilled',
            'order',
            $order['id'] ?? null
        );
    }

    private function renderOrderFulfilled(array $order, string $status): string
    {
        $name = htmlspecialchars((string) ($order['customer_name'] ?? 'Customer'));
        $action = $status === 'picked_up' ? 'picked up from our store' : 'delivered to your address';
        $title = $status === 'picked_up' ? 'Order Picked Up' : 'Order Delivered';
        
        return $this->shell($title, "
            <h2>Hello $name,</h2>
            <p>Great news! Your order <b>{$order['order_number']}</b> has been successfully {$action}.</p>
            <p>Thank you for shopping with YAROTECH. We hope you enjoy your purchase.</p>
            <p>If you have any questions or issues with your items, please don't hesitate to reach out to our support team.</p>
        ");
    }

    private function shell(string $title, string $body): string
    {
        return "<!doctype html><html><body style='font-family:Arial,sans-serif;color:#0a1733;background:#f6f7fb;padding:20px'>
            <div style='max-width:640px;margin:auto;background:#fff;padding:24px;border-radius:8px'>
              <div style='border-bottom:1px solid #e5e7eb;padding-bottom:8px;margin-bottom:16px'>
                <strong style='color:#0a1733;font-size:18px'>YAROTECH</strong>
                <span style='float:right;color:#6b7280;font-size:12px'>$title</span>
              </div>
              $body
              <p style='color:#9ca3af;font-size:12px;margin-top:24px'>YAROTECH - Engineering Procurement</p>
            </div></body></html>";
    }
}
