<?php

declare(strict_types=1);

namespace App\Middleware;

/**
 * All middleware extend this and implement handle().
 * On failure, call Response::unauthorized() / forbidden() / error()
 * which terminate the request.
 */
abstract class BaseMiddleware
{
    abstract public function handle(): void;
}
