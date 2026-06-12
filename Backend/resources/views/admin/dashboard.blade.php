@extends('layouts.admin')

@section('title', $system_settings['site_name'] . ' Admin - Dashboard')

@section('sidebar')
<!-- SAVO Sidebar -->
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
            <a href="{{ route('admin.dashboard') }}" class="sidebar-link active">
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
        <div class="sidebar-profile">
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
        <h1>Ikhtisar Sistem</h1>
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
<!-- Stats Grid Row -->
<div class="stats-grid">
    <!-- Stat 1 -->
    <div class="stat-card">
        <div class="stat-card-info">
            <div class="stat-label-row">
                <span class="stat-card-label">Total Pengguna Aktif</span>
                <span class="stat-badge trend-up">+12% Bulan ini</span>
            </div>
            <span class="stat-card-value">{{ number_format($totalActiveUsers) }}</span>
        </div>
        <div class="stat-card-icon maroon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="22" height="22">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
        </div>
    </div>

    <!-- Stat 2 -->
    <div class="stat-card">
        <div class="stat-card-info">
            <div class="stat-label-row">
                <span class="stat-card-label">Transaksi Aktif</span>
                <span class="stat-badge info-label">Sedang Berjalan</span>
            </div>
            <span class="stat-card-value">{{ number_format($activeTransactions) }}</span>
        </div>
        <div class="stat-card-icon" style="background-color: #FAF8F6; color: #5C5956; border: 1px solid var(--border-color);">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="22" height="22">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 1121.21 8H17m0 0V3" />
            </svg>
        </div>
    </div>

    <!-- Stat 3 -->
    <div class="stat-card">
        <div class="stat-card-info">
            <div class="stat-label-row">
                <span class="stat-card-label">Total Aktivitas</span>
                <span class="stat-badge info-label">Log Sistem</span>
            </div>
            <span class="stat-card-value">{{ number_format($totalActivities) }}</span>
        </div>
        <div class="stat-card-icon blue">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="22" height="22">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
            </svg>
        </div>
    </div>

</div>

<!-- Row 2: Grid Chart + Recent Activity -->
<div class="dashboard-grid-two">
    <!-- Chart Card -->
    <div class="dashboard-card">
        <div class="dashboard-card-header">
            <h3>Tren Transaksi (30 Hari)</h3>
            <a href="#" class="card-link">
                Laporan Lengkap
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="16" height="16">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
            </a>
        </div>
        
        <!-- CSS Bars Representation -->
        <div class="chart-container">
            <div class="chart-bar-group">
                <div class="chart-bar" style="height: 38%;"></div>
                <span class="chart-label">Minggu 1</span>
            </div>
            <div class="chart-bar-group">
                <div class="chart-bar active" style="height: 78%;"></div>
                <span class="chart-label">Minggu 2</span>
            </div>
            <div class="chart-bar-group">
                <div class="chart-bar" style="height: 54%;"></div>
                <span class="chart-label">Minggu 3</span>
            </div>
            <div class="chart-bar-group">
                <div class="chart-bar" style="height: 68%;"></div>
                <span class="chart-label">Minggu 4</span>
            </div>
        </div>
    </div>

    <!-- Recent Activity -->
    <div class="dashboard-card">
        <div class="dashboard-card-header">
            <h3>Aktivitas Terkini</h3>
        </div>
        
        <div class="activity-list">
            @forelse ($recentActivities as $activity)
                <div class="activity-item">
                    @php
                        $iconColor = '#6B7280';
                        $bgColor = '#F3F4F6';
                        $svgPath = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />'; // default
                        
                        if ($activity->action === 'Approve KYC') {
                            $iconColor = 'var(--accent-green)';
                            $bgColor = 'var(--accent-green-light)';
                            $svgPath = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />';
                        } elseif ($activity->action === 'Reject KYC') {
                            $iconColor = 'var(--accent-red)';
                            $bgColor = 'var(--accent-red-light)';
                            $svgPath = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />';
                        } elseif ($activity->action === 'Resolve Dispute') {
                            $iconColor = '#3B82F6';
                            $bgColor = '#EFF6FF';
                            $svgPath = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />';
                        }
                    @endphp
                    <div class="activity-icon-bullet" style="color: {{ $iconColor }}; background-color: {{ $bgColor }}; border-color: transparent;">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            {!! $svgPath !!}
                        </svg>
                    </div>
                    <div class="activity-details">
                        <p>{!! preg_replace('/(Rp \d+(?:\.\d+)*|[\w\s.-]+@[\w.-]+)/u', '<strong>$1</strong>', e($activity->description)) !!}</p>
                        <span>{{ $activity->created_at->diffForHumans() }}</span>
                    </div>
                </div>
            @empty
                <div style="padding: 20px; text-align: center; color: var(--text-secondary); font-size: 13px;">
                    Belum ada aktivitas admin tercatat.
                </div>
            @endforelse
        </div>
    </div>
</div>

@endsection
