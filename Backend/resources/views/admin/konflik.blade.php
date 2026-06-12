@extends('layouts.admin')

@section('title', $system_settings['site_name'] . ' Admin - Resolusi Konflik')

@section('sidebar')
<!-- SAVO Sidebar for Sengketa -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="sidebar-logo">
            <div class="sidebar-logo-icon" style="overflow: hidden; display: flex; align-items: center; justify-content: center;">
                @if ($system_settings['site_logo'])
                    <img src="{{ asset($system_settings['site_logo']) }}" alt="{{ $system_settings['site_name'] }}" style="width: 100%; height: 100%; object-fit: cover;">
                @else
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                        <path d="M11.47 3.82a.75.75 0 0 1 1.06 0l8.69 8.69a.75.75 0 1 1-1.06 1.06l-.22-.22V19.25a1.75 1.75 0 0 1-1.75 1.75H6.75A1.75 1.75 0 0 1 5 19.25V13.35l-.22.22a.75.75 0 0 1-1.06-1.06l8.69-8.69Z" />
                    </svg>
                @endif
            </div>
            <div>
                <h2>{{ $system_settings['site_name'] }} Admin</h2>
                <p>Admin Portal</p>
            </div>
        </div>
    </div>

    <ul class="sidebar-menu">
        <li class="sidebar-menu-item">
            <a href="{{ route('admin.dashboard') }}" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <rect x="3" y="3" width="7" height="9" rx="1" />
                    <rect x="14" y="3" width="7" height="5" rx="1" />
                    <rect x="14" y="12" width="7" height="9" rx="1" />
                    <rect x="3" y="16" width="7" height="5" rx="1" />
                </svg>
                Dashboard
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a href="{{ route('admin.antrian-kyc') }}" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Antrean KYC
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a href="{{ route('admin.konflik') }}" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
                Resolusi Konflik
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a href="{{ route('admin.settings') }}" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" width="20" height="20">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                Pengaturan
            </a>
        </li>
        <li class="sidebar-menu-item" style="margin-top: 20px;">
            <form id="logout-form" action="{{ route('admin.logout') }}" method="POST" style="display: none;">
                @csrf
            </form>
            <a href="#" onclick="event.preventDefault(); document.getElementById('logout-form').submit();" class="sidebar-link" style="color: var(--accent-red);">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" width="20" height="20">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                </svg>
                Keluar
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <div class="sidebar-profile" style="border-top: 1px solid var(--border-color); padding-top: 14px;">
            <img src="{{ Auth::user()->avatar_url ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop' }}" alt="{{ Auth::user()->name }}" class="sidebar-avatar">
            <div class="sidebar-profile-info">
                <h4>{{ Auth::user()->name }}</h4>
                <p>Super Admin</p>
            </div>
        </div>
    </div>
</aside>
@endsection

@section('navbar')
<nav class="top-navbar">
    <div class="top-navbar-title">
        <h1>Manajemen Resolusi Konflik</h1>
        <span class="divider" style="color: #ECE8E4; font-size: 16px;">/</span>
        <span style="font-size: 13px; color: var(--text-secondary); font-weight: 500;">Tinjau dan selesaikan sengketa transaksi Dana Aman.</span>
    </div>
    <div class="top-navbar-actions">
        <button class="btn-notification">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
            </svg>
        </button>
        <img src="{{ Auth::user()->avatar_url ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop' }}" alt="{{ Auth::user()->name }}" class="navbar-profile-img">
    </div>
</nav>
@endsection

@section('content')
@if (session('success'))
    <div style="background-color: var(--accent-green-light); border-left: 4px solid var(--accent-green); color: var(--text-primary); padding: 12px 16px; margin-bottom: 20px; border-radius: 6px; font-size: 13px; font-weight: 600; max-width: 1200px; margin-left: auto; margin-right: auto;">
        {{ session('success') }}
    </div>
@endif

