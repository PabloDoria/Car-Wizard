<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('make_model', function (Blueprint $table) {
            $table->id('PK_id')->comment('Unique identifier of the make-model combination');
            $table->unsignedBigInteger('FK_make_id')->comment('Foreign key referring to the make');
            $table->string('FK_name', 50)->comment('Foreign key referring to the model name');
            $table->timestamps();

            $table->foreign('FK_make_id')->references('PK_id')->on('makes')->onDelete('cascade');
            $table->foreign('FK_name')->references('PK_name')->on('models')->onDelete('cascade');
            
            // Evitar duplicados
            $table->unique(['FK_make_id', 'FK_name']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('make_model');
    }
}; 