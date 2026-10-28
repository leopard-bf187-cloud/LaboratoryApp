<?php

/**
 * Stores attachment metadata in PostgreSQL; file contents live only in S3.
 */
final class AttachmentRepository
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function create(int $entryId, array $data): int
    {
        $statement = $this->pdo->prepare('
            INSERT INTO entry_attachments (entry_id, object_key, original_name, content_type, size_bytes)
            VALUES (:entry_id, :object_key, :original_name, :content_type, :size_bytes)
            RETURNING id
        ');
        $statement->execute([
            ':entry_id' => $entryId,
            ':object_key' => $data['object_key'],
            ':original_name' => $data['original_name'],
            ':content_type' => $data['content_type'],
            ':size_bytes' => $data['size_bytes'],
        ]);

        return (int)$statement->fetchColumn();
    }

    public function findByEntryId(int $entryId): array
    {
        $statement = $this->pdo->prepare('SELECT * FROM entry_attachments WHERE entry_id = :entry_id ORDER BY id');
        $statement->execute([':entry_id' => $entryId]);

        return $statement->fetchAll();
    }

    public function findByEntryIds(array $entries): array
    {
        if (!$entries) {
            return [];
        }

        $ids = array_map(static fn(array $entry): int => (int)$entry['id'], $entries);
        $placeholders = implode(', ', array_fill(0, count($ids), '?'));
        $statement = $this->pdo->prepare('SELECT * FROM entry_attachments WHERE entry_id IN (' . $placeholders . ') ORDER BY id');
        $statement->execute($ids);

        $grouped = [];
        foreach ($statement->fetchAll() as $attachment) {
            $grouped[(int)$attachment['entry_id']][] = $attachment;
        }

        return $grouped;
    }

    public function findByUserId(int $userId): array
    {
        $statement = $this->pdo->prepare('
            SELECT a.* FROM entry_attachments a
            INNER JOIN entries e ON e.id = a.entry_id
            WHERE e.user_id = :user_id
        ');
        $statement->execute([':user_id' => $userId]);

        return $statement->fetchAll();
    }

    public function findAccessible(int $id, int $userId, bool $isAdmin): ?array
    {
        $scope = $isAdmin ? '' : ' AND e.user_id = :user_id';
        $statement = $this->pdo->prepare('SELECT a.* FROM entry_attachments a INNER JOIN entries e ON e.id = a.entry_id WHERE a.id = :id' . $scope);
        $parameters = [':id' => $id];
        if (!$isAdmin) {
            $parameters[':user_id'] = $userId;
        }
        $statement->execute($parameters);

        return $statement->fetch() ?: null;
    }

    public function delete(int $id): void
    {
        $statement = $this->pdo->prepare('DELETE FROM entry_attachments WHERE id = :id');
        $statement->execute([':id' => $id]);
    }
}
