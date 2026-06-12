<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserIsKycVerified
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Unauthenticated.'
            ], 401);
        }

        // Admins bypass KYC verification checks
        if ($user->is_admin) {
            return $next($request);
        }

        if ($user->kyc_status !== 'approved') {
            return response()->json([
                'status' => 'error',
                'message' => 'Akun Anda belum diverifikasi oleh Admin. Silakan lengkapi KYC terlebih dahulu.',
                'kyc_status' => $user->kyc_status
            ], 403);
        }

        return $next($request);
    }
}
