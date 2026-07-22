<?php

declare(strict_types=1);

namespace App\Helpers;

use Dotenv\Dotenv;

/**
 * Thin wrapper around vlucas/phpdotenv with a safe `env()` accessor.
 */
final class Env
{
    private static bool $loaded = false;

    public static function load(string $envFile): void
    {
        if (self::$loaded) {
            return;
        }

        $dir = dirname($envFile);
        $file = basename($envFile);

        if (is_file($envFile)) {
            Dotenv::createImmutable($dir, $file)->safeLoad();
        }

        self::$loaded = true;
    }

    public static function get(string $key, $default = null)
    {
        $value = $_ENV[$key] ?? $_SERVER[$key] ?? getenv($key);
        if ($value === false || $value === null || $value === '') {
            return $default;
        }
        switch (strtolower((string) $value)) {
            case 'true':
            case '(true)':   return true;
            case 'false':
            case '(false)':  return false;
            case 'null':
            case '(null)':   return null;
            default:         return $value;
        }
    }
}
