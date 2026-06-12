<?php

use App\Models\User;
use App\Models\Gig;
use App\Models\EscrowTransaction;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

test('admin can access dashboard and view pending escrows without relation errors', function () {
    // 1. Create admin user
    $admin = User::factory()->create([
        'is_admin' => true,
        'kyc_status' => 'approved',
    ]);

    // 2. Create requester and helper users
    $requester = User::factory()->create([
        'name' => 'Budi Requester',
        'is_admin' => false,
        'kyc_status' => 'approved',
    ]);

    $helper = User::factory()->create([
        'name' => 'Andi Helper',
        'is_admin' => false,
        'kyc_status' => 'approved',
    ]);

    // 3. Create a gig for the requester
    $gig = Gig::create([
        'user_id' => $requester->id,
        'helper_id' => $helper->id,
        'title' => 'Bantu Bersihkan Kamar',
        'description' => 'Membersihkan kamar kost ukuran 3x3',
        'location' => 'Kost Asri',
        'category' => 'Lainnya',
        'price' => 50000.00,
        'deadline_date' => now()->addDays(2),
        'deadline_time' => '12:00',
        'status' => 'in_progress',
    ]);

    // 4. Create escrow transaction
    $escrow = EscrowTransaction::create([
        'gig_id' => $gig->id,
        'amount' => 50000.00,
        'status' => 'held',
    ]);

    // 5. Authenticate as admin and request dashboard
    $response = $this->actingAs($admin)
        ->get('/savo/admin/dashboard');

    // 6. Assert success and contents (no RelationNotFoundException!)
    $response->assertStatus(200);
    $response->assertSee('Budi Requester');
    $response->assertSee('Andi Helper');
    $response->assertSee('Rp 50.000');
});
