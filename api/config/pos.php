<?php

return [
    'base_url'        => env('POS_API_BASE_URL', ''),
    'api_key'         => env('POS_API_KEY', ''),
    'timeout_seconds' => (int) env('POS_TIMEOUT', '10'),

    // When true OR when base_url/api_key are empty, PosService falls back
    // to the in-memory mock dataset so the frontend can be developed and
    // tested without a live POS connection.
    'use_mock'        => filter_var(env('POS_USE_MOCK', 'true'), FILTER_VALIDATE_BOOLEAN),

    'endpoints' => [
        'products'    => '/api/products',
        'product'     => '/api/products/{id}',
        'stock'       => '/api/products/{id}/stock',
        'create_sale' => '/api/sales',
    ],
];
