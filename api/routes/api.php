<?php

/**
 * API route definitions.
 *
 * Phase 1: health probe.
 * Phase 3: POS-aware merged products, categories, reviews, and the
 *          admin product enrichment surface.
 *
 * Path conventions:
 *   /api/<resource>            (public collection)
 *   /api/<resource>/:id        (public single)
 *   /api/admin/<resource>      (admin scope, AdminMiddleware)
 *
 * Frontend integration: every URL here is reachable at APP_URL + path.
 */

use App\Controllers\Admin\AdminProductController;
use App\Controllers\Admin\AdminAuditController;
use App\Controllers\Admin\AdminDashboardController;
use App\Controllers\Admin\AdminNotificationController;
use App\Controllers\Admin\AdminOrderController;
use App\Controllers\Admin\AdminPaymentController;
use App\Controllers\Admin\AdminReportController;
use App\Controllers\Admin\AdminSettingsController;
use App\Controllers\Admin\AdminSupportController;
use App\Controllers\Admin\AdminUserController;
use App\Controllers\CartController;
use App\Controllers\CheckoutController;
use App\Controllers\ContactController;
use App\Controllers\DeliveryController;
use App\Controllers\NotificationController;
use App\Controllers\OrderController;
use App\Controllers\PaymentController;
use App\Controllers\ProductController;
use App\Controllers\ReviewController;
use App\Controllers\AuthController;
use App\Controllers\SitemapController;
use App\Middleware\AdminMiddleware;
use App\Middleware\AuthMiddleware;
use App\Controllers\PosController;
use App\Controllers\InvoiceController;

/** @var \App\Core\Router $router */

// ---------- system ----------
$router->get('/', fn () => [
    'name'    => 'YAROTECH API',
    'status'  => 'ok',
    'version' => '0.7.0',
]);

$router->get('/api/health', fn () => [
    'ok'   => true,
    'env'  => env('APP_ENV', 'local'),
    'time' => date('c'),
    'php'  => PHP_VERSION,
]);

// ---------- sitemap ----------
$router->get('/api/sitemap.xml', [SitemapController::class, 'index']);

// ---------- auth ----------
$router->post('/api/auth/login',    [AuthController::class, 'login']);
$router->post('/api/auth/register', [AuthController::class, 'register']);
$router->post('/api/auth/google',   [AuthController::class, 'googleLogin']);
$router->post('/api/auth/verify-account',          [AuthController::class, 'verifyAccount']);
$router->post('/api/auth/resend-verification-otp', [AuthController::class, 'resendVerificationOtp']);
$router->post('/api/auth/forgot-password',         [AuthController::class, 'forgotPassword']);
$router->post('/api/auth/verify-forgot-otp',       [AuthController::class, 'verifyForgotOtp']);
$router->post('/api/auth/reset-password',          [AuthController::class, 'resetPassword']);
$router->get('/api/auth/me',        [AuthController::class, 'me'], [AuthMiddleware::class]);

// ---------- public storefront ----------
$router->get('/api/products',          [ProductController::class, 'index']);
$router->get('/api/products/:slug',    [ProductController::class, 'show']);
$router->get('/api/categories',        [ProductController::class, 'categories']);

// ---------- public reviews ----------
$router->get('/api/reviews',           [ReviewController::class, 'index']);
$router->post('/api/reviews',          [ReviewController::class, 'store'], [AuthMiddleware::class]);

