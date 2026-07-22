<?php

declare(strict_types=1);

namespace App\Models;

final class PaymentEvent extends BaseModel
{
    protected string $table = 'payment_events';

    public function record(?int $paymentId, string $reference, string $type, $payload = null): void
    {
        $this->insert([
            'payment_id' => $paymentId,
            'reference'  => $reference,
            'event_type' => $type,
            'payload'    => is_string($payload) ? $payload : json_encode($payload),
        ]);
    }
}
