<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable(['gig_id', 'reporter_id', 'reported_user_id', 'category', 'detail_text', 'status'])]
class Report extends Model
{
    public function gig(): BelongsTo
    {
        return $this->belongsTo(Gig::class);
    }

    public function reporter(): BelongsTo
    {
        return $this->belongsTo(User::class, 'reporter_id');
    }

    public function reportedUser(): BelongsTo
    {
        return $this->belongsTo(User::class, 'reported_user_id');
    }

    public function evidences(): HasMany
    {
        return $this->hasMany(ReportEvidence::class);
    }
}
