<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class EngineSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $engines = [
            [
                'engine_type' => 'Gasoline',
                'fuel_type' => 'Regular Unleaded',
                'cylinders' => 'I4',
                'size' => '2.0L',
                'horsepower_hp' => 169,
                'horsepower_rpm' => 6600.00,
                'torque_ft_lbs' => 151.00,
                'valves' => 16.00,
                'valve_timing' => 'Variable',
                'cam_type' => 'DOHC',
                'drive_type' => 'FWD',
                'transmission' => 'CVT'
            ],
            [
                'engine_type' => 'Gasoline',
                'fuel_type' => 'Regular Unleaded',
                'cylinders' => 'I4',
                'size' => '1.5L',
                'horsepower_hp' => 180,
                'horsepower_rpm' => 6000.00,
                'torque_ft_lbs' => 177.00,
                'valves' => 16.00,
                'valve_timing' => 'Variable',
                'cam_type' => 'DOHC',
                'drive_type' => 'FWD',
                'transmission' => 'CVT'
            ],
            [
                'engine_type' => 'Gasoline',
                'fuel_type' => 'Premium Unleaded',
                'cylinders' => 'I4',
                'size' => '2.0L',
                'horsepower_hp' => 228,
                'horsepower_rpm' => 5000.00,
                'torque_ft_lbs' => 258.00,
                'valves' => 16.00,
                'valve_timing' => 'Variable',
                'cam_type' => 'DOHC',
                'drive_type' => 'FWD',
                'transmission' => '7-Speed DSG'
            ],
            [
                'engine_type' => 'Hybrid',
                'fuel_type' => 'Regular Unleaded/Electric',
                'cylinders' => 'I4',
                'size' => '2.5L',
                'horsepower_hp' => 219,
                'horsepower_rpm' => 5700.00,
                'torque_ft_lbs' => 163.00,
                'valves' => 16.00,
                'valve_timing' => 'Variable',
                'cam_type' => 'DOHC',
                'drive_type' => 'AWD',
                'transmission' => 'ECVT'
            ],
            [
                'engine_type' => 'Electric',
                'fuel_type' => 'Electric',
                'cylinders' => null,
                'size' => null,
                'horsepower_hp' => 201,
                'horsepower_rpm' => null,
                'torque_ft_lbs' => 290.00,
                'valves' => null,
                'valve_timing' => null,
                'cam_type' => null,
                'drive_type' => 'RWD',
                'transmission' => 'Single-Speed'
            ],
            [
                'engine_type' => 'Gasoline',
                'fuel_type' => 'Regular Unleaded',
                'cylinders' => 'V6',
                'size' => '3.5L',
                'horsepower_hp' => 280,
                'horsepower_rpm' => 6000.00,
                'torque_ft_lbs' => 262.00,
                'valves' => 24.00,
                'valve_timing' => 'Variable',
                'cam_type' => 'DOHC',
                'drive_type' => 'AWD',
                'transmission' => '8-Speed Automatic'
            ],
            [
                'engine_type' => 'Diesel',
                'fuel_type' => 'Diesel',
                'cylinders' => 'I4',
                'size' => '2.0L',
                'horsepower_hp' => 188,
                'horsepower_rpm' => 3800.00,
                'torque_ft_lbs' => 295.00,
                'valves' => 16.00,
                'valve_timing' => 'Fixed',
                'cam_type' => 'DOHC',
                'drive_type' => '4WD',
                'transmission' => '8-Speed Automatic'
            ],
            [
                'engine_type' => 'Gasoline',
                'fuel_type' => 'Premium Unleaded',
                'cylinders' => 'V8',
                'size' => '5.0L',
                'horsepower_hp' => 460,
                'horsepower_rpm' => 7000.00,
                'torque_ft_lbs' => 420.00,
                'valves' => 32.00,
                'valve_timing' => 'Variable',
                'cam_type' => 'DOHC',
                'drive_type' => 'RWD',
                'transmission' => '6-Speed Manual'
            ]
        ];

        foreach ($engines as $engine) {
            DB::table('engines')->insert([
                'engine_type' => $engine['engine_type'],
                'fuel_type' => $engine['fuel_type'],
                'cylinders' => $engine['cylinders'],
                'size' => $engine['size'],
                'horsepower_hp' => $engine['horsepower_hp'],
                'horsepower_rpm' => $engine['horsepower_rpm'],
                'torque_ft_lbs' => $engine['torque_ft_lbs'],
                'valves' => $engine['valves'],
                'valve_timing' => $engine['valve_timing'],
                'cam_type' => $engine['cam_type'],
                'drive_type' => $engine['drive_type'],
                'transmission' => $engine['transmission'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
} 