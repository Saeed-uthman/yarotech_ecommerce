<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\DeliveryZone;
use App\Models\Setting;

final class AdminSettingsService
{
    private Setting $settings;
    private DeliveryZone $zones;

    public function __construct(
        ?Setting $settings = null,
        ?DeliveryZone $zones = null
    ) {
        $this->settings = $settings ?? new Setting();
        $this->zones = $zones ?? new DeliveryZone();
    }

    /**
     * @return array<string,mixed>
     */
    public function index(?string $group = null): array
    {
        $rows = $this->settings->listByGroup($group);
        $items = array_map(fn(array $r) => $this->formatSettingRow($r), $rows);

        return [
            'items' => $items,
            'grouped' => $this->groupRows($items),
            'frontend' => $this->frontendShape(),
        ];
    }

    /**
     * @return array<string,mixed>
     */
    public function update(string $key, string $value, string $group = 'general', bool $isPublic = false): array
    {
        $row = $this->settings->upsert($key, $value, $group, $isPublic);
        return $this->formatSettingRow($row);
    }

    /**
     * @return array<int,array<string,mixed>>
     */
    public function deliveryRates(?bool $active = null): array
    {
        return array_map(function (array $z): array {
            return [
                'id'               => (int) $z['id'],
                'state'            => (string) $z['state'],
                'city_or_lga'      => (string) $z['city_or_lga'],
                'zone_name'        => (string) $z['zone_name'],
                'base_fee'         => (float) $z['base_fee'],
                'extra_fee_per_kg' => $z['extra_fee_per_kg'] !== null ? (float) $z['extra_fee_per_kg'] : null,
                'eta_text'         => (string) ($z['eta_text'] ?? ''),
                'is_active'        => (bool) ((int) $z['is_active']),
            ];
        }, $this->zones->listAll($active));
    }

    /**
     * @param array<string,mixed> $payload
     * @return array<string,mixed>
     */
    public function updateDeliveryRate(array $payload): array
    {
        $zone = $this->zones->upsert([
            'id'               => (int) ($payload['id'] ?? 0),
            'state'            => trim((string) ($payload['state'] ?? '')),
            'city_or_lga'      => trim((string) ($payload['city_or_lga'] ?? '*')),
            'zone_name'        => trim((string) ($payload['zone_name'] ?? 'Default Zone')),
            'base_fee'         => (float) ($payload['base_fee'] ?? 0),
            'extra_fee_per_kg' => $payload['extra_fee_per_kg'] !== null ? (float) $payload['extra_fee_per_kg'] : null,
            'eta_text'         => trim((string) ($payload['eta_text'] ?? '')),
            'is_active'        => (bool) ($payload['is_active'] ?? true),
        ]);

        return [
            'id'               => (int) $zone['id'],
            'state'            => (string) $zone['state'],
            'city_or_lga'      => (string) $zone['city_or_lga'],
            'zone_name'        => (string) $zone['zone_name'],
            'base_fee'         => (float) $zone['base_fee'],
            'extra_fee_per_kg' => $zone['extra_fee_per_kg'] !== null ? (float) $zone['extra_fee_per_kg'] : null,
            'eta_text'         => (string) ($zone['eta_text'] ?? ''),
            'is_active'        => (bool) ((int) $zone['is_active']),
        ];
    }

