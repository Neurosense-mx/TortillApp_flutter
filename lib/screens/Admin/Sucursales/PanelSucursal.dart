import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa flutter_svg
import 'package:tortillapp/config/paletteColor.dart';

class Panel_Sucursal extends StatefulWidget {
  @override
  _Panel_SucursalState createState() => _Panel_SucursalState();
}

class _Panel_SucursalState extends State<Panel_Sucursal> with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();
  bool _isMenuExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<Offset> _slideAnimation3;
  late Animation<Offset> _slideAnimation4;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation1 = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _slideAnimation2 = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation3 = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation4 = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.6, 1.0, curve: Curves.easeOut),
    ));
  }

  void _toggleMenu() {
    if (_isMenuExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isMenuExpanded = !_isMenuExpanded;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colores.colorFondo,
      appBar: AppBar(
        title: Text(
          "Panel de Sucursal",
          style: TextStyle(
            color: colores.colorPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colores.colorFondo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colores.colorPrincipal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Stack(
        children: <Widget>[
          _buildMenuItem(_slideAnimation1, 90, "lib/assets/menu/gastos_icon.svg"),
          _buildMenuItem(_slideAnimation2, 140, "lib/assets/menu/precios_icon.svg"),
          _buildMenuItem(_slideAnimation3, 190, "lib/assets/menu/productos_icon.svg"),
          _buildMenuItem(_slideAnimation4, 240, "lib/assets/menu/empleados_icon.svg"),
          Positioned(
            bottom: 20,
            right: 10,
            child: FloatingActionButton(
              backgroundColor: colores.colorPrincipal,
              onPressed: _toggleMenu,
              child: Icon(_isMenuExpanded ? Icons.close : Icons.menu, color: Colors.white),
              shape: CircleBorder(),
              elevation: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Animation<Offset> animation, double bottom, String iconPath) {
    return Positioned(
      bottom: bottom,
      right: 15,
      child: SlideTransition(
        position: animation,
        child: FadeTransition(
          opacity: _animation,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            onPressed: () {},
            child: SvgPicture.asset(
              iconPath,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            shape: CircleBorder(),
            elevation: 6,
            mini: true,
          ),
        ),
      ),
    );
  }
}
