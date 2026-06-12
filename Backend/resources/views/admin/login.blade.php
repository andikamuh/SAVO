<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ $system_settings['site_name'] }} Admin - Sign In</title>
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="{{ $system_settings['site_icon'] ? asset($system_settings['site_icon']) : asset('favicon.ico') }}">
    <!-- Load custom admin stylesheet -->
    <link rel="stylesheet" href="{{ asset('css/admin.css') }}">
    <style>
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 50% 50%, #FFFFFF 0%, #EDE9E4 100%) !important;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Instrument Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            overflow: hidden;
        }
        
        .login-container {
            width: 100% !important;
            height: 100% !important;
            min-height: 100vh !important;
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
            justify-content: center !important;
            padding: 24px !important;
            box-sizing: border-box !important;
            background: transparent !important;
            overflow-y: auto !important;
        }

        /* Shrink Card and spacings */
        .login-card {
            padding: 28px 24px !important;
            max-width: 360px !important;
            border-radius: 16px !important;
        }
        
        .login-logo {
            width: 40px !important;
            height: 40px !important;
            margin-bottom: 12px !important;
        }
        
        .login-logo svg {
            width: 20px !important;
            height: 20px !important;
        }
        
        .login-title {
            font-size: 22px !important;
            margin-bottom: 2px !important;
            letter-spacing: -0.5px !important;
        }
        
        .login-subtitle {
            font-size: 16px !important;
            margin-bottom: 6px !important;
            letter-spacing: -0.3px !important;
        }
        
        .login-desc {
            font-size: 11px !important;
            margin-bottom: 16px !important;
            max-width: 260px !important;
            line-height: 1.4 !important;
        }
        
        .form-group {
            margin-bottom: 12px !important;
        }
        
        .form-label {
            font-size: 10px !important;
            margin-bottom: 4px !important;
        }
        
        .login-input {
            padding: 9px 12px 9px 36px !important;
            font-size: 12px !important;
            height: 38px !important;
        }
        
        .input-wrapper svg {
            width: 15px !important;
            height: 15px !important;
            left: 10px !important;
        }
        
        .form-options {
            margin-top: 10px !important;
            margin-bottom: 16px !important;
            font-size: 11px !important;
        }
        
        .btn-login {
            padding: 10px !important;
            font-size: 12px !important;
            height: 38px !important;
        }
        
        .btn-login svg {
            width: 12px !important;
            height: 12px !important;
        }
        
        .secure-connection {
            margin-top: 16px !important;
            font-size: 10px !important;
        }
        
        .secure-connection svg {
            width: 12px !important;
            height: 12px !important;
        }
        
        .login-footer-link {
            font-size: 11px !important;
            margin-top: 16px !important;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-card">
        <!-- Logo Perisai Keamanan -->
        <div class="login-logo" style="overflow: hidden; display: flex; align-items: center; justify-content: center;">
            @if ($system_settings['site_logo'])
                <img src="{{ asset($system_settings['site_logo']) }}" alt="{{ $system_settings['site_name'] }}" style="width: 100%; height: 100%; object-fit: contain;">
            @else
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2L4 5v7c0 5.25 3.42 10.16 8 11.37 4.58-1.21 8-6.12 8-11.37V5l-8-3zm0 15c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3-6H9V9c0-1.66 1.34-3 3-3s3 1.34 3 3v2z"/>
                </svg>
            @endif
        </div>

        <h1 class="login-title">{{ $system_settings['site_name'] }}</h1>
        <h2 class="login-subtitle">Admin Portal</h2>
        <p class="login-desc">Enter your administrative credentials to manage the campus marketplace ecosystem.</p>

        <!-- Login Form -->
        <form action="{{ route('admin.login') }}" method="POST" class="login-form">
            @csrf
            
            @if ($errors->any())
                <div style="background-color: #FFF5F5; border: 1px solid #FFE3E3; border-left: 4px solid var(--accent-maroon); color: var(--text-primary); padding: 10px 14px; border-radius: 8px; margin-bottom: 16px; font-size: 11px; text-align: left;">
                    <div style="font-weight: 700; margin-bottom: 3px; color: var(--accent-maroon);">Terjadi Kesalahan:</div>
                    <ul style="margin: 0; padding-left: 14px; list-style-type: disc;">
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <!-- Username Field -->
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <div class="input-wrapper">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    <input type="email" id="username" name="email" class="login-input" placeholder="admin@savo.edu" value="{{ old('email') }}" required>
                </div>
            </div>

            <!-- Password Field -->
            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <div class="input-wrapper">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                    </svg>
                    <input type="password" id="password" name="password" class="login-input" placeholder="••••••••" required>
                </div>
            </div>

            <!-- Checkbox & Link Options -->
            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" name="remember">
                    Remember me
                </label>
                <a href="#" class="forgot-link">Forgot password?</a>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-login">
                Sign In to Dashboard
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
            </button>
        </form>

        <!-- Secure Connection Footer -->
        <div class="secure-connection">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
            Secure Connection
        </div>
    </div>

    <!-- Help Link outside card -->
    <a href="#" class="login-footer-link" style="margin-top: 16px;">Need help accessing the portal?</a>
</div>

</body>
</html>
