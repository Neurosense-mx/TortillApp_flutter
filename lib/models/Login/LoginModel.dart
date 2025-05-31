import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tortillapp/config/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModel {
  String email = "";
  String password = "";

  //Setear el email
  void setEmail(String email) {
    this.email = email;
  }

  //Setear el password
  void setPassword(String password) {
    this.password = password;
  }

  //Funcion para login
  Future<Map<String, dynamic>> login() async {
    final url = Uri.parse(ApiConfig.backendUrl + '/login');
    try {
      // Realizamos la solicitud HTTP POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': this.email,
          'password': this.password,
        }),
      );

      var data = json.decode(response.body);

      //print("Codigo: " + response.statusCode.toString());

      if (response.statusCode == 200) {
        // Extre el diccionario de usuario
        var user = data['user'];
        var config = user['config'];

        saveDataAdmin(data['token'], user['id'], user['id_rol'], user['id_admin']);
        // verificar si el usuario es admin o no
        if (user['id_rol'] == 1) {
          print("Hol eres admin");
        } else {
          print("No eres admin");
          print("Nombre: " + user['nombre']);
        }

        return {
          'statusCode': 200, // OK
          'token': data['token'],
          'user': {
            'id': user['id'],
            'nombre': user['nombre'],
            'email': user['email'],
            'id_rol': user['id_rol'],
            'id_admin': user['id_admin'],
          },
          'config': user['id_rol'] == 1
              ? {
                  'negocio': config['negocio'],
                  'sucursal': config['sucursal'],
                  'precio': config['precio'],
                  'productos': config['productos'],
                  'gastos': config['gastos'],
                  'empleados': config['empleados'],
                }
              : [], // Si no es id_rol == 1, retorna un array vacío
        };
      } else {
        // Si la respuesta no es exitosa
        return {
          'statusCode': response.statusCode,
          'message': data['error'],
        };
      }
    } catch (e) {
      // Si ocurre un error en la conexión o la solicitud
      return {'statusCode': 500, 'message': 'Error en la conexión: $e'};
    }
  }

  //Funcion para guardar el token en el dispositivo
  Future<void> saveDataAdmin(String token, int id_cuenta, int id_rol, int id_admin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); //Guardar el token
    await prefs.setInt('id_cuenta', id_cuenta); //Guardar el nombre
    await prefs.setInt('id_rol', id_rol); //Guardar el id_rol
    await prefs.setInt('id_admin', id_admin); //Guardar si es admin
  }

  //Funcion para guardar saveDataAdminPrimerosPasos
  Future<void> saveIdNegocio(int id_negocio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_negocio', id_negocio); //Guardar el id_negocio
  }

  //Funcion para guardar saveDataUser
  Future<void> saveDataUser(String token, String name, int id_rol,
      int id_negocio, int id_sucursal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); //Guardar el token
    await prefs.setString('name', name); //Guardar el nombre
    await prefs.setInt('id_rol', id_rol); //Guardar el id_rol
    await prefs.setInt('id_negocio', id_negocio); //Guardar el id_negocio
    await prefs.setInt('id_sucursal', id_sucursal); //Guardar el id_sucursal
  }
}
