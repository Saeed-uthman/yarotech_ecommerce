<?php

declare(strict_types=1);

namespace App\Services;

/**
 * Centralised tax helper. Reads the VAT toggle/rate from config/checkout.php.
 */
final class TaxService
{
    private bool $enabled;
    private float $rate;

    public function __construct()
    {
        $cfg = config('checkout');
        $this->enabled = (bool) ($cfg['vat_enabled'] ?? true);
        $this->rate    = (float) ($cfg['vat_rate'] ?? 0.075);
    }

    public function rate(): float
    {
        return $this->enabled ? $this->rate : 0.0;
    }

    public function vatFor(float $subtotal): float
    {
        return $this->enabled ? round($subtotal * $this->rate, 2) : 0.0;
    }
}
