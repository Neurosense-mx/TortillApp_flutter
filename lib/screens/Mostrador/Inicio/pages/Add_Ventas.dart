import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';
import 'package:tortillapp/widgets/widgets.dart';

class AddVentasScreen extends StatefulWidget {
  MostradorModel mostrador;
  AddVentasScreen({Key? key, required this.mostrador}) : super(key: key);
  @override
  _AddVentasScreenState createState() => _AddVentasScreenState();
}

enum Unidad { kg, pesos }

class _AddVentasScreenState extends State<AddVentasScreen> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();
  //obtener el precio publico y precio tienda de las tortillas y la lista de productos

  final TextEditingController _cantidadController = TextEditingController();
  final List<String> sugerencias = ["1kg", "5kg", "10kg", "15kg", "20kg"];
  late double precioPublico;
  List<Map<String, dynamic>> carrito = [];

  List<Map<String, dynamic>> productos = [];
  Map<String, double> ubicacion = {};
  int tipo = 1; // 1 para efectivo, 2 para fiado
  Map<String, double>? _ubicacionCache; // Variable para cachear la ubicación
  bool _cargandoUbicacion = false; // Para mostrar estado de carga

  Unidad _unidad = Unidad.kg;
  @override
  void initState() {
    super.initState();
    fetchProductosSucursal();
    _obtenerUbicacionInicial();
    // obtenerUbicacion();
  }

  Future<void> fetchProductosSucursal() async {
    try {
      final Map<String, dynamic> nuevosDatos =
          await widget.mostrador.getProductosSucursal();

      setState(() {
        productos =
            List<Map<String, dynamic>>.from(nuevosDatos['productos'] ?? []);
        precioPublico = nuevosDatos['precio_publico'] ?? 0.0;
        print("Precio Publico: $precioPublico");
      });

      print("Productos cargados: $productos");
    } catch (e) {
      print("Error al cargar productos: $e");
    }
  }

  void _agregarTortillasAlCarrito() {
    if (_cantidadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresa una cantidad válida'),
        ),
      );
      return;
    }

    try {
      double cantidad = double.parse(_cantidadController.text);
      double precio;

      if (_unidad == Unidad.kg) {
        // Calcular precio basado en kilos
        precio = cantidad * precioPublico;
      } else {
        // El usuario ingresó pesos, la cantidad es el precio
        precio = cantidad;
        // Convertir a kilos para mostrar en el carrito
        cantidad = cantidad / precioPublico;
      }

      setState(() {
        // Buscar si ya hay tortillas en el carrito
        int index =
            carrito.indexWhere((item) => item['producto'] == 'Tortillas');

        if (index != -1) {
          // Si ya existe, actualizar cantidad y precio
          carrito[index]['cantidad'] += cantidad;
          carrito[index]['precio'] += precio;
        } else {
          // Si no existe, agregar nuevo item
          carrito.add({
            'producto': 'Tortillas',
            'cantidad': cantidad,
            'precio': precio,
            'unidad': _unidad == Unidad.kg ? 'kg' : 'kg',
            'tipo': 1,
          });
        }
      });

      // Limpiar el campo después de agregar
      _cantidadController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresa una cantidad válida'),
        ),
      );
    }
  }

// Método para obtener ubicación al iniciar
  Future<void> _obtenerUbicacionInicial() async {
    if (_ubicacionCache != null) return; // Si ya tenemos ubicación, no hacer nada
    
    setState(() => _cargandoUbicacion = true);
    
    try {
      final ubicacion = await obtenerUbicacion();
      if (ubicacion != null) {
        _ubicacionCache = ubicacion; // Cachear la ubicación
      }
    } catch (e) {
      print('Error al obtener ubicación inicial: $e');
    } finally {
      if (mounted) {
        setState(() => _cargandoUbicacion = false);
      }
    }
  }

  // Método optimizado para obtener ubicación
  Future<Map<String, double>?> obtenerUbicacion() async {
    // Si ya tenemos ubicación cacheada, devolverla
    if (_ubicacionCache != null) return _ubicacionCache;
    
    // Verificar si tenemos permisos
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Mostrar mensaje para activar GPS
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Active el GPS para continuar')),
        );
      }
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Permisos de ubicación denegados')),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permisos de ubicación permanentemente denegados')),
        );
      }
      return null;
    }

    try {
      // Obtener ubicación con timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).timeout(Duration(seconds: 10)); // Timeout de 10 segundos

      final ubicacion = {
        'latitud': position.latitude,
        'longitud': position.longitude,
      };
      
      _ubicacionCache = ubicacion; // Cachear la ubicación obtenida
      return ubicacion;
    } catch (e) {
      print('Error al obtener ubicación: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener ubicación')),
        );
      }
      return null;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose}
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Venta',
          style: TextStyle(
            color: colores.colorPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colores.colorFondo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: colores.colorPrincipal,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Tortillas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 40),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio<Unidad>(
                          value: Unidad.kg,
                          groupValue: _unidad,
                          onChanged: (Unidad? value) {
                            setState(() {
                              _unidad = value!;
                            });
                          },
                        ),
                        Text("KG"),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Radio<Unidad>(
                          value: Unidad.pesos,
                          groupValue: _unidad,
                          onChanged: (Unidad? value) {
                            setState(() {
                              _unidad = value!;
                            });
                          },
                        ),
                        Text("Pesos"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: customWidgets.TextfieldNumber(
                    controller: _cantidadController,
                    label: _unidad == Unidad.kg
                        ? "Cantidad (kg)"
                        : "Cantidad (\$)",
                    hasIcon: true,
                    icon:
                        _unidad == Unidad.kg ? Icons.scale : Icons.attach_money,
                  ),
                ),
                SizedBox(width: 8), // Espaciado entre el campo y el botón
                ElevatedButton(
                  onPressed: _agregarTortillasAlCarrito,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sugerencias.map((valor) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colores.colorFondo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      onPressed: () {
                        _cantidadController.text = valor.replaceAll('kg', '');
                        _agregarTortillasAlCarrito(); // Agregar directamente al carrito
                      },
                      child: Text(valor, style: TextStyle(color: Colors.black)),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Botón Productos
            ElevatedButton.icon(
              // Acción al seleccionar productos
              onPressed: mostrarModalProductos,
              icon: Icon(Icons.shopping_bag_outlined),
              label: Text("Productos"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 10),

            Text("Carrito de compras (${carrito.length})",
                style: TextStyle(
                    color: Colors.grey[800], fontWeight: FontWeight.bold)),

            SizedBox(height: 8),
            // Lista de productos
            ...carrito.map((item) {
              String cantidadTexto;
              if (item['producto'] == 'Tortillas') {
                cantidadTexto =
                    '${item['cantidad'].toStringAsFixed(2)} ${item['unidad']}';
              } else {
                cantidadTexto = '${item['cantidad']} ${item['unidad']}';
              }

              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$cantidadTexto de ${item['producto']} \$${item['precio'].toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          carrito.remove(item);
                        });
                      },
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 50)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: customWidgets.ButtonPrimary(
          text: 'Finalizar',
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            //if el carrito esta vacio mostrar un mensaje de error
            if (carrito.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('El carrito está vacío'),
                ),
              );
              return;
            }
            double total =
                carrito.fold(0, (suma, item) => suma + item['precio']);
            mostrarModalTipoCompra(context, total);
            
          },
        ),
      ),
    );
  }

