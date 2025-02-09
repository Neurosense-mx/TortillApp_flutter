import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tortillapp/screens/Molinero/Inicio/resources/Graficas.dart';

class HomeMolinero extends StatefulWidget {
  @override
  _HomeMolineroState createState() => _HomeMolineroState();
}

class _HomeMolineroState extends State<HomeMolinero> {
  String nombre = "";

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
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .9, // Ocupa el 90% de la pantalla
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hola, Nombre
              Text(
                'Hola, $nombre',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                _getSaludo(),
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 16),

              // Card Molinero
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Molinero',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Texto Acciones
              Text(
                'Acciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // LayoutBuilder para hacer los cards cuadrados
              LayoutBuilder(
                builder: (context, constraints) {
                  double cardSize = (constraints.maxWidth / 2) - 12;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSquareCard(Icons.access_alarm, 'Card1', cardSize),
                        SizedBox(width: 16),
                        _buildSquareCard(Icons.analytics, 'Card2', cardSize),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),

              // Texto Estadísticas
              Text(
                'Estadísticas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Expanded para ocupar el espacio restante
              Expanded(
                child: LineChartWidget(data: data),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget para construir los cards cuadrados
  Widget _buildSquareCard(IconData icon, String text, double size) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: size,
        height: size, // Misma altura que ancho para que sea cuadrado
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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