    /**
     * @return array<string,mixed>
     */
    public function systemConfig(): array
    {
        $paystack = config('paystack');
        $mail = config('mail');
        $checkout = config('checkout');
        $map = $this->settings->mapByGroup(null);

        return [
            'general' => [
                'app_env' => (string) config('app.env'),
                'app_url' => (string) config('app.url'),
                'frontend_url' => (string) config('app.frontend_url'),
            ],
            'smtp' => [
                'host' => (string) ($mail['host'] ?? ''),
                'port' => (int) ($mail['port'] ?? 587),
                'username_masked' => $this->mask((string) ($mail['username'] ?? '')),
                'password_masked' => $this->maskSecret((string) ($mail['password'] ?? '')),
                'from_address' => (string) ($mail['from']['address'] ?? ''),
                'from_name' => (string) ($mail['from']['name'] ?? ''),
                'encryption' => (string) ($mail['encryption'] ?? 'tls'),
            ],
            'paystack' => [
                'public_key_masked' => $this->mask((string) ($paystack['public_key'] ?? '')),
                'secret_key_masked' => $this->maskSecret((string) ($paystack['secret_key'] ?? '')),
                'webhook_secret_masked' => $this->maskSecret((string) ($paystack['webhook_secret'] ?? '')),
                'base_url' => (string) ($paystack['base_url'] ?? ''),
            ],
            'pos_sales' => [
                'allow_staff_sales' => $this->boolSetting($map, 'pos_allow_staff_sales', true),
                'require_customer_details' => $this->boolSetting($map, 'pos_require_customer_details', false),
                'default_payment_method' => $this->stringSetting($map, 'pos_default_payment_method', 'cash'),
                'receipt_prefix' => $this->stringSetting($map, 'receipt_prefix', 'YT-POS'),
            ],
            'payment_methods' => [
                'paystack' => $this->boolSetting($map, 'pm_paystack', true),
                'cash' => $this->boolSetting($map, 'pm_cash', true),
                'bank_transfer' => $this->boolSetting($map, 'pm_bank_transfer', true),
                'pos_terminal' => $this->boolSetting($map, 'pm_pos_terminal', true),
                'manual_card' => $this->boolSetting($map, 'pm_manual_card', true),
                'other' => $this->boolSetting($map, 'pm_other', true),
            ],
            'inventory' => [
                'enforce_stock_guard' => $this->boolSetting($map, 'inventory_enforce_stock_guard', true),
                'allow_negative_stock' => $this->boolSetting($map, 'inventory_allow_negative_stock', false),
                'low_stock_threshold' => $this->intSetting($map, 'low_stock_threshold', 5),
            ],
            'receipt' => [
                'show_logo' => $this->boolSetting($map, 'receipt_show_logo', true),
                'footer_note' => $this->stringSetting($map, 'receipt_footer_note', 'Thank you for choosing YAROTECH.'),
                'print_customer_phone' => $this->boolSetting($map, 'receipt_print_customer_phone', true),
            ],
            'tax' => [
                'vat_enabled' => $this->boolSetting($map, 'vat_enabled', (bool) ($checkout['vat_enabled'] ?? true)),
                'vat_rate' => $this->floatSetting($map, 'vat_rate', (float) ($checkout['vat_rate'] ?? 0.075)),
                'prices_include_vat' => $this->boolSetting($map, 'prices_include_vat', false),
            ],
            'staff_permissions' => [
                'can_create_pos_sales' => $this->boolSetting($map, 'staff_can_create_pos_sales', true),
                'can_edit_pos_price' => $this->boolSetting($map, 'staff_can_edit_pos_price', false),
                'can_apply_discount' => $this->boolSetting($map, 'staff_can_apply_discount', true),
                'can_process_returns' => $this->boolSetting($map, 'staff_can_process_returns', true),
                'max_discount_percent' => $this->intSetting($map, 'staff_max_discount_percent', 10),
            ],
        ];
    }