// ---------- admin: POS-aware product enrichment ----------
$router->get('/api/admin/products',                       [AdminProductController::class, 'index'],              [AdminMiddleware::class]);
$router->get('/api/admin/products/missing-meta',          [AdminProductController::class, 'missingMeta'],        [AdminMiddleware::class]);
$router->post('/api/admin/products/create',               [AdminProductController::class, 'create'],             [AdminMiddleware::class]);
$router->post('/api/admin/products/update-core',          [AdminProductController::class, 'updateCore'],         [AdminMiddleware::class]);
$router->post('/api/admin/products/stock-adjustment',     [AdminProductController::class, 'stockAdjustment'],    [AdminMiddleware::class]);
$router->post('/api/admin/products/stock-return',         [AdminProductController::class, 'stockReturn'],        [AdminMiddleware::class]);
$router->post('/api/admin/products/damaged-stock',        [AdminProductController::class, 'damagedStock'],       [AdminMiddleware::class]);
$router->post('/api/admin/products/stock-correction',     [AdminProductController::class, 'stockCorrection'],    [AdminMiddleware::class]);
$router->get('/api/admin/products/inventory-movements',   [AdminProductController::class, 'inventoryMovements'], [AdminMiddleware::class]);
$router->get('/api/admin/inventory/all-movements',        [AdminProductController::class, 'allMovements'],       [AdminMiddleware::class]);
$router->get('/api/admin/products/low-stock',             [AdminProductController::class, 'lowStock'],           [AdminMiddleware::class]);
$router->post('/api/admin/products/meta',                 [AdminProductController::class, 'updateMeta'],         [AdminMiddleware::class]);
$router->post('/api/admin/products/visibility',           [AdminProductController::class, 'setVisibility'],      [AdminMiddleware::class]);
$router->post('/api/admin/products/featured',             [AdminProductController::class, 'setFeatured'],        [AdminMiddleware::class]);
$router->post('/api/admin/products/specifications',       [AdminProductController::class, 'updateSpecifications'], [AdminMiddleware::class]);
$router->post('/api/admin/products/related',              [AdminProductController::class, 'updateRelated'],      [AdminMiddleware::class]);
$router->post('/api/admin/products/images',               [AdminProductController::class, 'uploadImage'],        [AdminMiddleware::class]);
$router->post('/api/admin/products/images/delete',        [AdminProductController::class, 'deleteImage'],        [AdminMiddleware::class]);
$router->post('/api/admin/products/images/set-primary',   [AdminProductController::class, 'setPrimaryImage'],    [AdminMiddleware::class]);
$router->delete('/api/admin/products/:id',                [AdminProductController::class, 'delete'],             [AdminMiddleware::class]);
$router->post('/api/admin/products/:id/archive',          [AdminProductController::class, 'archive'],            [AdminMiddleware::class]);
// phase 7 aliases (.php-style endpoint contracts)
$router->get('/api/admin/products/index.php',                     [AdminProductController::class, 'index'],               [AdminMiddleware::class]);
$router->get('/api/admin/products/missing-meta.php',              [AdminProductController::class, 'missingMeta'],         [AdminMiddleware::class]);
$router->post('/api/admin/products/create.php',                   [AdminProductController::class, 'create'],              [AdminMiddleware::class]);
$router->post('/api/admin/products/update-core.php',              [AdminProductController::class, 'updateCore'],          [AdminMiddleware::class]);
$router->post('/api/admin/products/stock-adjustment.php',         [AdminProductController::class, 'stockAdjustment'],     [AdminMiddleware::class]);
$router->post('/api/admin/products/stock-return.php',             [AdminProductController::class, 'stockReturn'],         [AdminMiddleware::class]);
$router->post('/api/admin/products/damaged-stock.php',            [AdminProductController::class, 'damagedStock'],        [AdminMiddleware::class]);
$router->post('/api/admin/products/stock-correction.php',         [AdminProductController::class, 'stockCorrection'],     [AdminMiddleware::class]);
$router->get('/api/admin/products/inventory-movements.php',       [AdminProductController::class, 'inventoryMovements'],  [AdminMiddleware::class]);
$router->get('/api/admin/products/low-stock.php',                 [AdminProductController::class, 'lowStock'],            [AdminMiddleware::class]);
$router->post('/api/admin/products/meta/update.php',              [AdminProductController::class, 'updateMeta'],          [AdminMiddleware::class]);
$router->post('/api/admin/products/images/upload.php',            [AdminProductController::class, 'uploadImage'],         [AdminMiddleware::class]);
$router->post('/api/admin/products/specifications/update.php',    [AdminProductController::class, 'updateSpecifications'],[AdminMiddleware::class]);
$router->post('/api/admin/products/visibility.php',               [AdminProductController::class, 'setVisibility'],       [AdminMiddleware::class]);
$router->post('/api/admin/products/featured.php',                 [AdminProductController::class, 'setFeatured'],         [AdminMiddleware::class]);
$router->post('/api/admin/products/archive.php',                  [AdminProductController::class, 'archive'],             [AdminMiddleware::class]);
$router->post('/api/admin/products/delete.php',                   [AdminProductController::class, 'delete'],              [AdminMiddleware::class]);
$router->get('/api/admin/products/:posId',                        [AdminProductController::class, 'show'],                [AdminMiddleware::class]);

// ---------- cart (guest + authenticated) ----------
$router->get('/api/cart',              [CartController::class, 'index']);
$router->post('/api/cart/add',            [CartController::class, 'add']);
$router->post('/api/cart/update',         [CartController::class, 'update']);
$router->post('/api/cart/remove',         [CartController::class, 'remove']);
$router->post('/api/cart/clear',          [CartController::class, 'clear']);
$router->post('/api/cart/sync',           [CartController::class, 'sync']);


