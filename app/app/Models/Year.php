<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Year extends Model
{
    protected $table = 'years';
    protected $primaryKey = 'PK_id';
    public $timestamps = true;

    protected $fillable = [
        'year' // Model year of the vehicle
    ];

    public function trims()
    {
        return $this->hasMany(Trim::class, 'FK_year');
    }
} 