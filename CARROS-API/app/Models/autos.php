<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class autos extends Model
{
    protected $fillable = [
        "color",
        "marca",
        "matricula",
        "modelo",
        "precio"
    ];
}
