<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\User;
use App\Helpers\Jwt as JwtHelper;
use App\Helpers\Request;
use App\Services\AuthService;
use App\Services\CustomerService;
use App\Services\MailService;
use App\Services\UserActivityLogService;

final class AuthController extends BaseController
{
    private User $users;
    private AuthService $auth;
    private MailService $mail;

    public function __construct()
    {
        $this->users = new User();
        $this->auth = new AuthService();
        $this->mail = new MailService();
    }

    public function login(): never
    {
        $email = $this->input('email');
        $password = $this->input('password');

        if (!$email || !$password) {
            $this->fail('Email and password are required', 400);
        }

        $user = $this->users->findByEmail($email);

        if (!$user || !password_verify((string)$password, $user['password_hash'])) {
            (new UserActivityLogService())->logLoginFailed($email, 'Invalid email or password');
            $this->fail('Invalid email or password', 401);
        }

        // Check email verification
        if ($user['email_verified_at'] === null) {
            // Generate OTP and send email
            $otp = $this->auth->generateOtp($user['email'], 'verify_email');
            $this->mail->sendVerificationEmail($user['email'], $user['full_name'], $otp);
            
            $this->fail('Please verify your email to continue.', 403, [
                'requires_verification' => true,
                'email'                 => $user['email'],
            ]);
        }

        // Generate JWT
        $token = $this->auth->generateToken($user);
        unset($user['password_hash']);
        
        (new UserActivityLogService())->logLoginSuccess((int)$user['id'], $user['email']);

        $this->ok([
            'user' => $user,
            'token' => $token,
        ], 'Login successful');
    }

    public function googleLogin(): never
    {
        $email = $this->input('email');
        $fullName = $this->input('full_name');

        if (!$email || !$fullName) {
            $this->fail('Email and full name are required', 400);
        }

        $user = $this->users->findByEmail($email);

        if (!$user) {
            $userId = $this->users->insert([
                'full_name' => $fullName,
                'email' => $email,
                'phone' => null,
                'password_hash' => password_hash(bin2hex(random_bytes(16)), PASSWORD_BCRYPT),
                'role' => 'user',
                'email_verified_at' => null // Google login requires OTP verification now
            ]);

            $user = $this->users->find($userId);
            (new UserActivityLogService())->logUserRegistered((int)$userId, $email);
        }

        // Require OTP verification for Google accounts too
        if ($user['email_verified_at'] === null) {
            // Generate OTP and send email
            $otp = $this->auth->generateOtp($user['email'], 'verify_email');
            $this->mail->sendVerificationEmail($user['email'], $user['full_name'], $otp);
            
            $this->fail('Please verify your email to continue.', 403, [
                'requires_verification' => true,
                'email'                 => $user['email'],
            ]);
        }

        (new UserActivityLogService())->logLoginSuccess((int)$user['id'], $user['email']);

        $token = $this->auth->generateToken($user);
        unset($user['password_hash']);

        $this->ok([
            'user' => $user,
            'token' => $token,
        ], 'Google sign-in successful');
    }

    public function register(): never
    {
        $data = $this->all();
        
        if (empty($data['email']) || empty($data['password']) || empty($data['full_name'])) {
            $this->fail('Missing required fields', 400);
        }

        if ($this->users->findByEmail($data['email'])) {
            $this->fail('Email already registered', 409);
        }

        $userId = $this->users->insert([
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone'] ?? null,
            'password_hash' => password_hash((string)$data['password'], PASSWORD_BCRYPT),
            'role' => 'user',
        ]);

        $user = $this->users->find($userId);
        unset($user['password_hash']);

        $phone = trim((string) ($data['phone'] ?? ''));
        if ($phone !== '') {
            try {
                (new CustomerService())->findOrCreate([
                    'name'    => $data['full_name'],
                    'phone'   => $phone,
                    'email'   => $data['email'],
                    'user_id' => (int) $userId,
                ]);
            } catch (\Throwable $e) {
                // Non-critical
            }
        }

        (new UserActivityLogService())->logUserRegistered((int)$userId, $data['email']);

        // Generate Verification OTP and email it
        $otp = $this->auth->generateOtp($user['email'], 'verify_email');
        $this->mail->sendVerificationEmail($user['email'], $user['full_name'], $otp);

        $this->ok([
            'user' => $user,
        ], 'Registration successful. Please verify your email.');
    }

