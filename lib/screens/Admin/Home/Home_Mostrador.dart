import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Mostrador extends StatefulWidget {
  @override
  _Home_MostradorState createState() => _Home_MostradorState();
}

class _Home_MostradorState extends State<Home_Mostrador> {
  final PaletaDeColores colores = PaletaDeColores();
  String nombre = "";

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? "Usuario";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context)
              .size
              .height, // Usa toda la altura de la pantalla
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              // Título alineado arriba con margen
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10), // Espacio superior
                child: CustomWidgets().Tittle_28(
                  text: 'Hola, $nombre',
                  color: colores.colorPrincipal,
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.centerLeft,
                child: CustomWidgets().Subtittle(
                    text: "Puesto actual", color: colores.colorPrincipal),
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: CustomWidgets().Puesto(
                  text: "Mostrador",
                  color: colores.colorInputs,
                  icon: 'lib/assets/home_mostrador/molino_.svg',
                ),
              ),

              Spacer(), // Empuja los botones al centro verticalmente
              Container(
                alignment: Alignment.centerLeft,
                child: CustomWidgets()
                    .Subtittle(text: "Acciones", color: colores.colorPrincipal),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidgets().ButtonMenu(
                    text: "Ventas",
                    color: colores.colorButtonBlue,
                    icon: 'lib/assets/home_mostrador/ventas.svg',
                    onPressed: () {
                      print("Botón 1 presionado");
                    },
                  ),
                  SizedBox(width: 23), // Espacio entre botones
                  CustomWidgets().ButtonMenu(
                    text: "Designar Kilos",
                    color: colores.colorButtonBeige,
                    icon: 'lib/assets/home_mostrador/reparto.svg',
                    onPressed: () {
                      print("Botón 2 presionado");
                    },
                  ),
                ],
              ),

              SizedBox(height: 23), // Espacio entre las filas de botones
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centra los botones horizontalmente
                children: [
                  CustomWidgets().ButtonMenu(
                    text: "Donaciones",
                    color: colores.colorButtonGreen,
                    icon: 'lib/assets/home_mostrador/cajas.svg',
                    onPressed: () {
                      // Acción del botón 3
                      print("Botón 3 presionado");
                    },
                  ),
                  SizedBox(width: 23), // Espacio entre botones
                  CustomWidgets().ButtonMenu(
                    text: "Sobrantes",
                    color: colores.colorButtonPurple,
                    icon: 'lib/assets/home_mostrador/cajas.svg',
                    onPressed: () {
                      // Acción del botón 4
                      print("Botón 4 presionado");
                    },
                  ),
                ],
              ),
              Spacer(), // Espacio inferior para mantener el centrado
            ],
          ),
        ),
      ),
    );
  }
}
