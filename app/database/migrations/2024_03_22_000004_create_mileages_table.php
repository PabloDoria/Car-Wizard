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
        Schema::create('mileages', function (Blueprint $table) {
            $table->id('PK_id');
            $table->decimal('fuel_tank_capacity', 8, 2)->comment('Fuel tank capacity in liters (L)')->nullable();
            $table->decimal('combined_LitersAt100km', 8, 2)->comment('Combined fuel consumption in L/100 km')->nullable();
            $table->decimal('city_LitersAt100km', 8, 2)->comment('City fuel consumption in L/100 km')->nullable();
            $table->decimal('highway_LitersAt100km', 8, 2)->comment('Highway fuel consumption in L/100 km')->nullable();
            $table->decimal('range_city', 8, 2)->comment('Estimated driving range in the city in kilometers (km)')->nullable();
            $table->decimal('range_highway', 8, 2)->comment('Estimated driving range on highways in kilometers (km)')->nullable();
            $table->decimal('battery_capacity_electric', 8, 2)->comment('Capacity of electric battery in kilowatt-hours (kWh)')->nullable();
            $table->string('epa_time_to_charge_hr_240v_electric', 50)->comment('Time to charge using 240V outlet in hours (text)')->nullable();
            $table->string('epa_kwh_100_mi_electric', 50)->comment('Energy usage over 100 miles in kWh/100mi (textual)')->nullable();
            $table->string('range_electric', 50)->comment('Estimated electric driving range in kilometers (km) (text)')->nullable();
            $table->decimal('epa_highway_mpg_electric', 8, 2)->comment('EPA-rated electric efficiency on highway if not converted in MPGe')->nullable();
            $table->decimal('epa_city_mpg_electric', 8, 2)->comment('EPA-rated electric efficiency in city if not converted in MPGe')->nullable();
            $table->decimal('epa_combined_mpg_electric', 8, 2)->comment('EPA-rated combined electric efficiency if not converted in MPGe')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mileages');
    }
}; 