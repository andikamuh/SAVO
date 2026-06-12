<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'name', 
    'email', 
    'password', 
    'nim', 
    'universitas', 
    'prodi', 
    'bio', 
    'avatar_url', 
    'kyc_status', 
    'kyc_selfie_path', 
    'kyc_ktm_path', 
    'kyc_rejected_reason', 
    'is_admin', 
    'rating'
])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_admin' => 'boolean',
            'rating' => 'decimal:2',
        ];
    }

    public function otps(): HasMany
    {
        return $this->hasMany(Otp::class);
    }

    public function paymentMethods(): HasMany
    {
        return $this->hasMany(PaymentMethod::class);
    }

    public function gigs(): HasMany
    {
        return $this->hasMany(Gig::class, 'user_id');
    }

    public function acceptedGigs(): HasMany
    {
        return $this->hasMany(Gig::class, 'helper_id');
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class, 'reviewee_id');
    }

    public function notifications(): HasMany
    {
        return $this->hasMany(Notification::class);
    }

    public function adminLogs(): HasMany
    {
        return $this->hasMany(AdminActivityLog::class);
    }
}
