<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Gig;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class GigController extends Controller
{
    public function index(Request $request)
    {
        $category = $request->query('category');
        $status = $request->query('status');
        $myJobs = $request->query('my_jobs');
        $involved = $request->query('involved');
        
        $query = Gig::with('requester', 'helper');

        if ($category && $category !== 'Semua') {
            $query->where('category', $category);
        }

        if ($status) {
            $query->where('status', $status);
        }

        if ($myJobs == 1 || $myJobs == '1') {
            $query->where('helper_id', Auth::id());
        }

        if ($involved == 1 || $involved == '1') {
            $query->where(function($q) {
                $q->where('user_id', Auth::id())
                  ->orWhere('helper_id', Auth::id());
            });
        }

        $gigs = $query->latest()->get();

        return response()->json([
            'status' => 'success',
            'data' => $gigs
        ], 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string',
            'category' => 'required|in:Tugas Kuliah,Desain,Antar Barang,Lainnya',
            'price' => 'required|numeric|min:0',
            'deadline_date' => 'required|date_format:Y-m-d',
            'deadline_time' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $gig = Gig::create([
            'user_id' => Auth::id(),
            'title' => $request->title,
            'description' => $request->description,
            'location' => $request->location,
            'category' => $request->category,
            'price' => $request->price,
            'deadline_date' => $request->deadline_date,
            'deadline_time' => $request->deadline_time,
            'status' => 'open',
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Gig berhasil dibuat',
            'data' => $gig->load('requester')
        ], 201);
    }

    public function show($id)
    {
        $gig = Gig::with('requester', 'helper', 'reviews')->find($id);

        if (!$gig) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gig tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $gig
        ], 200);
    }

    public function accept($id)
    {
        $gig = Gig::find($id);

        if (!$gig) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gig tidak ditemukan'
            ], 404);
        }

        if ($gig->status !== 'open') {
            return response()->json([
                'status' => 'error',
                'message' => 'Gig tidak dapat diambil karena status tidak open'
            ], 400);
        }

        if ($gig->user_id === Auth::id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak bisa mengambil gig Anda sendiri'
            ], 400);
        }

        $gig->update([
            'helper_id' => Auth::id(),
            'status' => 'in_progress',
        ]);

        // Auto-create chat room
        \App\Models\ChatRoom::firstOrCreate([
            'gig_id' => $gig->id,
            'requester_id' => $gig->user_id,
            'helper_id' => Auth::id(),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Gig berhasil diambil',
            'data' => $gig->load('requester', 'helper')
        ], 200);
    }

    public function complete(Request $request, $id)
    {
        $gig = Gig::find($id);

        if (!$gig) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gig tidak ditemukan'
            ], 404);
        }

        if ($gig->helper_id !== Auth::id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda bukan helper untuk gig ini'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'photo' => 'required|image|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $data = [
            'status' => 'completed',
            'completed_at' => now(),
        ];

        if ($request->hasFile('photo')) {
            $file = $request->file('photo');
            $filename = time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('evidences'), $filename);
            $data['evidence_photo_path'] = asset('evidences/' . $filename);
        }

        $gig->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Gig berhasil diselesaikan',
            'data' => $gig
        ], 200);
    }

    public function confirmRelease($id)
    {
        $gig = Gig::find($id);

        if (!$gig) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gig tidak ditemukan'
            ], 404);
        }

        if ($gig->user_id !== Auth::id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda bukan pembuat gig ini'
            ], 403);
        }

        // Just update gig/escrow status to complete or verify fund release
        $gig->update([
            'status' => 'completed' // release confirming transitions completed fully
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Pembayaran berhasil dilepas'
        ], 200);
    }
}
