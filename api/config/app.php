<?php

$frontendRaw = (string) env('FRONTEND_URLS', (string) env('FRONTEND_URL', 'http://localhost:5173, http://192.168.3.25:5173'));
$frontendUrls = array_values(array_filter(array_map(
    static fn(string $origin): string => rtrim(trim($origin), '/'),
    explode(',', $frontendRaw)
), static fn(string $origin): bool => $origin !== ''));

if ($frontendUrls === []) {
    $frontendUrls = ['http://localhost:5173'];
}

return [
    'env'          => env('APP_ENV', 'local'),
    'debug'        => filter_var(env('APP_DEBUG', false), FILTER_VALIDATE_BOOLEAN),
    'url'          => env('APP_URL', 'http://localhost'),
    'frontend_url' => (string) env('FRONTEND_URL', $frontendUrls[0]),
    'frontend_urls' => $frontendUrls,
    'app_key'      => env('JWT_SECRET_OR_APP_KEY', ''),
    'jwt_ttl'      => (int) env('JWT_TTL_MINUTES', 720),
    'admin_email'  => env('ADMIN_EMAIL', 'support@yarotech.ng'),
    'order_email'  => env('ORDER_NOTIFICATION_EMAIL', 'support@yarotech.ng'),
];
