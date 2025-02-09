import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/screens/Admin/Home/Home_Admin.dart';
import 'package:tortillapp/screens/Admin/MiPerfil/MiPerfil.dart';
import 'package:tortillapp/screens/Admin/Sucursales/Mis_Sucursales.dart';

class Admin_Estadisticas extends StatefulWidget {
  @override
  _Admin_EstadisticasState createState() => _Admin_EstadisticasState();
}

class _Admin_EstadisticasState extends State<Admin_Estadisticas>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();
  bool _isKeyboardVisible = false;
  int _selectedIndex = 2; // 'Mis Sucursales' está seleccionada por defecto

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Navegar a la pantalla correspondiente Inicio
    if (index == 0) {
      //navegar a la pantalla de inicio
    
    }
    // Navegar a la pantalla correspondiente Mis Sucursales
    if (index == 1) {
      //navegar a la pantalla de mis sucursales
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Mis_Sucursales_Screen(),
      ),
    );
    }
   
    // Navegar a la pantalla correspondiente Mi Perfil
    if (index == 3) {
      //navegar a la pantalla de mi perfil
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Admin_Mi_Perfil(),
      ),
    );
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                setState(() {
                  _isKeyboardVisible =
                      MediaQuery.of(context).viewInsets.bottom > 0;
                });
                return false;
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Contenido principal de Mis Sucursales
                            Text(
                              'Estadisticas',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: colores.colorPrincipal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/menu_horizontal/home_icon.svg',
              width: 20,
              height: 20,
              color: _selectedIndex == 0 ? colores.colorPrincipal : Colors.grey,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/menu_horizontal/sucursales_icon.svg',
              width: 20,
              height: 20,
              color: _selectedIndex == 1 ? colores.colorPrincipal : Colors.grey,
            ),
            label: 'Sucursales',
          ),
          BottomNavigationBarItem(
           icon: SvgPicture.asset(
              'lib/assets/menu_horizontal/estadisticas.svg',
              width: 20,
              height: 20,
              color: _selectedIndex == 2 ? colores.colorPrincipal : Colors.grey,
            ),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
           icon: SvgPicture.asset(
              'lib/assets/menu_horizontal/user.svg',
              width: 20,
              height: 20,
              color: _selectedIndex == 3 ? colores.colorPrincipal : Colors.grey,
            ),
            label: 'Mi Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colores.colorPrincipal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(fontSize: 12, ),  // Tamaño de fuente para el label seleccionado
  unselectedLabelStyle: TextStyle(fontSize: 9),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción al presionar el botón flotante
        },
        backgroundColor: colores.colorPrincipal, // Color de fondo del botón flotante
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
