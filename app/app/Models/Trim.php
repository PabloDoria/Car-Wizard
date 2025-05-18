<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Trim extends Model
{
    protected $table = 'trims';
    protected $primaryKey = 'PK_id';
    public $timestamps = true;

    protected $fillable = [
        'FK_year', // Model year
        'name', // Name of the trim or version (e.g., SE, XLE, GT-Line)
        'FK_engine_id', // Linked engine
        'FK_body_id', // Linked body type
        'description', // Short description of trim (may include doors, transmission)
        'price', // Manufacturer's suggested retail price (MSRP)
        'FK_make_model_id', // Linked model to which this trim belongs
        'FK_mileage_id', // Linked mileage entry (fuel efficiency)
        'estimatedKM' // Estimated kilometers driven (for market data or resale info)
    ];

    public function year()
    {
        return $this->belongsTo(Year::class, 'FK_year');
    }

    public function engine()
    {
        return $this->belongsTo(Motor::class, 'FK_engine_id');
    }

    public function body()
    {
        return $this->belongsTo(Body::class, 'FK_body_id');
    }

    public function makeModel()
    {
        return $this->belongsTo(MakeModel::class, 'FK_make_model_id');
    }

    public function mileage()
    {
        return $this->belongsTo(Mileage::class, 'FK_mileage_id');
    }
} 