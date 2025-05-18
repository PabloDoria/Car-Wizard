<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class YearSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $years = [
            2024, 2023, 2022, 2021, 2020, 
            2019, 2018, 2017, 2016, 2015,
            2014, 2013, 2012, 2011, 2010,
            2009, 2008, 2007, 2006, 2005
        ];

        foreach ($years as $year) {
            DB::table('years')->insert([
                'year' => $year,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
} 