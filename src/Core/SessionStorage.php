<?php

use Aws\DynamoDb\DynamoDbClient;
use Aws\DynamoDb\SessionHandler;

/**
 * Initializes PHP sessions with DynamoDB when configured, or local files otherwise.
 */
final class SessionStorage
{
    public static function start(): void
    {
        $envPath = __DIR__ . '/../../.env';

        if (!is_file($envPath)) {
            throw new RuntimeException('Файл .env не найден.');
        }

        $env = parse_ini_file($envPath, false, INI_SCANNER_RAW);

        if ($env === false) {
            throw new RuntimeException('Не удалось прочитать файл .env.');
        }

        $tableName = trim((string)($env['DYNAMODB_SESSIONS_TABLE'] ?? ''));

        if ($tableName !== '') {
            $region = trim((string)($env['AWS_REGION'] ?? ''));

            if ($region === '') {
                throw new RuntimeException('AWS_REGION должен быть указан в .env для DynamoDB.');
            }

            $client = new DynamoDbClient(['version' => 'latest', 'region' => $region]);
            $handler = SessionHandler::fromClient($client, ['table_name' => $tableName, 'hash_key' => 'id', 'session_lifetime_attribute' => 'expires', 'locking' => false]);

            if (!$handler->register()) {
                throw new RuntimeException('Не удалось зарегистрировать обработчик сессий DynamoDB.');
            }
        }

        if (!session_start()) {
            throw new RuntimeException('Не удалось запустить PHP-сессию.');
        }
    }
}
