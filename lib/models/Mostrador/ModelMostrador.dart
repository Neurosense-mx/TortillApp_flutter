import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tortillapp/config/backend.dart';
import 'package:tortillapp/utils/Data_sesion.dart';

class MostradorModel {
  late int id_account; // id de la cuenta
  late int id_sucursal; // id de la sucursal
  late int id_negocio; // id del negocio
  late int id_admin; // id del administrador
  late String token; // id del molino
  late String email; // email del molino
  late String nombre; // nombre del molino
  late double PrecioPublico = 0.0; // precio publico de las tortillas
  late double PrecioCliente = 0.0; // precio de mayoreo de las tortillas

  late List<Map<String, dynamic>> _productos = [];

  late List<Map<String, dynamic>> _designaciones = [];

  MostradorModel(this.id_account, this.id_sucursal, this.id_negocio,
      this.id_admin, this.token, this.email, this.nombre) {
    //_fetchData(id_account); // Llamamos al método para obtener los datos al instanciar el modelo
    print("Modelo de molino creado");
  }
  // Método para obtener los datos(id sucursal, id negocio) de la cuenta

  //------------------------- Acciones de mostrador -------------------------

  // Obtener designaciones diarias de los repartidores
  Future<List<Map<String, dynamic>>> getDesignaciones() async {
    final url = Uri.parse(
      '${ApiConfig.backendUrl}/mostrador/designaciones/hoy/$id_sucursal',
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> designacionesJson = json.decode(response.body);
      _designaciones = designacionesJson.cast<Map<String, dynamic>>();
      print("Designaciones obtenidas: $_designaciones");

      return _designaciones; // ← Este return es obligatorio
    } else {
      print("Error al obtener designaciones: ${response.body}");
      throw Exception('Error al obtener designaciones');
    }
  }

//get para devolver las designaciones
  List<Map<String, dynamic>> get designaciones {
    return _designaciones;
  }

// Método para eliminar una designación de un repartidor
  Future<bool> eliminarDesignacion(int idDesignacion) async {
    final url = Uri.parse(
        '${ApiConfig.backendUrl}/mostrador/designar/caja/$idDesignacion');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type':
            'application/json', // Asegúrate de que el token esté definido
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Designación eliminada correctamente");
      return true;
    } else {
      print("Error al eliminar designación: ${response.body}");
      return false;
    }
  }

  // Endpoint para agregar kilos de tortillas como sobrantes del dia
  Future<bool> addSobrantes(double kgSobrantes) async {
    print("Agregando sobrantes: $kgSobrantes kg");
    final url =
        Uri.parse(ApiConfig.backendUrl + '/mostrador/tortillas/sobrantes');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'id_cuenta': id_account,
        'id_sucursal': id_sucursal,
        'cantidad_kg': kgSobrantes,
      }),
    );

    if (response.statusCode == 200) {
      print("Sobrantes agregados correctamente");
      return true;
    } else {
      print("Error al agregar sobrantes: ${response.body}");
      return false;
    }
  }

  // Endpoint para agregar donaciones de tortillas (cantidad_kg, nombre)
  Future<bool> addDonaciones(double kgDonacion, String nombre) async {
    print("Agregando donación: $kgDonacion kg de $nombre");
    final url = Uri.parse(ApiConfig.backendUrl + '/mostrador/donaciones');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'id_cuenta': id_account,
        'id_sucursal': id_sucursal,
        'cantidad_kg': kgDonacion,
        'nombre': nombre,
      }),
    );

    if (response.statusCode == 200) {
      print("Donación agregada correctamente");
      return true;
    } else {
      print("Error al agregar donación: ${response.body}");
      return false;
    }
  }

  Future<List<String>> getEmpleados() async {
    final url =
        Uri.parse('${ApiConfig.backendUrl}/mostrador/empleados/$id_sucursal');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> empleadosJson = json.decode(response.body);
      final List<String> empleados =
          empleadosJson.map((e) => e.toString()).toList();
      print("Empleados obtenidos: $empleados");
      return empleados;
    } else {
      print("Error al obtener empleados: ${response.body}");
      throw Exception('Error al obtener empleados');
    }
  }

  Future<List<Map<String, dynamic>>> getRepartidores() async {
    final url = Uri.parse(
        '${ApiConfig.backendUrl}/mostrador/obtener/repartidores/$id_sucursal');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> repartidoresJson = json.decode(response.body);
      final List<Map<String, dynamic>> repartidores =
          repartidoresJson.cast<Map<String, dynamic>>();
      print("Repartidores obtenidos: $repartidores");
      return repartidores;
    } else {
      print("Error al obtener repartidores: ${response.body}");
      throw Exception('Error al obtener repartidores');
    }
  }