// ---------- delivery ----------
$router->get('/api/delivery/zones',        [DeliveryController::class, 'zones']);
$router->post('/api/delivery/calculate',   [DeliveryController::class, 'calculate']);

// ---------- checkout (auth required) ----------
$router->post('/api/checkout/preview', [CheckoutController::class, 'preview'], [AuthMiddleware::class]);

// ---------- payments ----------
$router->post('/api/payments/initialize', [PaymentController::class, 'initialize'], [AuthMiddleware::class]);
$router->get('/api/payments/verify',      [PaymentController::class, 'verify'], [AuthMiddleware::class]);
$router->post('/api/payments/webhook',    [PaymentController::class, 'webhook']);

// ---------- orders ----------
$router->get('/api/orders',               [OrderController::class, 'index'], [AuthMiddleware::class]);
$router->get('/api/orders/show',          [OrderController::class, 'show'], [AuthMiddleware::class]);
$router->get('/api/orders/tracking',      [OrderController::class, 'tracking'], [AuthMiddleware::class]);
$router->get('/api/orders/invoice',       [OrderController::class, 'invoice'], [AuthMiddleware::class]);
$router->post('/api/orders/sync-pos',     [OrderController::class, 'syncPos'], [AdminMiddleware::class]);

// ---------- invoices ----------
$router->get('/api/invoices/data',  [InvoiceController::class, 'data'], [AuthMiddleware::class]);
$router->get('/api/invoices/pdf',   [InvoiceController::class, 'pdf'],  [AuthMiddleware::class]);

// ---------- pos endpoints ----------
$router->get('/api/pos/dashboard',        [PosController::class, 'dashboard'], [AuthMiddleware::class]);
$router->get('/api/pos/products',         [PosController::class, 'products'], [AuthMiddleware::class]);
$router->get('/api/pos/orders',           [PosController::class, 'orders'], [AuthMiddleware::class]);
$router->post('/api/pos/orders',          [PosController::class, 'createOrder'], [AuthMiddleware::class]);
$router->post('/api/pos/register',        [PosController::class, 'registerStaff']);
$router->get('/api/pos/settings',         [PosController::class, 'getSettings'], [AuthMiddleware::class]);
$router->post('/api/pos/settings',        [PosController::class, 'updateSettings'], [AuthMiddleware::class]);

// ---------- pos stats endpoints ----------
$router->get('/api/stats/analysis.php',   [PosController::class, 'analysisData'], [AuthMiddleware::class]);
$router->get('/api/stats/tax.php',        [PosController::class, 'taxData'], [AuthMiddleware::class]);

// ---------- contact/inquiry ----------
$router->post('/api/contact/store.php',   [ContactController::class, 'store']);
$router->post('/api/contact/store',       [ContactController::class, 'store']);
$router->get('/api/support/my-tickets',   [ContactController::class, 'myTickets'], [AuthMiddleware::class]);

// ---------- user notifications ----------
$router->get('/api/notifications/index.php',         [NotificationController::class, 'index'], [AuthMiddleware::class]);
$router->get('/api/notifications/unread-count.php',  [NotificationController::class, 'unreadCount'], [AuthMiddleware::class]);
$router->post('/api/notifications/mark-read.php',    [NotificationController::class, 'markRead'], [AuthMiddleware::class]);
$router->post('/api/notifications/mark-all-read.php',[NotificationController::class, 'markAllRead'], [AuthMiddleware::class]);

// optional alias paths (without .php)
$router->get('/api/notifications',                 [NotificationController::class, 'index'], [AuthMiddleware::class]);
$router->get('/api/notifications/unread-count',    [NotificationController::class, 'unreadCount'], [AuthMiddleware::class]);
$router->post('/api/notifications/mark-read',      [NotificationController::class, 'markRead'], [AuthMiddleware::class]);
$router->post('/api/notifications/mark-all-read',  [NotificationController::class, 'markAllRead'], [AuthMiddleware::class]);

