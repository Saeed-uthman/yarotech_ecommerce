<?php

declare(strict_types=1);

namespace App\Services;

use Firebase\JWT\JWT;
use Exception;
use App\Helpers\Jwt as JwtHelper;
use App\Models\AuthOtp;

final class AuthService
{
    private AuthOtp $otps;

    public function __construct()
    {
        $this->otps = new AuthOtp();
    }

    public function generateToken(array $user): string
    {
        $payload = [
            'iss' => env('APP_URL', 'http://localhost'),
            'iat' => time(),
            'exp' => time() + ((int) env('JWT_TTL_MINUTES', 720) * 60),
            'id' => $user['id'],
            'email' => $user['email'],
            'role' => $user['role'] ?? 'user',
        ];

        return JWT::encode($payload, JwtHelper::secret(), 'HS256');
    }

    public function generateOtp(string $email, string $purpose, int $expiresInMinutes = 10): string
    {
        // Invalidate any existing unused OTPs for this purpose
        $this->otps->invalidateAllForEmail($email, $purpose);

        // Generate a random 6-digit code
        $code = str_pad((string)random_int(100000, 999999), 6, '0', STR_PAD_LEFT);
        
        // Hash it for secure storage
        $hash = password_hash($code, PASSWORD_BCRYPT);
        
        $this->otps->createOtp($email, $purpose, $hash, $expiresInMinutes);

        return $code;
    }

    public function verifyOtp(string $email, string $purpose, string $code): bool
    {
        $otpRecord = $this->otps->getValidOtp($email, $purpose);
        
        if (!$otpRecord) {
            return false;
        }

        if (password_verify($code, $otpRecord['code_hash'])) {
            $this->otps->markAsUsed((int)$otpRecord['id']);
            return true;
        }

        return false;
    }
}
