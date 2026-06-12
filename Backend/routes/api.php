<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\GigController;
use App\Http\Controllers\ChatController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\NotificationController;

Route::middleware('api_enabled')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    })->middleware('auth:sanctum');

    // Public & Auth Routes
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);
    Route::post('/reset-password', [AuthController::class, 'resetPassword']);

    // Public App Branding Settings Route
    Route::get('/settings', function () {
        return response()->json([
            'status' => 'success',
            'data' => [
                'site_name' => \App\Models\SystemSetting::get('site_name', 'SAVO') ?: 'SAVO',
                'site_logo' => asset(\App\Models\SystemSetting::get('site_logo') ?: 'images/savo_logo.webp'),
                'site_icon' => asset(\App\Models\SystemSetting::get('site_icon') ?: 'images/savo_logo.webp'),
                'api_enabled' => \App\Models\SystemSetting::get('api_enabled', '1') === '1',
            ]
        ]);
    });

    // Protected Routes (Sanctum)
    Route::middleware('auth:sanctum')->group(function () {
        // User Profile & KYC (Accessible by unverified users so they can complete KYC)
        Route::get('/profile', [ProfileController::class, 'show']);
        Route::put('/profile', [ProfileController::class, 'update']);
        Route::post('/profile/kyc', [ProfileController::class, 'submitKyc']);

        // Routes requiring approved KYC status
        Route::middleware('kyc_verified')->group(function () {
            Route::get('/profile/payment-methods', [PaymentController::class, 'getMethods']);
            Route::post('/profile/payment-methods', [PaymentController::class, 'saveMethod']);
            Route::get('/users/{id}/public-profile', [ProfileController::class, 'publicProfile']);
            
            // Gigs Management
            Route::get('/gigs', [GigController::class, 'index']);
            Route::post('/gigs', [GigController::class, 'store']);
            Route::get('/gigs/{gig}', [GigController::class, 'show']);
            Route::post('/gigs/{gig}/accept', [GigController::class, 'accept']);
            Route::post('/gigs/{gig}/complete', [GigController::class, 'complete']);
            Route::post('/gigs/{gig}/confirm-release', [GigController::class, 'confirmRelease']);
            
            // Chats
            Route::get('/chats', [ChatController::class, 'rooms']);
            Route::post('/chats/get-or-create', [ChatController::class, 'getOrCreateRoom']);
            Route::get('/chats/{room}/messages', [ChatController::class, 'messages']);
            Route::post('/chats/{room}/messages', [ChatController::class, 'sendMessage']);
            
            // Reviews
            Route::post('/reviews', [ReviewController::class, 'store']);
            
            // Reports
            Route::post('/reports', [ReportController::class, 'store']);
            
            // Notifications
            Route::get('/notifications', [NotificationController::class, 'index']);
            Route::put('/notifications/{notification}/read', [NotificationController::class, 'markRead']);
        });
    });
});
