@extends('layouts.admin')

@section('title', $system_settings['site_name'] . ' Admin - Antrian KYC')

@section('sidebar')
<!-- SAVO Sidebar for KYC -->
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
            <a href="{{ route('admin.antrian-kyc') }}" class="sidebar-link active">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                KYC Queue
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a href="{{ route('admin.konflik') }}" class="sidebar-link">
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
        <h1>SAVO Admin</h1>
        <span class="divider">/</span>
        <span>KYC Queue Management</span>
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
<div class="page-header">
    <div class="page-header-info">
        <h2>KYC Queue Management</h2>
        <p>Review and verify student registrations (KTM).</p>
    </div>
    <form action="{{ route('admin.antrian-kyc') }}" method="GET" class="search-filter-row" style="display: flex; gap: 12px; align-items: center;">
        <div class="search-wrapper">
            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <input type="text" name="search" class="search-input" value="{{ request('search') }}" placeholder="Cari Nama, NIM, atau Email...">
        </div>
        <button type="submit" class="btn-filter" style="padding: 8px 16px; font-weight: 600;">
            Cari
        </button>
        @if (request('search'))
            <a href="{{ route('admin.antrian-kyc') }}" class="btn-filter" style="display: inline-flex; align-items: center; text-decoration: none; padding: 8px 16px; background-color: #ECE8E4; color: var(--text-primary);">
                Reset
            </a>
        @endif
    </form>
</div>

<!-- Stats Grid Row -->
<div class="stats-grid">
    <!-- Stat 1: Menunggu Review -->
    <div class="stat-card">
        <div class="stat-card-info">
            <div class="stat-label-row">
                <span class="stat-card-label" style="color: #6B21A8;">Menunggu Review</span>
            </div>
            <span class="stat-card-value">{{ $pendingCount }}</span>
        </div>
        <div class="stat-card-icon maroon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="22" height="22">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
            </svg>
        </div>
    </div>

    <!-- Stat 2: Disetujui Hari Ini -->
    <div class="stat-card">
        <div class="stat-card-info">
            <div class="stat-label-row">
                <span class="stat-card-label" style="color: var(--accent-green);">Disetujui Hari Ini</span>
            </div>
            <span class="stat-card-value" style="color: var(--accent-green);">{{ $approvedToday }}</span>
        </div>
        <div class="stat-card-icon green">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="22" height="22">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>
    </div>

    <!-- Stat 3: Ditolak Hari Ini -->
    <div class="stat-card">
        <div class="stat-card-info">
            <div class="stat-label-row">
                <span class="stat-card-label" style="color: var(--accent-red);">Ditolak Hari Ini</span>
            </div>
            <span class="stat-card-value" style="color: var(--accent-red);">{{ $rejectedToday }}</span>
        </div>
        <div class="stat-card-icon red">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="22" height="22">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>
    </div>
</div>

<!-- Table Card Layout -->
<div class="table-card">
    @if (session('success'))
        <div style="background-color: var(--accent-green-light); border-left: 4px solid var(--accent-green); color: var(--text-primary); padding: 12px 16px; margin: 16px; border-radius: 6px; font-size: 13px; font-weight: 600;">
            {{ session('success') }}
        </div>
    @endif

    <table class="custom-table">
        <thead>
            <tr>
                <th>Nama Lengkap</th>
                <th>NIM</th>
                <th>Fakultas / Prodi</th>
                <th>Tanggal Daftar</th>
                <th>Status</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($pendingUsers as $pUser)
                <tr>
                    <td>
                        <div class="entity-info-cell">
                            <div class="entity-initial-badge" style="background-color: #E2DDD9; color: var(--text-primary);">
                                {{ strtoupper(substr($pUser->name, 0, 2)) }}
                            </div>
                            <div class="entity-details">
                                <span class="entity-name">{{ $pUser->name }}</span>
                                <span class="entity-subtext">{{ $pUser->email }}</span>
                            </div>
                        </div>
                    </td>
                    <td style="font-weight: 500;">{{ $pUser->nim ?? '-' }}</td>
                    <td>{{ $pUser->prodi ?? '-' }}</td>
                    <td>{{ $pUser->created_at->format('d M Y, H:i') }}</td>
                    <td>
                        <span class="status-badge pending">Pending</span>
                    </td>
                    <td>
                        <a href="{{ route('admin.detail-kyc', ['user' => $pUser->id]) }}" class="btn-action-maroon">Review Detail</a>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" style="text-align: center; padding: 32px; color: var(--text-secondary);">
                        Tidak ada antrean KYC yang pending.
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>

    <div class="table-footer">
        <span class="table-footer-info">
            Menampilkan {{ $pendingUsers->firstItem() ?? 0 }}-{{ $pendingUsers->lastItem() ?? 0 }} dari {{ $pendingUsers->total() }} antrean
        </span>
        <div class="pagination-controls">
            @if ($pendingUsers->onFirstPage())
                <button class="btn-pagination" disabled>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7" />
                    </svg>
                </button>
            @else
                <a href="{{ $pendingUsers->previousPageUrl() }}" class="btn-pagination" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none;">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7" />
                    </svg>
                </a>
            @endif

            @if ($pendingUsers->hasMorePages())
                <a href="{{ $pendingUsers->nextPageUrl() }}" class="btn-pagination" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none;">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7" />
                    </svg>
                </a>
            @else
                <button class="btn-pagination" disabled>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7" />
                    </svg>
                </button>
            @endif
        </div>
    </div>
</div>
@endsection
