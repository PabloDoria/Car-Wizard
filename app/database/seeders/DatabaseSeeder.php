<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            // Primero los seeders independientes
            MakeSeeder::class,
            ModelSeeder::class,
            YearSeeder::class,
            EngineSeeder::class,
            BodySeeder::class,
            MileageSeeder::class,
            
            // Luego los seeders que dependen de los anteriores
            MakeModelSeeder::class,
            TrimSeeder::class,
            
        ]);
    }
}
