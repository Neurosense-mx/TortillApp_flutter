import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/screens/Molinero/Estadísticas/Estadisticas_Screen.dart';
import 'package:tortillapp/screens/Molinero/Inicio/Inicio_Molinero.dart';
import 'package:tortillapp/screens/Molinero/Mi perfil/MolineroPerfil.dart';
import 'package:tortillapp/screens/Molinero/Mis_registros/MisRegistros.dart';
import 'package:tortillapp/utils/Data_sesion.dart';

class Molinero_Screen extends StatefulWidget {
  @override
  _Molinero_ScreenState createState() => _Molinero_ScreenState();
}

class _Molinero_ScreenState extends State<Molinero_Screen> {
  final PaletaDeColores colores = PaletaDeColores();

  int _selectedIndex = 0;
  late PageController _pageController;

  late MostradorModel molino;
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
    molino = MostradorModel(
      await dataUser.idCuenta,
      await dataUser.idSucursal,
      await dataUser.idNegocio,
      await dataUser.idAdmin,
      await dataUser.token,
      await dataUser.email,
      await dataUser.nombre,
    );

    _screens = [
      HomeMolinero(molino: molino),
      MisRegistrosMolinero(molino: molino),
      MiPerfilMolinero(
        molino: molino,
        onTabSelected: (index) {
          _onItemTapped(index);
          _jumpToVirtualPage(index);
        },
      ),
    ];

    // Inicializamos el controlador en el "medio" para permitir scroll infinito
    int initialPage =
        _virtualPageCount ~/ 2 - ((_virtualPageCount ~/ 2) % _screens.length);
    _pageController = PageController(initialPage: initialPage);

    setState(() {
      _isLoading = false;
      _selectedIndex = 0;
    });
  }

  // Función para obtener el índice real de la página mostrado
  int _getRealIndex(int position) {
    return position % _screens.length;
  }

  void _onItemTapped(int index) {
    _jumpToVirtualPage(index);
  }

  void _jumpToVirtualPage(int index) {
    int currentVirtualPage = _pageController.page?.round() ?? 0;
    int targetPage =
        currentVirtualPage - (_getRealIndex(currentVirtualPage)) + index;
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
        ? const Material(
            child: Center(child: CircularProgressIndicator()),
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
                  int index = _getRealIndex(position);
                  setState(() {
                    _selectedIndex = index;
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
                  icon: _buildNavIcon(
                      'lib/assets/menu_horizontal/home_icon.svg', 0),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(
                      'lib/assets/menu_horizontal/estadisticas.svg', 1),
                  label: 'Registros',
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
