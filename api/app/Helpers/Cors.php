<?php

declare(strict_types=1);

namespace App\Helpers;

/**
 * CORS handler. Accepts a comma-separated whitelist via FRONTEND_URL,
 * supports credentials, and short-circuits OPTIONS preflights.
 */
final class Cors
{
    public static function handle(): void
    {
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
        $allowed = array_filter(array_map('trim', explode(',', (string) env('FRONTEND_URL', 'http://localhost:5173'))));

        if ($origin && (in_array($origin, $allowed, true) || env('APP_ENV') === 'local')) {
            header("Access-Control-Allow-Origin: $origin");
            header('Vary: Origin');
            header('Access-Control-Allow-Credentials: true');
        }

        header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Authorization, X-Requested-With');
        header('Access-Control-Max-Age: 86400');

        if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
            http_response_code(204);
            exit;
        }
    }
}
