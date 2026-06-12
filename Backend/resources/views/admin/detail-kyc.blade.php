@extends('layouts.admin')

@section('title', $system_settings['site_name'] . ' Admin - Tinjauan KYC Detail')

@section('sidebar')
<!-- Sidebar is empty because this screen uses a clean top navbar layout as seen in Image 2 -->
@endsection

@section('main-style', 'margin-left: 0;')

@section('navbar')
<nav class="top-navbar" style="background-color: white; border-bottom: 1px solid var(--border-color); padding: 0 40px;">
    <div class="top-navbar-title">
        <a href="{{ route('admin.dashboard') }}" style="text-decoration: none; font-size: 20px; font-weight: 700; color: var(--text-primary);">Admin Panel</a>
        <span class="divider" style="color: #D1CAC4; font-size: 18px;">|</span>
        <span style="font-size: 15px; color: var(--text-primary); font-weight: 600;">Tinjauan KYC</span>
    </div>
    <div class="top-navbar-actions" style="display: flex; align-items: center; gap: 16px;">
        <button class="btn-notification">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
            </svg>
        </button>
        <div style="display: flex; align-items: center; gap: 8px;">
            <img src="{{ Auth::user()->avatar_url ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop' }}" alt="{{ Auth::user()->name }}" class="navbar-profile-img">
            <span style="font-size: 13px; font-weight: 600; color: var(--text-primary);">{{ Auth::user()->name }}</span>
        </div>
        <form action="{{ route('admin.logout') }}" method="POST" style="margin: 0;">
            @csrf
            <button type="submit" class="btn-filter" style="padding: 6px 12px; font-size: 12px; background-color: var(--accent-red-light); color: var(--accent-red); border-color: transparent; border-radius: 4px; font-weight: 600; cursor: pointer;">
                Logout
            </button>
        </form>
    </div>
</nav>
@endsection

