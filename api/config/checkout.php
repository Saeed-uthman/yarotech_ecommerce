<?php

return [
    // Nigerian VAT — toggle / override per environment.
    'vat_enabled'  => filter_var(env('VAT_ENABLED', 'true'), FILTER_VALIDATE_BOOLEAN),
    'vat_rate'     => (float) env('VAT_RATE', '0.075'),

    // Default fee used when no zone matches the requested state/city.
    'default_delivery_fee' => (float) env('DEFAULT_DELIVERY_FEE', '7500'),
    'default_zone_label'   => env('DEFAULT_ZONE_LABEL', 'Other Region'),
    'default_eta'          => env('DEFAULT_ETA', '5-7 business days'),

    // Pickup is always free; expose location for the UI.
    'pickup_label' => env('PICKUP_LABEL', 'Pickup at Lokoro plaza A Farm center, second floor, Kano'),
    'pickup_eta'   => env('PICKUP_ETA', 'Ready in 24 hours'),
];
