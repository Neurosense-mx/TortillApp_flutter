import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/widgets/widgets.dart';

class AddSobrantesScreen extends StatefulWidget {
  @override
  _AddSobrantesScreenState createState() => _AddSobrantesScreenState();
}

class _AddSobrantesScreenState extends State<AddSobrantesScreen> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  final TextEditingController _kgTortillaController = TextEditingController();
  final List<String> sugerencias = ["2kg", "3kg", "5kg", "8kg", "10kg"];

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: colores.colorPrincipal,
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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomWidgets().ButtonPrimary(
                    text: 'Finalizar',
                    icon: Icon(Icons.trending_down),
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
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
