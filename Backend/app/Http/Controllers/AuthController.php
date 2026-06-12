<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\User;
use App\Models\Otp;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'nim' => 'required|string|max:50',
            'universitas' => 'required|string|max:255',
            'prodi' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first(),
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'nim' => $request->nim,
            'universitas' => $request->universitas,
            'prodi' => $request->prodi,
            'kyc_status' => 'pending', // Default upon registering and entering KYC
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Registrasi berhasil',
            'token' => $token,
            'user' => $user
        ], 201);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Email atau kata sandi salah'
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Login berhasil',
            'token' => $token,
            'user' => $user
        ], 200);
    }

    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Email tidak terdaftar'
            ], 404);
        }

        // Generate 4 digit OTP code
        $code = (string) mt_rand(1000, 9999);

        // Expire old active OTPs
        Otp::where('user_id', $user->id)
            ->where('type', 'reset_password')
            ->whereNull('used_at')
            ->update(['expires_at' => now()]);

        Otp::create([
            'user_id' => $user->id,
            'code' => $code,
            'type' => 'reset_password',
            'expires_at' => now()->addMinutes(15)
        ]);

        // Send OTP email using Laravel Mail Facade and beautiful HTML Template
        $mailSent = false;
        try {
            Mail::send('emails.otp', ['code' => $code], function ($message) use ($user) {
                $message->to($user->email)
                    ->subject('Kode OTP Reset Password SAVO');
            });
            $mailSent = true;
        } catch (\Exception $e) {
            \Log::warning("Gagal mengirim email OTP ke {$user->email} via SMTP: " . $e->getMessage());
        }

        return response()->json([
            'status' => 'success',
            'message' => $mailSent 
                ? "Kode OTP berhasil dikirim ke email Anda." 
                : "OTP dibuat secara lokal. (Dev OTP: {$code})",
            'code' => $code // return code in response as fallback for easy development
        ], 200);
    }

    public function verifyOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'code' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Email tidak ditemukan'
            ], 404);
        }

        $otp = Otp::where('user_id', $user->id)
            ->where('code', $request->code)
            ->where('type', 'reset_password')
            ->where('expires_at', '>', now())
            ->whereNull('used_at')
            ->first();

        if (!$otp) {
            return response()->json([
                'status' => 'error',
                'message' => 'Kode OTP tidak valid atau telah kedaluwarsa'
            ], 400);
        }

        $otp->update(['used_at' => now()]);

        return response()->json([
            'status' => 'success',
            'message' => 'OTP berhasil diverifikasi'
        ], 200);
    }

    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Email tidak ditemukan'
            ], 404);
        }

        $user->update([
            'password' => Hash::make($request->password)
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Kata sandi berhasil diatur ulang'
        ], 200);
    }
}
