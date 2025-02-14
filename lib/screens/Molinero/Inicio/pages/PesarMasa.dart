import 'package:flutter/material.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:tortillapp/config/paletteColor.dart';

class Pesar_masa extends StatefulWidget {
  @override
  _Pesar_masaState createState() => _Pesar_masaState();
}

class _Pesar_masaState extends State<Pesar_masa> {

  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  // Controlador para el campo de texto
  final TextEditingController _kgMasa = TextEditingController();

  // Lista de valores sugeridos
  final List<Map<String, dynamic>> maiz_registrado = [
    {
      "id": 1,
      "fecha": "2021-10-01 16:00:00",
      "kg": "10",
    },
    {
      "id": 2,  // El "id" debe ser único para cada registro
      "fecha": "2021-10-01 16:00:00",
      "kg": "14",
    }
  ];

  int? _selectedMaizId; // Variable para almacenar el valor seleccionado
  String? _selectedKg; // Variable para almacenar el kg del maíz seleccionado

  @override
  void initState() {
    super.initState();
   //obtener del modelo el maiz registrado de ayer
  }
  @override
  void dispose() {
    _kgMasa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesar Masa', 
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
          icon: Icon(Icons.arrow_back, color: colores.colorPrincipal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho de pantalla
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), 
              customWidgets.Subtittle(
                text: 'Por favor registra el peso de la masa (kg)', 
                color: colores.colorPrincipal,
              ),
              
              SizedBox(height: 40), 
              // TextField para ingresar los kg de maíz
              customWidgets.TextfieldNumber(
                controller: _kgMasa,
                label: "Peso",
                hasIcon: true,
                icon: Icons.scale,
              ),


              SizedBox(height: 40),
              // Dropdown para seleccionar maíz
              customWidgets.DropdownPrimary(
                value: _selectedMaizId ?? maiz_registrado[0]['id'], // Usar el primer valor si no se ha seleccionado ninguno
                items: maiz_registrado.map((maiz) {
                  return DropdownMenuItem<int>(
                    value: maiz['id'],
                    child: Text('${maiz['fecha']} ${maiz['kg']} kg'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedMaizId = newValue; // Actualizar el estado con el nuevo valor
                    // Actualizar el kg seleccionado
                    _selectedKg = maiz_registrado.firstWhere((maiz) => maiz['id'] == newValue)['kg'];
                  });
                },
                label: 'Selecciona Maíz',
                hasIcon: true,
                icon: Icons.event_note,
              ),

              SizedBox(height: 20),

              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomWidgets().ButtonPrimary(
                    text: 'Guardar',
                    onPressed: () {
                      if (_kgMasa.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ingresa la cantidad de maíz')),
                        );
                      } else {
                        // Lógica para guardar los datos
                        print('ID Maíz seleccionado: $_selectedMaizId');
                       
                        print('KG ingresado: ${_kgMasa.text}');
                        Navigator.pop(context);
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
