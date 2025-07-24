import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';
import 'package:tortillapp/widgets/widgets.dart';

class AddSobrantesScreen extends StatefulWidget {
  final MostradorModel mostrador;

  const AddSobrantesScreen({Key? key, required this.mostrador})
      : super(key: key);

  @override
  _AddSobrantesScreenState createState() => _AddSobrantesScreenState();
}

class _AddSobrantesScreenState extends State<AddSobrantesScreen> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  final TextEditingController _kgTortillaController = TextEditingController();
  final List<String> sugerencias = ["2kg", "3kg", "5kg", "8kg", "10kg"];
  List<Map<String, dynamic>> _sobrantes = [];
  Future<void> _guardarSobrantes() async {
    // Validar si el campo de texto está vacío
    String texto = _kgTortillaController.text.trim();
    // Reemplazar coma por punto
    texto = texto.replaceAll(',', '.');

    if (_kgTortillaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa la cantidad de tortillas')),
      );
      return;
    }

    // Intentamos convertir el texto a doble y verificamos
    final sobrantes = double.tryParse(texto);
    if (sobrantes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El valor ingresado no es válido')),
      );
      return;
    }

    // Intentamos guardar y mostramos el resultado
    bool response = await widget.mostrador.addSobrantes(sobrantes);
     CargarSobrantes();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response
            ? '¡Sobrante de ${_kgTortillaController.text} registrado correctamente!'
            : 'Ocurrió un error al guardar'),
        backgroundColor: response ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
    //limpiar el campo de texto
    _kgTortillaController.clear();
  }

  @override
  void dispose() {
    _kgTortillaController.dispose();
    super.dispose();
    _sobrantes.clear(); // Limpiar la lista de sobrantes al salir
  }

  @override
  void initState() {
    super.initState();
    CargarSobrantes();
  }

 void CargarSobrantes() async {
  try {
    final sobrantesObtenidos = await widget.mostrador.getSobrantesHoy();
    if (mounted) {
      setState(() {
        _sobrantes = sobrantesObtenidos
            .map((sobrante) => {
                  'id': sobrante['id'],
                  'cantidad': sobrante['cantidad'],
                })
            .toList();
      });
    }
  } catch (e) {
    print("Error al cargar sobrantes: $e");
  }
}


  void _eliminarSobrante(int id) async {
  try {
    final response = await widget.mostrador.eliminarSobrante(id);

    if (response) {
      // Eliminar de la lista local
      setState(() {
        _sobrantes.removeWhere((item) => item['id'] == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sobrante eliminado correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el sobrante')),
      );
    }
  } catch (e) {
    print("Error al eliminar el sobrante: $e");
  }
}

void _confirmarEliminacionSobrante(int id) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: '¿Eliminar sobrante?',
    text: 'Esta acción no se puede deshacer.',
    confirmBtnText: 'Eliminar',
    cancelBtnText: 'Cancelar',
    confirmBtnColor: Colors.red,
    onConfirmBtnTap: () async {
      Navigator.of(context).pop(); // Cierra el diálogo antes de eliminar
      _eliminarSobrante(id);
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final anchoContenedor = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Sobrantes',
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: colores.colorPrincipal),
        ),
      ),
      body: Center(
        child: Container(
          width: anchoContenedor,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customWidgets.Subtittle(
                  text: "Cantidad de kilogramos:",
                  color: colores.colorPrincipal),
              const SizedBox(height: 40),
              customWidgets.TextfieldNumber(
                controller: _kgTortillaController,
                label: "Kilos de tortilla",
                hasIcon: true,
                icon: Icons.circle,
              ),
              const SizedBox(height: 20),
              // Sección de sugerencias con scroll horizontal
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
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        onPressed: () {
                          _kgTortillaController.text =
                              valor.replaceAll('kg', '');
                        },
                        child: Text(valor,
                            style: const TextStyle(color: Colors.black)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              // Botón final alineado en la parte inferior
               CustomWidgets().ButtonPrimary(
                text: 'Registrar Sobrante',
                icon: Icon(Icons.inventory),
                onPressed: () {
  if (_kgTortillaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ingresa la cantidad de tortillas')),
    );
    return;
  }

 final inputCantidad = double.tryParse(_kgTortillaController.text.trim()) ?? 0;

final sobranteExistente = _sobrantes.firstWhere(
  (d) => (d['cantidad'] as num).toDouble() != null,
  orElse: () => {},
);



  if (sobranteExistente.isNotEmpty) {
    // Si ya existe, mostrar confirmación
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Sobreescribir Sobrante',
      text:
          'El sobrante ya existe.\n¿Deseas sobrescribir esta cantidad?',
      confirmBtnText: 'Sí',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Cerrar alerta
        _guardarSobrantes(); // Guardar los nuevos kilos
      },
    );
  } else {
    // Si no existe, agregar directamente
   _guardarSobrantes();
  }
},

              ),
              const SizedBox(height: 25),
              SizedBox(height: 30),
              Text(
                'Sobrante del día:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colores.colorPrincipal,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _sobrantes.length,
                  itemBuilder: (context, index) {
                    final item = _sobrantes[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading:
                            Icon(Icons.eco, color: colores.colorPrincipal),
                        title: Text("Sobrante del día"),
                        subtitle: Text(
                            'Kilos sobrantes: ${item['cantidad']} kg'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Acción al presionar eliminar
                          _confirmarEliminacionSobrante(item['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
