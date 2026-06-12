<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\View;
use App\Models\SystemSetting;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        $settings = [
            'site_name' => 'SAVO',
            'site_logo' => 'images/savo_logo.webp',
            'site_icon' => 'images/savo_logo.webp',
            'api_enabled' => '1',
        ];

        try {
            if (Schema::hasTable('system_settings')) {
                $settings['site_name'] = SystemSetting::get('site_name', 'SAVO') ?: 'SAVO';
                $settings['site_logo'] = SystemSetting::get('site_logo') ?: 'images/savo_logo.webp';
                $settings['site_icon'] = SystemSetting::get('site_icon') ?: 'images/savo_logo.webp';
                $settings['api_enabled'] = SystemSetting::get('api_enabled', '1');
            }
        } catch (\Exception $e) {
            // Ignore DB errors during migrations/seeding
        }

        View::share('system_settings', $settings);
    }
}
