<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
// use Illuminate\Support\Integer;


class TestController extends Controller
{
    private $database;

public function __construct()
{
    $this->database = \App\Services\FirebaseService::connect();
}

public function crear(Request $request)
{
    // $id = Str::random(5);
    $id = mt_rand(1000000, 9999999);
    // dd($request->parameters);

        $this->database
        ->getReference('autos/'. $id)
        ->set([
            'modelo' => $request['modelo'],
            'marca' => $request['marca'],
            'color' => $request['color'],
            'matricula' => $request['matricula'],
            'precio' => $request['precio']
            ]);

            //  $this->database
//         ->getReference('autos/')
//         ->set o push([
//             "data" => [
//                 'modelo' => $request['modelo'],
//             'marca' => $request['marca'],
//             'color' => $request['color'],
//             'matricula' => $request['matricula'],
//             'precio' => $request['precio']
//             ]
//             ]
//     );
    return response()->json('Carro creado con exito');
}

// public function ver()
// {
//     return response()->json($this->database->getReference()->getValue());
//     //eturn $this->database->getReference('autos/');
// }

public function ver()
{
    // $responsedure = response()->json($this->database->getReference('autos')->getValue());
    // return collect([$responsedure->original]);

        return $this->database->getReference('autos/')->getValue();
}

public function verDetalleCarro(Request $request)
{

    return $this->database->getReference('autos/'.$request['id'])->getValue();
    // if($request->assertStatus(200))
    // {
    // }
    // else
    // {
    //     return response()->json('El carro que buscas no existe carnal');
    // }

}

public function editar(Request $request)
{
    $this->database->getReference('autos/' . $request['id'])
        ->update([
            'modelo' => $request['modelo'],
            'marca' => $request['marca'],
            'color' => $request['color'],
            'matricula' => $request['matricula'],
            'precio' => $request['precio'],
        ]);
    return response()->json('Carro editado con exito');
}


public function borrar(Request $request)
{
    $this->database
        ->getReference('autos/' . $request['id'])
        ->remove();
    return response()->json('Carro eliminado con exito');
}


}
