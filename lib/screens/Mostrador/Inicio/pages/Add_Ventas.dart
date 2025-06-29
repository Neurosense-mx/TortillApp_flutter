import 'package:flutter/material.dart';
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

  Unidad _unidad = Unidad.kg;
  @override
  void initState() {
    super.initState();
    fetchProductosSucursal();
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
      int index = carrito.indexWhere((item) => item['producto'] == 'Tortillas');
      
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
          'unidad': _unidad == Unidad.kg ? 'kg' : 'pesos',
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
    cantidadTexto = '${item['cantidad'].toStringAsFixed(2)} ${item['unidad']}';
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
            if (_cantidadController.text.isEmpty) {
              String unidadTexto =
                  _unidad == Unidad.kg ? "kilogramos" : "pesos";
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ingresa la cantidad de $unidadTexto'),
                ),
              );
            } else {
              double total =
                  carrito.fold(0, (suma, item) => suma + item['precio']);
              mostrarModalTipoCompra(context, total);
            }
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
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // Quitar márgenes para que quepa todo ancho
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 24),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customWidgets.opcionRadio(
                            valor: 'Efectivo',
                            texto: 'Efectivo',
                            grupoValor: tipoSeleccionado,
                            onChanged: (value) =>
                                setState(() => tipoSeleccionado = value))
                      ],
                    ),
                    SizedBox(width: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customWidgets.opcionRadio(
                            valor: 'Fiado',
                            texto: 'Fiado',
                            grupoValor: tipoSeleccionado,
                            onChanged: (value) =>
                                setState(() => tipoSeleccionado = value))
                      ],
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar", style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Aquí puedes guardar la venta con el tipo seleccionado
                    print("Compra guardada como: $tipoSeleccionado");
                  },
                  child: Text("Aceptar", style: TextStyle(color: Colors.green)),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void mostrarModalProductos() {
    String? productoSeleccionado;
    TextEditingController cantidadController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Selecciona el artículo:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),

              // Dropdown de productos
              DropdownButtonFormField<String>(
                value: productoSeleccionado,
                items: productos.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['nombre'],
                    child: Text('${item['nombre']} \$${item['precio']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  productoSeleccionado = value;
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Cantidad",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              SizedBox(height: 8),

              // Campo de cantidad
              TextField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(border: OutlineInputBorder()),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Botones Cancelar y Aceptar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                        Text("Cancelar", style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (productoSeleccionado != null &&
                          cantidadController.text.isNotEmpty) {
                        final producto = productos.firstWhere(
                          (e) => e['nombre'] == productoSeleccionado,
                        );
                        int cantidadNueva = int.parse(cantidadController.text);
                        double precioUnitario =
                            double.parse(producto['precio']);

                        setState(() {
                          // Buscar si el producto ya existe en el carrito
                          int indexExistente = carrito.indexWhere(
                            (item) => item['producto'] == productoSeleccionado,
                          );

                          if (indexExistente != -1) {
                            // Ya existe, actualizamos cantidad y precio
                            carrito[indexExistente]['cantidad'] +=
                                cantidadNueva;
                            carrito[indexExistente]['precio'] +=
                                precioUnitario * cantidadNueva;
                          } else {
                            // No existe, lo agregamos
                            carrito.add({
                              'producto': productoSeleccionado!,
                              'cantidad': cantidadNueva,
                              'precio': precioUnitario * cantidadNueva,
                              'unidad': 'unidad',
                            });
                          }
                        });

                        Navigator.pop(context);
                      }
                    },
                    child:
                        Text("Aceptar", style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
