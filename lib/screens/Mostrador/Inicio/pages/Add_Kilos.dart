import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/widgets/widgets.dart';

class AddKilosScreen extends StatefulWidget {
  @override
  _AddKilosScreenState createState() => _AddKilosScreenState();
}

class _AddKilosScreenState extends State<AddKilosScreen> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  final TextEditingController _kgTortillaController = TextEditingController();
  final List<String> sugerencias = ["5kg", "10kg", "15kg", "20kg", "30kg"];
  final List<Map<String, dynamic>> _repartidores = [
    {'id': 2, 'nombre': 'Juan', 'apellido': 'Martinez'},
    {'id': 3, 'nombre': 'Manuel', 'apellido': 'Martinez'}
  ];

  @override
  void dispose() {
    _kgTortillaController.dispose();
    super.dispose();
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
              SizedBox(height: 40),
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
                decoration: InputDecoration(
                  labelText: 'Selecciona un repartidor',
                  labelStyle: TextStyle(color: colores.colorNegro),
                  filled: true,
                  fillColor: colores.colorInputs,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: colores.colorContornoBlanco, width: 0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: colores.colorPrincipal, width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                ),
                items: _repartidores.map((repartidor) {
                  return DropdownMenuItem<int>(
                    value: repartidor['id'],
                    child: Text(
                      repartidor['nombre'],
                      style: TextStyle(
                        color: colores.colorNegro,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    // _selectedrepartidorId = value;
                  });
                },
                dropdownColor: colores.colorInputs,
                icon:
                    Icon(Icons.arrow_drop_down, color: colores.colorPrincipal),
                style: TextStyle(
                  color: colores.colorNegro,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomWidgets().ButtonPrimary(
                    text: 'Finalizar',
                    icon: Icon(Icons.inbox),
                    onPressed: () {
                      if (_kgTortillaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Ingresa la cantidad de tortillas')),
                        );
                      } else {
                        // Guardar
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
