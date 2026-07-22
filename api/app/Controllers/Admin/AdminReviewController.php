<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\ProductReview;
use App\Helpers\Request;

final class AdminReviewController extends BaseController
{
    /**
     * GET /api/admin/reviews
     * GET /api/admin/reviews.php
     */
    public function index(): never
    {
        $status = Request::query('status'); // optional filter: pending, approved, rejected
        $model = new ProductReview();
        
        $reviews = $model->getAdminReviews($status !== '' ? $status : null);
        
        $this->ok([
            'items' => array_map(fn($r) => [
                'id'          => (int) $r['id'],
                'product_id'  => $r['product_id'],
                'user_name'   => $r['user_name'] ?? 'Guest/Unknown',
                'rating'      => (int) $r['rating'],
                'review_text' => $r['review_text'],
                'status'      => $r['status'],
                'created_at'  => $r['created_at'],
            ], $reviews),
        ], 'Admin reviews fetched');
    }

    /**
     * POST /api/admin/reviews/update-status
     * POST /api/admin/reviews/update-status.php
     */
    public function updateStatus(): never
    {
        $clean = $this->validate([
            'id'     => 'required|integer',
            'status' => 'required|string|in:pending,approved,rejected',
        ]);

        $model = new ProductReview();
        $review = $model->find($clean['id']);

        if (!$review) {
            $this->fail('Review not found', 404);
        }

        $model->update($clean['id'], [
            'status' => $clean['status']
        ]);

        $this->ok(null, 'Review status updated');
    }

    /**
     * POST /api/admin/reviews/delete
     * POST /api/admin/reviews/delete.php
     */
    public function delete(): never
    {
        $clean = $this->validate([
            'id' => 'required|integer',
        ]);

        $model = new ProductReview();
        $review = $model->find($clean['id']);

        if (!$review) {
            $this->fail('Review not found', 404);
        }

        $model->delete($clean['id']);

        $this->ok(null, 'Review deleted');
    }
}
