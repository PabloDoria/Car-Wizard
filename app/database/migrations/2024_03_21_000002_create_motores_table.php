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
        Schema::create('engines', function (Blueprint $table) {
            $table->id('PK_id');
            $table->string('engine_type', 50)->comment('Type of engine (e.g., gas, diesel, electric)')->nullable();
            $table->string('fuel_type', 50)->comment('Type of fuel used')->nullable();
            $table->string('cylinders', 50)->comment('Engine cylinder configuration (e.g., I4, V6)')->nullable();
            $table->string('size', 50)->comment('Engine size or displacement in liters (L) (text)')->nullable();
            $table->unsignedInteger('horsepower_hp')->comment('Engine power in horsepower (hp)')->nullable();
            $table->decimal('horsepower_rpm', 8, 2)->comment('RPM at which max horsepower is delivered in revolutions/minute')->nullable();
            $table->decimal('torque_ft_lbs', 8, 2)->comment('Torque in pound-feet (lb-ft)')->nullable();
            $table->decimal('valves', 8, 2)->comment('Total number of engine valves in units')->nullable();
            $table->string('valve_timing', 50)->comment('Valve timing type (e.g., Variable)')->nullable();
            $table->string('cam_type', 50)->comment('Camshaft configuration (e.g., DOHC, SOHC)')->nullable();
            $table->string('drive_type', 50)->comment('Drivetrain configuration (e.g., FWD, AWD, RWD)')->nullable();
            $table->string('transmission', 50)->comment('Type of transmission (e.g., 6-speed automatic)')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('engines');
    }
}; 