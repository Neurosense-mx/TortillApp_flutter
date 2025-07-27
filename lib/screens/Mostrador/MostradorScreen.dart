import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';
import 'package:tortillapp/screens/Admin/Home/example2.dart';
import 'package:tortillapp/screens/Admin/Home/example3.dart';
import 'package:tortillapp/screens/Mostrador/Inicio/Inicio_Mostrador.dart';
import 'package:tortillapp/screens/Mostrador/Mi_perfil/MostradorPerfil.dart';
import 'package:tortillapp/screens/Mostrador/MisRegistros/RegistrosMostrador.dart';
import 'package:tortillapp/utils/Data_sesion.dart';

class Mostrador_Screen extends StatefulWidget {
  @override
  _Mostrador_ScreenState createState() => _Mostrador_ScreenState();
}

class _Mostrador_ScreenState extends State<Mostrador_Screen> {
  final PaletaDeColores colores = PaletaDeColores();

  int _selectedIndex = 0;
  late PageController _pageController;
  late int _initialVirtualPage;

  late MostradorModel mostrador;
  bool _isLoading = true;
  late final List<Widget> _screens;

  // Número grande para simular páginas infinitas
  static const int _virtualPageCount = 10000;

  @override
  void initState() {
    super.initState();
    _inicializarModelo();
  }

  Future<void> _inicializarModelo() async {
    final dataUser = DataUser();
    mostrador = MostradorModel(
      await dataUser.idCuenta,
      await dataUser.idSucursal,
      await dataUser.idNegocio,
      await dataUser.idAdmin,
      await dataUser.token,
      await dataUser.email,
      await dataUser.nombre,
    );
   

    _screens = [
      Home_Mostrador(mostrador: mostrador),
      MisRegistrosMostrador(mostrador: mostrador),
      MiPerfilMostrador(
        mostrador: mostrador,
        onTabSelected: (index) {
          _onItemTapped(index);
          _jumpToVirtualPage(index);
        },
      ),
    ];

    _initialVirtualPage = _virtualPageCount ~/ 2 - ((_virtualPageCount ~/ 2) % _screens.length);
    _pageController = PageController(initialPage: _initialVirtualPage);

    setState(() {
      _isLoading = false;
      _selectedIndex = 0;
    });
  }

  int _getRealIndex(int position) {
    return position % _screens.length;
  }

  void _onItemTapped(int index) {
    _jumpToVirtualPage(index);
  }

  void _jumpToVirtualPage(int index) {
    int currentVirtualPage = _pageController.page?.round() ?? _initialVirtualPage;
    int targetPage = currentVirtualPage - (_getRealIndex(currentVirtualPage)) + index;

    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavIcon(String assetPath, int index) {
    return SvgPicture.asset(
      assetPath,
      width: 20,
      height: 20,
      color: _selectedIndex == index ? colores.colorPrincipal : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: colores.colorFondo,
            body: SafeArea(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, position) {
                  int index = _getRealIndex(position);
                  return _screens[index];
                },
                onPageChanged: (position) {
                  setState(() {
                    _selectedIndex = _getRealIndex(position);
                  });
                },
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: colores.colorFondo,
              currentIndex: _selectedIndex,
              selectedItemColor: colores.colorPrincipal,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              selectedLabelStyle: const TextStyle(fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 9),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon('lib/assets/menu_horizontal/home_icon.svg', 0),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon('lib/assets/menu_horizontal/estadisticas.svg', 1),
                  label: 'Mis registros',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon('lib/assets/menu_horizontal/user.svg', 2),
                  label: 'Mi Perfil',
                ),
              ],
            ),
          );
  }
}
