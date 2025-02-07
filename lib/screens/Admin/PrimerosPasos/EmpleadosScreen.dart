import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/PrimerosPasos/PP_Model.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/Add_Productos.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/PreciosScreen.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/SucursalScreen.dart';
import 'package:tortillapp/screens/Register/RegisterPassword.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class PP_Empleados_Screen extends StatefulWidget {
  @override
  _PP_Empleados_ScreenState createState() => _PP_Empleados_ScreenState();
}

class _PP_Empleados_ScreenState extends State<PP_Empleados_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _tiendaController = TextEditingController();
  final TextEditingController _publicoController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isKeyboardVisible = false;
  late ConfettiController _confettiController;

  List<Map<String, dynamic>> productos = [
  {
    "id": 1,
    "nombre": "Salsa de tomate",
    "precio": 10.5,
  },
  {
    "id": 2,
    "nombre": "Salsa de tomate",
    "precio": 10.5,
  },
  {
    "id": 3,
    "nombre": "Salsa de tomate",
    "precio": 10.5,
  },
  {
    "id": 4,
    "nombre": "Salsa de tomate",
    "precio": 10.5,
  },
  {
    "id": 5,
    "nombre": "Salsa de tomate",
    "precio": 10.5,
  },
  
];

  //Instanciar el modelo
  final PP_Model pp_model = PP_Model();

  @override
  void initState() {
    super.initState();
_confettiController = ConfettiController(duration: Duration(seconds: 2));
    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );

    // Agregar un listener al controlador de texto
    _tiendaController.addListener(_updateProgress);
    _publicoController.addListener(_updateProgress);

 

    Future.delayed(Duration(seconds: 1), () {
    if (mounted) { // Asegura que el widget aún esté en pantalla antes de ejecutar
      _showCupertinoDialog(
      'Configuración de empleados', 
      'En esta sección podrás agregar empleados a tu sucursal. \n Puedes omitir este paso seleccionando el botón "Continuar", más adelante podrás agregarlos nuevamente.'
    );
    }
  });
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _tiendaController.removeListener(_updateProgress);
    _publicoController.removeListener(_updateProgress);
  _confettiController.dispose();
    _tiendaController.dispose();
    _publicoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

void _showConfetti() {
    _confettiController.play();
  }

  void _updateProgress() {
    // Verificar si el campo de email está lleno y el campo de publico
    if (_tiendaController.text.isNotEmpty &&
        _publicoController.text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
      //_animationController.forward();
    } else {
      // Reiniciar la animación al valor inicial
      _animationController.reverse();
    }
  }

  // Método para mostrar el dialogo en caso de error
  void _showCupertinoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeIn,
          )),
          child: CupertinoAlertDialog(
            title: Text(title, style: TextStyle(fontSize: 18)),
            content: Text('\n' + message, style: TextStyle(fontSize: 15)),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el diálogo
                },
                child: Text('Aceptar',
                    style: TextStyle(color: colores.colorPrincipal)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _savePrice() async {
    
    //Guardar el nombre en el modelo
    

     await _animationController.forward();
     //mostrar confetti
      _showConfetti();
   
  }

  Future<void> _omitir() async {
    await _animationController.forward();
    //validar si animacion esta completa

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return PP_AddProductos_Screen();
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
    
  }

@override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width * 0.8;
  double screenHeight = MediaQuery.of(context).size.height;
  double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  return Scaffold(
    backgroundColor: colores.colorFondo,
    body: SafeArea(
      child: Center( // Centra el contenido principal en la pantalla
        child: Container(
          width: screenWidth, // Ocupa el 80% del ancho de la pantalla
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: Color(0xFFF1F1F3),
                          valueColor: AlwaysStoppedAnimation<Color>(colores.colorPrincipal),
                          strokeWidth: 5.0,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      SvgPicture.asset(
                        'lib/assets/icons/product_icon.svg',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 50),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isKeyboardVisible ? 30 : 50,
                width: screenWidth,
                child: CustomWidgets().Tittle(
                  text: "Empleados",
                  color: colores.colorPrincipal,
                ),
              ),
              
              SizedBox(height: 10),
              
              Align(
                alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
                child: CustomWidgets().Subtittle(
                  text: 'Todos los productos adicionales (${productos.length})',
                  color: colores.colorPrincipal,
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  width: screenWidth,
                  child: productos.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Color(0xFFEBF1FD),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Color(0xFFDDE5FD)),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: SvgPicture.asset(
                                  "lib/assets/icons/etiqueta_icon.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(Color(0xFF1B374D), BlendMode.srcIn),
                                ),
                                title: Text(productos[index]["nombre"]),
                                subtitle: Text("\$${productos[index]["precio"].toString()}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Color(0xFFABB9D4)),
                                  onPressed: () {
                                    setState(() {
                                      productos.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "No hay productos agregados",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 10),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isKeyboardVisible ? 30 : 50,
                width: screenWidth,
                child: CustomWidgets().ButtonSecondary(
                  text: 'Agregar producto',
                  onPressed: () {
                    // Acción para agregar producto
                  },
                ),
              ),
               // Confetti Widget
         Positioned(
      top: -70, // Eleva el confeti más arriba de la pantalla
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: -pi / 2, // Hacia arriba
          emissionFrequency: 0.05, // Frecuencia de partículas
          numberOfParticles: 30, // Cantidad de partículas
          gravity: 0.05, // Menos gravedad para que suban más
          maxBlastForce: 30, // Aumenta la fuerza inicial del confeti
          minBlastForce: 20, // Evita que caigan rápido
        ),
      ),
    ),
              SizedBox(height: 10),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isKeyboardVisible ? 30 : 50,
                width: screenWidth,
                child: CustomWidgets().ButtonPrimary(
                  text: 'Continuar',
                  onPressed: () {

                    _savePrice();
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
  );
}
}