// ---------- admin notifications ----------
$router->get('/api/admin/notifications.php',                 [AdminNotificationController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/notifications/unread-count.php',    [AdminNotificationController::class, 'unreadCount'], [AdminMiddleware::class]);
$router->post('/api/admin/notifications/mark-read.php',      [AdminNotificationController::class, 'markRead'], [AdminMiddleware::class]);
$router->post('/api/admin/notifications/mark-all-read.php',  [AdminNotificationController::class, 'markAllRead'], [AdminMiddleware::class]);

// optional alias paths (without .php)
$router->get('/api/admin/notifications',                 [AdminNotificationController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/notifications/unread-count',    [AdminNotificationController::class, 'unreadCount'], [AdminMiddleware::class]);
$router->post('/api/admin/notifications/mark-read',      [AdminNotificationController::class, 'markRead'], [AdminMiddleware::class]);
$router->post('/api/admin/notifications/mark-all-read',  [AdminNotificationController::class, 'markAllRead'], [AdminMiddleware::class]);

// ---------- admin audit ----------
$router->get('/api/admin/email-logs.php',                [AdminAuditController::class, 'emailLogs'], [AdminMiddleware::class]);
$router->get('/api/admin/audit/user-activity.php',       [AdminAuditController::class, 'userActivity'], [AdminMiddleware::class]);

// optional alias paths (without .php)
$router->get('/api/admin/email-logs',                    [AdminAuditController::class, 'emailLogs'], [AdminMiddleware::class]);
$router->get('/api/admin/audit/user-activity',           [AdminAuditController::class, 'userActivity'], [AdminMiddleware::class]);

// ---------- admin dashboard ----------
$router->get('/api/admin/dashboard.php',                 [AdminDashboardController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/dashboard',                     [AdminDashboardController::class, 'index'], [AdminMiddleware::class]);

// ---------- admin orders ----------
$router->get('/api/admin/orders/index.php',              [AdminOrderController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/orders/show.php',               [AdminOrderController::class, 'show'], [AdminMiddleware::class]);
$router->post('/api/admin/orders/update-status.php',     [AdminOrderController::class, 'updateStatus'], [AdminMiddleware::class]);
$router->post('/api/admin/orders/retry-pos-sync.php',    [AdminOrderController::class, 'retryPosSync'], [AdminMiddleware::class]);
$router->post('/api/admin/orders/create-pos-sale.php',   [AdminOrderController::class, 'createPosSale'], [AdminMiddleware::class]);
// optional aliases without .php
$router->get('/api/admin/orders',                        [AdminOrderController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/orders/show',                   [AdminOrderController::class, 'show'], [AdminMiddleware::class]);
$router->post('/api/admin/orders/update-status',         [AdminOrderController::class, 'updateStatus'], [AdminMiddleware::class]);
$router->post('/api/admin/orders/retry-pos-sync',        [AdminOrderController::class, 'retryPosSync'], [AdminMiddleware::class]);
$router->post('/api/admin/orders/create-pos-sale',       [AdminOrderController::class, 'createPosSale'], [AdminMiddleware::class]);

// ---------- admin invoices (for POS / order desk) ----------
$router->get('/api/admin/orders/invoice-data',  [AdminOrderController::class, 'invoiceData'], [AdminMiddleware::class]);
$router->get('/api/admin/orders/invoice-pdf',   [AdminOrderController::class, 'invoicePdf'],  [AdminMiddleware::class]);

// ---------- admin users ----------
$router->get('/api/admin/users/index.php',               [AdminUserController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/users/show.php',                [AdminUserController::class, 'show'], [AdminMiddleware::class]);
$router->post('/api/admin/users/update-status.php',      [AdminUserController::class, 'updateStatus'], [AdminMiddleware::class]);
// optional aliases without .php
$router->get('/api/admin/users',                         [AdminUserController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/users/show',                    [AdminUserController::class, 'show'], [AdminMiddleware::class]);
$router->post('/api/admin/users/update-status',          [AdminUserController::class, 'updateStatus'], [AdminMiddleware::class]);

// ---------- admin payments ----------
$router->get('/api/admin/payments/index.php',            [AdminPaymentController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/payments/show.php',             [AdminPaymentController::class, 'show'], [AdminMiddleware::class]);
$router->get('/api/admin/payments/summary.php',          [AdminPaymentController::class, 'summary'], [AdminMiddleware::class]);
// optional aliases without .php
$router->get('/api/admin/payments',                      [AdminPaymentController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/payments/show',                 [AdminPaymentController::class, 'show'], [AdminMiddleware::class]);
$router->get('/api/admin/payments/summary',              [AdminPaymentController::class, 'summary'], [AdminMiddleware::class]);

// ---------- admin reports ----------
$router->get('/api/admin/reports/index.php',             [AdminReportController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/reports',                       [AdminReportController::class, 'index'], [AdminMiddleware::class]);

// ---------- admin support ----------
$router->get('/api/admin/support/index.php',             [AdminSupportController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/support/show.php',              [AdminSupportController::class, 'show'], [AdminMiddleware::class]);
$router->post('/api/admin/support/reply.php',            [AdminSupportController::class, 'reply'], [AdminMiddleware::class]);
$router->post('/api/admin/support/update-status.php',    [AdminSupportController::class, 'updateStatus'], [AdminMiddleware::class]);
// optional aliases without .php
$router->get('/api/admin/support',                       [AdminSupportController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/support/show',                  [AdminSupportController::class, 'show'], [AdminMiddleware::class]);
$router->post('/api/admin/support/reply',                [AdminSupportController::class, 'reply'], [AdminMiddleware::class]);
$router->post('/api/admin/support/update-status',        [AdminSupportController::class, 'updateStatus'], [AdminMiddleware::class]);

// ---------- admin settings ----------
$router->get('/api/admin/settings/index.php',            [AdminSettingsController::class, 'index'], [AdminMiddleware::class]);
$router->post('/api/admin/settings/update.php',          [AdminSettingsController::class, 'update'], [AdminMiddleware::class]);
$router->get('/api/admin/settings/delivery-rates.php',   [AdminSettingsController::class, 'deliveryRates'], [AdminMiddleware::class]);
$router->post('/api/admin/settings/update-delivery-rate.php', [AdminSettingsController::class, 'updateDeliveryRate'], [AdminMiddleware::class]);
$router->get('/api/admin/settings/system-config.php',    [AdminSettingsController::class, 'systemConfig'], [AdminMiddleware::class]);
// optional aliases without .php
$router->get('/api/admin/settings',                      [AdminSettingsController::class, 'index'], [AdminMiddleware::class]);
$router->post('/api/admin/settings/update',              [AdminSettingsController::class, 'update'], [AdminMiddleware::class]);
$router->get('/api/admin/settings/delivery-rates',       [AdminSettingsController::class, 'deliveryRates'], [AdminMiddleware::class]);
$router->post('/api/admin/settings/update-delivery-rate',[AdminSettingsController::class, 'updateDeliveryRate'], [AdminMiddleware::class]);
$router->get('/api/admin/settings/system-config',        [AdminSettingsController::class, 'systemConfig'], [AdminMiddleware::class]);

// ---------- admin activity logs ----------
$router->get('/api/admin/activity-logs',                 [\App\Controllers\Admin\AdminActivityLogController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/activity-logs/unread',          [\App\Controllers\Admin\AdminActivityLogController::class, 'unread'], [AdminMiddleware::class]);
$router->post('/api/admin/activity-logs/mark-read',      [\App\Controllers\Admin\AdminActivityLogController::class, 'markRead'], [AdminMiddleware::class]);

// ---------- admin customers ----------
$router->get('/api/admin/customers',                     [\App\Controllers\Admin\CustomerController::class, 'index'], [AdminMiddleware::class]);
$router->get('/api/admin/customers/show',                [\App\Controllers\Admin\CustomerController::class, 'show'], [AdminMiddleware::class]);
$router->get('/api/admin/customers/search',              [\App\Controllers\Admin\CustomerController::class, 'search'], [AdminMiddleware::class]);
$router->post('/api/admin/customers/create',             [\App\Controllers\Admin\CustomerController::class, 'create'], [AdminMiddleware::class]);
$router->post('/api/admin/customers/update',             [\App\Controllers\Admin\CustomerController::class, 'update'], [AdminMiddleware::class]);
$router->post('/api/admin/customers/delete',             [\App\Controllers\Admin\CustomerController::class, 'delete'], [AdminMiddleware::class]);

// ---------- admin reviews ----------
$router->get('/api/admin/reviews.php',                   [\App\Controllers\Admin\AdminReviewController::class, 'index'], [AdminMiddleware::class]);
$router->post('/api/admin/reviews/update-status.php',    [\App\Controllers\Admin\AdminReviewController::class, 'updateStatus'], [AdminMiddleware::class]);
$router->post('/api/admin/reviews/delete.php',           [\App\Controllers\Admin\AdminReviewController::class, 'delete'], [AdminMiddleware::class]);
// optional aliases without .php
$router->get('/api/admin/reviews',                       [\App\Controllers\Admin\AdminReviewController::class, 'index'], [AdminMiddleware::class]);
$router->post('/api/admin/reviews/update-status',        [\App\Controllers\Admin\AdminReviewController::class, 'updateStatus'], [AdminMiddleware::class]);
$router->post('/api/admin/reviews/delete',               [\App\Controllers\Admin\AdminReviewController::class, 'delete'], [AdminMiddleware::class]);

