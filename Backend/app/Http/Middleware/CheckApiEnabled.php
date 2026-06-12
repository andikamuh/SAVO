<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Models\SystemSetting;

class CheckApiEnabled
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // If request is for the public settings API, let it pass so the client knows it is disabled
        if ($request->is('api/v1/savo/settings')) {
            return $next($request);
        }

        // Check if API is enabled (default '1')
        $apiEnabled = SystemSetting::get('api_enabled', '1');

        if ($apiEnabled === '0') {
            return response()->json([
                'status' => 'error',
                'message' => 'API is currently disabled by administrator.',
                'api_enabled' => false
            ], 503);
        }

        return $next($request);
    }
}
