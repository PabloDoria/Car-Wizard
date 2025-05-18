<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Body extends Model
{
    protected $table = 'bodies';
    protected $primaryKey = 'PK_id';
    public $timestamps = true;

    protected $fillable = [
        'type', // Type of vehicle body (e.g., Sedan, SUV)
        'doors', // Number of doors
        'length', // Vehicle length in centimeters (cm)
        'width', // Vehicle width in centimeters (cm)
        'seats', // Number of seats
        'height', // Vehicle height in centimeters (cm)
        'wheel_base', // Distance between front and rear axles in centimeters (cm)
        'front_track', // Width between front wheels (nullable or textual)
        'rear_track', // Width between rear wheels (nullable or textual)
        'ground_clearance', // Height from ground to undercarriage in centimeters (cm)
        'cargo_capacity', // Standard cargo volume in liters (L)
        'max_cargo_capacity', // Maximum cargo volume with seats folded in liters (L)
        'curb_weight', // Weight of the empty vehicle in kilograms (kg)
        'gross_weight', // Maximum total vehicle weight in kilograms (kg)
        'max_payload', // Maximum additional weight the vehicle can carry in kilograms (kg)
        'max_towing_capacity' // Max weight the vehicle can tow in kilograms (kg)
    ];

    public function trims()
    {
        return $this->hasMany(Trim::class, 'FK_body_id');
    }
} 