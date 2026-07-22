<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Models\ContactMessage;
use App\Models\User;
use App\Services\AdminActivityLogService;
use App\Services\MailService;
use App\Services\NotificationService;

final class AdminSupportController extends BaseController
{
    /** @var string[] */
    private array $allowedStatuses = ['open', 'in_progress', 'resolved'];

    private ContactMessage $messages;
    private MailService $mail;
    private NotificationService $notifications;
    private User $users;
    private AdminActivityLogService $activity;

    public function __construct(
        ?ContactMessage $messages = null,
        ?MailService $mail = null,
        ?NotificationService $notifications = null,
        ?User $users = null,
        ?AdminActivityLogService $activity = null
    ) {
        $this->messages = $messages ?? new ContactMessage();
        $this->mail = $mail ?? new MailService();
        $this->notifications = $notifications ?? new NotificationService();
        $this->users = $users ?? new User();
        $this->activity = $activity ?? new AdminActivityLogService();
    }

    /** GET /api/admin/support/index.php */
    public function index(): never
    {
        $filters = [
            'status'       => Request::query('status'),
            'inquiry_type' => Request::query('inquiry_type'),
            'search'       => Request::query('search'),
            'page'         => Request::query('page', 1),
            'per_page'     => Request::query('per_page', 20),
        ];

        $result = $this->messages->listForAdmin($filters);
        $this->ok([
            'items' => array_map([$this, 'formatMessage'], $result['items']),
            'pagination' => [
                'page' => (int) $result['page'],
                'per_page' => (int) $result['per_page'],
                'total' => (int) $result['total'],
            ],
        ], 'Support messages fetched successfully');
    }

    /** GET /api/admin/support/show.php?id=... */
    public function show(): never
    {
        $id = (int) Request::query('id', 0);
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }
        $message = $this->messages->find($id);
        if (!$message) {
            Response::notFound('Support message not found.');
        }
        $this->ok($this->formatMessage($message), 'Support message fetched successfully');
    }

    /** POST /api/admin/support/reply.php */
    public function reply(): never
    {
        $id = (int) Request::input('id', 0);
        $reply = trim((string) Request::input('admin_reply', Request::input('reply', '')));
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }
        if ($reply === '') {
            Response::validation(['admin_reply' => 'admin_reply is required.']);
        }

        $message = $this->messages->find($id);
        if (!$message) {
            Response::notFound('Support message not found.');
        }

        $saved = $this->messages->setReply($id, $reply, 'resolved');
        $updated = $this->messages->find($id) ?: $message;

        if (!$saved) {
            Response::error('Failed to save support reply.', 500);
        }

        $ticketId = 'TKT-' . date('Ymd') . '-' . str_pad((string) $id, 6, '0', STR_PAD_LEFT);
        $emailSent = false;
        $notificationCreated = false;

        try {
            $emailSent = $this->mail->sendSupportReplyEmail($updated, $reply, $ticketId);
        } catch (\Throwable $e) {
            $emailSent = false;
        }

        try {
            $user = $this->users->findByEmail((string) ($updated['email'] ?? ''));
            if ($user) {
                $this->notifications->createUserNotification(
                    (int) $user['id'],
                    'admin_reply',
                    'Support reply received',
                    'Our support team replied to your inquiry ticket ' . $ticketId . '.',
                    ['contact_message_id' => $id, 'ticket_id' => $ticketId],
                );
            }

            $this->notifications->createAdminNotification(
                'admin_reply',
                'Support reply sent',
                'Reply saved for support ticket ' . $ticketId . '.',
                ['contact_message_id' => $id, 'ticket_id' => $ticketId],
            );
            $notificationCreated = true;
        } catch (\Throwable $e) {
            $notificationCreated = false;
        }

        $this->activity->log('support_reply_sent', 'success', [
            'contact_message_id' => $id,
            'ticket_id' => $ticketId,
            'email_sent' => $emailSent,
            'notification_created' => $notificationCreated,
        ]);

        $formatted = $this->formatMessage($updated);
        $formatted['reply_saved'] = true;
        $formatted['email_sent'] = $emailSent;
        $formatted['notification_created'] = $notificationCreated;

        $this->ok(
            $formatted,
            $emailSent
                ? 'Support reply saved and emailed successfully'
                : 'Support reply saved, but email delivery failed',
        );
    }

    /** POST /api/admin/support/update-status.php */
    public function updateStatus(): never
    {
        $id = (int) Request::input('id', 0);
        $status = trim((string) Request::input('status', ''));
        if ($id <= 0) {
            Response::validation(['id' => 'id is required.']);
        }
        if (!in_array($status, $this->allowedStatuses, true)) {
            Response::validation(['status' => 'Invalid support status.']);
        }

        $message = $this->messages->find($id);
        if (!$message) {
            Response::notFound('Support message not found.');
        }

        $this->messages->updateStatus($id, $status);
        $updated = $this->messages->find($id) ?: $message;

        $this->activity->log('support_status_updated', 'success', [
            'contact_message_id' => $id,
            'status' => $status,
        ]);

        $this->ok($this->formatMessage($updated), 'Support status updated successfully');
    }

    /**
     * @param array<string,mixed> $row
     * @return array<string,mixed>
     */
    private function formatMessage(array $row): array
    {
        $inquiryType = (string) ($row['inquiry_type'] ?? 'General Inquiry');
        return [
            'id' => (int) $row['id'],
            'full_name' => (string) ($row['full_name'] ?? ''),
            'name' => (string) ($row['full_name'] ?? ''),
            'phone' => (string) ($row['phone'] ?? ''),
            'email' => (string) ($row['email'] ?? ''),
            'inquiry_type' => $inquiryType,
            'service_type' => $row['service_type'] ?? null,
            'message' => (string) ($row['message'] ?? ''),
            'status' => (string) ($row['status'] ?? 'open'),
            'admin_reply' => $row['admin_reply'] ?? null,
            'created_at' => (string) ($row['created_at'] ?? ''),
            'updated_at' => (string) ($row['updated_at'] ?? ''),
            // frontend-friendly aliases
            'subject' => $inquiryType,
            'body' => (string) ($row['message'] ?? ''),
            'category' => $this->categoryFromInquiryType($inquiryType),
            'status_ui' => $this->statusUi((string) ($row['status'] ?? 'open')),
            'reply' => $row['admin_reply'] ?? null,
            'createdAt' => (string) ($row['created_at'] ?? ''),
        ];
    }

    private function categoryFromInquiryType(string $inquiryType): string
    {
        $t = strtolower($inquiryType);
        if (strpos($t, 'product') !== false) return 'product';
        if (strpos($t, 'delivery') !== false) return 'delivery';
        if (strpos($t, 'payment') !== false) return 'payment';
        if (strpos($t, 'complaint') !== false) return 'complaint';
        return 'general';
    }

    private function statusUi(string $status): string
    {
        switch ($status) {
            case 'open': return 'new';
            case 'in_progress': return 'in_review';
            default: return 'resolved';
        }
    }
}
