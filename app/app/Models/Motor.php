<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Motor extends Model
{
    protected $table = 'engines';
    protected $primaryKey = 'PK_id';
    public $timestamps = true;

    protected $fillable = [
        'engine_type', // Type of engine (e.g., gas, diesel, electric)
        'fuel_type', // Type of fuel used
        'cylinders', // Engine cylinder configuration (e.g., I4, V6)
        'size', // Engine size or displacement in liters (L) (text)
        'horsepower_hp', // Engine power in horsepower (hp)
        'horsepower_rpm', // RPM at which max horsepower is delivered in revolutions/minute
        'torque_ft_lbs', // Torque in pound-feet (lb-ft)
        'valves', // Total number of engine valves in units
        'valve_timing', // Valve timing type (e.g., Variable)
        'cam_type', // Camshaft configuration (e.g., DOHC, SOHC)
        'drive_type', // Drivetrain configuration (e.g., FWD, AWD, RWD)
        'transmission' // Type of transmission (e.g., 6-speed automatic)
    ];

    public function trims()
    {
        return $this->hasMany(Trim::class, 'FK_engine_id');
    }
} 