import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/screens/Molinero/Estad%C3%ADsticas/Estadisticas_Screen.dart';
import 'package:tortillapp/screens/Molinero/Inicio/Inicio_Molinero.dart';
import 'package:tortillapp/screens/Admin/Home/example4.dart';

class Molinero_Screen extends StatefulWidget {
  @override
  _Molinero_ScreenState createState() => _Molinero_ScreenState();
}

class _Molinero_ScreenState extends State<Molinero_Screen> {
  final PaletaDeColores colores = PaletaDeColores();
  int _selectedIndex = 0; 
  final PageController _pageController = PageController();
  late MolinoModel molino;

  @override
  void initState() {
    super.initState();
    molino = MolinoModel(1); // Instanciar el modelo
  }

  // Lista de pantallas con el modelo ya inicializado
  late final List<Widget> _screens;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screens = [
      HomeMolinero(molino: molino),
      LineChartExample(),
      example4(),
    ];
  }

  // Método para cambiar de pantalla con animación
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400), 
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colores.colorFondo,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
              color: _selectedIndex == 1 ? colores.colorPrincipal : Colors.grey,
            ),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/menu_horizontal/user.svg',
              width: 20,
              height: 20,
              color: _selectedIndex == 2 ? colores.colorPrincipal : Colors.grey,
            ),
            label: 'Mi Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colores.colorPrincipal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 9),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
