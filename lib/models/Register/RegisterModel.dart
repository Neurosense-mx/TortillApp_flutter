import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tortillapp/config/backend.dart';

class RegisterModel {
  String email = "";
  String password = "";
  bool codeVerify = false;
  String code = "";
  int id_suscription = 0;

// Función para buscar email
  Future<Map<String, dynamic>> search_email(String email) async {
    final url = Uri.parse(ApiConfig.backendUrl + '/register/validateEmail');
    try {
      // Realizamos la solicitud HTTP POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'correo': email}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Evaluamos el valor de 'exists'
        if (data['exists'] == true) {
          // Si el email ya existe, regresamos un código de error personalizado
          return {
            'statusCode': 409, // Código 409 - Conflict
            'message':
                'El correo electrónico ya está registrado, por favor intenta con otro.'
          };
        } else {
          // Si el email no existe, regresamos un código 200
          this.email = email; // Guardamos el email en la instancia de la clase
          return {
            'statusCode': 200, // OK
            'message': 'El correo electrónico está disponible.'
          };
        }
      } else {
        // Si la respuesta no es exitosa
        return {
          'statusCode': response.statusCode,
          'message': 'Error en la solicitud: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Si ocurre un error en la conexión o la solicitud
      return {'statusCode': 500, 'message': 'Error en la conexión: $e'};
    }
  }

// Gets de los atributos
  String getEmail() {
    return this.email;
  }

//Regresar el json
  Map<String, dynamic> _registro_to_JSON() {
    return {
      'email': this.email,
      'password': this.password,
      'codeVerify': this.codeVerify,
      'code': this.code,
      'id_suscription': this.id_suscription
    };
  }
}


