<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\CartIdentity;
use App\Services\CartService;

/**
 * Cart endpoints. Works for both authenticated users and guests with a
 * session_token. All totals are calculated server-side from POS data.
 */
final class CartController extends BaseController
{
    public function __construct(private CartService $service = new CartService()) {}

    public function index(): never
    {
        $owner = CartIdentity::requireOwner();
        $cart  = $this->service->getOrCreateCart($owner['user_id'], $owner['session_token']);
        $this->ok($this->service->buildCartView($cart), 'Cart fetched.');
    }

    public function add(): never
    {
        $data = $this->validate([
            'product_id' => 'required|string|max:64',
            'quantity'       => 'required|integer|min:1|max:999',
        ]);
        $owner = CartIdentity::requireOwner();
        $cart  = $this->service->getOrCreateCart($owner['user_id'], $owner['session_token']);
        $view  = $this->service->addItem($cart, (string) $data['product_id'], (int) $data['quantity']);
        $this->ok($view, 'Item added to cart.');
    }

    public function update(): never
    {
        $data = $this->validate([
            'product_id' => 'required|string|max:64',
            'quantity'       => 'required|integer|min:0|max:999',
        ]);
        $owner = CartIdentity::requireOwner();
        $cart  = $this->service->getOrCreateCart($owner['user_id'], $owner['session_token']);
        $view  = $this->service->updateItem($cart, (string) $data['product_id'], (int) $data['quantity']);
        $this->ok($view, 'Cart updated.');
    }

    public function remove(): never
    {
        $data = $this->validate([
            'product_id' => 'required|string|max:64',
        ]);
        $owner = CartIdentity::requireOwner();
        $cart  = $this->service->getOrCreateCart($owner['user_id'], $owner['session_token']);
        $view  = $this->service->removeItem($cart, (string) $data['product_id']);
        $this->ok($view, 'Item removed.');
    }

    public function clear(): never
    {
        $owner = CartIdentity::requireOwner();
        $cart  = $this->service->getOrCreateCart($owner['user_id'], $owner['session_token']);
        $view  = $this->service->clear($cart);
        $this->ok($view, 'Cart cleared.');
    }

    public function sync(): never
    {
        $data = $this->validate([
            'items' => 'required|array',
        ]);
        $owner = CartIdentity::requireOwner();
        $cart  = $this->service->getOrCreateCart($owner['user_id'], $owner['session_token']);
        $view  = $this->service->syncItems($cart, (array) $data['items']);
        $this->ok($view, 'Cart synced.');
    }
}
