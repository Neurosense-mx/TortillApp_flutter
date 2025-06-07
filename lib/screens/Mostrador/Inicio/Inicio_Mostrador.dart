import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';
import 'package:tortillapp/screens/Mostrador/Inicio/pages/Add_Donaciones.dart';
import 'package:tortillapp/screens/Mostrador/Inicio/pages/DesignarCajas.dart';
import 'package:tortillapp/screens/Mostrador/Inicio/pages/Add_Sobrantes.dart';
import 'package:tortillapp/screens/Mostrador/Inicio/pages/Add_Ventas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Mostrador extends StatefulWidget {
  final MostradorModel mostrador;
  const Home_Mostrador({Key? key, required this.mostrador}) : super(key: key);
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

  Future<void> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? "Usuario";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Hola, $nombre',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colores.colorPrincipal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _getSaludo(),
                style: TextStyle(fontSize: 15, color: Color(0xFF393939)),
              ),
              SizedBox(height: 16),
              Text(
                'Puesto actual',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: colores.colorPrincipal,
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.white,
                elevation: 2.4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Color(0xFFDADADA), width: 1),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'lib/assets/cards/mostrador/molino_.svg',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Mostrador',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: colores.colorPrincipal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Acciones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: colores.colorPrincipal,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSquareCard(
                    'lib/assets/cards/mostrador/ventas.svg',
                    'Ventas',
                    150.0,
                    colorToHex(colores.colorButtonBlue),
                    AddVentasScreen(),
                    context,
                  ),
                  SizedBox(width: 23),
                  _buildSquareCard(
                    'lib/assets/cards/mostrador/reparto.svg',
                    'Designar Kilos',
                    150,
                    colorToHex(colores.colorButtonBeige),
                    DesignarCajas(mostrador: widget.mostrador,),
                    context,
                  ),
                ],
              ),
              SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSquareCard(
                    'lib/assets/cards/mostrador/cajas.svg',
                    'Donaciones',
                    150,
                    colorToHex(colores.colorButtonGreen),
                    AddDonacionesScreen(
                      mostrador: widget.mostrador,
                    ),
                    context,
                  ),
                  SizedBox(width: 23),
                  _buildSquareCard(
                    'lib/assets/cards/mostrador/cajas.svg',
                    'Sobrantes',
                    150,
                    colorToHex(colores.colorButtonPurple),
                    AddSobrantesScreen(
                      mostrador: widget.mostrador,
                    ),
                    context,
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String colorToHex(Color color) {
    return '${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Widget _buildSquareCard(String imagePath, String text, double size,
      String color, Widget destino, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return destino;
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Deslizar desde la derecha
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: size,
          height: size, // Misma altura que ancho para que sea cuadrado
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(int.parse(
                "0xFF" + color)), // Se convierte el color de string a Color
            borderRadius: BorderRadius.circular(
                10), // Mantiene el redondeo de las esquinas
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Centra todo el contenido verticalmente
            crossAxisAlignment: CrossAxisAlignment
                .center, // Centra todo el contenido horizontalmente
            children: [
              SvgPicture.asset(
                imagePath,
                width: 50, // Tamaño de la imagen
                height: 50,
              ),
              SizedBox(height: 16), // Espacio entre el icono y el texto
              Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Retorna un saludo según la hora actual
  String _getSaludo() {
    int hour = DateTime.now().hour;
    if (hour < 12) return "Buenos días";
    if (hour < 18) return "Buenas tardes";
    return "Buenas noches";
  }
}
