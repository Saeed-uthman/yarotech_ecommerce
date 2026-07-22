<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Helpers\Jwt;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Services\UserActivityLogService;

/**
 * Validates JWT bearer tokens and hydrates the current user id.
 */
final class AuthMiddleware extends BaseMiddleware
{
    public function handle(): void
    {
        $token = Request::bearerToken();
        if (!$token) {
            try {
                (new UserActivityLogService())->logLoginFailed(
                    null,
                    'Missing bearer token on protected endpoint.'
                );
            } catch (\Throwable) {
            }
            Response::unauthorized('Authentication required');
        }

        $payload = Jwt::decode($token);
        if ($payload && isset($payload->id)) {
            $_SERVER['AUTH_USER_ID'] = (int) $payload->id;
            if (isset($payload->role)) {
                $_SERVER['AUTH_USER_ROLE'] = (string) $payload->role;
            }
            return;
        }

        Response::unauthorized('Invalid or expired session');
    }
}
