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
  double precio_publico = 0.0; //Precio al público
  double precio_tienda = 0.0; //Precio en la tienda

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
  //Set para precio_publico
  void setPrecioPublico(double precio_publico) {
    this.precio_publico = precio_publico;
  }
  //Set para precio_tienda
  void setPrecioTienda(double precio_tienda) {
    this.precio_tienda = precio_tienda;
  }
}


