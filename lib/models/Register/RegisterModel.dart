import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:tortillapp/config/backend.dart';
import 'package:flutter/material.dart';

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

//Funcion para setear el password
  void setPassword(String password) {
    //print("Password: $password");
    this.password = password;
  }

//funcion para enviar un code al email
  Future<Map<String, dynamic>> sendCode() async {
    final url =
        Uri.parse(ApiConfig.backendUrl + '/register/sendCode/' + this.email);
    try {
      // Realizamos la solicitud HTTP POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Se envio el codigo");
        var data = json.decode(response.body);
        this.code = data['code'].toString();
        //imprimir el codigo
        print(
            "--------------------------------------" + data['code'].toString());
        return {
          'statusCode': 200, // OK
          'message': 'El correo electrónico está disponible.'
        };
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

//Set para id_suscription
  void setIdSuscription(int id_suscription) {
    this.id_suscription = id_suscription;
  }

// ----------------------------------------------------------------------------- Gets de los atributos
  String getEmail() {
    return this.email;
  }

  String getCode() {
    return this.code;
  }

  //Funcion para enviar los datos al backend
  Future<Map<String, dynamic>> sendRegister() async {
    final url = Uri.parse(ApiConfig.backendUrl + '/register/adduser');
    try {
      // Realizamos la solicitud HTTP POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': this.email,
          'password': this.password,
          'id_suscripcion': this.id_suscription
        }),
      );

      if (response.statusCode == 200) {
        //obtener el ID del response
        final respuesta = jsonDecode(response.body);
        return {
          'statusCode': 200, // OK
          'message': 'Registro exitoso, por favor inicia sesión.',
          'ID': respuesta['ID']
        };
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
}