@section('content')
<div style="max-width: 1200px; margin: 0 auto; padding: 10px 0;">
    <div class="page-header" style="margin-bottom: 24px;">
        <div class="page-header-info">
            <h2 style="font-size: 28px; font-weight: 700; color: var(--text-primary); letter-spacing: -0.5px;">KYC Queue</h2>
            <p style="font-size: 13px; color: var(--text-secondary); margin-top: 4px;">Pending student verifications</p>
        </div>
        <div class="search-filter-row">
            <button class="btn-filter" style="border-radius: 6px; padding: 8px 14px; font-weight: 600;">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="16" height="16">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
                </svg>
                Filter
            </button>
        </div>
    </div>

    <!-- Main Two Column Grid (Queue List + Active Detail) -->
    <div class="kyc-queue-wrapper">
        
        <!-- Left Side: Queue List Table -->
        <div class="table-card" style="border-radius: 12px; overflow: hidden; height: fit-content;">
            <table class="custom-table">
                <thead>
                    <tr>
                        <th style="padding: 14px 20px;">Student</th>
                        <th style="padding: 14px 20px;">University</th>
                        <th style="padding: 14px 20px;">Submitted</th>
                        <th style="padding: 14px 20px;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($queueUsers as $qUser)
                        @php
                            $isActive = $user && $user->id === $qUser->id;
                        @endphp
                        <tr onclick="location.href='{{ route('admin.detail-kyc', $qUser) }}'" 
                            style="cursor: pointer; {{$isActive ? 'background-color: #FFF3F1;' : ''}}" 
                            class="{{ $isActive ? 'active-kyc-row' : '' }}">
                            <td style="padding: 16px 20px;">
                                <div class="entity-info-cell">
                                    <div class="entity-initial-badge" style="{{ $isActive ? 'background-color: #2D1A16; color: white;' : 'background-color: #E2DDD9; color: var(--text-primary);' }}">
                                        {{ strtoupper(substr($qUser->name, 0, 2)) }}
                                    </div>
                                    <div class="entity-details">
                                        <span class="entity-name" style="font-size: 13px; font-weight: {{$isActive ? '700' : '600'}}; color: {{$isActive ? '#2D1A16' : 'var(--text-primary)'}};">{{ $qUser->name }}</span>
                                        <span class="entity-subtext" style="font-size: 11px; color: {{$isActive ? '#7A7571' : 'var(--text-secondary)'}};">{{ $qUser->email }}</span>
                                    </div>
                                </div>
                            </td>
                            <td style="padding: 16px 20px; font-size: 13px; font-weight: 500; color: #5C5956;">{{ $qUser->universitas ?? '-' }}</td>
                            <td style="padding: 16px 20px; font-size: 13px; font-weight: 500; color: #7A7571;">{{ $qUser->created_at->diffForHumans() }}</td>
                            <td style="padding: 16px 20px;">
                                <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background-color: #D97706; {{ !$isActive ? 'opacity: 0.5;' : '' }}"></span>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 24px; color: var(--text-secondary);">
                                Tidak ada antrean pending.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        <!-- Right Side: Detail Review Panel for Selected User -->
        @if ($user)
            @php
                $selfieUrl = $user->kyc_selfie_path;
                if ($selfieUrl) {
                    if (str_contains($selfieUrl, '/storage/')) {
                        $selfieUrl = strstr($selfieUrl, '/storage/');
                    } elseif (!str_starts_with($selfieUrl, 'http')) {
                        $selfieUrl = asset('storage/' . $selfieUrl);
                    }
                } else {
                    $selfieUrl = asset('images/james_selfie.png');
                }

                $ktmUrl = $user->kyc_ktm_path;
                if ($ktmUrl) {
                    if (str_contains($ktmUrl, '/storage/')) {
                        $ktmUrl = strstr($ktmUrl, '/storage/');
                    } elseif (!str_starts_with($ktmUrl, 'http')) {
                        $ktmUrl = asset('storage/' . $ktmUrl);
                    }
                } else {
                    $ktmUrl = asset('images/james_ktm.png');
                }
            @endphp
            <div class="kyc-detail-card" style="top: 86px;">
                <div class="kyc-detail-header">
                    <div class="kyc-detail-title">
                        <h3>{{ $user->name }}</h3>
                        <p>NIM: {{ $user->nim ?? '-' }}</p>
                    </div>
                    <span class="kyc-badge-pending" style="background-color: #FDF5E6; color: #B25E00; font-weight: 700; border-radius: 20px; font-size: 11px;">Pending Review</span>
                </div>

                <!-- Documents Selfie and Student ID Card images -->
                <div class="kyc-docs-grid">
                    <!-- Selfie image -->
                    <div class="kyc-doc-item">
                        <div class="kyc-doc-label">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                                <circle cx="12" cy="13" r="3" />
                            </svg>
                            Selfie
                        </div>
                        <img src="{{ $selfieUrl }}" class="kyc-image-preview" alt="Selfie" style="object-fit: cover; border-radius: 8px;">
                    </div>

                    <!-- Student ID image -->
                    <div class="kyc-doc-item">
                        <div class="kyc-doc-label">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2" />
                            </svg>
                            Student ID (KTM)
                        </div>
                        <img src="{{ $ktmUrl }}" class="kyc-image-preview" alt="KTM Card" style="object-fit: contain; border-radius: 8px; padding: 4px; background-color: #1A1F26;">
                    </div>
                </div>

                <!-- Extracted OCR Metadata Card -->
                <div class="kyc-extracted-card">
                    <h4>Extracted Information (OCR)</h4>
                    <div class="kyc-extracted-grid">
                        <div class="kyc-extracted-item">
                            <span class="kyc-extracted-label">Name on ID</span>
                            <span class="kyc-extracted-value">{{ $user->name }}</span>
                        </div>
                        <div class="kyc-extracted-item">
                            <span class="kyc-extracted-label">Institution</span>
                            <span class="kyc-extracted-value">{{ $user->universitas ?? '-' }}</span>
                        </div>
                        <div class="kyc-extracted-item">
                            <span class="kyc-extracted-label">Valid Until</span>
                            <span class="kyc-extracted-value">Aug 2027</span>
                        </div>
                        <div class="kyc-extracted-item">
                            <span class="kyc-extracted-label">Face Match</span>
                            <span class="kyc-extracted-value match-percent">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="14" height="14" style="stroke-width: 2.5px;">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4" />
                                </svg>
                                98%
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Rejection Selector -->
                <div class="kyc-rejection-section">
                    <label for="rejection-reason-select">If rejecting, select reason:</label>
                    <select class="kyc-select" id="rejection-reason-select">
                        <option value="">-- Select Reason --</option>
                        <option value="KTM Buram / Tidak Terbaca">KTM Buram / Tidak Terbaca</option>
                        <option value="Wajah Selfie & KTM Tidak Cocok">Wajah Selfie & KTM Tidak Cocok</option>
                        <option value="Email Bukan Domain Kampus Resmi">Email Bukan Domain Kampus Resmi</option>
                        <option value="Masa Berlaku KTM Sudah Habis">Masa Berlaku KTM Sudah Habis</option>
                    </select>
                </div>

                <!-- Final Actions Buttons -->
                <div class="kyc-actions">
                    <form id="reject-form" action="{{ route('admin.kyc.reject', $user) }}" method="POST" style="display: none;">
                        @csrf
                        <input type="hidden" name="reason" id="hidden-reason" value="">
                    </form>

                    <button type="button" class="btn-kyc-reject" onclick="submitRejection()">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="16" height="16" style="stroke-width: 2.5px;">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                        Reject
                    </button>

                    <form action="{{ route('admin.kyc.approve', $user) }}" method="POST" style="display: inline-block;">
                        @csrf
                        <button type="submit" class="btn-kyc-approve">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="16" height="16" style="stroke-width: 2.5px;">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                            </svg>
                            Approve
                        </button>
                    </form>
                </div>
            </div>
        @else
            <div style="flex-grow: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: white; border-radius: 12px; border: 1px solid var(--border-color); padding: 40px; text-align: center; color: var(--text-secondary); min-height: 400px;">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="48" height="48" style="margin-bottom: 16px; opacity: 0.5;">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <h3 style="font-weight: 700; color: var(--text-primary); margin-bottom: 8px;">Antrean KYC Kosong</h3>
                <p style="font-size: 13px;">Tidak ada mahasiswa yang sedang mengajukan verifikasi saat ini.</p>
            </div>
        @endif
    </div>
</div>
@endsection

@section('scripts')
@if ($user)
<script>
    function submitRejection() {
        const select = document.getElementById('rejection-reason-select');
        const reason = select.value;
        if (!reason) {
            alert('Silakan pilih alasan penolakan terlebih dahulu.');
            return;
        }
        document.getElementById('hidden-reason').value = reason;
        document.getElementById('reject-form').submit();
    }
</script>
@endif
@endsection
