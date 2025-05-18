<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MakeModel extends Model
{
    protected $table = 'make_model';
    protected $primaryKey = 'PK_id';
    public $timestamps = true;

    protected $fillable = [
        'FK_make_id',
        'FK_name'
    ];

    public function make()
    {
        return $this->belongsTo(Make::class, 'FK_make_id');
    }

    public function model()
    {
        return $this->belongsTo(CarModel::class, 'FK_name', 'PK_name');
    }

    public function trims()
    {
        return $this->hasMany(Trim::class, 'FK_make_model_id');
    }
} 