<div class="dispute-page-layout">
    
    <!-- Left Column: Sengketa Aktif List -->
    <div class="dispute-column-left">
        <div class="dispute-column-header">
            <h3>Sengketa Aktif</h3>
            <span class="badge-dispute-count">{{ $pendingDisputesCount }} Perlu Tindakan</span>
        </div>
        
        <div class="dispute-list-scroll">
            @forelse ($activeDisputes as $item)
                @php
                    $isSelected = $dispute && $dispute->id === $item->id;
                    $itemEscrow = $item->gig ? $item->gig->escrowTransaction : null;
                    
                    $priority = 'Sedang';
                    $priorityClass = 'medium';
                    if ($itemEscrow && $itemEscrow->amount >= 100000) {
                        $priority = 'Tinggi';
                        $priorityClass = 'high';
                    }
                @endphp
                <div class="dispute-list-item {{ $isSelected ? 'active' : '' }}" onclick="location.href='{{ route('admin.konflik', ['dispute' => $item->id]) }}'" style="cursor: pointer;">
                    <div class="dispute-item-meta">
                        <span class="dispute-priority-badge {{ $priorityClass }}">{{ $priority }}</span>
                        <span class="dispute-item-id">ID: D-{{ $item->id }}</span>
                    </div>
                    <div class="dispute-item-title">{{ $item->gig->title ?? 'Sengketa Pekerjaan' }}</div>
                    <div class="dispute-item-footer">
                        <span class="dispute-item-price">Rp {{ $itemEscrow ? number_format($itemEscrow->amount, 0, ',', '.') : '0' }}</span>
                        <span>{{ $item->created_at->diffForHumans() }}</span>
                    </div>
                </div>
            @empty
                <div style="padding: 24px; text-align: center; color: var(--text-secondary); font-size: 13px;">
                    Tidak ada sengketa aktif saat ini.
                </div>
            @endforelse
        </div>
    </div>

    <!-- Mid Column: Selected Dispute Conversation & Justifications -->
    <div class="dispute-column-mid">
        @if ($dispute)
            <!-- Dispute Info Header Card -->
            <div class="dispute-detail-card-main">
                <div class="dispute-detail-header-row">
                    <div class="dispute-detail-title-block">
                        <h3>{{ $dispute->gig->title ?? 'Sengketa Pekerjaan' }}</h3>
                        <div class="dispute-detail-subtitle">
                            Sengketa ID: <span>D-{{ $dispute->id }}</span> • Dana Aman: <span>Rp {{ $escrow ? number_format($escrow->amount, 0, ',', '.') : '0' }}</span>
                        </div>
                    </div>
                    
                    @if ($dispute->status === 'resolved')
                        <div class="dispute-status-banner" style="background-color: var(--accent-green-light); color: var(--accent-green); border-color: transparent;">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="color: var(--accent-green); width: 16px; height: 16px;">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 12l2 2 4-4" />
                            </svg>
                            Selesai Diselesaikan
                        </div>
                    @else
                        <div class="dispute-status-banner">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="width: 16px; height: 16px;">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                            </svg>
                            Menunggu Keputusan
                        </div>
                    @endif
                </div>

                <!-- Actors Profile and Dispute Reasons -->
                <div class="dispute-actors-grid">
                    @php
                        $requester = $dispute->gig->requester ?? null;
                        $helper = $dispute->gig->helper ?? null;
                    @endphp
                    <!-- Requester (Peminta) -->
                    <div class="dispute-actor-card">
                        <div class="actor-role-label">Peminta (Requester)</div>
                        <div class="actor-profile-row">
                            <div class="actor-avatar" style="background-color: #E2DDD9; color: var(--text-primary); display: flex; align-items: center; justify-content: center; font-weight: 600;">
                                {{ $requester ? strtoupper(substr($requester->name, 0, 1)) : 'P' }}
                            </div>
                            <div class="actor-info">
                                <h4>
                                    {{ $requester->name ?? 'User Terhapus' }}
                                    @if ($requester && $requester->kyc_status === 'approved')
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" style="width: 14px; height: 14px; color: var(--accent-maroon); display: inline-block; vertical-align: middle;">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
                                        </svg>
                                    @endif
                                </h4>
                                <p>{{ $requester->prodi ?? 'Mahasiswa' }}</p>
                            </div>
                        </div>
                        <div class="actor-reason-bubble">
                            Alasan Sengketa: {{ $dispute->detail_text }}
                        </div>
                    </div>

                    <!-- Helper (Pekerja) -->
                    <div class="dispute-actor-card" style="border-color: var(--border-color);">
                        <div class="actor-role-label">Pekerja (Helper)</div>
                        <div class="actor-profile-row">
                            <div class="actor-avatar worker" style="background-color: #2D1A16; color: white; display: flex; align-items: center; justify-content: center; font-weight: 600;">
                                {{ $helper ? strtoupper(substr($helper->name, 0, 1)) : 'W' }}
                            </div>
                            <div class="actor-info">
                                <h4>
                                    {{ $helper->name ?? 'Belum Diambil' }}
                                    @if ($helper && $helper->kyc_status === 'approved')
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" style="width: 14px; height: 14px; color: var(--accent-maroon); display: inline-block; vertical-align: middle;">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
                                        </svg>
                                    @endif
                                </h4>
                                <p>{{ $helper->prodi ?? 'Mahasiswa' }}</p>
                            </div>
                        </div>
                        <div class="actor-reason-bubble worker">
                            Status Pekerjaan: {{ $dispute->gig ? ucfirst($dispute->gig->status) : '-' }} • Dana Aman Tertahan
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chat Transcript Card -->
            <div class="chat-transcript-card">
                <div class="chat-transcript-header">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
                    </svg>
                    Bukti Percakapan
                </div>
                
                <div class="chat-conversation-area">
                    <!-- System Action Log -->
                    <div class="chat-system-log">
                        Pekerjaan Dimulai - Dana Rp {{ $escrow ? number_format($escrow->amount, 0, ',', '.') : '0' }} dikunci di Dana Aman
                    </div>

                    @forelse ($chatMessages as $msg)
                        @php
                            $isRequesterMsg = $msg->sender_id === $dispute->gig->user_id;
                            $avatarInitial = strtoupper(substr($msg->sender->name ?? 'U', 0, 1));
                        @endphp
                        <div class="chat-bubble-container {{ $isRequesterMsg ? 'right' : 'left' }}">
                            <div class="chat-bubble-avatar {{ $isRequesterMsg ? 'requester' : '' }}">{{ $avatarInitial }}</div>
                            <div class="chat-bubble-content">
                                <span class="chat-bubble-text">{{ $msg->message_text }}</span>
                                <span class="chat-bubble-time">{{ $msg->created_at->format('d M Y, H:i') }}</span>
                            </div>
                        </div>
                    @empty
                        <div style="padding: 20px; text-align: center; color: var(--text-secondary); font-size: 13px;">
                            Tidak ada bukti percakapan dalam sistem.
                        </div>
                    @endforelse
                </div>
            </div>
        @else
            <!-- If no dispute exists or is selected -->
            <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: white; border-radius: 12px; border: 1px solid var(--border-color); padding: 40px; text-align: center; color: var(--text-secondary); min-height: 400px; width: 100%;">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="48" height="48" style="margin-bottom: 16px; opacity: 0.5;">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <h3 style="font-weight: 700; color: var(--text-primary); margin-bottom: 8px;">Tidak Ada Sengketa</h3>
                <p style="font-size: 13px;">Tidak ada sengketa aktif yang memerlukan tindakan saat ini.</p>
            </div>
        @endif
    </div>

    <!-- Right Column: Admin Decision Panel -->
    <div class="dispute-column-right">
        @if ($dispute && $escrow)
            <h3>Keputusan Admin</h3>
            @if ($dispute->status === 'resolved')
                <div style="background-color: #FAF8F6; border: 1px solid var(--border-color); border-radius: 8px; padding: 16px; margin-top: 12px;">
                    <h4 style="font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 8px;">Status Penyelesaian</h4>
                    <p style="font-size: 13px; color: var(--text-secondary); line-height: 1.5;">
                        Sengketa telah diselesaikan oleh admin.
                    </p>
                    <div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border-color); font-size: 12px; color: var(--text-primary); line-height: 1.6;">
                        <strong>Keputusan:</strong> {{ $escrow->resolution_detail }}<br>
                        <strong>Status Transaksi:</strong> {{ strtoupper($escrow->status) }}<br>
                        <strong>Diselesaikan Pada:</strong> {{ $escrow->updated_at->format('d M Y, H:i') }}
                    </div>
                </div>
            @else
                <p>Pilih resolusi untuk sengketa ini. Dana Aman sebesar <strong>Rp {{ number_format($escrow->amount, 0, ',', '.') }}</strong> akan didistribusikan sesuai pilihan Anda.</p>
                
                <div style="display: flex; flex-direction: column; gap: 12px; margin-top: 8px;">
                    <!-- Action 1: Refund to Requester -->
                    <form id="form-refund" action="{{ route('admin.konflik.resolve', $escrow) }}" method="POST" style="margin: 0;" onsubmit="event.preventDefault(); showConfirmModal('Apakah Anda yakin ingin melakukan refund seluruh dana aman ke Peminta?', 'form-refund');">
                        @csrf
                        <input type="hidden" name="action" value="refund">
                        <input type="hidden" name="dispute_id" value="{{ $dispute->id }}">
                        <button type="submit" class="btn-decision outline" style="width: 100%; text-align: left; display: flex; align-items: center; justify-content: flex-start; cursor: pointer;">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
                            </svg>
                            Refund ke Peminta
                        </button>
                    </form>
 
                    <!-- Action 2: Release to Helper -->
                    <form id="form-release" action="{{ route('admin.konflik.resolve', $escrow) }}" method="POST" style="margin: 0;" onsubmit="event.preventDefault(); showConfirmModal('Apakah Anda yakin ingin melepaskan seluruh dana aman ke Pekerja?', 'form-release');">
                        @csrf
                        <input type="hidden" name="action" value="release">
                        <input type="hidden" name="dispute_id" value="{{ $dispute->id }}">
                        <button type="submit" class="btn-decision outline green-icon" style="width: 100%; text-align: left; display: flex; align-items: center; justify-content: flex-start; cursor: pointer;">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            Rilis ke Pekerja
                        </button>
                    </form>
 
                    <!-- Action 3: Partial Split -->
                    <form id="form-split" action="{{ route('admin.konflik.resolve', $escrow) }}" method="POST" style="margin: 0;" onsubmit="event.preventDefault(); showConfirmModal('Apakah Anda yakin ingin membagi rata dana aman (50/50) antara Peminta dan Pekerja?', 'form-split');">
                        @csrf
                        <input type="hidden" name="action" value="split">
                        <input type="hidden" name="dispute_id" value="{{ $dispute->id }}">
                        <button type="submit" class="btn-decision solid-dark" style="width: 100%; text-align: left; display: flex; align-items: center; justify-content: flex-start; cursor: pointer;">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4" />
                            </svg>
                            Partial Split (50/50)
                        </button>
                    </form>
                </div>
            @endif
        @else
            <h3>Keputusan Admin</h3>
            <p style="font-size: 13px; color: var(--text-secondary); margin-top: 8px;">
                Pilih salah satu sengketa aktif dari daftar di sebelah kiri untuk melihat opsi keputusan penyelesaian.
            </p>
        @endif
    </div>

