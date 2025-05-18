<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Make extends Model
{
    protected $table = 'makes';
    protected $primaryKey = 'PK_id';
    public $timestamps = true;

    protected $fillable = [
        'name' // Name of the car manufacturer (e.g., Honda, Toyota)
    ];

    public function models()
    {
        return $this->belongsToMany(CarModel::class, 'make_model', 'FK_make_id', 'FK_name');
    }
} 