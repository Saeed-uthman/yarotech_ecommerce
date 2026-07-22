<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Helpers\Request;
use App\Helpers\Response;
use App\Services\AdminActivityLogService;
use App\Services\AdminSettingsService;

final class AdminSettingsController extends BaseController
{
    private AdminSettingsService $service;
    private AdminActivityLogService $activity;

    public function __construct(
        ?AdminSettingsService $service = null,
        ?AdminActivityLogService $activity = null
    ) {
        $this->service = $service ?? new AdminSettingsService();
        $this->activity = $activity ?? new AdminActivityLogService();
    }

    /** GET /api/admin/settings/index.php */
    public function index(): never
    {
        $group = Request::query('group');
        $this->ok($this->service->index(is_string($group) ? $group : null), 'Settings fetched successfully');
    }

    /** POST /api/admin/settings/update.php */
    public function update(): never
    {
        $key = trim((string) Request::input('setting_key', Request::input('key', '')));
        $valueInput = Request::input('setting_value', Request::input('value', ''));
        $group = trim((string) Request::input('setting_group', Request::input('group', 'general')));
        $isPublic = (bool) filter_var(Request::input('is_public', false), FILTER_VALIDATE_BOOLEAN);

        if ($key === '') {
            Response::validation(['setting_key' => 'setting_key is required.']);
        }
        if ($group === '') {
            $group = 'general';
        }

        $value = is_scalar($valueInput)
            ? (string) $valueInput
            : json_encode($valueInput);

        $row = $this->service->update($key, $value, $group, $isPublic);
        $this->activity->log('settings_updated', 'success', [
            'setting_key' => $key,
            'setting_group' => $group,
        ]);
        $this->ok($row, 'Setting updated successfully');
    }

    /** GET /api/admin/settings/delivery-rates.php */
    public function deliveryRates(): never
    {
        $active = Request::query('is_active');
        $activeFilter = null;
        if ($active !== null) {
            $activeFilter = in_array((string) $active, ['1', 'true', 'yes'], true);
        }
        $this->ok([
            'items' => $this->service->deliveryRates($activeFilter),
        ], 'Delivery rates fetched successfully');
    }

    /** POST /api/admin/settings/update-delivery-rate.php */
    public function updateDeliveryRate(): never
    {
        $id = (int) Request::input('id', 0);
        $state = trim((string) Request::input('state', ''));
        $city = trim((string) Request::input('city_or_lga', Request::input('city', '*')));
        $zoneName = trim((string) Request::input('zone_name', Request::input('region', '')));
        $baseFee = Request::input('base_fee', Request::input('baseFee'));
        $perKg = Request::input('extra_fee_per_kg', Request::input('perKgFee'));
        $etaText = trim((string) Request::input('eta_text', Request::input('eta', '')));
        $isActive = Request::input('is_active', Request::input('enabled'));

        if ($id <= 0 && $state === '') {
            Response::validation(['state' => 'state is required for new delivery zones.']);
        }
        
        if ($zoneName === '' && $state !== '') {
            $zoneName = $state . ' ' . $city;
        }
        if (!is_numeric($baseFee)) {
            Response::validation(['base_fee' => 'base_fee must be numeric.']);
        }

        $row = $this->service->updateDeliveryRate([
            'id' => $id,
            'state' => $state,
            'city_or_lga' => $city !== '' ? $city : '*',
            'zone_name' => $zoneName,
            'base_fee' => (float) $baseFee,
            'extra_fee_per_kg' => is_numeric($perKg) ? (float) $perKg : null,
            'eta_text' => $etaText,
            'is_active' => (bool) filter_var($isActive, FILTER_VALIDATE_BOOLEAN),
        ]);

        $this->activity->log('delivery_rate_updated', 'success', [
            'delivery_zone_id' => (int) $row['id'],
            'state' => $row['state'],
            'city_or_lga' => $row['city_or_lga'],
        ]);

        $this->ok($row, 'Delivery rate updated successfully');
    }

    /** GET /api/admin/settings/system-config.php */
    public function systemConfig(): never
    {
        $this->ok($this->service->systemConfig(), 'System config fetched successfully');
    }
}

