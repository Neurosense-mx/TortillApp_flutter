import 'package:flutter/material.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:tortillapp/config/paletteColor.dart';

class Add_maiz_screen extends StatefulWidget {
   final MolinoModel molino; // Parámetro requerido

  Add_maiz_screen({required this.molino}); // Constructor
  @override
  _Add_maiz_screenState createState() => _Add_maiz_screenState();
}

class _Add_maiz_screenState extends State<Add_maiz_screen> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  final TextEditingController _kgMaizController = TextEditingController();
  final List<String> sugerencias = ["1kg", "5kg", "10kg", "15kg", "20kg"];

  @override
  void dispose() {
    _kgMaizController.dispose();
    super.dispose();
  }
  
  // guardar los kilos de maíz
  void _guardarMaiz() {
    if (_kgMaizController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingresa la cantidad de maíz')),
      );
    } else {
      widget.molino.addMaiz(double.parse(_kgMaizController.text));
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cocer maíz',
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
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              customWidgets.Subtittle(
                text: 'Por favor registra los kilogramos de maíz',
                color: colores.colorPrincipal,
              ),
              SizedBox(height: 40),
              customWidgets.TextfieldNumber(
                controller: _kgMaizController,
                label: "Kilos de maíz",
                hasIcon: true,
                icon: Icons.grain,
              ),
              SizedBox(height: 20),

              // Lista optimizada con 5 botones
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
            _kgMaizController.text = valor.replaceAll('kg', '');
          },
          child: Text(valor, style: TextStyle(color: Colors.black)),
        ),
      );
    }).toList(),
  ),
),

              SizedBox(height: 20),

              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomWidgets().ButtonPrimary(
                    text: 'Guardar',
                    onPressed: () {
                      if (_kgMaizController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ingresa la cantidad de maíz')),
                        );
                      }
                      else {
                        _guardarMaiz();
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
