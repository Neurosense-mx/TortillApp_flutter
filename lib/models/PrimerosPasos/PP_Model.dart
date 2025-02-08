import 'dart:convert';

import 'package:tortillapp/config/backend.dart';
import 'package:http/http.dart' as http;

class PP_Model {
  String nombre = ""; // Nombre del administrador
  String nombreNegocio = ""; // Nombre del negocio
  String nombreDominio = ""; // Nombre del dominio
  String nombreSucursal = ""; // Nombre de la sucursal
  double latitud = 0.0; // Latitud del negocio
  double longitud = 0.0; // Longitud del negocio
  double precio_publico = 0.0; // Precio al público
  double precio_tienda = 0.0; // Precio en la tienda
  List<Map<String, dynamic>> productos = []; // Lista de productos
  List<Map<String, dynamic>> gastos = []; // Lista de productos
  //lista de empleados
  List<Map<String, dynamic>> empleados = [];

  List<Map<String, dynamic>> PP_MODEL_JSON = [];

  // Set para nombre
  void setNombre(String nombre) {
    this.nombre = nombre;
  }

  // Set para nombreNegocio
  void setNombreNegocio(String nombreNegocio) {
    this.nombreNegocio = nombreNegocio;
    //seteaar el nombre del dominio es el del negocio todo junto en minusculas
    nombreDominio = nombreNegocio.toLowerCase().replaceAll(" ", "");
  }

  // Set para nombreSucursal
  void setNombreSucursal(String nombreSucursal) {
    this.nombreSucursal = nombreSucursal;
  }

  // Set para latitud
  void setLatitud(double latitud) {
    this.latitud = latitud;
  }

  // Set para longitud
  void setLongitud(double longitud) {
    this.longitud = longitud;
  }

  // Set para precio_publico
  void setPrecioPublico(double precio_publico) {
    this.precio_publico = precio_publico;
  }

  // Set para precio_tienda
  void setPrecioTienda(double precio_tienda) {
    this.precio_tienda = precio_tienda;
  }

  // Método para agregar un producto a la lista
  void agregarProducto(Map<String, dynamic> producto) {
    productos.add(producto);
  }

  // Método para establecer la lista completa de productos
  void setProductos(List<Map<String, dynamic>> productos) {
    this.productos = productos;
  }
  // Método para agregar un gasto a la lista
  void agregarGasto(Map<String, dynamic> gasto) {
    gastos.add(gasto);
  }
  // Método para establecer la lista completa de gastos
  void setGastos(List<Map<String, dynamic>> gastos) {
    this.gastos = gastos;
  }
  // Método para agregar un empleado a la lista
  void agregarEmpleado(Map<String, dynamic> empleado) {
    empleados.add(empleado);
  }
  // Método para establecer la lista completa de empleados
  void setEmpleados(List<Map<String, dynamic>> empleados) {
    this.empleados = empleados;
  }


  //gets para el dominio
  String getDominio() {
    return nombreDominio;
  }

  void  build_json(){
    PP_MODEL_JSON = [
      {
        "nombre": nombre,
        "nombreNegocio": nombreNegocio,
        "nombreDominio": nombreDominio,
        "nombreSucursal": nombreSucursal,
        "latitud": latitud,
        "longitud": longitud,
        "precio_publico": precio_publico,
        "precio_tienda": precio_tienda,
        "productos": productos,
        "gastos": gastos,
        "empleados": empleados
      }
    ];
    print("Se construyó el JSON");
    print(PP_MODEL_JSON);
  }

  //Enviar json al server
  Future<Map<String, dynamic>> enviarData() async {
    final url = Uri.parse(ApiConfig.backendUrl + '/admin/firststeps');
    try {
      // Realizamos la solicitud HTTP POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},   
        body: json.encode(PP_MODEL_JSON)  
      );

      if (response.statusCode == 200) {
       
        print("Respone: ${response.body}");
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


}