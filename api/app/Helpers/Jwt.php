<?php

declare(strict_types=1);

namespace App\Helpers;

use Firebase\JWT\JWT as FirebaseJwt;
use Firebase\JWT\Key;

final class Jwt
{
    public static function secret(): string
    {
        $key = (string) env('JWT_SECRET_OR_APP_KEY', '');
        if ($key === '' || $key === 'default-insecure-key' || $key === 'change_this_secret') {
            throw new \RuntimeException('JWT secret is not configured');
        }

        return $key;
    }

    public static function decode(string $token): ?object
    {
        try {
            return FirebaseJwt::decode($token, new Key(self::secret(), 'HS256'));
        } catch (\Throwable) {
            return null;
        }
    }
}
