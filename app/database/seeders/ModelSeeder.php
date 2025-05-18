<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ModelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $models = [
            // Toyota
            'Corolla', 'Camry', 'RAV4', 'Highlander', 'Tacoma',
            // Honda
            'Civic', 'Accord', 'CR-V', 'Pilot', 'Odyssey',
            // Volkswagen
            'Jetta', 'Golf', 'Tiguan', 'Atlas', 'Passat',
            // Ford
            'Mustang', 'F-150', 'Escape', 'Explorer', 'Focus',
            // Chevrolet
            'Camaro', 'Silverado', 'Equinox', 'Malibu', 'Traverse',
            // Nissan
            'Altima', 'Rogue', 'Sentra', 'Pathfinder', '370Z',
            // Hyundai
            'Elantra', 'Tucson', 'Santa Fe', 'Sonata', 'Kona',
            // Kia
            'Forte', 'Sorento', 'Sportage', 'Optima', 'Soul',
            // BMW
            '3 Series', '5 Series', 'X3', 'X5', 'M3',
            // Mercedes-Benz
            'C-Class', 'E-Class', 'GLE', 'S-Class', 'A-Class'
        ];

        foreach ($models as $model) {
            DB::table('models')->insert([
                'PK_name' => $model,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
} 