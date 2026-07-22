<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\ContactMessage;

/**
 * Contact inquiry intake for ecommerce support.
 * This is the only inquiry intake path (no separate quote module).
 */
final class ContactService
{
    public function __construct(
        private ContactMessage $messages = new ContactMessage(),
        private MailService $mail = new MailService(),
        private NotificationService $notifier = new NotificationService(),
        private UserActivityLogService $activity = new UserActivityLogService(),
    ) {}

    /**
     * @param array<string,mixed> $payload
     * @return array{ticket_id:string,customer_ack_queued:bool,admin_notified:bool,id:int}
     */
    public function createInquiry(array $payload): array
    {
        $name = trim((string) ($payload['full_name'] ?? $payload['name'] ?? ''));
        $email = trim((string) ($payload['email'] ?? ''));
        $phone = trim((string) ($payload['phone'] ?? ''));
        $inquiryType = trim((string) ($payload['inquiry_type'] ?? $payload['inquiryType'] ?? 'General Inquiry'));
        $serviceType = trim((string) ($payload['service_type'] ?? $payload['serviceType'] ?? 'Not applicable'));
        $message = trim((string) ($payload['message'] ?? ''));

        $id = (int) $this->messages->insert([
            'full_name'    => mb_substr($name, 0, 150),
            'email'        => $email,
            'phone'        => $phone !== '' ? mb_substr($phone, 0, 30) : null,
            'inquiry_type' => mb_substr($inquiryType, 0, 120),
            'service_type' => ($serviceType !== '' && strcasecmp($serviceType, 'Not applicable') !== 0)
                ? mb_substr($serviceType, 0, 120)
                : null,
            'message'      => $message,
            'status'       => 'open',
        ]);

        $ticketId = $this->ticketId($id);
        $record = [
            'id'           => $id,
            'name'         => $name,
            'full_name'    => $name,
            'email'        => $email,
            'phone'        => $phone,
            'inquiry_type' => $inquiryType,
            'service_type' => $serviceType,
            'message'      => $message,
        ];

        $ack = $this->mail->sendContactAcknowledgementEmail($record, $ticketId);
        $admin = $this->mail->sendAdminContactInquiryEmail($record, $ticketId);

        $this->notifier->createAdminNotification(
            'contact_inquiry',
            'New contact inquiry received',
            $name . ' submitted a support inquiry.',
            [
                'ticket_id'    => $ticketId,
                'contact_id'   => $id,
                'inquiry_type' => $inquiryType,
            ],
        );

        $this->activity->log(
            null,
            'contact_inquiry',
            'success',
            null,
            null,
            [
                'ticket_id'    => $ticketId,
                'inquiry_type' => $inquiryType,
            ],
        );

        return [
            'ticket_id'            => $ticketId,
            'customer_ack_queued'  => $ack,
            'admin_notified'       => $admin,
            'id'                   => $id,
        ];
    }

    private function ticketId(int $id): string
    {
        return 'TKT-' . date('Ymd') . '-' . str_pad((string) $id, 6, '0', STR_PAD_LEFT);
    }
}
