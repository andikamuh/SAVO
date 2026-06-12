<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', $system_settings['site_name'] . ' Admin Portal')</title>
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="{{ $system_settings['site_icon'] ? asset($system_settings['site_icon']) : asset('favicon.ico') }}">
    <!-- Load custom admin stylesheet -->
    <link rel="stylesheet" href="{{ asset('css/admin.css') }}">
    @yield('styles')
</head>
<body>

    @yield('sidebar')

    <div class="main-wrapper" style="@yield('main-style', '')">
        @yield('navbar')

        <div class="content-body">
            @yield('content')
        </div>
    </div>

    @yield('scripts')
</body>
</html>
