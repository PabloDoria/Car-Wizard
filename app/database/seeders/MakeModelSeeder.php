<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MakeModelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $relations = [
            // Toyota models
            ['make' => 'Toyota', 'models' => ['Corolla', 'Camry', 'RAV4', 'Highlander', 'Tacoma']],
            // Honda models
            ['make' => 'Honda', 'models' => ['Civic', 'Accord', 'CR-V', 'Pilot', 'Odyssey']],
            // Volkswagen models
            ['make' => 'Volkswagen', 'models' => ['Jetta', 'Golf', 'Tiguan', 'Atlas', 'Passat']],
            // Ford models
            ['make' => 'Ford', 'models' => ['Mustang', 'F-150', 'Escape', 'Explorer', 'Focus']],
            // Chevrolet models
            ['make' => 'Chevrolet', 'models' => ['Camaro', 'Silverado', 'Equinox', 'Malibu', 'Traverse']],
            // Nissan models
            ['make' => 'Nissan', 'models' => ['Altima', 'Rogue', 'Sentra', 'Pathfinder', '370Z']],
            // Hyundai models
            ['make' => 'Hyundai', 'models' => ['Elantra', 'Tucson', 'Santa Fe', 'Sonata', 'Kona']],
            // Kia models
            ['make' => 'Kia', 'models' => ['Forte', 'Sorento', 'Sportage', 'Optima', 'Soul']],
            // BMW models
            ['make' => 'BMW', 'models' => ['3 Series', '5 Series', 'X3', 'X5', 'M3']],
            // Mercedes-Benz models
            ['make' => 'Mercedes-Benz', 'models' => ['C-Class', 'E-Class', 'GLE', 'S-Class', 'A-Class']],
        ];

        foreach ($relations as $relation) {
            $makeId = DB::table('makes')->where('name', $relation['make'])->value('PK_id');
            
            foreach ($relation['models'] as $modelName) {
                DB::table('make_model')->insert([
                    'FK_make_id' => $makeId,
                    'FK_name' => $modelName,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }
    }
} 