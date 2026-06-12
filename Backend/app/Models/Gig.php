<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'user_id', 
    'helper_id', 
    'title', 
    'description', 
    'location', 
    'category', 
    'price', 
    'deadline_date', 
    'deadline_time', 
    'status', 
    'evidence_photo_path', 
    'completed_at'
])]
class Gig extends Model
{
    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'deadline_date' => 'date',
            'completed_at' => 'datetime',
        ];
    }

    public function requester(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function helper(): BelongsTo
    {
        return $this->belongsTo(User::class, 'helper_id');
    }

    public function escrowTransaction(): HasOne
    {
        return $this->hasOne(EscrowTransaction::class);
    }

    public function chatRoom(): HasOne
    {
        return $this->hasOne(ChatRoom::class);
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }

    public function reports(): HasMany
    {
        return $this->hasMany(Report::class);
    }
}
