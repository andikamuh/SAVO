<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Review;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class ReviewController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'gig_id' => 'required|exists:gigs,id',
            'reviewee_id' => 'required|exists:users,id',
            'rating' => 'required|integer|min:1|max:5',
            'review_text' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $review = Review::create([
            'gig_id' => $request->gig_id,
            'reviewer_id' => Auth::id(),
            'reviewee_id' => $request->reviewee_id,
            'rating' => $request->rating,
            'review_text' => $request->review_text,
        ]);

        // Re-calculate the average rating for the reviewee user
        $averageRating = Review::where('reviewee_id', $request->reviewee_id)->avg('rating') ?: 0;
        User::where('id', $request->reviewee_id)->update(['rating' => $averageRating]);

        return response()->json([
            'status' => 'success',
            'message' => 'Ulasan berhasil dikirim',
            'data' => $review
        ], 201);
    }
}
