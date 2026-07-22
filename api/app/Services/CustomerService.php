<?php

declare(strict_types=1);

namespace App\Services;

use App\Core\Database;
use App\Models\Customer;

final class CustomerService
{
    private Customer $customers;

    public function __construct(?Customer $customers = null)
    {
        $this->customers = $customers ?? new Customer();
    }

    /**
     * Find or create a standalone customer by phone.
     * If found, updates name/email if better values are provided.
     *
     * @param array{name:string, phone:string, email?:string} $data
     */
    public function findOrCreate(array $data): array
    {
        $phone = trim((string) ($data['phone'] ?? ''));
        $name  = trim((string) ($data['name']  ?? ''));
        $email = trim((string) ($data['email'] ?? ''));

        if ($phone === '') {
            return ['id' => null];
        }

        $existing = $this->customers->findByPhone($phone);

        if ($existing) {
            $updates = [];
            if ($name !== '' && $name !== $existing['full_name'] && $name !== 'Walk-in customer') {
                $updates['full_name'] = $name;
            }
            if ($email !== '' && $email !== ($existing['email'] ?? '')) {
                $updates['email'] = $email;
            }
            if (!empty($updates)) {
                $this->customers->update((int) $existing['id'], $updates);
                return array_merge($existing, $updates);
            }
            return $existing;
        }

        $id = $this->customers->insert([
            'full_name'    => $name !== '' ? $name : 'Walk-in customer',
            'phone'        => $phone,
            'email'        => $email !== '' ? $email : null,
            'total_orders' => 0,
            'total_spent'  => 0.00,
        ]);

        return $this->customers->find((int) $id);
    }

    public function recordOrder(int $customerId, float $totalAmount): void
    {
        $this->customers->incrementOrders($customerId, $totalAmount);
    }

    public function list(array $filters = []): array
    {
        return $this->customers->listForAdmin($filters);
    }

    public function detail(int $id): ?array
    {
        $customer = $this->customers->find($id);
        if (!$customer) return null;

        $db = Database::connection();
        $stmt = $db->prepare(
            "SELECT o.id, o.order_number, o.customer_name, o.customer_email, o.customer_phone,
                    o.subtotal, o.tax_amount, o.delivery_fee, o.total_amount, o.currency,
                    o.order_status, o.payment_status, o.payment_method, o.sale_channel,
                    o.created_at,
                    p.reference AS payment_reference
             FROM orders o
             LEFT JOIN payments p ON p.id = (
                 SELECT p2.id FROM payments p2 WHERE p2.order_id = o.id ORDER BY p2.id DESC LIMIT 1
             )
             WHERE o.customer_phone = :phone
             ORDER BY o.created_at DESC"
        );
        $stmt->execute([':phone' => $customer['phone']]);
        $transactions = $stmt->fetchAll();

        $customer['total_orders'] = count($transactions);
        $customer['total_spent']  = array_sum(array_column($transactions, 'total_amount'));

        return ['customer' => $customer, 'transactions' => $transactions];
    }

    public function createCustomer(array $data): ?array
    {
        $name  = trim((string) ($data['name']  ?? ''));
        $phone = trim((string) ($data['phone'] ?? ''));
        $email = trim((string) ($data['email'] ?? ''));

        if ($phone === '' || $this->customers->findByPhone($phone)) {
            return null;
        }

        $id = $this->customers->insert([
            'full_name'    => $name !== '' ? $name : 'Walk-in customer',
            'phone'        => $phone,
            'email'        => $email !== '' ? $email : null,
            'total_orders' => 0,
            'total_spent'  => 0.00,
        ]);

        return $this->customers->find((int) $id);
    }

    public function updateCustomer(int $id, array $data): ?array
    {
        $customer = $this->customers->find($id);
        if (!$customer) return null;

        $updates = [];
        if (!empty($data['full_name'])) {
            $updates['full_name'] = trim((string) $data['full_name']);
        }
        if (!empty($data['phone'])) {
            $newPhone = trim((string) $data['phone']);
            if ($newPhone !== $customer['phone']) {
                $conflict = $this->customers->findByPhone($newPhone);
                if ($conflict && (int) $conflict['id'] !== $id) return null;
                $updates['phone'] = $newPhone;
            }
        }
        if (array_key_exists('email', $data)) {
            $updates['email'] = trim((string) $data['email']) !== '' ? trim((string) $data['email']) : null;
        }

        if (!empty($updates)) {
            $this->customers->update($id, $updates);
        }

        return $this->customers->find($id);
    }

    public function deleteCustomer(int $id): bool
    {
        if (!$this->customers->find($id)) return false;
        $this->customers->delete($id);
        return true;
    }

    public function search(string $query): array
    {
        return $this->customers->searchByNameOrPhone($query);
    }
}
