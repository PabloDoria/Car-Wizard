<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CarModel extends Model
{
    protected $table = 'models';
    protected $primaryKey = 'PK_name';
    public $incrementing = false;
    public $timestamps = true;

    protected $fillable = [
        'PK_name' // Unique name of the model (e.g., Civic, Corolla)
    ];

    public function makes()
    {
        return $this->belongsToMany(Make::class, 'make_model', 'FK_name', 'FK_make_id');
    }
} 