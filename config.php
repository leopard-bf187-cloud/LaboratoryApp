<?php

$envPath = __DIR__ . '/.env';

if (!is_file($envPath)) {
    throw new RuntimeException('Файл .env не найден.');
}

$env = parse_ini_file($envPath, false, INI_SCANNER_RAW);

if ($env === false) {
    throw new RuntimeException('Не удалось прочитать файл .env.');
}

return [
    'db' => [
        'host' => $env['DB_HOST'],
        'port' => (int)$env['DB_PORT'],
        'dbname' => $env['DB_NAME'],
        'user' => $env['DB_USER'],
        'password' => $env['DB_PASSWORD'],
        'charset' => $env['DB_CHARSET'] ?? 'utf8',
    ],
];