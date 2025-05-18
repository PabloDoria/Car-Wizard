<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MileageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $mileages = [
            [
                'fuel_tank_capacity' => 50.0,
                'combined_LitersAt100km' => 7.1,
                'city_LitersAt100km' => 8.5,
                'highway_LitersAt100km' => 6.3,
                'range_city' => 588.2,
                'range_highway' => 793.7,
                'battery_capacity_electric' => null,
                'epa_time_to_charge_hr_240v_electric' => null,
                'epa_kwh_100_mi_electric' => null,
                'range_electric' => null,
                'epa_highway_mpg_electric' => null,
                'epa_city_mpg_electric' => null,
                'epa_combined_mpg_electric' => null
            ],
            [
                'fuel_tank_capacity' => 47.0,
                'combined_LitersAt100km' => 6.7,
                'city_LitersAt100km' => 7.8,
                'highway_LitersAt100km' => 6.0,
                'range_city' => 602.6,
                'range_highway' => 783.3,
                'battery_capacity_electric' => null,
                'epa_time_to_charge_hr_240v_electric' => null,
                'epa_kwh_100_mi_electric' => null,
                'range_electric' => null,
                'epa_highway_mpg_electric' => null,
                'epa_city_mpg_electric' => null,
                'epa_combined_mpg_electric' => null
            ],
            [
                'fuel_tank_capacity' => 55.0,
                'combined_LitersAt100km' => 8.4,
                'city_LitersAt100km' => 10.2,
                'highway_LitersAt100km' => 7.3,
                'range_city' => 539.2,
                'range_highway' => 753.4,
                'battery_capacity_electric' => null,
                'epa_time_to_charge_hr_240v_electric' => null,
                'epa_kwh_100_mi_electric' => null,
                'range_electric' => null,
                'epa_highway_mpg_electric' => null,
                'epa_city_mpg_electric' => null,
                'epa_combined_mpg_electric' => null
            ],
            [
                'fuel_tank_capacity' => 43.0,
                'combined_LitersAt100km' => 4.5,
                'city_LitersAt100km' => 4.9,
                'highway_LitersAt100km' => 4.2,
                'range_city' => 877.6,
                'range_highway' => 1023.8,
                'battery_capacity_electric' => 1.3,
                'epa_time_to_charge_hr_240v_electric' => '2 hours',
                'epa_kwh_100_mi_electric' => '32 kWh/100mi',
                'range_electric' => '40 km',
                'epa_highway_mpg_electric' => 105.0,
                'epa_city_mpg_electric' => 114.0,
                'epa_combined_mpg_electric' => 110.0
            ],
            [
                'fuel_tank_capacity' => null,
                'combined_LitersAt100km' => null,
                'city_LitersAt100km' => null,
                'highway_LitersAt100km' => null,
                'range_city' => null,
                'range_highway' => null,
                'battery_capacity_electric' => 77.4,
                'epa_time_to_charge_hr_240v_electric' => '7.5 hours',
                'epa_kwh_100_mi_electric' => '30 kWh/100mi',
                'range_electric' => '455 km',
                'epa_highway_mpg_electric' => 113.0,
                'epa_city_mpg_electric' => 127.0,
                'epa_combined_mpg_electric' => 120.0
            ],
            [
                'fuel_tank_capacity' => 60.0,
                'combined_LitersAt100km' => 9.8,
                'city_LitersAt100km' => 11.7,
                'highway_LitersAt100km' => 8.6,
                'range_city' => 512.8,
                'range_highway' => 697.7,
                'battery_capacity_electric' => null,
                'epa_time_to_charge_hr_240v_electric' => null,
                'epa_kwh_100_mi_electric' => null,
                'range_electric' => null,
                'epa_highway_mpg_electric' => null,
                'epa_city_mpg_electric' => null,
                'epa_combined_mpg_electric' => null
            ],
            [
                'fuel_tank_capacity' => 58.0,
                'combined_LitersAt100km' => 7.2,
                'city_LitersAt100km' => 8.0,
                'highway_LitersAt100km' => 6.7,
                'range_city' => 725.0,
                'range_highway' => 865.7,
                'battery_capacity_electric' => null,
                'epa_time_to_charge_hr_240v_electric' => null,
                'epa_kwh_100_mi_electric' => null,
                'range_electric' => null,
                'epa_highway_mpg_electric' => null,
                'epa_city_mpg_electric' => null,
                'epa_combined_mpg_electric' => null
            ]
        ];

        foreach ($mileages as $mileage) {
            DB::table('mileages')->insert([
                'fuel_tank_capacity' => $mileage['fuel_tank_capacity'],
                'combined_LitersAt100km' => $mileage['combined_LitersAt100km'],
                'city_LitersAt100km' => $mileage['city_LitersAt100km'],
                'highway_LitersAt100km' => $mileage['highway_LitersAt100km'],
                'range_city' => $mileage['range_city'],
                'range_highway' => $mileage['range_highway'],
                'battery_capacity_electric' => $mileage['battery_capacity_electric'],
                'epa_time_to_charge_hr_240v_electric' => $mileage['epa_time_to_charge_hr_240v_electric'],
                'epa_kwh_100_mi_electric' => $mileage['epa_kwh_100_mi_electric'],
                'range_electric' => $mileage['range_electric'],
                'epa_highway_mpg_electric' => $mileage['epa_highway_mpg_electric'],
                'epa_city_mpg_electric' => $mileage['epa_city_mpg_electric'],
                'epa_combined_mpg_electric' => $mileage['epa_combined_mpg_electric'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
} 