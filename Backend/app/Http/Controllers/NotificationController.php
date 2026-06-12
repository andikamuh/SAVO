<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Notification;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $notifications = $request->user()->notifications()->latest()->get();
        return response()->json([
            'status' => 'success',
            'data' => $notifications
        ], 200);
    }

    public function markRead($id)
    {
        $notification = Notification::where('user_id', Auth::id())->find($id);

        if (!$notification) {
            return response()->json([
                'status' => 'error',
                'message' => 'Notifikasi tidak ditemukan'
            ], 404);
        }

        $notification->update(['is_read' => true]);

        return response()->json([
            'status' => 'success',
            'message' => 'Notifikasi telah dibaca'
        ], 200);
    }
}
