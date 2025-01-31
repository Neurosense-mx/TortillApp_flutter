import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class RegisterPassword extends StatefulWidget {
  final RegisterModel registerModel;
  RegisterPassword({required this.registerModel});

  @override
  _RegisterPasswordState createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _pass1Controller = TextEditingController();
  final TextEditingController _pass2Controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  String _email = "";

  @override
  void initState() {
    super.initState();
    _email = widget.registerModel.getEmail();

    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.25, end: 0.50).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );
    // Agregar listeners a los controladores de texto
    _pass2Controller.addListener(_updateProgress);
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _pass2Controller.removeListener(_updateProgress);
    _pass1Controller.dispose();
    _pass2Controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    // Verificar si el campo de email está lleno
    if (_pass2Controller.text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
      _animationController.forward();
    } else {
      // Reiniciar la animación al valor inicial
      _animationController.reverse();
    }
  }

 Future<void> _confirmPass() async {
  String pass1 = _pass1Controller.text.trim();
  String pass2 = _pass2Controller.text.trim();

  // Expresión regular para validar la contraseña
  RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$');

  if (pass1.isEmpty || pass2.isEmpty) {
    _showCupertinoDialog("Error", "Todos los campos son obligatorios.");
    return;
  }

  if (pass1 != pass2) {
    _showCupertinoDialog("Error", "Las contraseñas no coinciden.");
    return;
  }

  if (!passwordRegex.hasMatch(pass1)) {
    _showCupertinoDialog(
      "Error",
      "La contraseña debe tener al menos 6 caracteres, incluir una letra mayúscula, una letra minúscula y un número.",
    );
    return;
  }

  // Si pasa todas las validaciones, continuar con el registro
  print("Contraseña válida, continuar con el registro...");
}


  // Método para mostrar el dialogo en caso de error
  void _showCupertinoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: TextStyle(fontSize: 18)),
          content: Text('\n' + message, style: TextStyle(fontSize: 15)),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text(
                'Aceptar',
                style: TextStyle(color: colores.colorPrincipal),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              width: screenWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  // Usar AnimatedBuilder para optimizar la animación
                 
                  // Usar AnimatedBuilder para optimizar la animación
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
                              value: _progressAnimation
                                  .value, // Usar el valor animado
                              backgroundColor: Color(0xFFF1F1F3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  colores.colorPrincipal),
                              strokeWidth: 5.0,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          // Agregar el icono dentro del progress bar
                          SvgPicture.asset(
                            'lib/assets/icons/lock_icon.svg',
                            width: 40, // Ajusta el tamaño del icono
                            height: 40, // Ajusta el tamaño del icono
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 50),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: CustomWidgets().Tittle(
                      text: 'Paso 2',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: CustomWidgets().Subtittle(
                      text: 'Crea tus credenciales de acceso.',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(_email,
                      style: TextStyle(
                          color: colores.colorPrincipal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  CustomWidgets().TextfieldPass(
                    controller: _pass1Controller,
                    label: 'Contraseña',
                    hasIcon: true,
                    icon: Icons.lock,
                  ),
                  SizedBox(height: 20),
                  CustomWidgets().TextfieldPass(
                    controller: _pass2Controller,
                    label: 'Confirmar contraseña',
                    hasIcon: true,
                    icon: Icons.lock,
                  ),
                  SizedBox(height: 50),
                  CustomWidgets().ButtonPrimary(
                    text: 'Continuar',
                    onPressed: () {
                      _confirmPass();
                    },
                  ),
                  SizedBox(height: 20),
                  Text('¿Ya tienes cuenta?',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 61, 61, 61),
                          fontSize: 16)),
                  Text('Ingresa aquí',
                      style: TextStyle(
                          color: colores.colorPrincipal,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
