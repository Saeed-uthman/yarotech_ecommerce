<?php
/**
 * YAROTECH API — front controller.
 *
 * All HTTP traffic is rewritten through this file by public/.htaccess.
 * It bootstraps the environment, registers global error/exception handlers,
 * applies CORS, then dispatches the request via the Router.
 */

declare(strict_types=1);

define('APP_BASE_PATH', dirname(__DIR__));

require APP_BASE_PATH . '/vendor/autoload.php';

use App\Helpers\Env;
use App\Helpers\Cors;
use App\Core\Router;
use App\Core\ErrorHandler;

// 1. Load .env
Env::load(APP_BASE_PATH . '/.env');

// 1a. Force a consistent timezone so PHP date() matches MySQL NOW().
//     cPanel MySQL servers default to UTC. We pin PHP to UTC too.
//     To override, add APP_TIMEZONE=Africa/Lagos in your .env
date_default_timezone_set(env('APP_TIMEZONE', 'UTC'));

// 2. Register error + exception handlers (clean JSON in prod, traces in dev).
ErrorHandler::register();

// 3. CORS — must run before any route logic so OPTIONS preflights succeed.
Cors::handle();

// 4. Build router and load route definitions.
$router = new Router();
require APP_BASE_PATH . '/routes/api.php';

// 5. Normalize URI when app runs from a subdirectory (e.g. /yarotech-api/public).
$requestUri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?? '/';

// Bulletproof stripping of any subdirectories like XAMPP's /yarotech-api/
$apiPos = strpos($requestUri, '/api/');
if ($apiPos !== false) {
    $requestUri = substr($requestUri, $apiPos);
} elseif (preg_match('#/yarotech-api/?$#', $requestUri)) {
    // If they hit the root dir, treat as /
    $requestUri = '/';
} else {
    // Fallback: strip public dir if it exists
    $scriptDir = str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? ''));
    if ($scriptDir !== '/' && $scriptDir !== '.') {
        if (strpos($requestUri, $scriptDir) === 0) {
            $requestUri = substr($requestUri, strlen($scriptDir));
        }
    }
}
$requestUri = '/' . ltrim((string) $requestUri, '/');

// 6. Dispatch.
try {
    $router->dispatch(
        $_SERVER['REQUEST_METHOD'] ?? 'GET',
        $requestUri
    );
} catch (Throwable $e) {
    ErrorHandler::renderException($e);
}
