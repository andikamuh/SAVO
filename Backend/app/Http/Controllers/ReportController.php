<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Report;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class ReportController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'gig_id' => 'required|exists:gigs,id',
            'category' => 'required|string',
            'detail_text' => 'required|string',
            'evidences' => 'nullable|array',
            'evidences.*' => 'image|mimes:jpeg,png,jpg,gif|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $gig = \App\Models\Gig::find($request->gig_id);
        if (!$gig) {
            return response()->json([
                'status' => 'error',
                'message' => 'Pekerjaan (Gig) tidak ditemukan'
            ], 404);
        }

        // Determine reported user ID: the other participant in the gig
        $reported_user_id = Auth::id() === $gig->user_id ? $gig->helper_id : $gig->user_id;

        if (!$reported_user_id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Tidak ada pengguna lain yang terlibat untuk dilaporkan'
            ], 400);
        }

        $report = Report::create([
            'gig_id' => $request->gig_id,
            'reporter_id' => Auth::id(),
            'reported_user_id' => $reported_user_id,
            'category' => $request->category,
            'detail_text' => $request->detail_text,
            'status' => 'pending'
        ]);

        if ($request->hasFile('evidences')) {
            foreach ($request->file('evidences') as $file) {
                $filename = time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
                $file->move(public_path('report_evidences'), $filename);
                $report->evidences()->create([
                    'file_path' => asset('report_evidences/' . $filename)
                ]);
            }
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Laporan berhasil diajukan',
            'data' => $report->load('evidences')
        ], 201);
    }
}
