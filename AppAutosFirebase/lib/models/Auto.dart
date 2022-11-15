import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<Auto> allAutosFromJson(String str) {
  final js = json.decode(str);
  List<Auto> autos = List.empty(growable: true);

  js.forEach((k, v) {
    autos.add(Auto.fromJson(k, v));
  });

  return autos;
}

Auto OneAutoFromJson(String str, int Id) {
  final js = json.decode(str);
  Auto data =
      Auto(modelo: "", precio: 0, color: "", matricula: "", marca: "", Id: 0);

  data = Auto.fromJson(Id.toString(), js);

  return data;
}

class Auto {
  final String modelo;
  final int precio;
  final String color;
  final String matricula;
  final String marca;
  final int Id;

  Auto(
      {required this.modelo,
      required this.precio,
      required this.color,
      required this.matricula,
      required this.marca,
      required this.Id});

  factory Auto.fromJson(String key, dynamic json) => Auto(
      modelo: json["modelo"],
      precio: int.parse(json["precio"]),
      color: json["color"],
      matricula: json["matricula"],
      marca: json["marca"],
      Id: int.parse(key));

  Map<String, dynamic> toJson() => {
        "modelo": modelo,
        "precio": precio,
        "color": color,
        "matricula": matricula,
        "marca": marca,
        "Id": Id
      };
}
