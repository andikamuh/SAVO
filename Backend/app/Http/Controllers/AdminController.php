<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Gig;
use App\Models\EscrowTransaction;
use App\Models\Report;
use App\Models\ChatRoom;
use App\Models\ChatMessage;
use App\Models\AdminActivityLog;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AdminController extends Controller
{
    /**
     * Show the login form.
     */
    public function showLoginForm()
    {
        if (Auth::check() && Auth::user()->is_admin) {
            return redirect('/savo/admin/dashboard');
        }
        return view('admin.login');
    }

    /**
     * Handle authentication.
     */
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $remember = $request->has('remember');

        // Check if user exists and is admin
        $user = User::where('email', $credentials['email'])->first();

        if (!$user || !$user->is_admin) {
            return back()->withErrors([
                'email' => 'Kredensial administrasi tidak cocok atau Anda bukan administrator.',
            ])->withInput($request->only('email', 'remember'));
        }

        if (Auth::attempt($credentials, $remember)) {
            $request->session()->regenerate();

            return redirect()->intended('/savo/admin/dashboard');
        }

        return back()->withErrors([
            'email' => 'Password yang Anda masukkan salah.',
        ])->withInput($request->only('email', 'remember'));
    }

    /**
     * Handle logout.
     */
    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/savo/admin/login');
    }

    /**
     * Display the Dashboard.
     */
    public function dashboard()
    {
        $totalActiveUsers = User::where('is_admin', false)->where('kyc_status', 'approved')->count();
        $activeTransactions = Gig::where('status', 'in_progress')->count();
        $totalActivities = AdminActivityLog::count();

        $recentActivities = AdminActivityLog::with('user')
            ->orderBy('created_at', 'desc')
            ->take(5)
            ->get();

        $awaitingVerifications = EscrowTransaction::with(['gig.requester', 'gig.helper'])
            ->where('status', 'held')
            ->orderBy('created_at', 'desc')
            ->get();

        return view('admin.dashboard', compact(
            'totalActiveUsers',
            'activeTransactions',
            'totalActivities',
            'recentActivities',
            'awaitingVerifications'
        ));
    }

    /**
     * Display the KYC queue list.
     */
    public function antrianKyc(Request $request)
    {
        $query = User::where('kyc_status', 'pending');

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('nim', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $pendingUsers = $query->orderBy('created_at', 'asc')->paginate(10);

        // Stats
        $pendingCount = User::where('kyc_status', 'pending')->count();
        $approvedToday = User::where('kyc_status', 'approved')->whereDate('updated_at', today())->count();
        $rejectedToday = User::where('kyc_status', 'rejected')->whereDate('updated_at', today())->count();

        return view('admin.antrian-kyc', compact(
            'pendingUsers',
            'pendingCount',
            'approvedToday',
            'rejectedToday'
        ));
    }

    /**
     * Review detailed KYC for a student.
     */
    public function detailKyc(Request $request, User $user = null)
    {
        // Fetch all pending users for the sidebar queue
        $queueUsers = User::where('kyc_status', 'pending')->orderBy('created_at', 'asc')->get();

        // If no user is specified, default to the first one in the queue
        if (!$user && $queueUsers->isNotEmpty()) {
            $user = $queueUsers->first();
        }

        return view('admin.detail-kyc', compact('queueUsers', 'user'));
    }

    /**
     * Approve KYC.
     */
    public function approveKyc(User $user)
    {
        $user->update([
            'kyc_status' => 'approved',
            'kyc_rejected_reason' => null,
        ]);

        // Create log
        AdminActivityLog::create([
            'user_id' => Auth::id(),
            'action' => 'Approve KYC',
            'target_type' => 'User',
            'target_id' => $user->id,
            'description' => "KYC disetujui untuk {$user->name} ({$user->prodi})",
        ]);

        // Create notification for the student
        Notification::create([
            'user_id' => $user->id,
            'title' => 'Verifikasi KYC Disetujui',
            'description' => 'Akun Anda telah berhasil diverifikasi oleh admin. Sekarang Anda dapat menggunakan seluruh fitur SAVO!',
            'type' => 'sistem',
            'is_read' => false,
        ]);

        return redirect('/savo/admin/antrian-kyc')->with('success', "KYC untuk {$user->name} berhasil disetujui.");
    }

    /**
     * Reject KYC.
     */
    public function rejectKyc(Request $request, User $user)
    {
        $request->validate([
            'reason' => 'required|string|max:255',
        ]);

        $user->update([
            'kyc_status' => 'rejected',
            'kyc_rejected_reason' => $request->reason,
        ]);

        // Create log
        AdminActivityLog::create([
            'user_id' => Auth::id(),
            'action' => 'Reject KYC',
            'target_type' => 'User',
            'target_id' => $user->id,
            'description' => "KYC ditolak untuk {$user->name} ({$user->prodi}). Alasan: {$request->reason}",
        ]);

        // Create notification
        Notification::create([
            'user_id' => $user->id,
            'title' => 'Verifikasi KYC Ditolak',
            'description' => "Verifikasi KYC Anda ditolak dengan alasan: {$request->reason}. Silakan unggah dokumen yang benar.",
            'type' => 'sistem',
            'is_read' => false,
        ]);

        return redirect('/savo/admin/antrian-kyc')->with('success', "KYC untuk {$user->name} berhasil ditolak.");
    }

    /**
     * Display disputes resolution module.
     */
    public function konflik(Request $request, Report $dispute = null)
    {
        // Get all active dispute reports
        $activeDisputes = Report::with(['gig', 'reporter', 'reportedUser'])
            ->where('category', 'dispute')
            ->orderBy('created_at', 'desc')
            ->get();

        // Count pending
        $pendingDisputesCount = Report::where('category', 'dispute')
            ->where('status', 'pending')
            ->count();

        // If no dispute is selected, default to the first active dispute
        if (!$dispute && $activeDisputes->isNotEmpty()) {
            $dispute = $activeDisputes->first();
        }

        $escrow = null;
        $chatMessages = collect();

        if ($dispute) {
            $escrow = EscrowTransaction::where('gig_id', $dispute->gig_id)->first();
            
            // Get chat room and messages for conversation proof
            $chatRoom = ChatRoom::where('gig_id', $dispute->gig_id)->first();
            if ($chatRoom) {
                $chatMessages = ChatMessage::with('sender')
                    ->where('chat_room_id', $chatRoom->id)
                    ->orderBy('created_at', 'asc')
                    ->get();
            }
        }

        return view('admin.konflik', compact(
            'activeDisputes',
            'dispute',
            'escrow',
            'chatMessages',
            'pendingDisputesCount'
        ));
    }

    /**
     * Resolve a conflict/escrow dispute.
     */
    public function resolveKonflik(Request $request, EscrowTransaction $escrow)
    {
        $request->validate([
            'action' => 'required|in:refund,release,split',
            'dispute_id' => 'required|exists:reports,id',
        ]);

        $action = $request->action;
        $report = Report::find($request->dispute_id);
        $gig = $escrow->gig;

        if ($action === 'refund') {
            $escrow->update([
                'status' => 'refunded',
                'resolution_detail' => 'Refund ke Peminta sesuai keputusan admin.',
                'resolved_by' => Auth::id(),
            ]);

            $gig->update(['status' => 'cancelled']);

            // Notify requester
            Notification::create([
                'user_id' => $gig->user_id,
                'title' => 'Sengketa Diselesaikan (Refund)',
                'description' => "Sengketa untuk pekerjaan '{$gig->title}' diselesaikan. Dana Escrow sebesar Rp " . number_format($escrow->amount, 0, ',', '.') . " dikembalikan ke saldo Anda.",
                'type' => 'sistem',
            ]);

            // Notify helper
            Notification::create([
                'user_id' => $gig->helper_id,
                'title' => 'Sengketa Diselesaikan (Refund)',
                'description' => "Sengketa untuk pekerjaan '{$gig->title}' diselesaikan. Admin memutuskan untuk mengembalikan dana Escrow ke Peminta.",
                'type' => 'sistem',
            ]);

            $descriptionLog = "Refund dana Escrow sebesar Rp " . number_format($escrow->amount, 0, ',', '.') . " ke Peminta ({$report->reporter->name}) untuk pekerjaan: {$gig->title}";

        } elseif ($action === 'release') {
            $escrow->update([
                'status' => 'released',
                'resolution_detail' => 'Dana dilepas ke Pekerja sesuai keputusan admin.',
                'resolved_by' => Auth::id(),
            ]);

            $gig->update([
                'status' => 'completed',
                'completed_at' => now(),
            ]);

            // Notify requester
            Notification::create([
                'user_id' => $gig->user_id,
                'title' => 'Sengketa Diselesaikan (Rilis)',
                'description' => "Sengketa untuk pekerjaan '{$gig->title}' diselesaikan. Admin memutuskan untuk melepaskan dana Escrow ke Pekerja.",
                'type' => 'sistem',
            ]);

            // Notify helper
            Notification::create([
                'user_id' => $gig->helper_id,
                'title' => 'Sengketa Diselesaikan (Rilis)',
                'description' => "Sengketa untuk pekerjaan '{$gig->title}' diselesaikan. Dana Escrow sebesar Rp " . number_format($escrow->amount, 0, ',', '.') . " telah dirilis ke rekening/wallet Anda.",
                'type' => 'sistem',
            ]);

            $descriptionLog = "Rilis dana Escrow sebesar Rp " . number_format($escrow->amount, 0, ',', '.') . " ke Pekerja ({$report->reportedUser->name}) untuk pekerjaan: {$gig->title}";

        } else { // split
            $escrow->update([
                'status' => 'split',
                'resolution_detail' => 'Dana dibagi 50/50 sesuai keputusan admin.',
                'resolved_by' => Auth::id(),
            ]);

            $gig->update([
                'status' => 'completed',
                'completed_at' => now(),
            ]);

            $splitAmount = $escrow->amount / 2;

            // Notify requester
            Notification::create([
                'user_id' => $gig->user_id,
                'title' => 'Sengketa Diselesaikan (Split 50/50)',
                'description' => "Sengketa untuk pekerjaan '{$gig->title}' diselesaikan. Admin memutuskan untuk membagi rata dana Escrow (50/50). Dana sebesar Rp " . number_format($splitAmount, 0, ',', '.') . " dikembalikan ke Anda.",
                'type' => 'sistem',
            ]);

            // Notify helper
            Notification::create([
                'user_id' => $gig->helper_id,
                'title' => 'Sengketa Diselesaikan (Split 50/50)',
                'description' => "Sengketa untuk pekerjaan '{$gig->title}' diselesaikan. Admin memutuskan untuk membagi rata dana Escrow (50/50). Dana sebesar Rp " . number_format($splitAmount, 0, ',', '.') . " dirilis ke rekening/wallet Anda.",
                'type' => 'sistem',
            ]);

            $descriptionLog = "Pembagian 50/50 dana Escrow (masing-masing Rp " . number_format($splitAmount, 0, ',', '.') . ") antara Peminta dan Pekerja untuk pekerjaan: {$gig->title}";
        }

        // Update report status to resolved
        $report->update(['status' => 'resolved']);

        // Log Admin Activity
        AdminActivityLog::create([
            'user_id' => Auth::id(),
            'action' => 'Resolve Dispute',
            'target_type' => 'EscrowTransaction',
            'target_id' => $escrow->id,
            'description' => $descriptionLog,
        ]);

        return redirect('/savo/admin/konflik')->with('success', 'Sengketa berhasil diselesaikan.');
    }

    /**
     * Display the settings and notification forms.
     */
    public function settings()
    {
        $users = User::where('is_admin', false)->orderBy('name', 'asc')->get();
        return view('admin.settings', compact('users'));
    }

    /**
     * Update system settings (site name, logo, icon).
     */
    public function updateSettings(Request $request)
    {
        $request->validate([
            'site_name' => 'required|string|max:50',
            'site_logo' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'site_icon' => 'nullable|file|mimes:jpeg,png,jpg,gif,svg,ico|max:1024',
        ]);

        \App\Models\SystemSetting::set('site_name', $request->site_name);

        $apiEnabled = $request->has('api_enabled') ? '1' : '0';
        \App\Models\SystemSetting::set('api_enabled', $apiEnabled);

        if ($request->hasFile('site_logo')) {
            $logoFile = $request->file('site_logo');
            $logoName = 'logo_' . time() . '_' . uniqid() . '.' . $logoFile->getClientOriginalExtension();
            
            // Delete old logo if exists in public directory
            $oldLogo = \App\Models\SystemSetting::get('site_logo');
            if ($oldLogo) {
                $oldPath = public_path(str_replace('storage/', '', $oldLogo));
                if (file_exists($oldPath)) {
                    @unlink($oldPath);
                }
            }
            
            $logoFile->move(public_path('branding'), $logoName);
            \App\Models\SystemSetting::set('site_logo', 'branding/' . $logoName);
        }

        if ($request->hasFile('site_icon')) {
            $iconFile = $request->file('site_icon');
            $iconName = 'icon_' . time() . '_' . uniqid() . '.' . $iconFile->getClientOriginalExtension();
            
            // Delete old icon if exists in public directory
            $oldIcon = \App\Models\SystemSetting::get('site_icon');
            if ($oldIcon) {
                $oldPath = public_path(str_replace('storage/', '', $oldIcon));
                if (file_exists($oldPath)) {
                    @unlink($oldPath);
                }
            }
            
            $iconFile->move(public_path('branding'), $iconName);
            \App\Models\SystemSetting::set('site_icon', 'branding/' . $iconName);
        }

        // Log Admin Activity
        AdminActivityLog::create([
            'user_id' => Auth::id(),
            'action' => 'Update Settings',
            'target_type' => 'SystemSetting',
            'target_id' => 0,
            'description' => "Memperbarui pengaturan sistem: nama situs menjadi '{$request->site_name}', " . 
                "status API " . ($apiEnabled === '1' ? 'Aktif' : 'Nonaktif') . 
                ($request->hasFile('site_logo') ? ", memperbarui logo" : "") . 
                ($request->hasFile('site_icon') ? ", memperbarui icon" : ""),
        ]);

        return redirect()->back()->with('success', 'Pengaturan sistem berhasil diperbarui.');
    }

    /**
     * Send system notification to users.
     */
    public function sendSystemNotification(Request $request)
    {
        $request->validate([
            'target' => 'required',
            'title' => 'required|string|max:150',
            'description' => 'required|string',
        ]);

        $title = $request->title;
        $description = $request->description;

        if ($request->target === 'all') {
            $users = User::where('is_admin', false)->get();
            foreach ($users as $user) {
                Notification::create([
                    'user_id' => $user->id,
                    'title' => $title,
                    'description' => $description,
                    'type' => 'sistem',
                    'is_read' => false,
                ]);
            }
            $targetDesc = "Semua Pengguna";
        } else {
            $user = User::findOrFail($request->target);
            Notification::create([
                'user_id' => $user->id,
                'title' => $title,
                'description' => $description,
                'type' => 'sistem',
                'is_read' => false,
            ]);
            $targetDesc = $user->name;
        }

        // Log Admin Activity
        AdminActivityLog::create([
            'user_id' => Auth::id(),
            'action' => 'Send System Notification',
            'target_type' => 'Notification',
            'target_id' => 0,
            'description' => "Mengirim notifikasi sistem kepada {$targetDesc}: '{$title}'",
        ]);

        return redirect()->back()->with('success', 'Notifikasi sistem berhasil dikirim.');
    }

    public function updateProfile(Request $request)
    {
        $admin = Auth::user();

        $request->validate([
            'name' => 'required|string|max:255',
            'password' => 'nullable|string|min:8|confirmed',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        $data = [
            'name' => $request->name,
        ];

        if ($request->filled('password')) {
            $data['password'] = Hash::make($request->password);
        }

        if ($request->hasFile('avatar')) {
            // Delete old avatar if exists in public directory
            if ($admin->avatar_url) {
                $oldFilename = basename($admin->avatar_url);
                $oldFilePath = public_path('avatars/' . $oldFilename);
                if (file_exists($oldFilePath)) {
                    @unlink($oldFilePath);
                }
            }

            $file = $request->file('avatar');
            $filename = 'admin_' . time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('avatars'), $filename);
            $data['avatar_url'] = asset('avatars/' . $filename);
        }

        $admin->update($data);

        // Log Admin Activity
        AdminActivityLog::create([
            'user_id' => Auth::id(),
            'action' => 'Update Profile',
            'target_type' => 'User',
            'target_id' => $admin->id,
            'description' => "Admin memperbarui profil sendiri" . 
                ($request->filled('password') ? " dan mengganti password" : "") . 
                ($request->hasFile('avatar') ? " serta memperbarui foto profil" : ""),
        ]);

        return redirect()->back()->with('success', 'Profil Admin berhasil diperbarui.');
    }
}
