import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tortillapp/config/backend.dart';

class PP_Model {
  String nombre = ""; //Nombre del administrador
  String nombreNegocio = ""; //Nombre del negocio
  String nombreSucursal = ""; //Nombre de la sucursal
  double latitud = 0.0; //Latitud del negocio
  double longitud = 0.0; //Longitud del negocio

 //Set para nombre
  void setNombre(String nombre) {
    this.nombre = nombre;
  }
  //Set para nombreNegocio
  void setNombreNegocio(String nombreNegocio) {
    this.nombreNegocio = nombreNegocio;
  }
  //Set para nombreSucursal
  void setNombreSucursal(String nombreSucursal) {
    this.nombreSucursal = nombreSucursal;
  }
  //Set para latitud
  void setLatitud(double latitud) {
    this.latitud = latitud;
  }
  //Set para longitud
  void setLongitud(double longitud) {
    this.longitud = longitud;
  }
}


