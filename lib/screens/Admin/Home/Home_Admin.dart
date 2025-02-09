import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/screens/Admin/Home/example1.dart';
import 'package:tortillapp/screens/Admin/Home/example2.dart';
import 'package:tortillapp/screens/Admin/Home/example3.dart';
import 'package:tortillapp/screens/Admin/Home/example4.dart';


class Home_Admin extends StatefulWidget {
  @override
  _Home_AdminState createState() => _Home_AdminState();
}

class _Home_AdminState extends State<Home_Admin>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();
  bool _isKeyboardVisible = false;
  int _selectedIndex = 0; // Índice seleccionado por defecto

  // Lista de pantallas
  final List<Widget> _screens = [
    example1(), // Pantalla de inicio
    example2(), // Pantalla de mis sucursales
    example3(), // Pantalla de estadísticas
    example4(), // Pantalla de mi perfil
  ];

  // Función para cambiar la pantalla
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambiar el índice cuando se selecciona un ítem
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex, // Mostrar la pantalla correspondiente
          children: _screens, // Lista de pantallas
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
        onTap: _onItemTapped, // Cambiar la pantalla al seleccionar un ítem
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 9),
      ),
    );
  }
}
