<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\EmailLog;

final class EmailLogService
{
    private const MAX_ERROR = 500;

    private EmailLog $model;

    public function __construct(?EmailLog $model = null)
    {
        $this->model = $model ?? new EmailLog();
    }

    public function record(
        string $recipientEmail,
        string $subject,
        string $emailType,
        string $status,
        ?string $errorMessage = null,
        ?string $relatedEntityType = null,
        $relatedEntityId = null
    ): void {
        $status = in_array($status, ['sent', 'failed'], true) ? $status : 'failed';
        $this->model->insert([
            'recipient_email'     => trim($recipientEmail),
            'subject'             => mb_substr(trim($subject), 0, 255),
            'email_type'          => mb_substr(trim($emailType) ?: 'generic', 0, 80),
            'status'              => $status,
            'error_message'       => $errorMessage !== null ? mb_substr(trim($errorMessage), 0, self::MAX_ERROR) : null,
            'related_entity_type' => $relatedEntityType !== null ? mb_substr(trim($relatedEntityType), 0, 80) : null,
            'related_entity_id'   => $relatedEntityId !== null ? mb_substr((string) $relatedEntityId, 0, 80) : null,
        ]);
    }
}

