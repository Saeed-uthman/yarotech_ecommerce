<?php

declare(strict_types=1);

namespace App\Helpers;

/**
 * Resolves the "owner" of a cart from the current request.
 *
 *   - Authenticated requests: pull user_id from the authenticated user
 *     stashed by AuthMiddleware (Phase 2). For Phase 4 — until JWT
 *     hydration is wired — we accept a numeric "X-User-Id" header so the
 *     frontend can already exercise the user-cart code paths.
 *   - Guest requests: read session_token from the JSON body, query
 *     string, or "X-Cart-Session" header.
 */
final class CartIdentity
{
    public static function userId(): ?int
    {
        // 1. Check if AuthMiddleware already hydrated the user.
        $uid = $_SERVER['AUTH_USER_ID'] ?? null;
        if ($uid !== null) return (int) $uid;

        // 2. Fallback: manual check for X-User-Id (legacy/debug)
        $uid = Request::header('X-User-Id');
        if ($uid !== null && $uid !== '') {
            return (int) filter_var($uid, FILTER_VALIDATE_INT);
        }

        // 3. Proactive hydration: check if a Bearer token is present but
        // AuthMiddleware wasn't triggered (e.g. on public cart routes).
        $token = Request::bearerToken();
        if ($token) {
            $payload = Jwt::decode($token);
            if ($payload && isset($payload->id)) {
                return (int) $payload->id;
            }
        }

        return null;
    }

    public static function sessionToken(): ?string
    {
        $token = Request::input('session_token')
            ?? Request::header('X-Cart-Session');
        if (!is_string($token)) return null;
        $token = trim($token);
        return $token === '' ? null : substr($token, 0, 80);
    }

    public static function requireOwner(): array
    {
        $uid = self::userId();
        if ($uid !== null) return ['user_id' => $uid, 'session_token' => null];

        $tok = self::sessionToken();
        if ($tok !== null) return ['user_id' => null, 'session_token' => $tok];

        Response::error('A session_token (guest) or authentication is required.', 400);
    }
}