    /**
     * Frontend-friendly settings shape (mirrors src/api/admin.ts mock shape).
     *
     * @return array<string,mixed>
     */
    public function frontendShape(): array
    {
        $map = $this->settings->mapByGroup(null);
        $mail = config('mail');
        $paystack = config('paystack');
        $checkout = config('checkout');

        return [
            'settings' => [
                'general' => [
                    'storeName'    => $map['store_name']    ?? 'YAROTECH NETWORK LIMITED',
                    'storeAddress' => $map['store_address'] ?? 'Lokoro plaza A Farm Center, Kano State, Nigeria',
                    'storePhone'   => $map['store_phone']   ?? '',
                    'storeEmail'   => $map['store_email']   ?? (string) ($mail['from']['address'] ?? ''),
                    'supportEmail' => $map['support_email'] ?? (string) config('app.admin_email'),
                    'currency'     => $map['currency']      ?? 'NGN',
                    'vatPercent'   => (float) ($map['vat_percent'] ?? ((float) ($checkout['vat_rate'] ?? 0.075) * 100)),
                ],
                'paystack' => [
                    'publicKeyMasked' => $this->mask((string) ($paystack['public_key'] ?? '')),
                    'secretKeyMasked' => $this->maskSecret((string) ($paystack['secret_key'] ?? '')),
                    'webhookUrl' => rtrim((string) config('app.url'), '/') . '/api/payments/webhook',
                ],
                'smtp' => [
                    'host' => (string) ($mail['host'] ?? ''),
                    'port' => (int) ($mail['port'] ?? 587),
                    'fromAddress' => (string) ($mail['from']['address'] ?? ''),
                    'encryption' => (string) ($mail['encryption'] ?? 'tls'),
                ],
                'posSales' => [
                    'allowStaffSales' => $this->boolSetting($map, 'pos_allow_staff_sales', true),
                    'requireCustomerDetails' => $this->boolSetting($map, 'pos_require_customer_details', false),
                    'defaultPaymentMethod' => $this->stringSetting($map, 'pos_default_payment_method', 'cash'),
                    'autoMarkPaidAsCompleted' => $this->boolSetting($map, 'pos_auto_mark_paid_completed', true),
                    'holdStockForPendingPosSales' => $this->boolSetting($map, 'pos_hold_stock_for_pending_sales', false),
                ],
                'paymentMethods' => [
                    'paystack' => $this->boolSetting($map, 'pm_paystack', true),
                    'cash' => $this->boolSetting($map, 'pm_cash', true),
                    'bankTransfer' => $this->boolSetting($map, 'pm_bank_transfer', true),
                    'posTerminal' => $this->boolSetting($map, 'pm_pos_terminal', true),
                    'manualCard' => $this->boolSetting($map, 'pm_manual_card', true),
                    'other' => $this->boolSetting($map, 'pm_other', true),
                ],
                'inventory' => [
                    'enforceStockGuard' => $this->boolSetting($map, 'inventory_enforce_stock_guard', true),
                    'allowNegativeStock' => $this->boolSetting($map, 'inventory_allow_negative_stock', false),
                    'lowStockThreshold' => $this->intSetting($map, 'low_stock_threshold', 5),
                    'trackMovementNotes' => $this->boolSetting($map, 'inventory_track_notes', true),
                ],
                'receipt' => [
                    'prefix' => $this->stringSetting($map, 'receipt_prefix', 'YT-POS'),
                    'showLogo' => $this->boolSetting($map, 'receipt_show_logo', true),
                    'footerNote' => $this->stringSetting($map, 'receipt_footer_note', 'Thank you for choosing YAROTECH.'),
                    'printCustomerPhone' => $this->boolSetting($map, 'receipt_print_customer_phone', true),
                ],
                'tax' => [
                    'vatEnabled' => $this->boolSetting($map, 'vat_enabled', (bool) ($checkout['vat_enabled'] ?? true)),
                    'vatPercent' => $this->floatSetting($map, 'vat_rate', (float) ($checkout['vat_rate'] ?? 0.075)) * 100,
                    'pricesIncludeVat' => $this->boolSetting($map, 'prices_include_vat', false),
                ],
                'staffPermissions' => [
                    'canCreatePosSales' => $this->boolSetting($map, 'staff_can_create_pos_sales', true),
                    'canEditPosPrice' => $this->boolSetting($map, 'staff_can_edit_pos_price', false),
                    'canApplyDiscount' => $this->boolSetting($map, 'staff_can_apply_discount', true),
                    'canProcessReturns' => $this->boolSetting($map, 'staff_can_process_returns', true),
                    'maxDiscountPercent' => $this->intSetting($map, 'staff_max_discount_percent', 10),
                ],
                'preferences' => [
                    'notifyOnNewOrder' => $this->boolVal($map['notify_on_new_order'] ?? '1'),
                    'notifyOnLowStock' => $this->boolVal($map['notify_on_low_stock'] ?? '1'),
                ],
            ],
            'deliveryZones' => array_map(function (array $z): array {
                return [
                    'id' => (string) $z['id'],
                    'region' => trim((string) $z['state'] . ' ' . (string) $z['city_or_lga']),
                    'baseFee' => (float) $z['base_fee'],
                    'perKgFee' => $z['extra_fee_per_kg'] !== null ? (float) $z['extra_fee_per_kg'] : 0.0,
                    'etaDays' => $this->etaToDays((string) ($z['eta_text'] ?? '')),
                    'enabled' => (bool) ((int) $z['is_active']),
                ];
            }, $this->zones->listAll(null)),
        ];
    }

