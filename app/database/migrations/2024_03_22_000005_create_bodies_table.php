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
        Schema::create('bodies', function (Blueprint $table) {
            $table->id('PK_id');
            $table->string('type', 50)->comment('Type of vehicle body (e.g., Sedan, SUV)');
            $table->unsignedInteger('doors')->comment('Number of doors');
            $table->decimal('length', 8, 2)->comment('Vehicle length in centimeters (cm)');
            $table->decimal('width', 8, 2)->comment('Vehicle width in centimeters (cm)');
            $table->unsignedInteger('seats')->comment('Number of seats');
            $table->decimal('height', 8, 2)->comment('Vehicle height in centimeters (cm)');
            $table->decimal('wheel_base', 8, 2)->comment('Distance between front and rear axles in centimeters (cm)');
            $table->string('front_track', 50)->comment('Width between front wheels (nullable or textual)')->nullable();
            $table->string('rear_track', 50)->comment('Width between rear wheels (nullable or textual)')->nullable();
            $table->decimal('ground_clearance', 8, 2)->comment('Height from ground to undercarriage in centimeters (cm)');
            $table->decimal('cargo_capacity', 8, 2)->comment('Standard cargo volume in liters (L)');
            $table->decimal('max_cargo_capacity', 8, 2)->comment('Maximum cargo volume with seats folded in liters (L)');
            $table->decimal('curb_weight', 8, 2)->comment('Weight of the empty vehicle in kilograms (kg)');
            $table->decimal('gross_weight', 8, 2)->comment('Maximum total vehicle weight in kilograms (kg)');
            $table->decimal('max_payload', 8, 2)->comment('Maximum additional weight the vehicle can carry in kilograms (kg)');
            $table->decimal('max_towing_capacity', 8, 2)->comment('Max weight the vehicle can tow in kilograms (kg)');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bodies');
    }
}; 