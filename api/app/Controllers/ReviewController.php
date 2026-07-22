<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Core\Database;
use App\Helpers\Request;
use App\Models\ProductReview;
use App\Services\MailService;

final class ReviewController extends BaseController
{
    /** GET /api/reviews?product_id=... */
    public function index(): never
    {
        $posId = (string) Request::query('product_id', '');
        if ($posId === '') $this->fail('product_id is required', 422);
        $reviews = (new ProductReview())->approvedFor($posId);
        $this->ok([
            'items' => array_map(fn($r) => [
                'id'          => (int) $r['id'],
                'user_name'   => $r['user_name'] ?? 'Customer',
                'rating'      => (int) $r['rating'],
                'review_text' => $r['review_text'],
                'created_at'  => $r['created_at'],
            ], $reviews),
        ], 'Reviews fetched');
    }

    /** POST /api/reviews — auth required (Phase 2 will inject user_id) */
    public function store(): never
    {
        $clean = $this->validate([
            'product_id' => 'required|string|max:64',
            'rating'         => 'required|integer|min:1|max:5',
            'review_text'    => 'string|max:2000',
        ]);

        // Default approval status comes from settings (review-auto-approve flag).
        $auto = $this->reviewsAutoApprove();
        $model = new ProductReview();
        
        $userId = isset($_SERVER['AUTH_USER_ID']) ? (int) $_SERVER['AUTH_USER_ID'] : null;

        $id = $model->insert([
            'product_id' => $clean['product_id'],
            'user_id'    => $userId,
            'rating'     => (int) $clean['rating'],
            'review_text'=> $clean['review_text'] ?? null,
            'status'     => $auto ? 'approved' : 'pending',
        ]);

        try {
            $mailService = new MailService();
            $mailService->sendAdminNewReviewEmail([
                'id'          => $id,
                'product_id'  => $clean['product_id'],
                'rating'      => (int) $clean['rating'],
                'review_text' => $clean['review_text'] ?? 'No text provided',
                'status'      => $auto ? 'approved' : 'pending',
                'user_id'     => $userId
            ]);
        } catch (\Throwable $e) {
            // Silently fail email sending so review submission still succeeds
        }

        $this->ok([
            'id'     => (int) $id,
            'status' => $auto ? 'approved' : 'pending',
        ], 'Review submitted');
    }

    private function reviewsAutoApprove(): bool
    {
        $stmt = Database::connection()->prepare(
            "SELECT setting_value FROM settings WHERE setting_key = 'reviews_auto_approve' LIMIT 1"
        );
        $stmt->execute();
        $row = $stmt->fetch();
        if (!$row) return false;
        $val = json_decode((string) $row['setting_value'], true);
        return !empty($val['enabled']);
    }
}