//funcion parar agregar la designacion de kilos a un repartidor /mostrador/designar/caja
  Future<bool> addDesignacion(double kgTortilla, int idRepartidor) async {
    print(
        "Agregando designación: $kgTortilla kg al repartidor con ID $idRepartidor");
    final url = Uri.parse(ApiConfig.backendUrl + '/mostrador/designar/caja');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'id_cuenta': id_account,
        'id_sucursal': id_sucursal,
        'cantidad_kg': kgTortilla,
        'id_repartidor': idRepartidor,
      }),
    );

    if (response.statusCode == 200) {
      print("Designación agregada correctamente");
      return true;
    } else {
      print("Error al agregar designación: ${response.body}");
      return false;
    }
  }

  //Pbtener los productos de la sucursal, /mostrador/productos/sucursal
  Future<Map<String, dynamic>> getProductosSucursal() async {
    final url =
        Uri.parse(ApiConfig.backendUrl + '/mostrador/productos/$id_sucursal');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Obteniendo productos de la sucursal: $id_sucursal");

    if (response.statusCode == 200) {
      print("Respuesta del servidor: ${response.body}");

      // Decodificar como Map (porque el JSON es un objeto, no una lista)
      final Map<String, dynamic> data = json.decode(response.body);

      // Extraer precios
      PrecioPublico = data['precio_publico']?.toDouble() ?? 0.0;
      PrecioCliente = data['precio_cliente']?.toDouble() ?? 0.0;

      print("Precio Público: $PrecioPublico, Precio Cliente: $PrecioCliente");

      // Extraer productos (es una lista anidada)
      final List<dynamic> productosAnidados = data['productos'];
      final List<Map<String, dynamic>> productos = productosAnidados.isNotEmpty
          ? List<Map<String, dynamic>>.from(productosAnidados[0])
          : [];

      print("Productos obtenidos: $productos");

      // Regresar todo el JSON para uso general si lo necesitas
      return {
        'precio_publico': PrecioPublico,
        'precio_cliente': PrecioCliente,
        'productos': productos,
      };
    } else {
      print("Error al obtener productos: ${response.body}");
      throw Exception('Error al obtener productos');
    }
  }

  // Obtener los sobrantes del día
  Future<List<Map<String, dynamic>>> getSobrantesHoy() async {
    final url = Uri.parse(
      '${ApiConfig.backendUrl}/mostrador/tortillas/sobrantes/hoy/$id_sucursal',
    );
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> sobrantesJson = json.decode(response.body);
      final List<Map<String, dynamic>> sobrantes =
          sobrantesJson.cast<Map<String, dynamic>>();
      print("Sobrantes obtenidos: $sobrantes");
      return sobrantes;
    } else {
      print("Error al obtener sobrantes: ${response.body}");
      throw Exception('Error al obtener sobrantes');
    }
  }

  // eliminar un sobrante por su ID
  Future<bool> eliminarSobrante(int idSobrante) async {
    final url = Uri.parse(
      '${ApiConfig.backendUrl}/mostrador/tortillas/sobrantes/$idSobrante',
    );
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Sobrante eliminado correctamente");
      return true;
    } else {
      print("Error al eliminar sobrante: ${response.body}");
      return false;
    }
  }
Future<bool> registrarVenta(
  List<Map<String, dynamic>> carrito,
  int tipoPago, {
  required Map<String, double> ubicacion,
}) async {
  print("Registrando venta: $carrito");
  print("Tipo de pago: $tipoPago");

  final tortillas = carrito.where((item) => item['tipo'] == 1).toList();
  final otrosProductos = carrito.where((item) => item['tipo'] != 1).toList();

  bool ventaTortillasRegistrada = true;

  // Si hay tortillas, registrar la venta de tortillas
  if (tortillas.isNotEmpty) {
    final double tortillas_kg = tortillas.fold(
      0.0,
      (sum, item) => sum + (item['cantidad'] as double),
    );
    final double precio = tortillas.fold(
      0.0,
      (sum, item) => sum + (item['precio'] as double),
    );

    print("Total de kilos de tortillas: $tortillas_kg");
    print("Total de precio de tortillas: $precio");

    final data = {
      "id_sucursal": id_sucursal,
      "id_cuenta": id_account,
      "cantidad_kg": tortillas_kg,
      "longitud": ubicacion['longitud'] ?? 0.0,
      "latitud": ubicacion['latitud'] ?? 0.0,
      "tipo_venta": tipoPago,
      "lugar_venta": 1,
      "devoluciones_kg": 0,
    };

    print("Datos a enviar (tortillas): $data");

    final url =
        Uri.parse(ApiConfig.backendUrl + '/mostrador/ventas/tortillas');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print("Venta de tortillas registrada correctamente.");
    } else {
      print("Error al registrar venta de tortillas: ${response.body}");
      ventaTortillasRegistrada = false;
    }
  }

  // Registrar productos adicionales
  bool productosRegistradosCorrectamente = true;

  if (otrosProductos.isNotEmpty) {
    print("----- Otros productos a registrar: $otrosProductos");

    for (var producto in otrosProductos) {
      final productoData = {
        "id_sucursal": id_sucursal,
        "id_cuenta": id_account,
        "id_producto": producto['id_producto'],
        "cantidad": producto['cantidad'],
        "total_venta": producto['precio']
      };

      final productoUrl =
          Uri.parse(ApiConfig.backendUrl + '/mostrador/ventas/productos');

      final productoResponse = await http.post(
        productoUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(productoData),
      );

      if (productoResponse.statusCode == 200) {
        print("Producto ${producto['producto']} registrado correctamente.");
      } else {
        print(
            "Error al registrar producto ${producto['producto']}: ${productoResponse.body}");
        productosRegistradosCorrectamente = false;
      }
    }
  }

  return ventaTortillasRegistrada && productosRegistradosCorrectamente;
}



  //function para cerrar sesion, elimiar el token
  Future<void> logout() async {
    await DataUser().clear();
  }
}
