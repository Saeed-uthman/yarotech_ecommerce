<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\Response;
use App\Services\ContactService;

final class ContactController extends BaseController
{
    public function __construct(private ContactService $service = new ContactService()) {}

    /** POST /api/contact/store.php */
    public function store(): never
    {
        $all = $this->all();
        $clean = [
            'full_name'    => trim((string) ($all['full_name'] ?? $all['name'] ?? '')),
            'email'        => trim((string) ($all['email'] ?? '')),
            'phone'        => trim((string) ($all['phone'] ?? '')),
            'inquiry_type' => trim((string) ($all['inquiry_type'] ?? $all['inquiryType'] ?? 'General Inquiry')),
            'service_type' => trim((string) ($all['service_type'] ?? $all['serviceType'] ?? '')),
            'message'      => trim((string) ($all['message'] ?? '')),
        ];

        $errors = [];
        if (mb_strlen($clean['full_name']) < 2) $errors['full_name'] = 'full_name is required.';
        if (!filter_var($clean['email'], FILTER_VALIDATE_EMAIL)) $errors['email'] = 'Valid email is required.';
        if (mb_strlen($clean['phone']) < 7) $errors['phone'] = 'Valid phone is required.';
        if (mb_strlen($clean['message']) < 10) $errors['message'] = 'Message must be at least 10 characters.';
        if (!empty($errors)) Response::validation($errors);

        $result = $this->service->createInquiry($clean);
        $this->ok([
            'ok'                 => true,
            'ticketId'           => $result['ticket_id'],
            'customerAckQueued'  => (bool) $result['customer_ack_queued'],
            'adminNotified'      => (bool) $result['admin_notified'],
        ], 'Contact inquiry submitted successfully');
    }

    /** GET /api/support/my-tickets */
    public function myTickets(): never
    {
        $userId = \App\Helpers\CartIdentity::userId();
        if (!$userId) Response::unauthorized();

        $userModel = new \App\Models\User();
        $user = $userModel->find($userId);
        if (!$user) Response::notFound('User account not found.');

        $email = $user['email'] ?? '';
        if ($email === '') {
            $this->ok([], 'No tickets submitted yet.');
        }

        $contactMessageModel = new \App\Models\ContactMessage();
        $rows = $contactMessageModel->listForUser($email);

        // Format for frontend
        $formatted = array_map(function ($row) {
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
                // aliases matching SupportMessage frontend typings
                'subject' => $inquiryType,
                'body' => (string) ($row['message'] ?? ''),
                'category' => $this->categoryFromInquiryType($inquiryType),
                'status_ui' => $this->statusUi((string) ($row['status'] ?? 'open')),
                'reply' => $row['admin_reply'] ?? null,
                'createdAt' => (string) ($row['created_at'] ?? ''),
            ];
        }, $rows);

        $this->ok($formatted, 'My support tickets fetched successfully.');
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
