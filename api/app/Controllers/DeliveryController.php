<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Services\DeliveryService;

final class DeliveryController extends BaseController
{
    public function __construct(private DeliveryService $service = new DeliveryService()) {}

    public function zones(): never
    {
        $rows = $this->service->listZones();
        $items = array_map(fn($r) => [
            'id'           => (int) $r['id'],
            'state'        => $r['state'],
            'city_or_lga'  => $r['city_or_lga'],
            'zone_name'    => $r['zone_name'],
            'base_fee'     => (float) $r['base_fee'],
            'eta_text'     => $r['eta_text'],
        ], $rows);
        $this->ok(['items' => $items, 'total' => count($items)], 'Delivery zones.');
    }

    public function calculate(): never
    {
        $data = $this->validate([
            'fulfillment_method' => 'required|in:pickup,delivery',
            'state'              => 'string|max:80',
            'city_or_lga'        => 'string|max:120',
            'address_line'       => 'string|max:255',
        ]);

        $method = (string) $data['fulfillment_method'];
        if ($method === 'delivery' && empty($data['state'])) {
            $this->fail('State is required for delivery.', 422, ['state' => 'Required for delivery.']);
        }

        $quote = $this->service->quote(
            $method,
            $data['state']       ?? null,
            $data['city_or_lga'] ?? null,
        );
        $this->ok($quote, 'Delivery fee calculated.');
    }
}
