<?php

declare(strict_types=1);

namespace App\Models;

final class ActivityLog extends BaseModel
{
    protected string $table = 'activity_logs';

    /**
     * @return array<string,mixed>|null
     */
    public function find($id): ?array
    {
        return parent::find($id);
    }

    /**
     * @return array<int, array<string,mixed>>
     */
    public function getRecent(int $limit = 50): array
    {
        $stmt = $this->db->prepare("SELECT a.*, u.full_name as staff_name FROM {$this->table} a LEFT JOIN users u ON a.staff_id = u.id ORDER BY a.created_at DESC LIMIT :limit");
        $stmt->bindValue(':limit', max(1, $limit), \PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }
    
    /**
     * @return array<int, array<string,mixed>>
     */
    public function getUnreadHighPriority(): array
    {
        $stmt = $this->db->query("SELECT a.*, u.full_name as staff_name FROM {$this->table} a LEFT JOIN users u ON a.staff_id = u.id WHERE a.is_read = 0 ORDER BY a.created_at DESC LIMIT 20");
        return $stmt->fetchAll();
    }
    
    public function markAsRead(int $id): void
    {
        $this->update($id, ['is_read' => 1]);
    }
    
    public function markAllAsRead(): void
    {
        $this->db->exec("UPDATE {$this->table} SET is_read = 1 WHERE is_read = 0");
    }
}
