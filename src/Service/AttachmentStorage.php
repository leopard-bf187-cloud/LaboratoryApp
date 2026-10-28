<?php

use Aws\S3\S3Client;

/**
 * Stores private diary attachments in Amazon S3 using the EC2 IAM role.
 */
final class AttachmentStorage
{
    private S3Client $client;
    private string $bucket;

    public function __construct(string $bucket, string $region)
    {
        if ($bucket === '' || $region === '') {
            throw new RuntimeException('S3_BUCKET и AWS_REGION должны быть указаны в .env.');
        }

        $this->bucket = $bucket;
        $this->client = new S3Client(['version' => 'latest', 'region' => $region]);
    }

    /**
     * Returns null when no file was submitted; otherwise validates its contents.
     */
    public static function validateUpload(?array $file): ?array
    {
        if ($file === null || ($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) {
            return null;
        }

        if (!isset($file['error'], $file['tmp_name'], $file['name'], $file['size']) || (int)$file['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException('Не удалось принять вложение. Проверьте лимиты загрузки PHP.');
        }

        $path = (string)$file['tmp_name'];
        $size = (int)$file['size'];

        if (!is_uploaded_file($path) || $size < 1 || $size > 10 * 1024 * 1024) {
            throw new RuntimeException('Вложение должно быть размером от 1 байта до 10 МБ.');
        }

        $types = ['image/png' => 'png', 'image/jpeg' => 'jpg', 'application/pdf' => 'pdf'];
        $type = (new finfo(FILEINFO_MIME_TYPE))->file($path);

        if (!isset($types[$type])) {
            throw new RuntimeException('Разрешены только PNG, JPEG и PDF.');
        }

        $name = basename(str_replace('\\', '/', (string)$file['name']));
        if ($name === '' || strlen($name) > 200 || preg_match('/[\x00-\x1F\x7F]/', $name)) {
            throw new RuntimeException('Недопустимое имя вложения.');
        }

        return ['source_file' => $path, 'original_name' => $name, 'content_type' => $type, 'extension' => $types[$type], 'size_bytes' => $size];
    }

    public function upload(array $file): array
    {
        $key = 'uploads/' . bin2hex(random_bytes(16)) . '.' . $file['extension'];
        $this->client->putObject(['Bucket' => $this->bucket, 'Key' => $key, 'SourceFile' => $file['source_file'], 'ContentType' => $file['content_type']]);

        return ['object_key' => $key, 'original_name' => $file['original_name'], 'content_type' => $file['content_type'], 'size_bytes' => $file['size_bytes']];
    }

    public function delete(string $key): void
    {
        $this->assertUploadsKey($key);
        $this->client->deleteObject(['Bucket' => $this->bucket, 'Key' => $key]);
    }

    public function createDownloadUrl(array $attachment): string
    {
        $this->assertUploadsKey($attachment['object_key']);
        $name = $attachment['original_name'];
        $asciiName = preg_replace('/[^a-zA-Z0-9._-]/', '_', $name);
        $asciiName = $asciiName !== '' ? $asciiName : 'attachment';
        $disposition = $attachment['content_type'] === 'application/pdf' ? 'attachment' : 'inline';
        $header = $disposition . '; filename="' . $asciiName . '"; filename*=UTF-8' . "''" . rawurlencode($name);

        $command = $this->client->getCommand('GetObject', [
            'Bucket' => $this->bucket,
            'Key' => $attachment['object_key'],
            'ResponseContentType' => $attachment['content_type'],
            'ResponseContentDisposition' => $header,
        ]);

        return (string)$this->client->createPresignedRequest($command, '+5 minutes')->getUri();
    }

    private function assertUploadsKey(string $key): void
    {
        if (strpos($key, 'uploads/') !== 0 || strlen($key) <= strlen('uploads/')) {
            throw new InvalidArgumentException('Ключ объекта должен находиться внутри uploads/.');
        }
    }
}
