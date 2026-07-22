<?php

declare(strict_types=1);

namespace App\Validators;

use App\Helpers\Validator;

/**
 * Optional dedicated validator class per resource. Extend and define
 * rules in static methods. Controllers call e.g.
 *   AuthValidator::register($data)
 */
abstract class BaseValidator
{
    protected static function check(array $data, array $rules): array
    {
        return Validator::make($data, $rules);
    }
}
