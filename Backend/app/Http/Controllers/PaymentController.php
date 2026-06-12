<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\PaymentMethod;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class PaymentController extends Controller
{
    public function getMethods(Request $request)
    {
        $methods = PaymentMethod::where('user_id', Auth::id())->get();
        return response()->json([
            'status' => 'success',
            'data' => $methods
        ], 200);
    }

    public function saveMethod(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'type' => 'required|in:bank,e_wallet',
            'provider_name' => 'required|string',
            'account_number' => 'required|string',
            'account_name' => 'required|string',
            'is_primary' => 'sometimes|boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $isPrimary = $request->boolean('is_primary', false);

        // If this is primary or first payment method, force other to non-primary
        if ($isPrimary) {
            PaymentMethod::where('user_id', Auth::id())->update(['is_primary' => false]);
        }

        $method = PaymentMethod::create([
            'user_id' => Auth::id(),
            'type' => $request->type,
            'provider_name' => $request->provider_name,
            'account_number' => $request->account_number,
            'account_name' => $request->account_name,
            'is_primary' => $isPrimary
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Metode pembayaran berhasil disimpan',
            'data' => $method
        ], 200);
    }
}
