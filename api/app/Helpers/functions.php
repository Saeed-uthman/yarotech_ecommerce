<?php

declare(strict_types=1);

use App\Helpers\Env;

if (!function_exists('env')) {
    function env(string $key, $default = null)
    {
        return Env::get($key, $default);
    }
}

if (!function_exists('config')) {
    /**
     * Lazily loads a config file from /config and returns the whole array
     * or a dot-path key. Files are cached for the request lifetime.
     */
    function config(string $key, $default = null)
    {
        static $cache = [];
        [$file, $rest] = array_pad(explode('.', $key, 2), 2, null);

        if (!isset($cache[$file])) {
            $path = APP_BASE_PATH . "/config/{$file}.php";
            $cache[$file] = is_file($path) ? require $path : [];
        }

        if ($rest === null) {
            return $cache[$file];
        }

        $value = $cache[$file];
        foreach (explode('.', $rest) as $segment) {
            if (!is_array($value) || !array_key_exists($segment, $value)) {
                return $default;
            }
            $value = $value[$segment];
        }
        return $value;
    }
}

if (!function_exists('base_path')) {
    function base_path(string $sub = ''): string
    {
        return APP_BASE_PATH . ($sub === '' ? '' : DIRECTORY_SEPARATOR . ltrim($sub, '/\\'));
    }
}

if (!function_exists('storage_path')) {
    function storage_path(string $sub = ''): string
    {
        return base_path('storage' . ($sub === '' ? '' : '/' . ltrim($sub, '/\\')));
    }
}
