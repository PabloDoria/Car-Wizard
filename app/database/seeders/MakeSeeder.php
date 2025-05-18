<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MakeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $makes = [
            ['name' => 'Toyota'],
            ['name' => 'Honda'],
            ['name' => 'Volkswagen'],
            ['name' => 'Ford'],
            ['name' => 'Chevrolet'],
            ['name' => 'Nissan'],
            ['name' => 'Hyundai'],
            ['name' => 'Kia'],
            ['name' => 'BMW'],
            ['name' => 'Mercedes-Benz'],
        ];

        foreach ($makes as $make) {
            DB::table('makes')->insert([
                'name' => $make['name'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
} 