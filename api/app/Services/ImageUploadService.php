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
        if (!isset($file['tmp_name'], $file['error'])) {
            throw new RuntimeException('Upload failed: no file received by the server. Check PHP file_uploads setting and post_max_size.');
        }

        $errorCode = (int) $file['error'];
        if ($errorCode !== UPLOAD_ERR_OK) {
            $descriptions = [
                UPLOAD_ERR_INI_SIZE   => 'File exceeds server upload_max_filesize limit (' . ini_get('upload_max_filesize') . ')',
                UPLOAD_ERR_FORM_SIZE  => 'File exceeds form MAX_FILE_SIZE directive',
                UPLOAD_ERR_PARTIAL    => 'File was only partially uploaded',
                UPLOAD_ERR_NO_FILE    => 'No file was uploaded',
                UPLOAD_ERR_NO_TMP_DIR => 'Missing temporary folder on the server',
                UPLOAD_ERR_CANT_WRITE => 'Failed to write file to disk',
                UPLOAD_ERR_EXTENSION  => 'Upload blocked by a PHP extension',
            ];
            $detail = $descriptions[$errorCode] ?? "Unknown upload error code: $errorCode";
            throw new RuntimeException("Upload failed: $detail");
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
        if (!is_dir($dir) && !@mkdir($dir, 0775, true) && !is_dir($dir)) {
            throw new RuntimeException("Upload failed: cannot create directory '$dir'. Check web server write permissions.");
        }
        if (!is_writable($dir)) {
            throw new RuntimeException("Upload failed: directory '$dir' is not writable. Run: sudo chown -R www-data:www-data '$dir' && sudo chmod -R 775 '$dir'");
        }

        $name = bin2hex(random_bytes(12)) . '.' . $ext;
        $dest = $dir . '/' . $name;

        if (!move_uploaded_file($file['tmp_name'], $dest)) {
            $openBasedir = ini_get('open_basedir');
            $tmpDir = sys_get_temp_dir();
            throw new RuntimeException("Upload failed: move_uploaded_file() returned false. open_basedir=$open_basedir, sys_get_temp_dir=$tmpDir, dest=$dest");
        }

        return '/uploads/' . trim($subdir, '/') . '/' . $name;
    }
}