</div>

<!-- Custom Sleek Resolution Modal -->
<div id="confirm-modal" class="modal-overlay" style="display: none;">
    <div class="modal-content">
        <h3 id="modal-title">Konfirmasi Resolusi</h3>
        <p id="modal-message">Apakah Anda yakin ingin melakukan tindakan ini?</p>
        <div class="modal-buttons">
            <button type="button" class="btn-modal-cancel" onclick="closeConfirmModal()">Batal</button>
            <button type="button" class="btn-modal-confirm" id="modal-confirm-btn">Ya, Konfirmasi</button>
        </div>
    </div>
</div>

<style>
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    backdrop-filter: blur(4px);
    transition: all 0.3s ease;
}
.modal-content {
    background-color: #ffffff;
    padding: 28px 24px;
    border-radius: 16px;
    width: 90%;
    max-width: 380px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
    text-align: center;
    animation: modalSlideUp 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
@keyframes modalSlideUp {
    from { transform: translateY(15px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}
.modal-content h3 {
    font-size: 18px;
    font-weight: 700;
    color: #1A1F26;
    margin-bottom: 12px;
}
.modal-content p {
    font-size: 14px;
    color: #5C5956;
    line-height: 1.5;
    margin-bottom: 24px;
}
.modal-buttons {
    display: flex;
    gap: 12px;
    justify-content: center;
}
.btn-modal-cancel {
    background-color: #F3F1EE;
    color: #2D1A16;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    flex: 1;
    transition: background 0.2s;
}
.btn-modal-cancel:hover {
    background-color: #E6E2DE;
}
.btn-modal-confirm {
    background-color: #2D1A16;
    color: #ffffff;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    flex: 1;
    transition: background 0.2s;
}
.btn-modal-confirm:hover {
    background-color: #1F110F;
}
</style>

<script>
let currentFormToSubmit = null;

function showConfirmModal(message, formId) {
    document.getElementById('modal-message').innerText = message;
    currentFormToSubmit = document.getElementById(formId);
    document.getElementById('confirm-modal').style.display = 'flex';
}

function closeConfirmModal() {
    document.getElementById('confirm-modal').style.display = 'none';
    currentFormToSubmit = null;
}

// Attach listener to confirm button
document.getElementById('modal-confirm-btn').addEventListener('click', function() {
    if (currentFormToSubmit) {
        currentFormToSubmit.submit();
    }
});
</script>
@endsection
