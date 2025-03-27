import 'dart:convert';
import 'package:http/http.dart' as http;

class MolinoModel {
  int id_account; // id de la cuenta
  late int id_sucursal; // id de la sucursal
  late int id_negocio; // id del negocio

  MolinoModel(this.id_account) {
    //_fetchData(id_account); // Llamamos al método para obtener los datos al instanciar el modelo
    print("Modelo de molino creado");
  }
  // Método para obtener los datos(id sucursal, id negocio) de la cuenta
  Future<void> _fetchData(int id_account) async {
    try {
      final response = await http.get(Uri.parse('https://miapi.com/getData?id_account=$id_account'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        this.id_sucursal = data['id_sucursal']; // Asignar los datos recibidos
        this.id_negocio = data['id_negocio'];   // Asignar los datos recibidos
      } else {
        throw Exception('Error al obtener datos');
      }
    } catch (e) {
      print('Error al realizar la petición: $e');
    }
  }

  //------------------------- Acciones del molino -------------------------
  // Método para agregar maíz para cocer
  Future<void> addMaiz(double maiz) async {
    print("Agregando maíz: $maiz kg");
  }

  
}
