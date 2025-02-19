import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tortillapp/screens/Molinero/Inicio/Inicio_Molinero.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:tortillapp/config/paletteColor.dart';

class Add_maiz_screen extends StatefulWidget {
  @override
  _Add_maiz_screenState createState() => _Add_maiz_screenState();
}

class _Add_maiz_screenState extends State<Add_maiz_screen> {
  LatLng? _selectedLocation; // Variable para la ubicación seleccionada
  final PaletaDeColores colores = PaletaDeColores();
  @override
  void initState() {
    super.initState();
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _confirmSelection() {
    if (_selectedLocation != null) {
      Navigator.pop(
          context, _selectedLocation); // Devuelve la ubicación seleccionada
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona una ubicación en el mapa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecciona una ubicación',
          style: TextStyle(
            color: colores.colorPrincipal, // Color del texto
            fontSize: 18, // Tamaño del texto
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        backgroundColor: colores.colorFondo, // Color de fondo del AppBar
        elevation: 0, // Elimina la sombra del AppBar
        centerTitle: true, // Centra el título
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colores.colorPrincipal, // Color del ícono de retroceso
          ),
          onPressed: () {
             Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomeMolinero();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
        ),
      ),
      body: Center(
  child: Container(
    width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho de pantalla
    child: Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Aquí puedes agregar el contenido principal
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: CustomWidgets().ButtonPrimary(
                  text: 'Guardar',
                  onPressed: _confirmSelection,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

    );
  }
}
