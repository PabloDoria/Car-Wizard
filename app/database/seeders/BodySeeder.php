<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class BodySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $bodies = [
            [
                'type' => 'Sedan',
                'doors' => 4,
                'length' => 483.9,
                'width' => 180.5,
                'seats' => 5,
                'height' => 142.3,
                'wheel_base' => 279.3,
                'front_track' => '156.9 cm',
                'rear_track' => '157.0 cm',
                'ground_clearance' => 13.7,
                'cargo_capacity' => 470.0,
                'max_cargo_capacity' => 470.0,
                'curb_weight' => 1375.0,
                'gross_weight' => 1810.0,
                'max_payload' => 435.0,
                'max_towing_capacity' => 680.0
            ],
            [
                'type' => 'SUV',
                'doors' => 5,
                'length' => 459.5,
                'width' => 182.0,
                'seats' => 5,
                'height' => 168.5,
                'wheel_base' => 266.0,
                'front_track' => '158.2 cm',
                'rear_track' => '158.5 cm',
                'ground_clearance' => 19.8,
                'cargo_capacity' => 586.0,
                'max_cargo_capacity' => 1690.0,
                'curb_weight' => 1540.0,
                'gross_weight' => 2030.0,
                'max_payload' => 490.0,
                'max_towing_capacity' => 1500.0
            ],
            [
                'type' => 'Truck',
                'doors' => 4,
                'length' => 575.8,
                'width' => 205.2,
                'seats' => 5,
                'height' => 197.5,
                'wheel_base' => 348.0,
                'front_track' => '171.5 cm',
                'rear_track' => '172.0 cm',
                'ground_clearance' => 24.5,
                'cargo_capacity' => 1500.0,
                'max_cargo_capacity' => 1500.0,
                'curb_weight' => 2190.0,
                'gross_weight' => 3175.0,
                'max_payload' => 985.0,
                'max_towing_capacity' => 5500.0
            ],
            [
                'type' => 'Hatchback',
                'doors' => 5,
                'length' => 426.5,
                'width' => 179.3,
                'seats' => 5,
                'height' => 145.5,
                'wheel_base' => 262.0,
                'front_track' => '153.7 cm',
                'rear_track' => '153.9 cm',
                'ground_clearance' => 14.2,
                'cargo_capacity' => 380.0,
                'max_cargo_capacity' => 1160.0,
                'curb_weight' => 1290.0,
                'gross_weight' => 1765.0,
                'max_payload' => 475.0,
                'max_towing_capacity' => 630.0
            ],
            [
                'type' => 'Coupe',
                'doors' => 2,
                'length' => 471.0,
                'width' => 187.8,
                'seats' => 4,
                'height' => 138.2,
                'wheel_base' => 268.0,
                'front_track' => '159.5 cm',
                'rear_track' => '160.0 cm',
                'ground_clearance' => 11.5,
                'cargo_capacity' => 320.0,
                'max_cargo_capacity' => 320.0,
                'curb_weight' => 1580.0,
                'gross_weight' => 1950.0,
                'max_payload' => 370.0,
                'max_towing_capacity' => 0.0
            ],
            [
                'type' => 'Minivan',
                'doors' => 5,
                'length' => 513.5,
                'width' => 195.4,
                'seats' => 7,
                'height' => 169.8,
                'wheel_base' => 304.8,
                'front_track' => '168.7 cm',
                'rear_track' => '169.0 cm',
                'ground_clearance' => 16.5,
                'cargo_capacity' => 929.0,
                'max_cargo_capacity' => 3984.0,
                'curb_weight' => 1985.0,
                'gross_weight' => 2735.0,
                'max_payload' => 750.0,
                'max_towing_capacity' => 1600.0
            ]
        ];

        foreach ($bodies as $body) {
            DB::table('bodies')->insert([
                'type' => $body['type'],
                'doors' => $body['doors'],
                'length' => $body['length'],
                'width' => $body['width'],
                'seats' => $body['seats'],
                'height' => $body['height'],
                'wheel_base' => $body['wheel_base'],
                'front_track' => $body['front_track'],
                'rear_track' => $body['rear_track'],
                'ground_clearance' => $body['ground_clearance'],
                'cargo_capacity' => $body['cargo_capacity'],
                'max_cargo_capacity' => $body['max_cargo_capacity'],
                'curb_weight' => $body['curb_weight'],
                'gross_weight' => $body['gross_weight'],
                'max_payload' => $body['max_payload'],
                'max_towing_capacity' => $body['max_towing_capacity'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
} 