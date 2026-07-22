<?php

declare(strict_types=1);

namespace App\Helpers;

/**
 * Tiny request helper. Lazily parses the JSON body once per request and
 * gives unified access to query, body, headers, and route params.
 */
final class Request
{
    private static ?array $body = null;
    /** @var array<string,string> */
    private static array $params = [];

    public static function setRouteParams(array $params): void
    {
        self::$params = $params;
    }

    public static function param(string $key, ?string $default = null): ?string
    {
        return self::$params[$key] ?? $default;
    }

    public static function query(string $key, $default = null)
    {
        return $_GET[$key] ?? $default;
    }

    public static function body(): array
    {
        if (self::$body !== null) {
            return self::$body;
        }

        $raw = file_get_contents('php://input') ?: '';
        $contentType = strtolower($_SERVER['CONTENT_TYPE'] ?? '');

        if ($raw !== '' && strpos($contentType, 'application/json') !== false) {
            $decoded = json_decode($raw, true);
            self::$body = is_array($decoded) ? $decoded : [];
        } else {
            self::$body = $_POST;
        }
        return self::$body;
    }

    public static function input(string $key, $default = null)
    {
        $body = self::body();
        return $body[$key] ?? $_GET[$key] ?? $default;
    }

    public static function all(): array
    {
        return array_merge($_GET, self::body());
    }

    public static function header(string $name): ?string
    {
        $key = 'HTTP_' . strtoupper(str_replace('-', '_', $name));
        $value = $_SERVER[$key] ?? null;
        return $value !== null ? trim((string) $value) : null;
    }

    public static function bearerToken(): ?string
    {
        // Try multiple common locations for the Authorization header.
        $auth = self::header('Authorization') 
            ?? $_SERVER['HTTP_AUTHORIZATION'] 
            ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] 
            ?? null;

        if ($auth && stripos((string) $auth, 'Bearer ') === 0) {
            return trim(substr((string) $auth, 7));
        }
        return null;
    }

    public static function ip(): string
    {
        return $_SERVER['HTTP_X_FORWARDED_FOR']
            ?? $_SERVER['REMOTE_ADDR']
            ?? '0.0.0.0';
    }

    public static function user(): ?array
    {
        $userId = $_SERVER['AUTH_USER_ID'] ?? null;
        if (!$userId) {
            return null;
        }

        $userModel = new \App\Models\User();
        return $userModel->find((int)$userId) ?: null;
    }
}
