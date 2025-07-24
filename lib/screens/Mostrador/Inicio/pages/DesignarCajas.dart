import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';
import 'package:tortillapp/widgets/widgets.dart';

class DesignarCajas extends StatefulWidget {
  final MostradorModel mostrador;
  const DesignarCajas({Key? key, required this.mostrador}) : super(key: key);
  @override
  _DesignarCajasState createState() => _DesignarCajasState();
}

class _DesignarCajasState extends State<DesignarCajas> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  final TextEditingController _kgTortillaController = TextEditingController();
  final List<String> sugerencias = ["5kg", "10kg", "15kg", "20kg", "30kg"];
  List<Map<String, dynamic>> _repartidores = [];
  String? _nombreRepartidor;
  int? _selectedrepartidorId;

  List<Map<String, dynamic>> _designaciones = [];

  @override
  void dispose() {
    _kgTortillaController.dispose();
    super.dispose();
  }

  Future<void> obtenerRepartidores() async {
     final designadosObtenidos = await widget.mostrador.getDesignaciones(); // Cargar designaciones al iniciar
    final repartidoresObtenidos = await widget.mostrador.getRepartidores();
    print("Repartidores obtenidos: $repartidoresObtenidos");
    //imprimir el nombre de los repartidores
    if (mounted) {
      _repartidores = repartidoresObtenidos
          .map((repartidor) => {
                'id': repartidor['id'],
                'nombre': repartidor['nombre'],
              })
          .toList();
      _designaciones = designadosObtenidos.map((designacion) => {
        'id': designacion['id'],
        'repartidor': designacion['repartidor'],
        'kilosDesignados': designacion['kilosDesignados'],
      }).toList();
      // obtener del modelo las designaciones
     // _designaciones = widget.mostrador.designaciones;
      setState(() {});

//    print("Repartidores asignados: $_repartidores");
    } else {
      print("El widget no está montado, no se puede actualizar el estado.");
    }
  }

//Fucion para agrar la designacion de kilos a un repartidor
 Future<void> agregarDesignacion() async {
  String texto = _kgTortillaController.text.trim();
  texto = texto.replaceAll(',', '.');

  double? kilos = double.tryParse(texto);
  if (kilos == null || kilos <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ingresa una cantidad válida')),
    );
    return;
  }

  if (_selectedrepartidorId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selecciona un repartidor')),
    );
    return;
  }

  bool response = await widget.mostrador
      .addDesignacion(kilos, int.parse(_selectedrepartidorId.toString()));
  print("Respuesta de la designación: $response");

  if (response) {
    await obtenerRepartidores(); // 🔄 Recargar para actualizar el card

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Designación de kilos exitosa a ${_nombreRepartidor ?? ''}!',
      title: '¡Éxito!',
      confirmBtnText: 'Aceptar',
      onConfirmBtnTap: () {
        Navigator.pop(context);
      },
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ocurrió un error al guardar la designación'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  _kgTortillaController.clear();
  setState(() {
    _selectedrepartidorId = null;
  });
}

// Función para eliminar una designación
  Future<void> _eliminarDesignacion(int idDesignacion) async {
    print("Eliminando designación con ID: $idDesignacion");
    bool response = await widget.mostrador.eliminarDesignacion(idDesignacion);
    if (response) {
      await obtenerRepartidores(); // 🔄 Recargar para actualizar el card
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Designación eliminada exitosamente',
        title: '¡Éxito!',
        confirmBtnText: 'Aceptar',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error al eliminar la designación'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
  }


  //init state
  @override
  void initState() {
    super.initState();
    obtenerRepartidores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Designar Kilos',
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
          icon: Icon(Icons.arrow_back, color: colores.colorPrincipal),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              customWidgets.Subtittle(
                  text: "Cantidad de kilogramos:",
                  color: colores.colorPrincipal),
              SizedBox(height: 20),
              customWidgets.TextfieldNumber(
                  controller: _kgTortillaController,
                  label: "Kilos de tortilla",
                  hasIcon: true,
                  icon: Icons.circle),
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
                          _kgTortillaController.text =
                              valor.replaceAll('kg', '');
                        },
                        child:
                            Text(valor, style: TextStyle(color: Colors.black)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedrepartidorId,
                decoration: InputDecoration(
                  labelText: 'Selecciona un repartidor',
                  filled: true,
                  fillColor: colores.colorInputs,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: _repartidores.map((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'],
                    child: Text(item['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedrepartidorId = value;
                    _nombreRepartidor = _repartidores
                        .firstWhere((item) => item['id'] == value)['nombre'];
                  });
                },
              ),
              SizedBox(height: 20),
              CustomWidgets().ButtonPrimary(
                text: 'Designar',
                icon: Icon(Icons.inbox),
                onPressed: () {
  if (_kgTortillaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ingresa la cantidad de tortillas')),
    );
    return;
  }

  // Verificar si el repartidor ya tiene kilos asignados
  final designacionExistente = _designaciones.firstWhere(
    (d) => d['repartidor'] == _nombreRepartidor,
    orElse: () => {},
  );

  if (designacionExistente.isNotEmpty) {
    // Si ya existe, mostrar confirmación
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Reasignar Kilos',
      text:
          'El repartidor ${_nombreRepartidor ?? ''} ya tiene ${designacionExistente['kilosDesignados']} kg asignados.\n¿Deseas sobrescribir esta cantidad?',
      confirmBtnText: 'Sí',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Cerrar alerta
        agregarDesignacion(); // Reasignar
      },
    );
  } else {
    // Si no existe, agregar directamente
    agregarDesignacion();
  }
},

              ),
              SizedBox(height: 30),
              Text(
                'Designaciones del día:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colores.colorPrincipal,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _designaciones.length,
                  itemBuilder: (context, index) {
                    final item = _designaciones[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading:
                            Icon(Icons.person, color: colores.colorPrincipal),
                        title: Text(item['repartidor']),
                        subtitle: Text(
                            'Kilos designados: ${item['kilosDesignados']} kg'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Acción al presionar eliminar
                            _eliminarDesignacion(item['id']);
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
