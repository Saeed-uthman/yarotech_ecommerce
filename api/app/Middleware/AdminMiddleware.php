<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Helpers\Jwt;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Services\UserActivityLogService;

/**
 * Admin gate. Accepts either a verified admin/staff JWT or a configured
 * static admin token for operational API access.
 */
final class AdminMiddleware extends BaseMiddleware
{
    public function handle(): void
    {
        $token = Request::bearerToken();
        if (!$token) {
            try {
                (new UserActivityLogService())->log(
                    null,
                    'admin_auth_failed',
                    'failed',
                    null,
                    null,
                    ['reason' => 'Missing bearer token for admin endpoint'],
                );
            } catch (\Throwable) {
                // logging failure should not replace auth failure response.
            }
            Response::unauthorized('Admin authentication required');
        }

        $adminToken = env('ADMIN_API_TOKEN', '');
        if ($adminToken !== '' && hash_equals($adminToken, $token)) {
            return; // static admin token accepted
        }

        $payload = Jwt::decode($token);
        if (
            $payload &&
            isset($payload->id, $payload->role) &&
            in_array((string) $payload->role, ['admin', 'staff'], true)
        ) {
            $_SERVER['AUTH_USER_ID'] = (int) $payload->id;
            $_SERVER['AUTH_USER_ROLE'] = (string) $payload->role;
            return;
        }

        Response::unauthorized('Admin or Staff role required', 403);
    }
}
