<?php

return [
    'up' => function(PDO $pdo): void {
        $pdo->exec('
            CREATE TABLE IF NOT EXISTS entry_attachments (
                id SERIAL PRIMARY KEY,
                entry_id INTEGER NOT NULL REFERENCES entries(id) ON DELETE CASCADE,
                object_key TEXT NOT NULL UNIQUE,
                original_name VARCHAR(255) NOT NULL,
                content_type VARCHAR(100) NOT NULL,
                size_bytes BIGINT NOT NULL CHECK (size_bytes > 0),
                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
        ');
        $pdo->exec('CREATE INDEX IF NOT EXISTS idx_entry_attachments_entry_id ON entry_attachments(entry_id)');
    },
    'down' => function(PDO $pdo): void {
        $pdo->exec('DROP TABLE IF EXISTS entry_attachments');
    },
];