void mostrarModalTipoCompra(BuildContext context, double total) {
  String tipoSeleccionado = 'Efectivo';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Selecciona el tipo de compra",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.money, color: Colors.green),
                        title: Text("Efectivo"),
                        trailing: Radio<String>(
                          value: 'Efectivo',
                          groupValue: tipoSeleccionado,
                          onChanged: (value) =>
                              setState(() => tipoSeleccionado = value!),
                        ),
                        onTap: () => setState(() => tipoSeleccionado = 'Efectivo'),
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt_long, color: Colors.orange),
                        title: Text("Fiado"),
                        trailing: Radio<String>(
                          value: 'Fiado',
                          groupValue: tipoSeleccionado,
                          onChanged: (value) =>
                              setState(() => tipoSeleccionado = value!),
                        ),
                        onTap: () => setState(() => tipoSeleccionado = 'Fiado'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "Total: \$${total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.cancel, color: Colors.red),
                        label: Text("Cancelar", style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);

                          if (tipoSeleccionado == 'Fiado') {
                            tipo = 2;
                          } else {
                            tipo = 1;
                          }

                          Map<String, double>? ubicacion = _ubicacionCache;

                          if (ubicacion == null) {
                            setState(() => _cargandoUbicacion = true);
                            ubicacion = await obtenerUbicacion();
                            setState(() => _cargandoUbicacion = false);
                          }

                          if (ubicacion == null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Ubicación no disponible")),
                              );
                            }
                            return;
                          }

                          await registrarVenta(ubicacion);
                        },
                        icon: Icon(Icons.check_circle),
                        label: Text("Aceptar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

Future<void> registrarVenta(Map<String, double> ubicacion) async {
  final bool isCompleted = await widget.mostrador.registrarVenta(carrito, tipo, ubicacion: ubicacion);
    
  if (mounted) {
    if (isCompleted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Venta registrada correctamente',
        title: '¡Éxito!',
        confirmBtnText: 'Aceptar',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context); // Regresa a la pantalla anterior
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error al registrar la venta',
        title: '¡Error!',
        confirmBtnText: 'Aceptar',
      );
    }
  }
}

void mostrarModalProductos() {
  String? productoSeleccionado;
  TextEditingController cantidadController = TextEditingController(text: '1');

  QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: false, // Evita cerrar al tocar fuera
    confirmBtnText: 'Aceptar',
    cancelBtnText: 'Cancelar',
    showCancelBtn: true,
    onCancelBtnTap: () {
      Navigator.pop(context);
    },
    onConfirmBtnTap: () {
      if (productoSeleccionado != null &&
          cantidadController.text.isNotEmpty) {
        final producto = productos.firstWhere(
          (e) => e['nombre'] == productoSeleccionado,
        );
        int cantidadNueva = int.parse(cantidadController.text);
        double precioUnitario = double.parse(producto['precio']);

        setState(() {
          int indexExistente = carrito.indexWhere(
            (item) => item['producto'] == productoSeleccionado,
          );

          if (indexExistente != -1) {
            carrito[indexExistente]['cantidad'] += cantidadNueva;
            carrito[indexExistente]['precio'] += precioUnitario * cantidadNueva;
          } else {
            carrito.add({
              'id_producto': producto['id'],
              'producto': productoSeleccionado!,
              'cantidad': cantidadNueva,
              'precio': precioUnitario * cantidadNueva,
              'unidad': 'unidad',
              'tipo': 2,
            });
          }
        });

        Navigator.pop(context);
      }
    },
    widget: StatefulBuilder(
      builder: (context, setStateDialog) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selecciona el artículo:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: productoSeleccionado,
              isExpanded: true,
              hint: Text("Selecciona un producto"),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              items: productos.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['nombre'],
                  child: Text('${item['nombre']} - \$${item['precio']}'),
                );
              }).toList(),
              onChanged: (value) {
                setStateDialog(() {
                  productoSeleccionado = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text("Cantidad:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ingresa la cantidad",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
          ],
        );
      },
    ),
  );
}

}
