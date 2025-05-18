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
        Schema::create('trims', function (Blueprint $table) {
            $table->id('PK_id')->comment('Unique identifier of the trim');
            $table->unsignedBigInteger('FK_year')->comment('Model year');
            $table->string('name', 50)->comment('Name of the trim or version (e.g., SE, XLE, GT-Line)');
            $table->unsignedBigInteger('FK_engine_id')->comment('Linked engine');
            $table->unsignedBigInteger('FK_body_id')->comment('Linked body type');
            $table->string('description', 50)->comment('Short description of trim (may include doors, transmission)')->nullable();
            $table->unsignedInteger('price')->comment('Manufacturer\'s suggested retail price (MSRP)')->nullable();
            $table->unsignedBigInteger('FK_make_model_id')->comment('Linked model to which this trim belongs');
            $table->unsignedBigInteger('FK_mileage_id')->comment('Linked mileage entry (fuel efficiency)');
            $table->unsignedInteger('estimatedKM')->comment('Estimated kilometers driven (for market data or resale info)')->nullable();
            $table->timestamps();

            // FKs
            $table->foreign('FK_year')->references('PK_id')->on('years');
            $table->foreign('FK_engine_id')->references('PK_id')->on('engines');
            $table->foreign('FK_body_id')->references('PK_id')->on('bodies');
            $table->foreign('FK_make_model_id')->references('PK_id')->on('make_model');
            $table->foreign('FK_mileage_id')->references('PK_id')->on('mileages');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('trims');
    }
}; 