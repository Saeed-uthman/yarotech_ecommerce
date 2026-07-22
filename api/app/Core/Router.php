<?php

declare(strict_types=1);

namespace App\Core;

use App\Helpers\Request;
use App\Helpers\Response;

/**
 * Minimal regex-based router with `:param` placeholders and middleware
 * support. Handler can be:
 *   - a Closure
 *   - [ControllerClass::class, 'method']
 *   - 'ControllerClass@method'
 */
final class Router
{
    /** @var array<int,array{method:string,pattern:string,handler:mixed,middleware:string[]}> */
    private array $routes = [];

    public function get(string $path, $handler, array $middleware = []): void    { $this->add('GET', $path, $handler, $middleware); }
    public function post(string $path, $handler, array $middleware = []): void   { $this->add('POST', $path, $handler, $middleware); }
    public function put(string $path, $handler, array $middleware = []): void    { $this->add('PUT', $path, $handler, $middleware); }
    public function patch(string $path, $handler, array $middleware = []): void  { $this->add('PATCH', $path, $handler, $middleware); }
    public function delete(string $path, $handler, array $middleware = []): void { $this->add('DELETE', $path, $handler, $middleware); }

    private function add(string $method, string $path, $handler, array $middleware): void
    {
        $this->routes[] = [
            'method'     => $method,
            'pattern'    => $this->compile($path),
            'handler'    => $handler,
            'middleware' => $middleware,
        ];
    }

    private function compile(string $path): string
    {
        $regex = preg_replace('#:([a-zA-Z_][a-zA-Z0-9_]*)#', '(?P<$1>[^/]+)', $path);
        return '#^' . rtrim($regex, '/') . '/?$#';
    }

    public function dispatch(string $method, string $uri): void
    {
        $uri = '/' . trim($uri, '/');

        foreach ($this->routes as $route) {
            if ($route['method'] !== $method) continue;
            if (!preg_match($route['pattern'], $uri, $matches)) continue;

            $params = array_filter($matches, fn($k) => !is_int($k), ARRAY_FILTER_USE_KEY);
            Request::setRouteParams($params);

            // Run middleware chain.
            foreach ($route['middleware'] as $mw) {
                if (is_string($mw) && class_exists($mw)) {
                    (new $mw())->handle();
                }
            }

            $this->invoke($route['handler'], $params);
            return;
        }

        Response::notFound('Endpoint not found: ' . $method . ' ' . $uri);
    }

    private function invoke($handler, array $params): void
    {
        if (is_string($handler) && strpos($handler, '@') !== false) {
            [$class, $action] = explode('@', $handler, 2);
            $handler = [$class, $action];
        }

        if (is_array($handler) && is_string($handler[0])) {
            $instance = new $handler[0]();
            $result = $instance->{$handler[1]}(...array_values($params));
        } elseif ($handler instanceof \Closure) {
            $result = $handler(...array_values($params));
        } else {
            Response::error('Invalid route handler', 500);
        }

        if (is_array($result)) {
            Response::success($result);
        }
    }
}
