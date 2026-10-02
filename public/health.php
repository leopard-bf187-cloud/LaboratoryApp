<?php

header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../src/Core/Database.php';

try {
    $pdo = Database::getConnection();
    $pdo->query('SELECT 1');

    echo json_encode(['status' => 'ok', 'db' => 'ok'], JSON_UNESCAPED_UNICODE);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'db' => 'error'], JSON_UNESCAPED_UNICODE);
}

