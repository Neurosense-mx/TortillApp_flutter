import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/screens/Molinero/Estadísticas/Estadisticas_Screen.dart';
import 'package:tortillapp/screens/Molinero/Inicio/Inicio_Molinero.dart';
import 'package:tortillapp/screens/Molinero/Mi perfil/MolineroPerfil.dart';
import 'package:tortillapp/utils/Data_sesion.dart';

class Molinero_Screen extends StatefulWidget {
  @override
  _Molinero_ScreenState createState() => _Molinero_ScreenState();
}

class _Molinero_ScreenState extends State<Molinero_Screen> {
  final PaletaDeColores colores = PaletaDeColores();

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  late MolinoModel molino;
  bool _isLoading = true;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _inicializarModelo();
  }

  Future<void> _inicializarModelo() async {
    final dataUser = DataUser();
    molino = MolinoModel(
      await dataUser.idCuenta,
      await dataUser.idSucursal,
      await dataUser.idNegocio,
      await dataUser.idAdmin,
      await dataUser.token,
    );

    _screens = [
      HomeMolinero(molino: molino),
      MiPerfilMolinero(),         // <-- Corregido: antes era otro MiPerfil
      MiPerfilMolinero(),
    ];

    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
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
          // Esto asegura que nada del scaffold principal se dibuje
          child: Center(child: CircularProgressIndicator()),
        )
      : Scaffold(
          backgroundColor: colores.colorFondo,
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              children: _screens,
              onPageChanged: (index) {
                setState(() => _selectedIndex = index);
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
                label: 'Estadísticas',
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
