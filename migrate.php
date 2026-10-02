<?php

require_once __DIR__ . '/src/Core/Database.php';

$pdo = Database::getConnection();

$pdo->exec("
    CREATE TABLE IF NOT EXISTS schema_migrations (
        id SERIAL PRIMARY KEY,
        migration VARCHAR(255) NOT NULL UNIQUE,
        applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
");

$files = glob(__DIR__ . '/migrations/*.php');
sort($files);

foreach ($files as $file) {
    $migrationName = basename($file);

    $stmt = $pdo->prepare("SELECT COUNT(*) FROM schema_migrations WHERE migration = :migration");
    $stmt->execute([':migration' => $migrationName]);

    if ((int)$stmt->fetchColumn() > 0) {
        echo "Пропущена: {$migrationName}\n";
        continue;
    }

    $pdo->beginTransaction();

    try {
        $migration = require $file;

        if (!isset($migration['up']) || !is_callable($migration['up'])) {
            throw new RuntimeException("Миграция {$migrationName} не содержит функцию up.");
        }

        $migration['up']($pdo);

        $stmt = $pdo->prepare("INSERT INTO schema_migrations (migration) VALUES (:migration)");
        $stmt->execute([':migration' => $migrationName]);

        $pdo->commit();

        echo "Применена: {$migrationName}\n";
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        echo "Ошибка: {$migrationName}: {$e->getMessage()}\n";
        exit(1);
    }
}

echo "Миграции успешно применены.\n";