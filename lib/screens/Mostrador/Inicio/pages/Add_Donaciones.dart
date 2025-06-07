import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';
import 'package:tortillapp/widgets/widgets.dart';

class AddDonacionesScreen extends StatefulWidget {
  final MostradorModel mostrador;
  const AddDonacionesScreen({Key? key, required this.mostrador}) : super(key: key);

  @override
  _AddDonacionesScreenState createState() => _AddDonacionesScreenState();
}

class _AddDonacionesScreenState extends State<AddDonacionesScreen> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  bool esEmpleado = true;
  final TextEditingController _otroNombreController = TextEditingController();
  final TextEditingController _kgTortillaController = TextEditingController();

  int? _empleadoSeleccionado;
  List<Map<String, dynamic>> _empleados = [];
  final List<String> sugerencias = ["1kg", "1.5kg", "2kg", "3kg"];

  @override
  void initState() {
    super.initState();
    _obtenerEmpleados();
  }

  @override
  void dispose() {
    _kgTortillaController.dispose();
    _otroNombreController.dispose();
    super.dispose();
  }

  Future<void> _obtenerEmpleados() async {
    final empleadosObtenidos = await widget.mostrador.getEmpleados();
    if (mounted) {
      _empleados = empleadosObtenidos
          .asMap()
          .entries
          .map((entry) => {'id': entry.key, 'nombre': entry.value})
          .toList();
      setState(() {});
    }
  }

  Future<void> _guardarDonacion() async {
    String texto = _kgTortillaController.text.trim();
    // Reemplazar coma por punto
    texto = texto.replaceAll(',', '.');
    double? kilos = double.tryParse(texto);
    if (kilos == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una cantidad válida')),
      );
      return;
    }
    if (kilos <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad debe ser mayor a 0')),
      );
      return;
    }

    if (esEmpleado && _empleadoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un empleado')),
      );
      return;
    }

    if (!esEmpleado && _otroNombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el nombre de la persona')),
      );
      return;
    }

    final nombre = esEmpleado
        ? _empleados.firstWhere((r) => r['id'] == _empleadoSeleccionado)['nombre']
        : _otroNombreController.text;

    bool response = await widget.mostrador.addDonaciones(kilos, nombre);

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response ? '¡Donación agregada correctamente!' : 'Ocurrió un error al guardar',
        ),
        backgroundColor: response ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );

    setState(() {
      _kgTortillaController.clear();
      _otroNombreController.clear();
      esEmpleado = true;
      _empleadoSeleccionado = null;
    });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la donación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Donaciones',
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
          icon: const Icon(Icons.arrow_back),
          color: colores.colorPrincipal,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    customWidgets.Subtittle(
                      text: "Cantidad de kilogramos:",
                      color: colores.colorPrincipal,
                    ),
                    const SizedBox(height: 20),
                    customWidgets.TextfieldNumber(
                      controller: _kgTortillaController,
                      label: "Kilos de tortilla",
                      hasIcon: true,
                      icon: Icons.circle,
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sugerencias.map((valor) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colores.colorFondo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              onPressed: () {
                                _kgTortillaController.text = valor.replaceAll('kg', '');
                              },
                              child: Text(valor, style: const TextStyle(color: Colors.black)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tipo de persona a donar:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: colores.colorPrincipal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ToggleButtons(
                      isSelected: [esEmpleado, !esEmpleado],
                      onPressed: (index) {
                        setState(() {
                          esEmpleado = index == 0;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      borderColor: colores.colorPrincipal,
                      selectedBorderColor: colores.colorPrincipal,
                      borderWidth: 2,
                      fillColor: colores.colorPrincipal,
                      selectedColor: Colors.white,
                      color: Colors.black,
                      constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
                      children: const [Text('Empleado'), Text('Otro')],
                    ),
                    const SizedBox(height: 20),
                    esEmpleado
                        ? DropdownButtonFormField<int>(
                            value: _empleadoSeleccionado,
                            decoration: InputDecoration(
                              labelText: 'Selecciona un empleado',
                              filled: true,
                              fillColor: colores.colorInputs,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            items: _empleados.map((item) {
                              return DropdownMenuItem<int>(
                                value: item['id'],
                                child: Text(item['nombre']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _empleadoSeleccionado = value;
                              });
                            },
                          )
                        : TextField(
                            controller: _otroNombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre de la persona',
                              filled: true,
                              fillColor: colores.colorInputs,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    customWidgets.ButtonPrimary(
                      text: 'Finalizar',
                      icon: const Icon(Icons.volunteer_activism),
                      onPressed: _guardarDonacion,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
