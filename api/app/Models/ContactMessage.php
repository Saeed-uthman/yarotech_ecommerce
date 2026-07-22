<?php

declare(strict_types=1);

namespace App\Models;

final class ContactMessage extends BaseModel
{
    protected string $table = 'contact_messages';

    /**
     * @return array{items:array<int,array<string,mixed>>,total:int,page:int,per_page:int}
     */
    public function listForAdmin(array $filters = []): array
    {
        $page = max(1, (int) ($filters['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($filters['per_page'] ?? 20)));
        $offset = ($page - 1) * $perPage;

        $where = ['1=1'];
        $params = [];

        if (!empty($filters['status'])) {
            $where[] = 'status = :status';
            $params[':status'] = (string) $filters['status'];
        }
        if (!empty($filters['inquiry_type'])) {
            $where[] = 'inquiry_type = :inquiry_type';
            $params[':inquiry_type'] = (string) $filters['inquiry_type'];
        }
        if (!empty($filters['search'])) {
            $where[] = '(full_name LIKE :q OR email LIKE :q OR inquiry_type LIKE :q OR message LIKE :q)';
            $params[':q'] = '%' . trim((string) $filters['search']) . '%';
        }

        $whereSql = implode(' AND ', $where);

        $count = $this->db->prepare("SELECT COUNT(*) FROM {$this->table} WHERE {$whereSql}");
        foreach ($params as $k => $v) {
            $count->bindValue($k, $v);
        }
        $count->execute();
        $total = (int) $count->fetchColumn();

        $sql = "SELECT *
                FROM {$this->table}
                WHERE {$whereSql}
                ORDER BY created_at DESC, id DESC
                LIMIT :l OFFSET :o";
        $stmt = $this->db->prepare($sql);
        foreach ($params as $k => $v) {
            $stmt->bindValue($k, $v);
        }
        $stmt->bindValue(':l', $perPage, \PDO::PARAM_INT);
        $stmt->bindValue(':o', $offset, \PDO::PARAM_INT);
        $stmt->execute();

        return [
            'items'    => $stmt->fetchAll(),
            'total'    => $total,
            'page'     => $page,
            'per_page' => $perPage,
        ];
    }

    public function updateStatus(int $id, string $status): bool
    {
        $stmt = $this->db->prepare(
            "UPDATE {$this->table} SET status = :s, updated_at = CURRENT_TIMESTAMP WHERE id = :id"
        );
        return $stmt->execute([
            ':s'  => $status,
            ':id' => $id,
        ]);
    }

    public function setReply(int $id, string $reply, ?string $status = null): bool
    {
        if ($status === null) {
            $stmt = $this->db->prepare(
                "UPDATE {$this->table}
                 SET admin_reply = :r, updated_at = CURRENT_TIMESTAMP
                 WHERE id = :id"
            );
            return $stmt->execute([':r' => $reply, ':id' => $id]);
        }

        $stmt = $this->db->prepare(
            "UPDATE {$this->table}
             SET admin_reply = :r, status = :s, updated_at = CURRENT_TIMESTAMP
             WHERE id = :id"
        );
        return $stmt->execute([
            ':r'  => $reply,
            ':s'  => $status,
            ':id' => $id,
        ]);
    }

    /**
     * @return array<int,array<string,mixed>>
     */
    public function listForUser(string $email): array
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM {$this->table} WHERE email = :email ORDER BY created_at DESC"
        );
        $stmt->execute([':email' => $email]);
        return $stmt->fetchAll();
    }
}
