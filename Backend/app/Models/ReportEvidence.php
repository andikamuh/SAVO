<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable(['report_id', 'file_path'])]
class ReportEvidence extends Model
{
    protected $table = 'report_evidences';

    public function report(): BelongsTo
    {
        return $this->belongsTo(Report::class);
    }
}
