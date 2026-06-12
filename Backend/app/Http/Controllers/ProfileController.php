<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        return response()->json([
            'status' => 'success',
            'data' => $request->user()->load('paymentMethods')
        ], 200);
    }

    public function update(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|required|string|max:255',
            'bio' => 'nullable|string',
            'nim' => 'sometimes|required|string|max:50',
            'universitas' => 'sometimes|required|string|max:255',
            'prodi' => 'sometimes|required|string|max:255',
            'avatar' => 'nullable|image|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $data = $request->only(['name', 'bio', 'nim', 'universitas', 'prodi']);

        if ($request->hasFile('avatar')) {
            // Delete old avatar if exists
            if ($user->avatar_url) {
                $oldFilename = basename($user->avatar_url);
                $oldFilePath = public_path('avatars/' . $oldFilename);
                if (file_exists($oldFilePath)) {
                    @unlink($oldFilePath);
                }
            }
            $file = $request->file('avatar');
            $filename = time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('avatars'), $filename);
            $data['avatar_url'] = asset('avatars/' . $filename);
        }

        $user->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Profil berhasil diperbarui',
            'data' => $user
        ], 200);
    }

    public function submitKyc(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'kyc_selfie' => 'required|image|max:2048',
            'kyc_ktm' => 'required|image|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $selfieFile = $request->file('kyc_selfie');
        $selfieFilename = time() . '_selfie_' . uniqid() . '.' . $selfieFile->getClientOriginalExtension();
        $selfieFile->move(public_path('kyc'), $selfieFilename);

        $ktmFile = $request->file('kyc_ktm');
        $ktmFilename = time() . '_ktm_' . uniqid() . '.' . $ktmFile->getClientOriginalExtension();
        $ktmFile->move(public_path('kyc'), $ktmFilename);

        $user->update([
            'kyc_selfie_path' => asset('kyc/' . $selfieFilename),
            'kyc_ktm_path' => asset('kyc/' . $ktmFilename),
            'kyc_status' => 'pending',
            'kyc_rejected_reason' => null
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Dokumen KYC berhasil diajukan'
        ], 202);
    }

    public function publicProfile($id)
    {
        $user = \App\Models\User::find($id);

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Pengguna tidak ditemukan'
            ], 404);
        }

        $gigs = \App\Models\Gig::where('user_id', $user->id)
            ->where('status', 'active')
            ->latest()
            ->get();

        $rating = \App\Models\Review::where('reviewee_id', $user->id)->avg('rating') ?: 5.0;
        $ratingCount = \App\Models\Review::where('reviewee_id', $user->id)->count();

        return response()->json([
            'status' => 'success',
            'data' => [
                'id' => $user->id,
                'name' => $user->name,
                'bio' => $user->bio,
                'avatar_url' => $user->avatar_url,
                'universitas' => $user->universitas,
                'prodi' => $user->prodi,
                'rating' => number_format((double)$rating, 1),
                'rating_count' => $ratingCount,
                'gigs' => $gigs,
            ]
        ], 200);
    }
}
