<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;

Route::get('/', function () {
    return redirect('/savo/admin/login');
});

// Admin Panel Routes (savo prefix)
Route::prefix('savo/admin')->group(function () {
    // Login routes
    Route::get('/login', [AdminController::class, 'showLoginForm'])->name('admin.login');
    Route::post('/login', [AdminController::class, 'login']);

    // Protected Admin Routes
    Route::middleware(['web', 'admin'])->group(function () {
        Route::get('/dashboard', [AdminController::class, 'dashboard'])->name('admin.dashboard');
        
        // KYC Queue & Review
        Route::get('/antrian-kyc', [AdminController::class, 'antrianKyc'])->name('admin.antrian-kyc');
        Route::get('/detail-kyc/{user?}', [AdminController::class, 'detailKyc'])->name('admin.detail-kyc');
        Route::post('/detail-kyc/{user}/approve', [AdminController::class, 'approveKyc'])->name('admin.kyc.approve');
        Route::post('/detail-kyc/{user}/reject', [AdminController::class, 'rejectKyc'])->name('admin.kyc.reject');
        
        // Dispute Resolution
        Route::get('/konflik/{dispute?}', [AdminController::class, 'konflik'])->name('admin.konflik');
        Route::post('/konflik/resolve/{escrow}', [AdminController::class, 'resolveKonflik'])->name('admin.konflik.resolve');
        
        // Settings & System Notifications
        Route::get('/settings', [AdminController::class, 'settings'])->name('admin.settings');
        Route::post('/settings', [AdminController::class, 'updateSettings'])->name('admin.settings.update');
        Route::post('/settings/profile', [AdminController::class, 'updateProfile'])->name('admin.profile.update');
        Route::post('/settings/notify', [AdminController::class, 'sendSystemNotification'])->name('admin.settings.notify');
        
        // Logout
        Route::post('/logout', [AdminController::class, 'logout'])->name('admin.logout');
        Route::get('/logout', [AdminController::class, 'logout']);
    });
});
