<?php

declare(strict_types=1);

namespace App\Services;

use RuntimeException;

/**
 * Validates and stores uploaded product images under public/uploads/products.
 * Returns the public-relative path that the frontend can render directly.
 */
final class ImageUploadService
{
    private const ALLOWED_MIMES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    private const MAX_BYTES     = 5 * 1024 * 1024; // 5 MB

    public function store(array $file, string $subdir = 'products'): string
    {
        if (!isset($file['tmp_name'], $file['error']) || $file['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException('Upload failed: invalid file payload');
        }
        if ((int) ($file['size'] ?? 0) > self::MAX_BYTES) {
            throw new RuntimeException('Upload failed: file exceeds 5MB limit');
        }

        $mime = null;
        if (class_exists('finfo')) {
            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            $mime  = (string) $finfo->file($file['tmp_name']);
        } elseif (function_exists('mime_content_type')) {
            $mime = (string) mime_content_type($file['tmp_name']);
        } else {
            $mime = (string) ($file['type'] ?? '');
        }
        
        if (!in_array($mime, self::ALLOWED_MIMES, true)) {
            throw new RuntimeException('Upload failed: unsupported image type');
        }

        switch ($mime) {
            case 'image/jpeg': $ext = 'jpg'; break;
            case 'image/png':  $ext = 'png'; break;
            case 'image/webp': $ext = 'webp'; break;
            case 'image/gif':  $ext = 'gif'; break;
            default: $ext = 'bin'; break;
        }

        $dir = APP_BASE_PATH . '/public/uploads/' . trim($subdir, '/');
        if (!is_dir($dir) && !mkdir($dir, 0775, true) && !is_dir($dir)) {
            throw new RuntimeException('Upload failed: cannot create directory');
        }

        $name = bin2hex(random_bytes(12)) . '.' . $ext;
        $dest = $dir . '/' . $name;

        if (!move_uploaded_file($file['tmp_name'], $dest)) {
            throw new RuntimeException('Upload failed: cannot move uploaded file');
        }

        return '/uploads/' . trim($subdir, '/') . '/' . $name;
    }
}
