import 'package:flutter/material.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:tortillapp/config/paletteColor.dart';

class Add_maiz_screen extends StatefulWidget {
  final MolinoModel molino;

  Add_maiz_screen({required this.molino});

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

  void _guardarMaiz() async {
    if (_kgMaizController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresa la cantidad de maíz'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    double kg = double.parse(_kgMaizController.text);
    bool success = await widget.molino.addMaiz(kg);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Maíz agregado correctamente!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error al guardar'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Cocer maíz',
          style: TextStyle(
            color: colores.colorPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colores.colorPrincipal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customWidgets.Subtittle(
                text: 'Por favor registra los kilogramos de maíz',
                color: colores.colorPrincipal,
              ),
              const SizedBox(height: 30),

              customWidgets.TextfieldNumber(
                controller: _kgMaizController,
                label: "Kilos de maíz",
                hasIcon: true,
                icon: Icons.grain,
              ),

              const SizedBox(height: 20),

              // Botones sugerencia
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: sugerencias.map((valor) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                        child: Text(
                          valor,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 30),

              // Botón principal
              customWidgets.ButtonPrimary(
                text: 'Guardar',
                onPressed: _guardarMaiz,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
