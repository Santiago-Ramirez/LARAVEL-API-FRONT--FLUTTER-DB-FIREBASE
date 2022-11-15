<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/verDetalleCarro/{id}', [TestController::class, 'verDetalleCarro']);
Route::post('/crearCarro', [TestController::class, 'crear']);
Route::get('/verCarro', [TestController::class, 'ver']);
Route::post('/editarCarro/{id}', [TestController::class, 'editar']);
Route::delete('/borrarCarro/{id}', [TestController::class, 'borrar']);
