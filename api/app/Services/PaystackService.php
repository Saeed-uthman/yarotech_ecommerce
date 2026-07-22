<?php

declare(strict_types=1);

namespace App\Services;

use RuntimeException;

/**
 * PaystackService — thin HTTPS wrapper around the Paystack REST API.
 *
 *   - initializePayment($order)  -> returns ['authorization_url','reference','access_code']
 *   - verifyPayment($reference)  -> returns the full Paystack 'data' object
 *   - validateWebhookSignature() -> verifies x-paystack-signature against the raw body
 *
 * In dev / when secret key is empty, mock mode returns deterministic
 * "successful" payloads so the storefront can be exercised end-to-end.
 */
final class PaystackService
{
    private array $config;

    public function __construct()
    {
        $this->config = config('paystack');
    }

    public function isMock(): bool
    {
        return empty($this->config['secret_key']);
    }

    /**
     * Initialize a transaction. Amount on $order is in NGN; Paystack
     * expects the smallest unit (kobo) so we multiply by 100.
     */
    public function initializePayment(array $order, string $callbackUrl, string $email): array
    {
        $reference = $this->generateReference($order['order_number']);
        $amountKobo = (int) round(((float) $order['total_amount']) * 100);

        if ($this->isMock()) {
            return [
                'reference'         => $reference,
                'authorization_url' => rtrim($callbackUrl, '/?') . '?reference=' . urlencode($reference) . '&mock=1',
                'access_code'       => 'mock_' . substr($reference, -8),
            ];
        }

        $resp = $this->request('POST', '/transaction/initialize', [
            'email'        => $email,
            'amount'       => $amountKobo,
            'reference'    => $reference,
            'callback_url' => $callbackUrl,
            'currency'     => $order['currency'] ?? 'NGN',
            'metadata'     => [
                'order_number' => $order['order_number'],
                'order_id'     => $order['id'],
            ],
        ]);

        $data = $resp['data'] ?? [];
        return [
            'reference'         => (string) ($data['reference'] ?? $reference),
            'authorization_url' => (string) ($data['authorization_url'] ?? ''),
            'access_code'       => (string) ($data['access_code'] ?? ''),
        ];
    }

    /**
     * Verify by reference. Returns Paystack `data` object normalized:
     *   ['status'=>'success'|'failed'|'abandoned',
     *    'amount'=>NGN float,
     *    'channel','paid_at','gateway_response','currency']
     */
    public function verifyPayment(string $reference): array
    {
        if ($this->isMock()) {
            return [
                'status'           => 'success',
                'amount'           => null, // forces caller to use internal order total
                'channel'          => 'mock',
                'paid_at'          => date('c'),
                'gateway_response' => 'Approved (mock)',
                'currency'         => 'NGN',
                'reference'        => $reference,
                'raw'              => ['mock' => true],
            ];
        }

        $resp = $this->request('GET', '/transaction/verify/' . urlencode($reference));
        $data = $resp['data'] ?? [];

        $amountKobo = (int) ($data['amount'] ?? 0);
        return [
            'status'           => (string) ($data['status'] ?? 'failed'),
            'amount'           => $amountKobo > 0 ? $amountKobo / 100 : 0.0,
            'channel'          => (string) ($data['channel'] ?? ''),
            'paid_at'          => (string) ($data['paid_at'] ?? $data['paidAt'] ?? ''),
            'gateway_response' => (string) ($data['gateway_response'] ?? ''),
            'currency'         => (string) ($data['currency'] ?? 'NGN'),
            'reference'        => (string) ($data['reference'] ?? $reference),
            'raw'              => $data,
        ];
    }

    /**
     * Verify the x-paystack-signature header against the raw request body
     * using the secret key. Returns true if valid.
     */
    public function validateWebhookSignature(string $rawBody, string $signature): bool
    {
        if (empty($this->config['secret_key'])) return false;
        $computed = hash_hmac('sha512', $rawBody, $this->config['secret_key']);
        return hash_equals($computed, $signature);
    }

    // --------------------------------------------------------------

    private function generateReference(string $orderNumber): string
    {
        return 'YT-PAY-' . preg_replace('/[^A-Za-z0-9]/', '', $orderNumber)
            . '-' . strtoupper(bin2hex(random_bytes(4)));
    }

    private function request(string $method, string $path, array $body = []): array
    {
        $url = rtrim((string) $this->config['base_url'], '/') . $path;
        $ch = curl_init($url);

        $headers = [
            'Authorization: Bearer ' . $this->config['secret_key'],
            'Accept: application/json',
            'Content-Type: application/json',
        ];

        $opts = [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 20,
            CURLOPT_HTTPHEADER     => $headers,
            CURLOPT_CUSTOMREQUEST  => $method,
        ];
        if ($method !== 'GET' && !empty($body)) {
            $opts[CURLOPT_POSTFIELDS] = json_encode($body);
        }
        curl_setopt_array($ch, $opts);

        $raw  = curl_exec($ch);
        $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $err  = curl_error($ch);
        curl_close($ch);

        if ($raw === false) {
            throw new RuntimeException("Paystack request failed: $err");
        }
        $decoded = json_decode((string) $raw, true);
        if (!is_array($decoded)) {
            throw new RuntimeException("Paystack returned non-JSON ($code): " . substr((string) $raw, 0, 200));
        }
        if ($code >= 400 || ($decoded['status'] ?? false) === false) {
            $msg = $decoded['message'] ?? 'Paystack error';
            throw new RuntimeException("Paystack error ($code): $msg");
        }
        return $decoded;
    }
}
