import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/screens/Admin/Home/example2.dart';
import 'package:tortillapp/screens/Admin/Home/example3.dart';
import 'package:tortillapp/screens/Mostrador/Inicio/Inicio_Mostrador.dart';

class Mostrador_Screen extends StatefulWidget {
  @override
  _Mostrador_ScreenState createState() => _Mostrador_ScreenState();
}

class _Mostrador_ScreenState extends State<Mostrador_Screen> {
  final PaletaDeColores colores = PaletaDeColores();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  late final List<Widget> _screens;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _screens = [
      Home_Mostrador(),
      example2(),
      example3(),
    ];
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