    public function verifyAccount(): never
    {
        $email = $this->input('email');
        $otp = $this->input('otp');

        if (!$email || !$otp) {
            $this->fail('Email and OTP are required', 400);
        }

        if (!$this->auth->verifyOtp($email, 'verify_email', $otp)) {
            $this->fail('Invalid or expired verification code', 400);
        }

        $user = $this->users->findByEmail($email);
        if ($user) {
            $this->users->update((int)$user['id'], ['email_verified_at' => date('Y-m-d H:i:s')]);
        }

        $this->ok([], 'Email successfully verified');
    }

    public function resendVerificationOtp(): never
    {
        $email = $this->input('email');
        if (!$email) $this->fail('Email is required', 400);

        $user = $this->users->findByEmail($email);
        if (!$user) $this->ok([], 'OTP sent'); // Silent success to prevent email enumeration

        if ($user['email_verified_at']) {
            $this->fail('Email is already verified', 400);
        }

        $otp = $this->auth->generateOtp($user['email'], 'verify_email');
        $this->mail->sendVerificationEmail($user['email'], $user['full_name'], $otp);

        $this->ok([], 'Verification email sent');
    }

    public function forgotPassword(): never
    {
        $email = $this->input('email');
        if (!$email) $this->fail('Email is required', 400);

        $user = $this->users->findByEmail($email);
        if ($user) {
            $otp = $this->auth->generateOtp($user['email'], 'reset_password');
            $this->mail->sendForgotPasswordEmail($user['email'], $user['full_name'], $otp);
        }

        $this->ok([], 'If an account exists, a reset code has been sent');
    }

    public function verifyForgotOtp(): never
    {
        $email = $this->input('email');
        $otp = $this->input('otp');

        if (!$email || !$otp) {
            $this->fail('Email and OTP are required', 400);
        }

        if (!$this->auth->verifyOtp($email, 'reset_password', $otp)) {
            $this->fail('Invalid or expired reset code', 400);
        }

        // Return a temporary reset token (in this case, we issue a special JWT scoped for password reset)
        $resetToken = \Firebase\JWT\JWT::encode([
            'email' => $email,
            'purpose' => 'reset_password',
            'exp' => time() + 1800 // 30 minutes
        ], JwtHelper::secret(), 'HS256');

        $this->ok(['reset_token' => $resetToken], 'Code verified. You can now reset your password.');
    }

    public function resetPassword(): never
    {
        $email = $this->input('email');
        $password = $this->input('password');
        // We accept either an OTP directly or a reset_token
        $otp = $this->input('otp');
        $resetToken = $this->input('reset_token');

        if (!$email || !$password) {
            $this->fail('Email and new password are required', 400);
        }

        // If they pass an OTP, verify it. If they pass a token, verify the token.
        $verified = false;
        
        if ($resetToken) {
            try {
                $decoded = \Firebase\JWT\JWT::decode($resetToken, new \Firebase\JWT\Key(JwtHelper::secret(), 'HS256'));
                if ($decoded->purpose === 'reset_password' && $decoded->email === $email) {
                    $verified = true;
                }
            } catch (\Throwable $e) {}
        } else if ($otp) {
            $verified = $this->auth->verifyOtp($email, 'reset_password', $otp);
        }

        if (!$verified) {
            $this->fail('Unauthorized to reset password. Invalid code or token.', 401);
        }

        $user = $this->users->findByEmail($email);
        if ($user) {
            $this->users->update((int)$user['id'], [
                'password_hash' => password_hash((string)$password, PASSWORD_BCRYPT)
            ]);
        }

        $this->ok([], 'Password successfully reset');
    }

    public function me(): never
    {
        $user = Request::user(); // AuthMiddleware attaches the user
        if (!$user) {
            $this->fail('Unauthorized', 401);
        }
        
        unset($user['password_hash']);
        $this->ok($user, 'Profile fetched');
    }
}
