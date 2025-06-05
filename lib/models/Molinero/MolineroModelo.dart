import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tortillapp/config/backend.dart';
import 'package:tortillapp/utils/Data_sesion.dart';

class MolinoModel {
  late int id_account; // id de la cuenta
  late int id_sucursal; // id de la sucursal
  late int id_negocio; // id del negocio
  late int id_admin; // id del administrador
  late String token; // id del molino
  late String email; // email del molino
  late String nombre; // nombre del molino

  MolinoModel(this.id_account, this.id_sucursal, this.id_negocio, this.id_admin,
      this.token, this.email, this.nombre) {
    //_fetchData(id_account); // Llamamos al método para obtener los datos al instanciar el modelo
    print("Modelo de molino creado");
  }
  // Método para obtener los datos(id sucursal, id negocio) de la cuenta

  //------------------------- Acciones del molino -------------------------
  // Método para agregar maíz para cocer
  Future<bool> addMaiz(double maiz) async {
    print("Agregando maíz: $maiz kg");
    final url = Uri.parse(ApiConfig.backendUrl + '/molinero/cocer/maiz');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'id_cuenta': id_account,
        'id_sucursal': id_sucursal,
        'kg_cocidos': maiz,
      }),
    );

    if (response.statusCode == 200) {
      print("Maíz agregado correctamente");
      return true;
    } else {
      print("Error al agregar maíz: ${response.body}");
      return false;
    }
  }

//Obtener los datos de estadistica semanal
  Future<Map<String, dynamic>> getEstadisticas() async {
    final url = Uri.parse(
        ApiConfig.backendUrl + '/molinero/registros/semana/$id_account');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener las estadísticas: ${response.body}');
    }
  }

//obtener los registros de maiz que no han sido pesados
  Future<List<Map<String, dynamic>>> getMaizSinPesar() async {
    final url = Uri.parse(
        ApiConfig.backendUrl + '/molinero/cocer/maiz/sin_peso/$id_account');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception(
          'Error al obtener los maíces sin pesar: ${response.body}');
    }
  }

//bool para registrar el peso del maiz /molinero/masa/pesar
  Future<bool> pesarMasa(int id_maiz, double kg_masa) async {
    final url = Uri.parse(ApiConfig.backendUrl + '/molinero/masa/pesar');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'id_cuenta': id_account,
        'id_sucursal': id_sucursal,
        'id_costales': id_maiz,
        'kg_masa': kg_masa,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Error al pesar masa: ${response.body}");
      return false;
    }
  }

//Endpoint para obtener mis registros
  Future<List<Map<String, dynamic>>> getMisRegistros() async {
    final url =
        Uri.parse(ApiConfig.backendUrl + '/molinero/mis_registros/$id_account');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener mis registros: ${response.body}');
    }
  }

  //function para cerrar sesion, elimiar el token
  Future<void> logout() async {
    await DataUser().clear();
  }
}
