import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:appautosfirebase/models/Auto.dart';
import 'dart:io';

String url = 'http://100.10.20.3:8080/api';

Future<List<Auto>> getAllAutos() async {
  final response = await http.get('$url/verCarro');
  return allAutosFromJson(response.body);
}

Future<Auto> getAuto(int Id) async {
  final response = await http.get('$url/verDetalleCarro/${Id}');
  return OneAutoFromJson(response.body, Id);
}

Future<http.Response> EditarAutoApi(String Id, String Marca, String Modelo,
    String Color, int Precio, String Matricula) async {
  final data = json.encode(<String, String>{
    'marca': Marca,
    'modelo': Modelo,
    'color': Color,
    'precio': Precio.toString(),
    'matricula': Matricula,
  });

  print(data);

  return await http.post('${url}/editarCarro/${Id}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data);
}

Future<http.Response> createAuto(String Marca, String Modelo, String Color,
    int Precio, String Matricula) async {
  final data = json.encode(<String, String>{
    'marca': Marca,
    'modelo': Modelo,
    'color': Color,
    'precio': Precio.toString(),
    'matricula': Matricula,
  });

  print(data);

  return await http.post('${url}/crearCarro',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data);
}

Future<http.Response> eliminarAuto(String Id) async {
  return await http
      .delete('${url}/borrarCarro/${Id}', headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
}


//Future<http.Response> createPost(Auto post) async {
//  final response = await http.post('$url',
//      headers: {
//        HttpHeaders.contentTypeHeader: 'application/json',
//        HttpHeaders.authorizationHeader: ''
//      },
      //body: AutosTo(post));
//  return response;
//}
