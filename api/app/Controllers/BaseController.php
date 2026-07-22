<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\Request;
use App\Helpers\Response;
use App\Helpers\Validator;

abstract class BaseController
{
    protected function input(string $key, $default = null)
    {
        return Request::input($key, $default);
    }

    protected function all(): array
    {
        return Request::all();
    }

    protected function validate(array $rules): array
    {
        return Validator::make(Request::all(), $rules);
    }

    protected function ok($data = null, string $message = 'Request completed successfully'): never
    {
        Response::success($data, $message);
    }

    protected function fail(string $message, int $status = 400, array $errors = []): never
    {
        Response::error($message, $status, $errors);
    }
}
