<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\DeliveryZone;

/**
 * DeliveryService — resolves shipping fees from the admin-defined
 * delivery_zones table. Pickup is always free.
 *
 * Returns a normalized quote shape:
 *   [
 *     'fulfillment_method' => 'pickup'|'delivery',
 *     'delivery_fee'       => float,
 *     'zone'               => string,
 *     'eta'                => string,
 *     'matched'            => bool,    // false => fell back to default
 *   ]
 */
final class DeliveryService
{
    private array $cfg;
    private DeliveryZone $zones;

    public function __construct(?DeliveryZone $zones = null)
    {
        $this->zones = $zones ?? new DeliveryZone();
        $this->cfg   = config('checkout');
    }

    public function listZones(): array
    {
        return $this->zones->activeZones();
    }

    public function quote(string $method, ?string $state = null, ?string $city = null): array
    {
        if ($method === 'pickup') {
            return [
                'fulfillment_method' => 'pickup',
                'delivery_fee'       => 0.0,
                'zone'               => (string) $this->cfg['pickup_label'],
                'eta'                => (string) $this->cfg['pickup_eta'],
                'matched'            => true,
            ];
        }

        $row = $state ? $this->zones->resolve($state, $city) : null;
        if ($row) {
            return [
                'fulfillment_method' => 'delivery',
                'delivery_fee'       => (float) $row['base_fee'],
                'zone'               => (string) $row['zone_name'],
                'eta'                => (string) ($row['eta_text'] ?? ''),
                'matched'            => true,
            ];
        }

        // Default fallback for unmapped destinations.
        return [
            'fulfillment_method' => 'delivery',
            'delivery_fee'       => (float) $this->cfg['default_delivery_fee'],
            'zone'               => (string) $this->cfg['default_zone_label'],
            'eta'                => (string) $this->cfg['default_eta'],
            'matched'            => false,
        ];
    }
}
