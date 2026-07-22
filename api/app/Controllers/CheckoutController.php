<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\CartIdentity;
use App\Helpers\Response;
use App\Services\CheckoutService;

final class CheckoutController extends BaseController
{
    public function __construct(private CheckoutService $service = new CheckoutService()) {}

    /**
     * Authoritative checkout preview. Authentication is required —
     * guests must log in or register before previewing checkout.
     */
    public function preview(): never
    {
        $owner = CartIdentity::requireOwner();
        if ($owner['user_id'] === null) {
            Response::unauthorized('You must sign in to preview checkout.');
        }

        if ($owner['user_id']) {
            $user = (new \App\Models\User())->find((string) $owner['user_id']);
            if ($user && empty($user['email_verified_at'])) {
                Response::forbidden('Please verify your email address before checking out.');
            }
        }

        $payload = $this->all();
        $preview = $this->service->preview($owner, $payload);
        $this->ok($preview, 'Checkout preview ready.');
    }
}
