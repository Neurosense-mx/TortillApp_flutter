import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/screens/Molinero/Inicio/resources/Graficas.dart';

class HomeMolinero extends StatefulWidget {
  @override
  _HomeMolineroState createState() => _HomeMolineroState();
}

class _HomeMolineroState extends State<HomeMolinero> {
  String nombre = "";
  PaletaDeColores colores = PaletaDeColores();

 final Map<String, Map<String, double>> data = {
    "costales_cocidos": {
      "Dom": 10,
      "Lun": 20,
      "Mar": 30,
      "Mie": 40,
      "Jue": 50,
      "Vie": 60,
      "Sab": 70,
    },
    "masa_pesada": {
      "Dom": 5,
      "Lun": 14,
      "Mar": 12,
      "Mie": 13,
      "Jue": 7,
      "Vie": 17,
      "Sab": 21,
    },
  };

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
  return Container(
    color: Color(0xFFF8F8F8), // Fondo gris claro
    child: Scaffold(
      backgroundColor: Colors.transparent, // Hace que el fondo del Scaffold sea transparente
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .9, // Ocupa el 90% de la pantalla
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              // Hola, Nombre
              Text(
                'Hola, $nombre',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colores.colorPrincipal),
              ),
              SizedBox(height: 4),
              Text(
                _getSaludo(),
                style: TextStyle(fontSize: 15, color: Color(0xFF393939)),
              ),
              SizedBox(height: 16),
Text(
                'Puesto actual',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: colores.colorPrincipal),
              ),
              SizedBox(height: 10),
              // Card Molinero
             Card(
  color: const Color.fromARGB(255, 255, 255, 255), // Fondo blanco
  elevation: 2.4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: BorderSide(color: Color.fromARGB(255, 218, 218, 218), width: 1), // Borde de 2px color #ABBCC9
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Row(
      mainAxisSize: MainAxisSize.min, // Ajusta el ancho al contenido
      children: [
        SvgPicture.asset(
          'lib/assets/cards/molinero/molino_icon.svg',
          width: 30, // Tamaño del ícono
          height: 30,
        ),
        SizedBox(width: 10), // Espacio entre el ícono y el texto
        Text(
          'Molino',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: colores.colorPrincipal),
        ),
      ],
    ),
  ),
),


              SizedBox(height: 16),

              // Texto Acciones
              Text(
                'Acciones',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: colores.colorPrincipal),
              ),
              SizedBox(height: 10),

              // LayoutBuilder para hacer los cards cuadrados
              LayoutBuilder(
                builder: (context, constraints) {
                  double cardSize = (constraints.maxWidth / 2) - 12;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSquareCard('lib/assets/cards/molinero/cocer_icon.svg', 'Cocer maíz', cardSize, '21B0E4'),
                        SizedBox(width: 10),
                        _buildSquareCard('lib/assets/cards/molinero/pesar_masa_icon.svg', 'Pesar masa', cardSize, '5BA951'),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),

              // Texto Estadísticas
              Text(
                'Estadísticas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: colores.colorPrincipal),
              ),
              SizedBox(height: 10),

              // Expanded para ocupar el espacio restante
              Expanded(
                child: LineChartWidget(data: data),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


Widget _buildSquareCard(String imagePath, String text, double size, String color) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      width: size,
      height: size, // Misma altura que ancho para que sea cuadrado
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(int.parse("0xFF" + color)), // Se convierte el color de string a Color
        borderRadius: BorderRadius.circular(10), // Mantiene el redondeo de las esquinas
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra todo el contenido verticalmente
        crossAxisAlignment: CrossAxisAlignment.center, // Centra todo el contenido horizontalmente
        children: [
          SvgPicture.asset(
            imagePath,
            width: 50,  // Tamaño de la imagen
            height: 50,
          ),
          SizedBox(height: 16), // Espacio entre el icono y el texto
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
          ),
        ],
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