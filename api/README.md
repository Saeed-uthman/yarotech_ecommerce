# YAROTECH API

Plain modern PHP 8.1+ / MySQL backend for the YAROTECH ecommerce
platform. Product ownership is internal: core product fields and
ecommerce enrichments are both managed directly in this API/database.

## Requirements

- PHP >= 8.1 with `pdo_mysql`, `curl`, `fileinfo`, `mbstring`, `openssl`
- MySQL 5.7+ / MariaDB 10.3+
- Composer

## Setup (XAMPP / local)

```bash
cd yarotech-api
composer install
cp .env.example .env
# edit .env — set DB_*, MAIL_*, POS_*, ADMIN_API_TOKEN
```

Create the database, then run migrations in order:

```bash
mysql -u root yarotech_db < database/schema.sql
mysql -u root yarotech_db < database/migrations/phase3_products.sql
mysql -u root yarotech_db < database/migrations/phase4_cart_checkout.sql
mysql -u root yarotech_db < database/migrations/phase5_orders_payments.sql
mysql -u root yarotech_db < database/migrations/phase6_notifications_logs.sql
mysql -u root yarotech_db < database/migrations/phase7_admin_apis.sql
mysql -u root yarotech_db < database/migrations/phase8_internal_products.sql
mysql -u root yarotech_db < database/migrations/phase9_unified_sales.sql
mysql -u root yarotech_db < database/migrations/phase10_inventory_movements.sql
mysql -u root yarotech_db < database/seed.sql   # optional
```

Point Apache to `yarotech-api/public/` (XAMPP virtual host) or browse
`http://localhost/yarotech-api/public/api/health`.

## cPanel deployment

1. Upload the project outside `public_html` (e.g. `/home/USER/yarotech-api`).
2. Symlink or copy `yarotech-api/public/*` into `public_html/api/`.
3. Set the document root for the `api.yarotech.ng` subdomain to that
   `public_html/api/` directory so `.htaccess` rewrites all traffic to
   `index.php`.
4. Create the MySQL database in cPanel, import `schema.sql` then
   `migrations/phase3_products.sql`.
5. Edit `.env` with the production DB / SMTP / POS / ADMIN credentials.
6. Ensure `public/uploads/products/` is writable (chmod 775).

## Phase 3 — POS-aware product API

| Method | Path                                      | Auth   | Notes                                  |
|--------|-------------------------------------------|--------|----------------------------------------|
| GET    | `/api/products`                           | public | Merged list + filters + pagination     |
| GET    | `/api/products/:slug`                     | public | Merged detail by ecommerce slug        |
| GET    | `/api/categories`                         | public | Distinct POS categories                |
| GET    | `/api/reviews?pos_product_id=POS-001`     | public | Approved reviews                       |
| POST   | `/api/reviews`                            | user   | Submit review (auto/pending per setting)|
| GET    | `/api/admin/products`                     | admin  | Full list incl. hidden                 |
| GET    | `/api/admin/products/missing-meta`        | admin  | POS products with no enrichment        |
| GET    | `/api/admin/products/:posId`              | admin  | Admin detail incl. hidden              |
| POST   | `/api/admin/products/meta`                | admin  | Upsert ecommerce-only fields           |
| POST   | `/api/admin/products/visibility`          | admin  | Show/hide on storefront                |
| POST   | `/api/admin/products/featured`            | admin  | Toggle featured flag                   |
| POST   | `/api/admin/products/specifications`      | admin  | Replace full spec list                 |
| POST   | `/api/admin/products/related`             | admin  | Replace related-items list             |
| POST   | `/api/admin/products/images`              | admin  | Multipart upload (`image`, `pos_product_id`, `is_primary`, `alt_text`) |
| DELETE | `/api/admin/products/images/:id`          | admin  | Remove image record + file             |

### Public list query params

`search`, `category`, `stock_status` (`in_stock|low_stock|out_of_stock`),
`sort` (`newest|price_asc|price_desc|name_asc|rating|featured`),
`page`, `per_page` (max 60).

### Merged product summary shape

```json
{
  "pos_product_id": "POS-001",
  "name": "5KVA Hybrid Inverter",
  "sku": "INV-5KVA",
  "category": "Inverters",
  "price": 450000,
  "stock_quantity": 12,
  "stock_status": "in_stock",
  "slug": "5kva-hybrid-inverter",
  "short_description": "...",
  "primary_image": "/uploads/products/abc.jpg",
  "is_featured": true,
  "rating_average": 4.8,
  "review_count": 124
}
```

### Mock POS fallback

If `POS_USE_MOCK=true` OR `POS_API_BASE_URL`/`POS_API_KEY` are empty,
`PosService` serves a deterministic 6-product mock catalogue. Live POS
errors (timeout, 5xx, non-JSON) also fall back to the mock so the
storefront stays online — failures are recorded in `pos_sync_logs`.

### Admin authentication

Until Phase 2 JWT auth ships, set `ADMIN_API_TOKEN` in `.env` and send
it as `Authorization: Bearer <token>` to admin endpoints. Phase 2 will
swap this for JWT + role check transparently — no route changes needed.

### Frontend integration notes

- The frontend's existing `src/api/products.ts` hits `/api/products` and
  `/api/products/:slug` — the response envelope already matches.
- `src/api/admin.ts` for product enrichment should hit
  `/api/admin/products*` with the admin token.
- `primary_image` and `images[].image_path` are already public-relative
  (`/uploads/...`) — prefix with `APP_URL` when rendering.
- POS-controlled fields (`name`, `sku`, `category`, `price`,
  `stock_quantity`) must be rendered read-only in admin UI.

## Phase 6 - Notifications + email logs + activity logs

User notification endpoints:

- `GET /api/notifications/index.php`
- `GET /api/notifications/unread-count.php`
- `POST /api/notifications/mark-read.php`
- `POST /api/notifications/mark-all-read.php`

Admin notification and audit endpoints:

- `GET /api/admin/notifications.php`
- `GET /api/admin/notifications/unread-count.php`
- `POST /api/admin/notifications/mark-read.php`
- `POST /api/admin/notifications/mark-all-read.php`
- `GET /api/admin/email-logs.php`
- `GET /api/admin/audit/user-activity.php`

Contact intake (for support notification integration):

- `POST /api/contact/store.php`

## Phase 7 - Admin APIs + reports + support/contact + settings

Dashboard:

- `GET /api/admin/dashboard.php`

Orders & users:

- `GET /api/admin/orders/index.php`
- `GET /api/admin/orders/show.php?id=...`
- `POST /api/admin/orders/update-status.php`
- `POST /api/admin/orders/retry-pos-sync.php`
- `GET /api/admin/users/index.php`
- `GET /api/admin/users/show.php?id=...`
- `POST /api/admin/users/update-status.php`

Payments and reports:

- `GET /api/admin/payments/index.php`
- `GET /api/admin/payments/show.php?id=...`
- `GET /api/admin/payments/summary.php`
- `GET /api/admin/reports/index.php?period=monthly`

Support and settings:

- `GET /api/admin/support/index.php`
- `GET /api/admin/support/show.php?id=...`
- `POST /api/admin/support/reply.php`
- `POST /api/admin/support/update-status.php`
- `GET /api/admin/settings/index.php`
- `POST /api/admin/settings/update.php`
- `GET /api/admin/settings/delivery-rates.php`
- `POST /api/admin/settings/update-delivery-rate.php`
- `GET /api/admin/settings/system-config.php`
