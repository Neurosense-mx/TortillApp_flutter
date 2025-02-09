import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/screens/Admin/Home/example1.dart';
import 'package:tortillapp/screens/Admin/Home/example2.dart';
import 'package:tortillapp/screens/Admin/Home/example3.dart';
import 'package:tortillapp/screens/Admin/Home/example4.dart';
import 'package:tortillapp/screens/Molinero/Inicio/Grafica.dart';
import 'package:tortillapp/screens/Molinero/Inicio/Inicio_Molinero.dart';


class Molinero_Screen extends StatefulWidget {
  @override
  _Molinero_ScreenState createState() => _Molinero_ScreenState();
}

class _Molinero_ScreenState extends State<Molinero_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();
  bool _isKeyboardVisible = false;
  int _selectedIndex = 0; // Índice seleccionado por defecto

  // Lista de pantallas
  final List<Widget> _screens = [
    HomeMolinero(), // Pantalla de inicio
    LineChartExample(), // Pantalla de estadísticas
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
  return Scaffold(
  backgroundColor: colores.colorFondo,
  body: SafeArea(
    child: IndexedStack(
      index: _selectedIndex,
      children: _screens,
    ),
  ),
  bottomNavigationBar: Theme(
    data: Theme.of(context).copyWith(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    child: BottomNavigationBar(
      backgroundColor: colores.colorFondo,
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
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      onTap: _onItemTapped,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 9),
      type: BottomNavigationBarType.fixed,
    ),
  ),
);
}

}
