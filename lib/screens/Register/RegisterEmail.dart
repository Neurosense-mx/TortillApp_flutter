import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/screens/Register/RegisterPassword.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _emailController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  //Instanciar el modelo
  final RegisterModel registerModel = RegisterModel();

  @override
  void initState() {
    super.initState();

    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );

    // Agregar un listener al controlador de texto
    _emailController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _emailController.removeListener(_updateProgress);
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    // Verificar si el campo de email está lleno
    if (_emailController.text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
      _animationController.forward();
    } else {
      // Reiniciar la animación al valor inicial
      _animationController.reverse();
    }
  }
// Método para buscar y validar el correo electrónico
Future<void> _searchEmail() async {
  final email = _emailController.text;

  // Validación del formato de correo electrónico usando una expresión regular
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (email.isEmpty) {
    _showCupertinoDialog('Error', 'El correo electrónico es obligatorio');
    return;
  } 
  if (!emailRegex.hasMatch(email)) {
    _showCupertinoDialog('Error', 'Por favor ingresa un correo electrónico válido');
    return;
  }

  // Mostrar mensaje de "Buscando..."
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Buscando...'),
      duration: Duration(seconds: 1), // Se oculta automáticamente
    ),
  );

  // Llamamos a la función para buscar el correo
  var result = await registerModel.search_email(email);
  int statusCode = result['statusCode'];
  String message = result['message'];

  // Ocultar el mensaje de "Buscando..."
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  if (statusCode != 200) {
    _showCupertinoDialog('Atención', message);
  } else {
    // Mostrar diálogo de confirmación para continuar con el registro
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Confirmación de correo', style: TextStyle(fontSize: 18)),
          content: Text('\n¿Registrar con este correo? $email', style: TextStyle(fontSize: 15)),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context), // Cerrar el diálogo
              child: Text('Cancelar', style: TextStyle(color: colores.colorTextRojo)),
            ),
            CupertinoDialogAction(
              onPressed: () {
                // Ir a la siguiente pantalla RegisterPassword()
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return RegisterPassword(registerModel: registerModel);
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Deslizar desde la derecha
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );
              },
              child: Text('Continuar', style: TextStyle(color: colores.colorPrincipal)),
            ),
          ],
        );
      },
    );
  }
}


  // Método para mostrar el dialogo en caso de error
  void _showCupertinoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: TextStyle(fontSize: 18)),
          content: Text('\n'+message, style: TextStyle(fontSize: 15)),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('Aceptar', style: TextStyle(color: colores.colorPrincipal)),
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
                            'lib/assets/icons/email_add.svg',
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
                      text: 'Paso 1',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: CustomWidgets().Subtittle(
                      text:
                          'Ingresa tu email, para vincularlo a tu nueva cuenta.',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomWidgets().TextfieldPrimary(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    hasIcon: true,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 140),
                  CustomWidgets().ButtonPrimary(
                    text: 'Buscar',
                    onPressed: () {
                      _searchEmail();
                    },
                    icon: Icon(Icons.search), // Agregar el icono de lupa
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
