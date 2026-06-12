<?php

use App\Models\User;
use App\Models\SystemSetting;
use App\Models\Notification;
use App\Models\AdminActivityLog;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

uses(RefreshDatabase::class);

test('admin can access settings page', function () {
    $admin = User::factory()->create(['is_admin' => true]);

    $response = $this->actingAs($admin)
        ->get('/savo/admin/settings');

    $response->assertStatus(200);
    $response->assertSee('Pengaturan Branding');
    $response->assertSee('Kirim Notifikasi Sistem');
});

test('non-admin cannot access settings page', function () {
    $user = User::factory()->create(['is_admin' => false]);

    $response = $this->actingAs($user)
        ->get('/savo/admin/settings');

    $response->assertStatus(302); // Redirect back or login
});

test('admin can update site name and branding', function () {
    Storage::fake('public');
    $admin = User::factory()->create(['is_admin' => true]);

    $logo = UploadedFile::fake()->image('logo.png');
    $icon = UploadedFile::fake()->image('favicon.ico');

    $response = $this->actingAs($admin)
        ->post('/savo/admin/settings', [
            'site_name' => 'Custom SAVO App',
            'site_logo' => $logo,
            'site_icon' => $icon,
        ]);

    $response->assertRedirect();
    $response->assertSessionHas('success');

    $this->assertEquals('Custom SAVO App', SystemSetting::get('site_name'));
    $this->assertNotNull(SystemSetting::get('site_logo'));
    $this->assertNotNull(SystemSetting::get('site_icon'));

    // Check storage
    $logoPath = str_replace('storage/', '', SystemSetting::get('site_logo'));
    $iconPath = str_replace('storage/', '', SystemSetting::get('site_icon'));
    Storage::disk('public')->assertExists($logoPath);
    Storage::disk('public')->assertExists($iconPath);

    // Verify activity log is created
    $this->assertTrue(AdminActivityLog::where('action', 'Update Settings')->exists());
});

test('admin can send broadcast system notification to all users', function () {
    $admin = User::factory()->create(['is_admin' => true]);
    $user1 = User::factory()->create(['is_admin' => false]);
    $user2 = User::factory()->create(['is_admin' => false]);

    $response = $this->actingAs($admin)
        ->post('/savo/admin/settings/notify', [
            'target' => 'all',
            'title' => 'Pemberitahuan Sistem Baru',
            'description' => 'Aplikasi SAVO sedang dalam perawatan terjadwal malam ini.',
        ]);

    $response->assertRedirect();
    $response->assertSessionHas('success');

    // Verify notifications were created for user1 and user2
    $this->assertTrue(Notification::where('user_id', $user1->id)->where('type', 'sistem')->exists());
    $this->assertTrue(Notification::where('user_id', $user2->id)->where('type', 'sistem')->exists());

    // Verify activity log is created
    $this->assertTrue(AdminActivityLog::where('action', 'Send System Notification')->exists());
});

test('admin can send system notification to a specific user', function () {
    $admin = User::factory()->create(['is_admin' => true]);
    $user = User::factory()->create(['is_admin' => false]);

    $response = $this->actingAs($admin)
        ->post('/savo/admin/settings/notify', [
            'target' => $user->id,
            'title' => 'Peringatan Akun',
            'description' => 'Akun Anda terindikasi melanggar aturan penggunaan.',
        ]);

    $response->assertRedirect();
    $response->assertSessionHas('success');

    // Verify notification was created only for that user
    $this->assertTrue(Notification::where('user_id', $user->id)->where('type', 'sistem')->exists());
    $this->assertEquals(1, Notification::where('type', 'sistem')->count());
});

test('anyone can fetch branding settings via api', function () {
    // 1. Check with default values
    $response = $this->getJson('/api/v1/savo/settings');
    $response->assertStatus(200);
    $response->assertJson([
        'status' => 'success',
        'data' => [
            'site_name' => 'SAVO',
            'site_logo' => asset('images/savo_logo.webp'),
            'site_icon' => asset('images/savo_logo.webp'),
            'api_enabled' => true,
        ]
    ]);

    // 2. Update settings and check again
    SystemSetting::set('site_name', 'SAVO Mobile');
    SystemSetting::set('site_logo', 'storage/branding/custom_logo.png');
    SystemSetting::set('site_icon', 'storage/branding/custom_icon.png');
    SystemSetting::set('api_enabled', '0');

    $response = $this->getJson('/api/v1/savo/settings');
    $response->assertStatus(200);
    $response->assertJson([
        'status' => 'success',
        'data' => [
            'site_name' => 'SAVO Mobile',
            'site_logo' => asset('storage/branding/custom_logo.png'),
            'site_icon' => asset('storage/branding/custom_icon.png'),
            'api_enabled' => false,
        ]
    ]);
});

test('api_enabled setting toggle blocks other api endpoints', function () {
    // 1. When API is enabled, public route (like register) is not blocked with 503
    SystemSetting::set('api_enabled', '1');
    $response = $this->postJson('/api/v1/savo/register', []);
    // Validation error or method mismatch, but not 503
    $this->assertNotEquals(503, $response->getStatusCode());

    // 2. When API is disabled, public settings endpoint is NOT blocked
    SystemSetting::set('api_enabled', '0');
    $settingsResponse = $this->getJson('/api/v1/savo/settings');
    $settingsResponse->assertStatus(200);
    $settingsResponse->assertJsonPath('data.api_enabled', false);

    // 3. Other API endpoints (like register) ARE blocked with 503
    $response = $this->postJson('/api/v1/savo/register', []);
    $response->assertStatus(503);
    $response->assertJson([
        'status' => 'error',
        'message' => 'API is currently disabled by administrator.',
        'api_enabled' => false
    ]);
});
