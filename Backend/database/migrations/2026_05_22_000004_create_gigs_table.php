<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('gigs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete(); // Poster
            $table->foreignId('helper_id')->nullable()->constrained('users')->nullOnDelete(); // Helper
            $table->string('title');
            $table->text('description');
            $table->string('location');
            $table->enum('category', ['Tugas Kuliah', 'Desain', 'Antar Barang', 'Lainnya']);
            $table->decimal('price', 10, 2);
            $table->date('deadline_date');
            $table->time('deadline_time');
            $table->enum('status', ['open', 'in_progress', 'completed', 'disputed', 'cancelled'])->default('open');
            $table->string('evidence_photo_path')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('gigs');
    }
};
