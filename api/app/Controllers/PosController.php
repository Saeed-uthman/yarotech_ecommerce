<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Helpers\Request;
use App\Helpers\Response;
use App\Services\OrderService;
use App\Models\Product;

final class PosController extends BaseController
{
    /** GET /api/pos/products */
    public function products(): never
    {
        $db = \App\Core\Database::connection();
        $stmt = $db->query("
            SELECT 
                id, 
                name, 
                sku, 
                category, 
                selling_price AS price, 
                selling_price AS unit_price, 
                stock_quantity AS stock, 
                vat_enabled, 
                max_markup
            FROM products
            WHERE status = 'active'
            ORDER BY name ASC
        ");
        $products = $stmt->fetchAll();
        
        $products = array_map(function($p) {
            return [
                'id' => (string) $p['id'],
                'name' => (string) $p['name'],
                'sku' => (string) $p['sku'],
                'category' => (string) $p['category'],
                'price' => (float) $p['price'],
                'unit_price' => (float) $p['unit_price'],
                'stock' => (int) $p['stock'],
                'vat_enabled' => (bool) $p['vat_enabled'],
                'max_markup' => (float) $p['max_markup'],
            ];
        }, $products);

        $this->ok($products, 'POS products fetched successfully');
    }

    /** GET /api/pos/dashboard */
    public function dashboard(): never
    {
        $db = \App\Core\Database::connection();
        
        // TOTAL SALES (POS only)
        $stmt = $db->query("SELECT COALESCE(SUM(total_amount), 0) AS total_sales FROM orders WHERE sale_channel = 'pos'");
        $totalSales = (float) $stmt->fetch()['total_sales'];

        // TOTAL PROFIT (Simple estimation or 0 for now)
        $totalProfit = 0;

        // TOTAL INVOICES
        $stmt = $db->query("SELECT COUNT(*) AS count FROM orders WHERE sale_channel = 'pos'");
        $totalInvoices = (int) $stmt->fetch()['count'];

        // TOTAL INVENTORY VALUE
        $stmt = $db->query("SELECT COALESCE(SUM(cost_price * stock_quantity), 0) AS total_inventory_value FROM products WHERE status = 'active'");
        $totalInventoryValue = (float) $stmt->fetch()['total_inventory_value'];

        // TOTAL PRODUCTS
        $stmt = $db->query("SELECT COUNT(*) AS count FROM products WHERE status = 'active'");
        $totalProducts = (int) $stmt->fetch()['count'];

        // LOW STOCK COUNT
        $stmt = $db->query("SELECT COUNT(*) FROM products WHERE stock_quantity <= minimum_stock AND status = 'active'");
        $lowStockCount = (int) $stmt->fetchColumn();

        // LOW STOCK PRODUCTS
        $stmt = $db->query("
            SELECT id, name, category, stock_quantity AS stock
            FROM products
            WHERE stock_quantity <= minimum_stock AND status = 'active'
            ORDER BY stock_quantity ASC
            LIMIT 10
        ");
        $lowStockProducts = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        foreach ($lowStockProducts as &$p) {
            $p['stock'] = (int)$p['stock'];
        }

        $this->ok([
            'totalSales' => $totalSales,
            'totalProfit' => $totalProfit,
            'totalProducts' => $totalProducts,
            'totalInventoryValue' => $totalInventoryValue,
            'totalInvoices' => $totalInvoices,
            'lowStockCount' => $lowStockCount,
            'lowStockProducts' => $lowStockProducts
        ], 'Dashboard stats fetched successfully');
    }

    /** POST /api/pos/orders */
    public function createOrder(): never
    {
        $payload = $this->all();
        $payload['sale_channel'] = 'pos';
        $payload['order_status'] = 'delivered'; // POS sales are usually immediately delivered
        $payload['payment_status'] = 'success';
        
        if (empty($payload['created_by_user_id'])) {
            $user = Request::user();
            if ($user) {
                $payload['created_by_user_id'] = (int) $user['id'];
            } elseif (isset($_SERVER['AUTH_USER_ID'])) {
                $payload['created_by_user_id'] = (int) $_SERVER['AUTH_USER_ID'];
            } else {
                $payload['created_by_user_id'] = 1; // Fallback to system admin if auth context is missing
            }
        }
        if (empty($payload['created_by'])) {
            $payload['created_by'] = (string) (Request::header('X-User-Role') ?? 'staff');
        }

        $service = new OrderService();
        $envelope = $service->createPosSale($payload);

        $this->ok($envelope, 'POS order created successfully');
    }

    /** GET /api/pos/orders */
    public function orders(): never
    {
        $db = \App\Core\Database::connection();
        // Return recent POS orders
        $stmt = $db->query("
            SELECT id, order_number, customer_name, subtotal, tax_amount AS tax, delivery_fee, total_amount AS total, created_at, order_status, created_by
            FROM orders
            WHERE sale_channel = 'pos'
            ORDER BY created_at DESC
            LIMIT 50
        ");
        $orders = $stmt->fetchAll();

        // Also fetch items for these orders to populate the `items` array
        if (!empty($orders)) {
            $orderIds = array_column($orders, 'id');
            $placeholders = implode(',', array_fill(0, count($orderIds), '?'));
            $itemStmt = $db->prepare("
                SELECT order_id, product_name_snapshot AS name, unit_price_snapshot AS price, quantity
                FROM order_items
                WHERE order_id IN ($placeholders)
            ");
            $itemStmt->execute($orderIds);
            $allItems = $itemStmt->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_ASSOC);

            foreach ($orders as &$order) {
                $order['subtotal'] = (float) $order['subtotal'];
                $order['tax'] = (float) $order['tax'];
                $order['total'] = (float) $order['total'];
                $order['delivery_fee'] = (float) $order['delivery_fee'];
                
                $items = $allItems[$order['id']] ?? [];
                foreach ($items as &$item) {
                    $item['price'] = (float) $item['price'];
                    $item['quantity'] = (int) $item['quantity'];
                }
                $order['items'] = $items;
            }
        }

        $this->ok([
            'data' => $orders,
            'meta' => [
                'total' => count($orders),
                'page' => 1,
                'limit' => 50,
                'total_pages' => 1
            ]
        ], 'POS orders fetched successfully');
    }

    /** POST /api/pos/register */
    public function registerStaff(): never
    {
        $data = $this->all();
        
        if (empty($data['email']) || empty($data['password']) || empty($data['name']) || empty($data['access_code'])) {
            $this->fail('Missing required fields', 400);
        }

        // Validate access code (in a real app this might come from a config or db setting)
        $expectedCode = config('app.pos_access_code', 'YAROPOS2024'); // default fallback
        if ($data['access_code'] !== $expectedCode) {
            $this->fail('Invalid security access code', 403);
        }

        $users = new \App\Models\User();
        if ($users->findByEmail($data['email'])) {
            $this->fail('Email already registered', 409);
        }

        $userId = $users->insert([
            'full_name' => $data['name'],
            'email' => $data['email'],
            'phone' => null,
            'password_hash' => password_hash((string)$data['password'], PASSWORD_BCRYPT),
            'role' => 'staff', // Force staff role for POS signups
            'email_verified_at' => date('Y-m-d H:i:s') // POS staff are pre-verified
        ]);

        $user = $users->find($userId);
        unset($user['password_hash']);

        $auth = new \App\Services\AuthService();
        $token = $auth->generateToken($user);

        $this->ok([
            'user' => $user,
            'token' => $token,
        ], 'Staff registration successful.');
    }

    /** GET /api/pos/settings */
    public function getSettings(): never
    {
        $db = \App\Core\Database::connection();

        $keys = [
            'company_name',
            'company_address',
            'company_phone',
            'company_email',
            'currency_symbol',
            'vat_rate',
        ];

        $placeholders = implode(',', array_fill(0, count($keys), '?'));
        $stmt = $db->prepare(
            "SELECT setting_key, setting_value FROM settings WHERE setting_key IN ($placeholders)"
        );
        $stmt->execute($keys);
        $rawRows = $stmt->fetchAll(\PDO::FETCH_KEY_PAIR); // key => raw JSON string

        // The setting_value column is JSON type — decode each value to a plain string
        $rows = [];
        foreach ($rawRows as $k => $v) {
            if ($v === null) {
                $rows[$k] = '';
            } else {
                $decoded = json_decode((string) $v, true);
                // If it decoded to a scalar use that, otherwise keep raw
                $rows[$k] = is_scalar($decoded) ? (string) $decoded : (string) $v;
            }
        }

        $defaults = [
            'company_name'    => '',
            'company_address' => '',
            'company_phone'   => '',
            'company_email'   => '',
            'currency_symbol' => 'NGN',
            'vat_rate'        => '7.5',
        ];

        $this->ok(array_merge($defaults, $rows), 'Settings fetched successfully');
    }

    /** POST /api/pos/settings */
    public function updateSettings(): never
    {
        $data = Request::body();

        $allowed = [
            'company_name',
            'company_address',
            'company_phone',
            'company_email',
            'currency_symbol',
            'vat_rate',
        ];

        // Use the Setting model which handles JSON encoding and upsert correctly
        $model = new \App\Models\Setting();
        $saved = [];
        foreach ($allowed as $key) {
            if (!array_key_exists($key, $data)) continue;
            $value = (string) $data[$key];
            $model->upsert($key, $value, 'pos');
            $saved[$key] = $value;
        }

        $this->ok($saved, 'Settings updated successfully');
    }

    /** GET /api/stats/analysis.php */
    public function analysisData(): never
    {
        $db = \App\Core\Database::connection();

        // 1. Weekly Data (last 7 days)
        $weeklyData = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = date('Y-m-d', strtotime("-$i days"));
            $stmt = $db->prepare("SELECT COALESCE(SUM(total_amount), 0) as total, COUNT(*) as count FROM orders WHERE sale_channel = 'pos' AND DATE(created_at) = ?");
            $stmt->execute([$date]);
            $row = $stmt->fetch();
            $weeklyData[] = [
                'date' => date('D', strtotime($date)),
                'total' => (float) $row['total'],
                'count' => (int) $row['count']
            ];
        }

        // 2. Monthly Data (last 6 months)
        $monthlyData = [];
        for ($i = 5; $i >= 0; $i--) {
            $month = date('Y-m', strtotime("-$i months"));
            $stmt = $db->prepare("SELECT COALESCE(SUM(total_amount), 0) as total, COUNT(*) as count FROM orders WHERE sale_channel = 'pos' AND DATE_FORMAT(created_at, '%Y-%m') = ?");
            $stmt->execute([$month]);
            $row = $stmt->fetch();
            $monthlyData[] = [
                'date' => date('M', strtotime($month . '-01')),
                'total' => (float) $row['total'],
                'count' => (int) $row['count']
            ];
        }

        $startOfWeek = date('Y-m-d', strtotime('monday this week'));
        $stmt = $db->query("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE sale_channel = 'pos' AND DATE(created_at) >= '$startOfWeek'");
        $thisWeekTotal = (float) $stmt->fetchColumn();

        $startOfLastWeek = date('Y-m-d', strtotime('monday last week'));
        $endOfLastWeek = date('Y-m-d', strtotime('sunday last week'));
        $stmt = $db->query("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE sale_channel = 'pos' AND DATE(created_at) BETWEEN '$startOfLastWeek' AND '$endOfLastWeek'");
        $lastWeekTotal = (float) $stmt->fetchColumn();

        $startOfMonth = date('Y-m-01');
        $stmt = $db->query("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE sale_channel = 'pos' AND DATE(created_at) >= '$startOfMonth'");
        $thisMonthTotal = (float) $stmt->fetchColumn();

        $startOfLastMonth = date('Y-m-01', strtotime('last month'));
        $endOfLastMonth = date('Y-m-t', strtotime('last month'));
        $stmt = $db->query("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE sale_channel = 'pos' AND DATE(created_at) BETWEEN '$startOfLastMonth' AND '$endOfLastMonth'");
        $lastMonthTotal = (float) $stmt->fetchColumn();

        $this->ok([
            'weeklyData' => $weeklyData,
            'monthlyData' => $monthlyData,
            'thisWeekTotal' => $thisWeekTotal,
            'lastWeekTotal' => $lastWeekTotal,
            'thisMonthTotal' => $thisMonthTotal,
            'lastMonthTotal' => $lastMonthTotal,
        ], 'Analysis data fetched successfully');
    }

    /** GET /api/stats/tax.php */
    public function taxData(): never
    {
        $db = \App\Core\Database::connection();
        $year = (int) (\App\Helpers\Request::query('year') ?? date('Y'));

        $stmt = $db->query("SELECT DISTINCT YEAR(created_at) FROM orders WHERE sale_channel = 'pos' ORDER BY YEAR(created_at) DESC");
        $years = $stmt->fetchAll(\PDO::FETCH_COLUMN);
        $availableYears = array_map('intval', $years);
        if (empty($availableYears)) $availableYears = [(int) date('Y')];

        $stmt = $db->prepare("SELECT COALESCE(SUM(tax_amount), 0) as totalTax, COALESCE(SUM(total_amount), 0) as totalSales, COUNT(*) as totalInvoices FROM orders WHERE sale_channel = 'pos' AND YEAR(created_at) = ?");
        $stmt->execute([$year]);
        $totals = $stmt->fetch();
        $totalTax = (float) $totals['totalTax'];
        $totalSales = (float) $totals['totalSales'];
        $totalInvoices = (int) $totals['totalInvoices'];

        $monthlyData = [];
        for ($m = 1; $m <= 12; $m++) {
            $monthFormatted = sprintf('%04d-%02d', $year, $m);
            $stmt = $db->prepare("SELECT COALESCE(SUM(tax_amount), 0) as tax, COALESCE(SUM(total_amount), 0) as sales, COUNT(*) as count FROM orders WHERE sale_channel = 'pos' AND DATE_FORMAT(created_at, '%Y-%m') = ?");
            $stmt->execute([$monthFormatted]);
            $row = $stmt->fetch();
            $monthlyData[] = [
                'month' => date('M', mktime(0, 0, 0, $m, 10)),
                'tax' => (float) $row['tax'],
                'sales' => (float) $row['sales'],
                'invoiceCount' => (int) $row['count'],
            ];
        }

        $quarterlyData = [];
        for ($q = 1; $q <= 4; $q++) {
            $startMonth = ($q - 1) * 3 + 1;
            $endMonth = $q * 3;
            $stmt = $db->prepare("SELECT COALESCE(SUM(tax_amount), 0) as tax, COALESCE(SUM(total_amount), 0) as sales, COUNT(*) as count FROM orders WHERE sale_channel = 'pos' AND YEAR(created_at) = ? AND MONTH(created_at) BETWEEN ? AND ?");
            $stmt->execute([$year, $startMonth, $endMonth]);
            $row = $stmt->fetch();
            $quarterlyData[] = [
                'quarter' => "Q$q",
                'tax' => (float) $row['tax'],
                'sales' => (float) $row['sales'],
                'invoiceCount' => (int) $row['count'],
            ];
        }

        $this->ok([
            'monthlyData' => $monthlyData,
            'quarterlyData' => $quarterlyData,
            'totalTax' => $totalTax,
            'totalSales' => $totalSales,
            'totalInvoices' => $totalInvoices,
            'availableYears' => $availableYears,
            'selectedYear' => $year,
        ], 'Tax data fetched successfully');
    }
}
