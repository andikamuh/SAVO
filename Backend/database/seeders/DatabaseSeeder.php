<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Gig;
use App\Models\EscrowTransaction;
use App\Models\Report;
use App\Models\ChatRoom;
use App\Models\ChatMessage;
use App\Models\AdminActivityLog;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Truncate tables to make it clean for SQLite
        \Illuminate\Support\Facades\Schema::disableForeignKeyConstraints();
        User::truncate();
        Gig::truncate();
        EscrowTransaction::truncate();
        Report::truncate();
        ChatRoom::truncate();
        ChatMessage::truncate();
        AdminActivityLog::truncate();
        \Illuminate\Support\Facades\Schema::enableForeignKeyConstraints();

        // 1. Seed Admin
        $admin = User::create([
            'name' => 'Budi Santoso',
            'email' => 'admin@savo.edu',
            'password' => Hash::make('password'),
            'is_admin' => true,
            'kyc_status' => 'approved',
        ]);

        // 2. Seed Regular Students (Approved)
        $andi = User::create([
            'name' => 'Andi Wijaya',
            'email' => 'andi@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011044',
            'universitas' => 'Mulia University',
            'prodi' => 'Sistem Informasi',
            'bio' => 'Student developer who loves design and coding.',
            'kyc_status' => 'approved',
            'rating' => 4.8,
            'is_admin' => false,
        ]);

        $rina = User::create([
            'name' => 'Rina Permatasari',
            'email' => 'rina@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011055',
            'universitas' => 'Mulia University',
            'prodi' => 'Ilmu Komunikasi',
            'bio' => 'Freelance designer & content creator.',
            'kyc_status' => 'approved',
            'rating' => 4.9,
            'is_admin' => false,
        ]);

        $rudi = User::create([
            'name' => 'Rudi Hermawan',
            'email' => 'rudi@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011088',
            'universitas' => 'Mulia University',
            'prodi' => 'Informatika',
            'kyc_status' => 'approved',
            'rating' => 4.5,
        ]);

        $maya = User::create([
            'name' => 'Maya Putri',
            'email' => 'maya@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011099',
            'universitas' => 'Mulia University',
            'prodi' => 'Sistem Informasi',
            'kyc_status' => 'approved',
            'rating' => 4.7,
        ]);

        $rizky = User::create([
            'name' => 'Rizky Amelia',
            'email' => 'rizky@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011011',
            'universitas' => 'Mulia University',
            'prodi' => 'Informatika',
            'kyc_status' => 'approved',
            'rating' => 4.6,
        ]);

        $siti = User::create([
            'name' => 'Siti Aminah',
            'email' => 'siti@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011022',
            'universitas' => 'Mulia University',
            'prodi' => 'Sistem Informasi',
            'kyc_status' => 'approved',
            'rating' => 5.0,
        ]);

        $tomi = User::create([
            'name' => 'Tomi Wijaya',
            'email' => 'tomi@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011033',
            'universitas' => 'Mulia University',
            'prodi' => 'Desain Grafis',
            'kyc_status' => 'approved',
            'rating' => 4.2,
        ]);

        // 3. Seed Students Pending KYC (for Queue)
        User::create([
            'name' => 'Ahmad Setiawan',
            'email' => 'ahmad.s@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011045',
            'universitas' => 'Mulia University',
            'prodi' => 'Ilmu Komputer',
            'kyc_status' => 'pending',
            'kyc_ktm_path' => 'ktm/ahmad_ktm.png',
            'kyc_selfie_path' => 'selfie/ahmad_selfie.png',
        ]);

        User::create([
            'name' => 'Budi Prakoso',
            'email' => 'budi.p@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2122012',
            'universitas' => 'Mulia University',
            'prodi' => 'Ekonomi & Bisnis',
            'kyc_status' => 'pending',
            'kyc_ktm_path' => 'ktm/budi_ktm.png',
            'kyc_selfie_path' => 'selfie/budi_selfie.png',
        ]);

        User::create([
            'name' => 'Citra Wahyuni',
            'email' => 'citra.w@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2233098',
            'universitas' => 'Mulia University',
            'prodi' => 'Desain Kreatif',
            'kyc_status' => 'pending',
            'kyc_ktm_path' => 'ktm/citra_ktm.png',
            'kyc_selfie_path' => 'selfie/citra_selfie.png',
        ]);

        User::create([
            'name' => 'Dian Nugraha',
            'email' => 'dian.n@mhs.mulia.ac.id',
            'password' => Hash::make('password'),
            'nim' => '2011076',
            'universitas' => 'Mulia University',
            'prodi' => 'Ilmu Komputer',
            'kyc_status' => 'pending',
            'kyc_ktm_path' => 'ktm/dian_ktm.png',
            'kyc_selfie_path' => 'selfie/dian_selfie.png',
        ]);

        $james = User::create([
            'name' => 'James Smith',
            'email' => 'james.s@student.edu',
            'password' => Hash::make('password'),
            'nim' => 'STU-8924-A',
            'universitas' => 'Tech University',
            'prodi' => 'Computer Science',
            'kyc_status' => 'pending',
            'kyc_ktm_path' => 'ktm/james_ktm.png',
            'kyc_selfie_path' => 'selfie/james_selfie.png',
        ]);

        User::create([
            'name' => 'Maria Garcia',
            'email' => 'm.garcia@state.edu',
            'password' => Hash::make('password'),
            'nim' => 'STU-1234-B',
            'universitas' => 'State College',
            'prodi' => 'Business',
            'kyc_status' => 'pending',
            'kyc_ktm_path' => 'ktm/maria_ktm.png',
            'kyc_selfie_path' => 'selfie/maria_selfie.png',
        ]);

        User::create([
            'name' => 'Alex Lee',
            'email' => 'alee@uni.edu',
            'password' => Hash::make('password'),
            'nim' => 'STU-5678-C',
            'universitas' => 'City University',
            'prodi' => 'Information Technology',
            'kyc_status' => 'pending',
            'kyc_ktm_path' => 'ktm/alex_ktm.png',
            'kyc_selfie_path' => 'selfie/alex_selfie.png',
        ]);

        // 4. Seed Gigs
        // Dispute Gig 1: Desain Poster Fasilkom
        $gig1 = Gig::create([
            'user_id' => $andi->id,
            'helper_id' => $rina->id,
            'title' => 'Desain Poster Fasilkom',
            'description' => 'Membutuhkan desain poster untuk acara tahunan Fasilkom dengan format formal dan revisi maksimal 1 kali.',
            'location' => 'Kampus Mulia',
            'category' => 'Desain',
            'price' => 150000,
            'deadline_date' => now()->addDays(2)->format('Y-m-d'),
            'deadline_time' => '12:00:00',
            'status' => 'disputed',
        ]);

        // Dispute Gig 2: Jasa Terjemahan Jurnal
        $gig2 = Gig::create([
            'user_id' => $rudi->id,
            'helper_id' => $maya->id,
            'title' => 'Jasa Terjemahan Jurnal',
            'description' => 'Terjemahkan jurnal bahasa Inggris ke bahasa Indonesia tentang Machine Learning sebanyak 10 halaman.',
            'location' => 'Remote',
            'category' => 'Tugas Kuliah',
            'price' => 200000,
            'deadline_date' => now()->addDays(5)->format('Y-m-d'),
            'deadline_time' => '23:59:59',
            'status' => 'disputed',
        ]);

        // Dispute Gig 3: Instalasi Software SPSS
        $gig3 = Gig::create([
            'user_id' => $rizky->id,
            'helper_id' => $tomi->id,
            'title' => 'Instalasi Software SPSS',
            'description' => 'Butuh bantuan menginstal software SPSS versi 26 di laptop Mac OS M1.',
            'location' => 'Gedung B Fasilkom',
            'category' => 'Lainnya',
            'price' => 50000,
            'deadline_date' => now()->subDays(1)->format('Y-m-d'),
            'deadline_time' => '17:00:00',
            'status' => 'disputed',
        ]);

        // Gigs that are completed/in progress
        Gig::create([
            'user_id' => $rudi->id,
            'helper_id' => $siti->id,
            'title' => 'Jasa Review Tugas Algoritma',
            'description' => 'Mengevaluasi program Python untuk tugas struktur data.',
            'location' => 'Perpustakaan Utama',
            'category' => 'Tugas Kuliah',
            'price' => 75000,
            'deadline_date' => now()->subDays(2)->format('Y-m-d'),
            'deadline_time' => '15:00:00',
            'status' => 'completed',
            'completed_at' => now()->subDays(2),
        ]);

        Gig::create([
            'user_id' => $maya->id,
            'helper_id' => $tomi->id,
            'title' => 'Antar Paket Buku ke Kosan',
            'description' => 'Bantu ambil paket di pos satpam dan antarkan ke Kos Melati kamar 12.',
            'location' => 'Pos Satpam Utama',
            'category' => 'Antar Barang',
            'price' => 15000,
            'deadline_date' => now()->addHours(3)->format('Y-m-d'),
            'deadline_time' => now()->addHours(3)->format('H:i:s'),
            'status' => 'in_progress',
        ]);

        // 5. Seed Escrow Transactions
        $escrow1 = EscrowTransaction::create([
            'gig_id' => $gig1->id,
            'amount' => 150000,
            'status' => 'held',
        ]);

        $escrow2 = EscrowTransaction::create([
            'gig_id' => $gig2->id,
            'amount' => 200000,
            'status' => 'held',
        ]);

        $escrow3 = EscrowTransaction::create([
            'gig_id' => $gig3->id,
            'amount' => 50000,
            'status' => 'held',
        ]);

        // Completed Gig Escrow
        $completedGig = Gig::where('status', 'completed')->first();
        EscrowTransaction::create([
            'gig_id' => $completedGig->id,
            'amount' => 75000,
            'status' => 'released',
            'resolved_by' => $admin->id,
            'resolution_detail' => 'Automatic release on completion.',
        ]);

        // 6. Seed Dispute Reports
        $report1 = Report::create([
            'gig_id' => $gig1->id,
            'reporter_id' => $andi->id,
            'reported_user_id' => $rina->id,
            'category' => 'dispute',
            'detail_text' => 'Pekerjaan tidak sesuai deskripsi. Rina menolak mengubah warna dan font poster padahal warnanya tidak sesuai tema Fasilkom.',
            'status' => 'pending',
        ]);

        $report2 = Report::create([
            'gig_id' => $gig2->id,
            'reporter_id' => $rudi->id,
            'reported_user_id' => $maya->id,
            'category' => 'dispute',
            'detail_text' => 'Hasil terjemahan kurang akurat dan banyak menggunakan Google Translate tanpa dirapikan.',
            'status' => 'pending',
        ]);

        $report3 = Report::create([
            'gig_id' => $gig3->id,
            'reporter_id' => $rizky->id,
            'reported_user_id' => $tomi->id,
            'category' => 'dispute',
            'detail_text' => 'Tomi merusak sistem OS saya dan software SPSS tetap tidak bisa terbuka setelah dia instal.',
            'status' => 'pending',
        ]);

        // 7. Seed Chat Messages for Proofs
        // Create chat room for Gig 1
        $room1 = ChatRoom::create([
            'gig_id' => $gig1->id,
            'requester_id' => $andi->id,
            'helper_id' => $rina->id,
        ]);

        ChatMessage::create([
            'chat_room_id' => $room1->id,
            'sender_id' => $rina->id,
            'message_text' => 'Halo Kak Andi, ini draft pertama posternya ya. Silakan dicek.',
            'is_read' => true,
        ]);

        ChatMessage::create([
            'chat_room_id' => $room1->id,
            'sender_id' => $andi->id,
            'message_text' => 'Halo Rina. Warnanya kurang cocok nih sama tema acara. Bisa diganti jadi dominan biru nggak? Terus fontnya tolong diganti yang lebih formal.',
            'is_read' => true,
        ]);

        ChatMessage::create([
            'chat_room_id' => $room1->id,
            'sender_id' => $rina->id,
            'message_text' => 'Waduh kak, kalau ganti warna dominan dan font itu berarti rombak total. Di awal kesepakatannya cuma 1 kali revisi minor kak. Kalau begini berarti saya harus buat dari nol lagi...',
            'is_read' => true,
        ]);

        // Chat room for Gig 2
        $room2 = ChatRoom::create([
            'gig_id' => $gig2->id,
            'requester_id' => $rudi->id,
            'helper_id' => $maya->id,
        ]);
        ChatMessage::create([
            'chat_room_id' => $room2->id,
            'sender_id' => $maya->id,
            'message_text' => 'Ini file jurnalnya yang sudah diterjemahkan ya mas Rudi.',
            'is_read' => true,
        ]);
        ChatMessage::create([
            'chat_room_id' => $room2->id,
            'sender_id' => $rudi->id,
            'message_text' => 'Loh kok di halaman 3-5 kalimatnya berantakan banget? Ini langsung copy-paste Google Translate ya?',
            'is_read' => true,
        ]);

        // 8. Seed Admin Activity Logs
        AdminActivityLog::create([
            'user_id' => $admin->id,
            'action' => 'Approve KYC',
            'target_type' => 'User',
            'target_id' => $andi->id,
            'description' => 'KYC disetujui untuk Andi Wijaya (Sistem Informasi)',
        ]);

        AdminActivityLog::create([
            'user_id' => $admin->id,
            'action' => 'Approve KYC',
            'target_type' => 'User',
            'target_id' => $rina->id,
            'description' => 'KYC disetujui untuk Rina Permatasari (Ilmu Komunikasi)',
        ]);

        AdminActivityLog::create([
            'user_id' => $admin->id,
            'action' => 'Refund Escrow',
            'target_type' => 'EscrowTransaction',
            'target_id' => 99,
            'description' => 'Dana Escrow dicairkan Rp 500.000 ke Siti Aminah',
        ]);
    }
}
