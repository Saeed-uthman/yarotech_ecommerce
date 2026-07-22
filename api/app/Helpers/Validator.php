<?php

declare(strict_types=1);

namespace App\Helpers;

/**
 * Lightweight rule-based validator.
 *
 * Usage:
 *   $clean = Validator::make($data, [
 *     'email'    => 'required|email|max:120',
 *     'password' => 'required|min:6',
 *     'phone'    => 'required|string|min:7',
 *     'qty'      => 'required|integer|min:1',
 *   ]);
 *
 * Throws ValidationException (caught by ErrorHandler -> 422 JSON response).
 */
final class Validator
{
    /**
     * @param array<string,mixed> $data
     * @param array<string,string> $rules
     * @return array<string,mixed> sanitized data
     */
    public static function make(array $data, array $rules): array
    {
        $errors = [];
        $clean  = [];

        foreach ($rules as $field => $ruleString) {
            $value = $data[$field] ?? null;
            $ruleList = explode('|', $ruleString);
            $isRequired = in_array('required', $ruleList, true);
            $isMissing = $value === null || $value === '' || (is_array($value) && empty($value));

            if ($isMissing) {
                if ($isRequired) {
                    $errors[$field] = ucfirst(str_replace('_', ' ', $field)) . ' is required.';
                }
                continue;
            }

            foreach ($ruleList as $rule) {
                if ($rule === '' || $rule === 'required') continue;

                [$name, $param] = array_pad(explode(':', $rule, 2), 2, null);
                $err = self::applyRule($field, $value, $name, $param);
                if ($err !== null) {
                    $errors[$field] = $err;
                    break;
                }
            }

            if (!isset($errors[$field])) {
                $clean[$field] = $value;
            }
        }

        if (!empty($errors)) {
            throw new ValidationException($errors);
        }

        return $clean;
    }

    private static function applyRule(string $field, $value, string $name, ?string $param): ?string
    {
        $label = ucfirst(str_replace('_', ' ', $field));

        switch ($name) {
            case 'string':  return is_string($value) ? null : "$label must be a string.";
            case 'integer': return filter_var($value, FILTER_VALIDATE_INT) !== false ? null : "$label must be an integer.";
            case 'numeric': return is_numeric($value) ? null : "$label must be numeric.";
            case 'boolean': 
                return (is_bool($value) || in_array($value, [0, 1, '0', '1', 'true', 'false'], true))
                    ? null
                    : "$label must be boolean.";
            case 'email':   return filter_var($value, FILTER_VALIDATE_EMAIL) ? null : "$label must be a valid email.";
            case 'url':     return filter_var($value, FILTER_VALIDATE_URL) ? null : "$label must be a valid URL.";
            case 'min':     return self::checkMin($value, (int) $param) ? null : "$label must be at least $param.";
            case 'max':     return self::checkMax($value, (int) $param) ? null : "$label may not be greater than $param.";
            case 'in':      return in_array((string) $value, explode(',', (string) $param), true)
                ? null
                : "$label is invalid.";
            case 'array':   return is_array($value) ? null : "$label must be an array.";
            case 'same':    return (isset($GLOBALS) && ($value === ($_REQUEST[$param] ?? null)))
                ? null
                : "$label must match $param.";
            default: return null;
        }
    }

    private static function checkMin($value, int $min): bool
    {
        if (is_numeric($value)) return $value + 0 >= $min;
        if (is_array($value))   return count($value) >= $min;
        return mb_strlen((string) $value) >= $min;
    }

    private static function checkMax($value, int $max): bool
    {
        if (is_numeric($value)) return $value + 0 <= $max;
        if (is_array($value))   return count($value) <= $max;
        return mb_strlen((string) $value) <= $max;
    }
}