    /**
     * @param array<string,mixed> $row
     * @return array<string,mixed>
     */
    private function formatSettingRow(array $row): array
    {
        $key = (string) ($row['setting_key'] ?? '');
        $value = (string) ($row['setting_value'] ?? '');
        $group = (string) ($row['setting_group'] ?? 'general');
        $isPublic = (bool) ((int) ($row['is_public'] ?? 0));
        $sensitive = $this->isSensitiveKey($key);

        return [
            'id' => isset($row['id']) ? (int) $row['id'] : null,
            'setting_key' => $key,
            'setting_value' => $sensitive ? $this->maskSecret($value) : $value,
            'raw_value_available' => !$sensitive,
            'setting_group' => $group,
            'is_public' => $isPublic,
            'created_at' => (string) ($row['created_at'] ?? ''),
            'updated_at' => (string) ($row['updated_at'] ?? ''),
        ];
    }

    /**
     * @param array<int,array<string,mixed>> $rows
     * @return array<string,array<int,array<string,mixed>>>
     */
    private function groupRows(array $rows): array
    {
        $out = [];
        foreach ($rows as $row) {
            $group = (string) ($row['setting_group'] ?? 'general');
            $out[$group][] = $row;
        }
        ksort($out);
        return $out;
    }

    private function boolVal(string $value): bool
    {
        return in_array(strtolower(trim($value)), ['1', 'true', 'yes', 'on'], true);
    }

    /**
     * @param array<string,string> $map
     */
    private function boolSetting(array $map, string $key, bool $default): bool
    {
        if (!isset($map[$key])) return $default;
        return $this->boolVal((string) $map[$key]);
    }

    /**
     * @param array<string,string> $map
     */
    private function intSetting(array $map, string $key, int $default): int
    {
        if (!isset($map[$key]) || !is_numeric($map[$key])) return $default;
        return (int) $map[$key];
    }

    /**
     * @param array<string,string> $map
     */
    private function floatSetting(array $map, string $key, float $default): float
    {
        if (!isset($map[$key]) || !is_numeric($map[$key])) return $default;
        return (float) $map[$key];
    }

    /**
     * @param array<string,string> $map
     */
    private function stringSetting(array $map, string $key, string $default): string
    {
        $v = trim((string) ($map[$key] ?? ''));
        return $v !== '' ? $v : $default;
    }

    private function etaToDays(string $eta): int
    {
        if (preg_match('/(\d+)/', $eta, $m)) {
            return (int) $m[1];
        }
        return 3;
    }

    private function mask(string $value): string
    {
        $value = trim($value);
        if ($value === '') return '';
        if (strlen($value) <= 6) return str_repeat('*', strlen($value));
        return substr($value, 0, 3) . str_repeat('*', max(4, strlen($value) - 6)) . substr($value, -3);
    }

    private function maskSecret(string $value): string
    {
        $value = trim($value);
        if ($value === '') return '';
        return str_repeat('*', max(8, min(20, strlen($value))));
    }

    private function isSensitiveKey(string $key): bool
    {
        $k = strtolower($key);
        return strpos($k, 'secret') !== false
            || strpos($k, 'password') !== false
            || strpos($k, 'token') !== false
            || strpos($k, 'api_key') !== false
            || strpos($k, 'smtp') !== false;
    }
}
