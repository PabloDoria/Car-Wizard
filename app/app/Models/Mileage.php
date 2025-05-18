<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Mileage extends Model
{
    protected $table = 'mileages';
    protected $primaryKey = 'PK_id';
    public $timestamps = true;

    protected $fillable = [
        'fuel_tank_capacity', // Fuel tank capacity in liters (L)
        'combined_LitersAt100km', // Combined fuel consumption in L/100 km
        'city_LitersAt100km', // City fuel consumption in L/100 km
        'highway_LitersAt100km', // Highway fuel consumption in L/100 km
        'range_city', // Estimated driving range in the city in kilometers (km)
        'range_highway', // Estimated driving range on highways in kilometers (km)
        'battery_capacity_electric', // Capacity of electric battery in kilowatt-hours (kWh)
        'epa_time_to_charge_hr_240v_electric', // Time to charge using 240V outlet in hours (text)
        'epa_kwh_100_mi_electric', // Energy usage over 100 miles in kWh/100mi (textual)
        'range_electric', // Estimated electric driving range in kilometers (km) (text)
        'epa_highway_mpg_electric', // EPA-rated electric efficiency on highway if not converted in MPGe
        'epa_city_mpg_electric', // EPA-rated electric efficiency in city if not converted in MPGe
        'epa_combined_mpg_electric' // EPA-rated combined electric efficiency if not converted in MPGe
    ];

    public function trims()
    {
        return $this->hasMany(Trim::class, 'FK_mileage_id');
    }
} 