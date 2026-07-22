<?php

declare(strict_types=1);

namespace App\Core;

use App\Helpers\Response;
use App\Helpers\ValidationException;
use Throwable;

final class ErrorHandler
{
    public static function register(): void
    {
        $debug = (bool) env('APP_DEBUG', false);

        ini_set('display_errors', $debug ? '1' : '0');
        ini_set('log_errors', '1');
        ini_set('error_log', dirname(__DIR__, 2) . '/storage/logs/php-error.log');
        error_reporting(E_ALL);

        set_exception_handler([self::class, 'renderException']);
        set_error_handler(function ($severity, $message, $file, $line) {
            if (!(error_reporting() & $severity)) return false;
            throw new \ErrorException($message, 0, $severity, $file, $line);
        });
        register_shutdown_function(function () {
            $err = error_get_last();
            if ($err && in_array($err['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR], true)) {
                self::renderException(new \ErrorException(
                    $err['message'], 0, $err['type'], $err['file'], $err['line']
                ));
            }
        });
    }

    public static function renderException(Throwable $e): void
    {
        if ($e instanceof ValidationException) {
            Response::validation($e->errors, $e->getMessage());
        }

        $debug = (bool) env('APP_DEBUG', false);
        $status = ($e->getCode() >= 400 && $e->getCode() < 600) ? (int) $e->getCode() : 500;

        @file_put_contents(
            dirname(__DIR__, 2) . '/storage/logs/app.log',
            sprintf("[%s] %s: %s in %s:%d\n", date('c'), get_class($e), $e->getMessage(), $e->getFile(), $e->getLine()),
            FILE_APPEND
        );

        $payload = [
            'success' => false,
            'message' => $debug ? $e->getMessage() : ($status >= 500 ? 'Server error' : $e->getMessage()),
            'errors'  => new \stdClass(),
        ];
        if ($debug) {
            $payload['debug'] = [
                'exception' => get_class($e),
                'file'      => $e->getFile(),
                'line'      => $e->getLine(),
                'trace'     => explode("\n", $e->getTraceAsString()),
            ];
        }
        Response::json($payload, $status);
    }
}
