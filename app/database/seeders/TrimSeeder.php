<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TrimSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Obtener IDs de las tablas relacionadas
        $yearId2024 = DB::table('years')->where('year', 2024)->value('PK_id');
        $yearId2023 = DB::table('years')->where('year', 2023)->value('PK_id');
        
        // Engine IDs - Asumiendo que los engines tienen IDs del 1 al 8 basado en el orden de inserción
        $engineIdSedan = 1; // 2.0L Regular Gas
        $engineIdHonda = 2; // 1.5L Turbo
        $engineIdVW = 3;    // 2.0L Premium
        $engineIdHybrid = 4; // Hybrid
        $engineIdElectric = 5; // Electric
        
        // Body IDs - Asumiendo que los bodies tienen IDs del 1 al 6 basado en el orden de inserción
        $bodyIdSedan = 1;
        $bodyIdSUV = 2;
        $bodyIdTruck = 3;
        $bodyIdHatchback = 4;
        $bodyIdCoupe = 5;
        
        // Make-Model IDs - Necesitamos obtener estos de la base de datos
        $toyotaCorollaId = DB::table('make_model')
            ->join('makes', 'make_model.FK_make_id', '=', 'makes.PK_id')
            ->where('makes.name', 'Toyota')
            ->where('make_model.FK_name', 'Corolla')
            ->value('make_model.PK_id');
            
        $toyotaCamryId = DB::table('make_model')
            ->join('makes', 'make_model.FK_make_id', '=', 'makes.PK_id')
            ->where('makes.name', 'Toyota')
            ->where('make_model.FK_name', 'Camry')
            ->value('make_model.PK_id');
            
        $hondaCivicId = DB::table('make_model')
            ->join('makes', 'make_model.FK_make_id', '=', 'makes.PK_id')
            ->where('makes.name', 'Honda')
            ->where('make_model.FK_name', 'Civic')
            ->value('make_model.PK_id');
            
        $vwJettaId = DB::table('make_model')
            ->join('makes', 'make_model.FK_make_id', '=', 'makes.PK_id')
            ->where('makes.name', 'Volkswagen')
            ->where('make_model.FK_name', 'Jetta')
            ->value('make_model.PK_id');
        
        // Mileage IDs - Asumiendo que mileages tienen IDs del 1 al 7 basado en el orden de inserción
        $mileageIdSedan = 1;
        $mileageIdHonda = 2;
        $mileageIdVW = 3;
        $mileageIdHybrid = 4;
        $mileageIdElectric = 5;
        
        $trims = [
            [
                'FK_year' => $yearId2024,
                'name' => 'SE',
                'FK_engine_id' => $engineIdSedan,
                'FK_body_id' => $bodyIdSedan,
                'description' => '4-door sedan with CVT',
                'price' => 21550,
                'FK_make_model_id' => $toyotaCorollaId,
                'FK_mileage_id' => $mileageIdSedan,
                'estimatedKM' => 0
            ],
            [
                'FK_year' => $yearId2024,
                'name' => 'XLE',
                'FK_engine_id' => $engineIdSedan,
                'FK_body_id' => $bodyIdSedan,
                'description' => '4-door premium sedan with CVT',
                'price' => 25500,
                'FK_make_model_id' => $toyotaCorollaId,
                'FK_mileage_id' => $mileageIdSedan,
                'estimatedKM' => 0
            ],
            [
                'FK_year' => $yearId2024,
                'name' => 'Touring',
                'FK_engine_id' => $engineIdHonda,
                'FK_body_id' => $bodyIdSedan,
                'description' => '4-door premium sedan with CVT',
                'price' => 29650,
                'FK_make_model_id' => $hondaCivicId,
                'FK_mileage_id' => $mileageIdHonda,
                'estimatedKM' => 0
            ],
            [
                'FK_year' => $yearId2024,
                'name' => 'Sport',
                'FK_engine_id' => $engineIdHonda,
                'FK_body_id' => $bodyIdSedan,
                'description' => '4-door sporty sedan with CVT',
                'price' => 25050,
                'FK_make_model_id' => $hondaCivicId,
                'FK_mileage_id' => $mileageIdHonda,
                'estimatedKM' => 0
            ],
            [
                'FK_year' => $yearId2024,
                'name' => 'GLI',
                'FK_engine_id' => $engineIdVW,
                'FK_body_id' => $bodyIdSedan,
                'description' => '4-door performance sedan with DSG',
                'price' => 31500,
                'FK_make_model_id' => $vwJettaId,
                'FK_mileage_id' => $mileageIdVW,
                'estimatedKM' => 0
            ],
            [
                'FK_year' => $yearId2023,
                'name' => 'S',
                'FK_engine_id' => $engineIdVW,
                'FK_body_id' => $bodyIdSedan,
                'description' => '4-door base sedan with manual',
                'price' => 21000,
                'FK_make_model_id' => $vwJettaId,
                'FK_mileage_id' => $mileageIdVW,
                'estimatedKM' => 15000
            ],
            [
                'FK_year' => $yearId2023,
                'name' => 'Hybrid LE',
                'FK_engine_id' => $engineIdHybrid,
                'FK_body_id' => $bodyIdSedan,
                'description' => '4-door hybrid sedan with ECVT',
                'price' => 24050,
                'FK_make_model_id' => $toyotaCamryId,
                'FK_mileage_id' => $mileageIdHybrid,
                'estimatedKM' => 12000
            ]
        ];

        foreach ($trims as $trim) {
            DB::table('trims')->insert([
                'FK_year' => $trim['FK_year'],
                'name' => $trim['name'],
                'FK_engine_id' => $trim['FK_engine_id'],
                'FK_body_id' => $trim['FK_body_id'],
                'description' => $trim['description'],
                'price' => $trim['price'],
                'FK_make_model_id' => $trim['FK_make_model_id'],
                'FK_mileage_id' => $trim['FK_mileage_id'],
                'estimatedKM' => $trim['estimatedKM'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
} 