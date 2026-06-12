<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\ChatRoom;
use App\Models\ChatMessage;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class ChatController extends Controller
{
    public function rooms(Request $request)
    {
        $user = Auth::user();
        $rooms = ChatRoom::with('gig', 'requester', 'helper')
            ->where('requester_id', $user->id)
            ->orWhere('helper_id', $user->id)
            ->latest('updated_at')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $rooms
        ], 200);
    }

    public function messages(Request $request, $roomId)
    {
        $room = ChatRoom::find($roomId);

        if (!$room) {
            return response()->json([
                'status' => 'error',
                'message' => 'Chat room tidak ditemukan'
            ], 404);
        }

        $user = Auth::user();
        if ($room->requester_id !== $user->id && $room->helper_id !== $user->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak memiliki akses ke chat room ini'
            ], 403);
        }

        $query = ChatMessage::with('sender')
            ->where('chat_room_id', $roomId)
            ->oldest();

        // Support incremental polling: only return messages newer than after_id
        if ($request->has('after_id') && is_numeric($request->after_id)) {
            $query->where('id', '>', (int) $request->after_id);
        }

        $messages = $query->get();

        return response()->json([
            'status' => 'success',
            'data' => $messages
        ], 200);
    }

    public function sendMessage(Request $request, $roomId)
    {
        $room = ChatRoom::find($roomId);

        if (!$room) {
            return response()->json([
                'status' => 'error',
                'message' => 'Chat room tidak ditemukan'
            ], 404);
        }

        $user = Auth::user();
        if ($room->requester_id !== $user->id && $room->helper_id !== $user->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak memiliki akses ke chat room ini'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'message_text' => 'required_without:image|nullable|string',
            'image' => 'nullable|image|max:10240',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $imageUrl = null;
        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $filename = time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
            $destinationPath = public_path('chat_images');
            if (!file_exists($destinationPath)) {
                mkdir($destinationPath, 0755, true);
            }
            $file->move($destinationPath, $filename);
            $imageUrl = asset('chat_images/' . $filename);
        }

        $message = ChatMessage::create([
            'chat_room_id' => $roomId,
            'sender_id' => $user->id,
            'message_text' => $request->message_text,
            'image_url' => $imageUrl,
            'is_read' => false
        ]);

        // Touch the room timestamp so it appears at top of lists
        $room->touch();

        return response()->json([
            'status' => 'success',
            'message' => 'Pesan berhasil dikirim',
            'data' => $message->load('sender')
        ], 201);
    }

    public function getOrCreateRoom(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'gig_id' => 'required|exists:gigs,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $gig = \App\Models\Gig::find($request->gig_id);
        $user = Auth::user();

        // The chat room is between the gig creator (user_id) and the helper
        $helperId = $gig->helper_id ?: $user->id;
        if ($gig->user_id === $user->id) {
            $helperId = $gig->helper_id;
        }

        if (!$helperId) {
            return response()->json([
                'status' => 'error',
                'message' => 'Chat room belum bisa dibuat karena helper belum ditentukan'
            ], 400);
        }

        $room = ChatRoom::firstOrCreate([
            'gig_id' => $gig->id,
            'requester_id' => $gig->user_id,
            'helper_id' => $helperId,
        ]);

        return response()->json([
            'status' => 'success',
            'data' => $room
        ], 200);
    }
}
