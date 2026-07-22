<?php

declare(strict_types=1);

namespace App\Helpers;

/**
 * Standard JSON envelope used by every endpoint.
 *
 *   { success: bool, message: string, data?: any, errors?: object }
 */
final class Response
{
    public static function json(array $payload, int $status = 200): never
    {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
        header('X-Content-Type-Options: nosniff');
        echo json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        exit;
    }

    public static function success(
        $data = null,
        string $message = 'Request completed successfully',
        int $status = 200,
    ): never {
        self::json([
            'success' => true,
            'message' => $message,
            'data'    => $data ?? new \stdClass(),
        ], $status);
    }

    public static function error(
        string $message = 'Request failed',
        int $status = 400,
        array $errors = [],
    ): never {
        self::json([
            'success' => false,
            'message' => $message,
            'errors'  => (object) $errors,
        ], $status);
    }

    public static function notFound(string $message = 'Resource not found'): never
    {
        self::error($message, 404);
    }

    public static function unauthorized(string $message = 'Unauthorized'): never
    {
        self::error($message, 401);
    }

    public static function forbidden(string $message = 'Forbidden'): never
    {
        self::error($message, 403);
    }

    public static function validation(array $errors, string $message = 'Validation failed'): never
    {
        file_put_contents(__DIR__ . '/../../validation_debug.log', date('[Y-m-d H:i:s] ') . json_encode($errors) . PHP_EOL, FILE_APPEND);
        self::error($message, 422, $errors);
    }
}
