<?php

declare(strict_types=1);

namespace App\Helpers;

use RuntimeException;

final class ValidationException extends RuntimeException
{
    /** @var array<string,string> */
    public array $errors;

    public function __construct(array $errors, string $message = 'Validation failed')
    {
        $this->errors = $errors;
        parent::__construct($message, 422);
    }
}
