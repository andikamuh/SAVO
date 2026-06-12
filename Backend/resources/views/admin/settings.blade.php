@extends('layouts.admin')

@section('title', $system_settings['site_name'] . ' Admin - Pengaturan')

@section('styles')
<style>
.switch {
  position: relative;
  display: inline-block;
  width: 40px;
  height: 20px;
}

.switch input { 
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #d1c7bd;
  transition: .4s;
  border-radius: 20px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 14px;
  width: 14px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #8c2626;
}

input:checked + .slider:before {
  transform: translateX(20px);
}
</style>
@endsection

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
            <a href="{{ route('admin.konflik') }}" class="sidebar-link">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
                Resolusi Konflik
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a href="{{ route('admin.settings') }}" class="sidebar-link active">
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
        <h1>Pengaturan Sistem</h1>
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
<div style="display: flex; flex-direction: column; gap: 20px; max-width: 1000px; margin: 0 auto; width: 100%;">
    
    @if (session('success'))
        <div style="background-color: var(--accent-green-light); border: 1px solid var(--accent-green); color: var(--accent-green); padding: 12px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 8px;">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" style="width: 18px; height: 18px;">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
            </svg>
            {{ session('success') }}
        </div>
    @endif

    @if ($errors->any())
        <div style="background-color: var(--accent-red-light); border: 1px solid var(--accent-red); color: var(--accent-red); padding: 12px 16px; border-radius: 8px; font-size: 13px; font-weight: 600;">
            <div style="font-weight: 700; margin-bottom: 4px;">Terjadi Kesalahan:</div>
            <ul style="margin: 0; padding-left: 16px; list-style-type: disc;">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
        <!-- Left: Branding Settings -->
        <div class="dashboard-card" style="display: flex; flex-direction: column; gap: 16px; padding: 20px; background-color: white; border: 1px solid var(--border-color); border-radius: 8px; box-shadow: var(--card-shadow);">
            <div class="dashboard-card-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 4px;">
                <h3 style="font-size: 14px; font-weight: 700; color: var(--text-primary);">Pengaturan Branding</h3>
            </div>
            
            <form action="{{ route('admin.settings.update') }}" method="POST" enctype="multipart/form-data" style="display: flex; flex-direction: column; gap: 16px;">
                @csrf
                
                <!-- Nama Situs -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Nama Aplikasi</label>
                    <input type="text" name="site_name" value="{{ old('site_name', $system_settings['site_name']) }}" style="width: 100%; padding: 10px 12px; background-color: #EEEAE6; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-primary); transition: var(--transition-smooth);" required placeholder="Contoh: SAVO">
                </div>

                <!-- Logo Input & Preview -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Logo Aplikasi</label>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 48px; height: 48px; background-color: var(--accent-maroon-light); border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px dashed var(--border-color);">
                            @if ($system_settings['site_logo'])
                                <img src="{{ asset($system_settings['site_logo']) }}" style="width: 100%; height: 100%; object-fit: contain;">
                            @else
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="20" height="20" style="color: var(--accent-maroon);">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                            @endif
                        </div>
                        <div style="flex: 1;">
                            <input type="file" name="site_logo" accept="image/*" style="font-size: 12px;">
                            <p style="font-size: 10px; color: var(--text-secondary); margin-top: 4px;">PNG, JPG, SVG maks 2MB</p>
                        </div>
                    </div>
                </div>

                <!-- Icon/Favicon Input & Preview -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Icon Aplikasi (Favicon)</label>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 48px; height: 48px; background-color: var(--bg-sidebar); border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px dashed var(--border-color);">
                            @if ($system_settings['site_icon'])
                                <img src="{{ asset($system_settings['site_icon']) }}" style="width: 24px; height: 24px; object-fit: contain;">
                            @else
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="20" height="20" style="color: var(--text-secondary);">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                                </svg>
                            @endif
                        </div>
                        <div style="flex: 1;">
                            <input type="file" name="site_icon" accept="image/*,.ico" style="font-size: 12px;">
                            <p style="font-size: 10px; color: var(--text-secondary); margin-top: 4px;">PNG, ICO, SVG maks 1MB</p>
                        </div>
                    </div>
                </div>
                <!-- Status API (Active/Inactive Toggle) -->
                <div style="display: flex; align-items: center; justify-content: space-between; padding: 12px; background-color: var(--bg-sidebar); border-radius: 8px; border: 1px solid var(--border-color); margin-top: 4px;">
                    <div style="display: flex; flex-direction: column; gap: 2px;">
                        <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-primary); letter-spacing: 0.5px;">Status API</label>
                        <span style="font-size: 10px; color: var(--text-secondary);">Aktifkan atau matikan seluruh akses API SAVO</span>
                    </div>
                    <div>
                        <label class="switch">
                            <input type="checkbox" name="api_enabled" value="1" {{ $system_settings['api_enabled'] == '1' ? 'checked' : '' }}>
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <div style="margin-top: 8px;">
                    <button type="submit" class="btn-decision solid-dark" style="height: 38px;">Simpan Perubahan</button>
                </div>
            </form>
        </div>

        <!-- Right: Notification Broadcaster -->
        <div class="dashboard-card" style="display: flex; flex-direction: column; gap: 16px; padding: 20px; background-color: white; border: 1px solid var(--border-color); border-radius: 8px; box-shadow: var(--card-shadow);">
            <div class="dashboard-card-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 4px;">
                <h3 style="font-size: 14px; font-weight: 700; color: var(--text-primary);">Kirim Notifikasi Sistem</h3>
            </div>
            
            <form action="{{ route('admin.settings.notify') }}" method="POST" style="display: flex; flex-direction: column; gap: 16px;">
                @csrf
                
                <!-- Penerima (Target) -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Penerima Notifikasi</label>
                    <select name="target" style="width: 100%; padding: 10px 12px; background-color: #EEEAE6; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-primary); transition: var(--transition-smooth);" required>
                        <option value="all">Semua Pengguna (Broadcast)</option>
                        @foreach ($users as $user)
                            <option value="{{ $user->id }}">{{ $user->name }} ({{ $user->email }})</option>
                        @endforeach
                    </select>
                </div>

                <!-- Judul Notifikasi -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Judul Notifikasi</label>
                    <input type="text" name="title" value="{{ old('title') }}" style="width: 100%; padding: 10px 12px; background-color: #EEEAE6; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-primary); transition: var(--transition-smooth);" required placeholder="Contoh: Pemeliharaan Sistem">
                </div>

                <!-- Isi Notifikasi -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Isi / Deskripsi Notifikasi</label>
                    <textarea name="description" rows="4" style="width: 100%; padding: 10px 12px; background-color: #EEEAE6; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-primary); transition: var(--transition-smooth); resize: vertical;" required placeholder="Tulis rincian pesan notifikasi sistem di sini..."></textarea>
                </div>

                <div style="margin-top: 8px;">
                    <button type="submit" class="btn-decision solid-dark" style="height: 38px; background-color: var(--accent-maroon); border-color: var(--accent-maroon);">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="16" height="16" style="stroke-width: 2.5px;">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                        </svg>
                        Kirim Notifikasi
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Admin Profile Settings -->
    <div class="dashboard-card" style="display: flex; flex-direction: column; gap: 16px; padding: 20px; background-color: white; border: 1px solid var(--border-color); border-radius: 8px; box-shadow: var(--card-shadow); margin-top: 20px;">
        <div class="dashboard-card-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 4px;">
            <h3 style="font-size: 14px; font-weight: 700; color: var(--text-primary);">Pengaturan Profil Admin</h3>
        </div>
        
        <form action="{{ route('admin.profile.update') }}" method="POST" enctype="multipart/form-data" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            @csrf
            
            <div style="display: flex; flex-direction: column; gap: 16px;">
                <!-- Nama Admin -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Nama Admin</label>
                    <input type="text" name="name" value="{{ old('name', Auth::user()->name) }}" style="width: 100%; padding: 10px 12px; background-color: #EEEAE6; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-primary); transition: var(--transition-smooth);" required>
                </div>

                <!-- Email (Read-only for safety) -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Email Admin (Tidak dapat diubah)</label>
                    <input type="email" value="{{ Auth::user()->email }}" style="width: 100%; padding: 10px 12px; background-color: #E2DDD9; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-secondary);" readonly>
                </div>

                <!-- Foto Profil Admin -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Foto Profil Admin</label>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 48px; height: 48px; background-color: var(--bg-sidebar); border-radius: 50%; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px dashed var(--border-color);">
                            @if (Auth::user()->avatar_url)
                                <img src="{{ Auth::user()->avatar_url }}" style="width: 100%; height: 100%; object-fit: cover;">
                            @else
                                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop" style="width: 100%; height: 100%; object-fit: cover;">
                            @endif
                        </div>
                        <div style="flex: 1;">
                            <input type="file" name="avatar" accept="image/*" style="font-size: 12px;">
                            <p style="font-size: 10px; color: var(--text-secondary); margin-top: 4px;">PNG, JPG, JPEG maks 2MB (Tersimpan di folder public)</p>
                        </div>
                    </div>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; gap: 16px;">
                <!-- Password Baru -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Password Baru (Kosongkan jika tidak ingin mengubah)</label>
                    <input type="password" name="password" style="width: 100%; padding: 10px 12px; background-color: #EEEAE6; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-primary); transition: var(--transition-smooth);" placeholder="Minimal 8 karakter">
                </div>

                <!-- Konfirmasi Password -->
                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-secondary); letter-spacing: 0.5px;">Konfirmasi Password Baru</label>
                    <input type="password" name="password_confirmation" style="width: 100%; padding: 10px 12px; background-color: #EEEAE6; border: 1.5px solid transparent; border-radius: 8px; font-family: var(--font-sans); font-size: 13px; color: var(--text-primary); transition: var(--transition-smooth);" placeholder="Ketik ulang password baru">
                </div>
            </div>

            <div style="grid-column: span 2; margin-top: 8px;">
                <button type="submit" class="btn-decision solid-dark" style="height: 38px; max-width: 200px;">Perbarui Profil</button>
            </div>
        </form>
    </div>
</div>
@endsection
