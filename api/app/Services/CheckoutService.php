<?php

declare(strict_types=1);

namespace App\Services;

use App\Helpers\Response;
use App\Models\UserAddress;

/**
 * CheckoutService — assembles the authoritative preview the frontend
 * displays before sending the payment request. Totals are recomputed
 * from POS prices + admin delivery zones; the request body's totals
 * are ignored entirely.
 */
final class CheckoutService
{
    private CartService $cartService;
    private DeliveryService $delivery;
    private TaxService $tax;
    private UserAddress $addresses;

    public function __construct(
        ?CartService $cartService = null,
        ?DeliveryService $delivery = null,
        ?TaxService $tax = null,
        ?UserAddress $addresses = null
    ) {
        $this->cartService = $cartService ?? new CartService();
        $this->delivery = $delivery ?? new DeliveryService();
        $this->tax = $tax ?? new TaxService();
        $this->addresses = $addresses ?? new UserAddress();
    }

    /**
     * @param array{user_id:?int, session_token:?string} $owner
     * @param array<string,mixed> $payload
     */
    public function preview(array $owner, array $payload): array
    {
        $method = (string) ($payload['fulfillment_method'] ?? 'delivery');
        if (!in_array($method, ['pickup', 'delivery'], true)) {
            Response::validation(['fulfillment_method' => 'Must be pickup or delivery.']);
        }

        $cart    = $this->cartService->getOrCreateCart($owner['user_id'], $owner['session_token']);
        $cartView = $this->cartService->buildCartView($cart);

        if (empty($cartView['items'])) {
            Response::error('Your cart is empty.', 422);
        }

        // Resolve delivery details — either an existing user address or
        // an inline state/city pair.
        $state = null;
        $city  = null;
        $address = null;

        if ($method === 'delivery') {
            $addressId = (int) ($payload['address_id'] ?? 0);
            if ($addressId > 0 && $owner['user_id'] !== null) {
                $address = $this->addresses->findForUser($owner['user_id'], $addressId);
                if (!$address) Response::notFound('Saved address not found.');
                $state = $address['state'];
                $city  = $address['city_or_lga'];
            } else {
                $state = trim((string) ($payload['state'] ?? ''));
                $city  = trim((string) ($payload['city_or_lga'] ?? ''));
                if ($state === '') {
                    Response::validation(['state' => 'Delivery state is required.']);
                }
            }
        }

        $quote = $this->delivery->quote($method, $state, $city);

        $subtotal     = (float) $cartView['subtotal'];
        $vat          = $this->tax->vatFor($subtotal);
        $deliveryFee  = (float) $quote['delivery_fee'];
        $total        = $subtotal + $vat + $deliveryFee;

        $warnings = $cartView['warnings'];
        if (!$quote['matched'] && $method === 'delivery') {
            $warnings[] = 'No specific delivery zone matched — using default rate.';
        }

        return [
            'cart' => [
                'cart_id'  => $cartView['cart_id'],
                'items'    => $cartView['items'],
                'count'    => $cartView['count'],
            ],
            'fulfillment' => [
                'method'  => $method,
                'zone'    => $quote['zone'],
                'eta'     => $quote['eta'],
                'address' => $address ? [
                    'id'           => (int) $address['id'],
                    'full_name'    => $address['full_name'],
                    'phone'        => $address['phone'],
                    'state'        => $address['state'],
                    'city_or_lga'  => $address['city_or_lga'],
                    'address_line' => $address['address_line'],
                    'landmark'     => $address['landmark'],
                ] : ($method === 'delivery' ? [
                    'state'       => $state,
                    'city_or_lga' => $city,
                    'address_line'=> $payload['address_line'] ?? null,
                ] : null),
            ],
            'totals' => [
                'subtotal'     => round($subtotal, 2),
                'vat'          => round($vat, 2),
                'vat_rate'     => $this->tax->rate(),
                'delivery_fee' => round($deliveryFee, 2),
                'total'        => round($total, 2),
                'currency'     => 'NGN',
            ],
            'warnings' => $warnings,
        ];
    }
}
