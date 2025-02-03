import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Login/LoginModel.dart';
import 'package:tortillapp/widgets/widgets.dart';

import 'package:tortillapp/screens/Register/RegisterEmail.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    //validar que los campos no esten vacios
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showCupertinoDialog('Error', 'Por favor, llena todos los campos.');
      return;
    }
    //validar que tenga fromato de correo
    if (!_emailController.text.contains('@')) {
      _showCupertinoDialog('Error', 'Por favor, ingresa un correo válido.');
      return;
    }
    // Instanciamos el modelo de Login
    LoginModel loginModel = LoginModel();
    loginModel.setEmail(_emailController.text);
    loginModel.setPassword(_passwordController.text);
    //Bajar en un Map la respuesta
    Map<String, dynamic> response = await loginModel.login();
    //Mostrar la respuesta
    print(response);

    //Si la respuesta es 200
    if (response['statusCode'] == 200) { //-------------------------------------- Inicio de sesion exitoso

      //Obtener el tipo de usuario con el rol
        
      //---------------------------------------- User admin
      //Obtener el name del usuario, si esta "", redirigir a la pantalla de primeros pasos
      //Si no, redirigir a la pantalla de home_admin

      // ---------------------------------------- User normal
      //Mostrar un dialogo de bienvenida
      _showCupertinoDialog('Bienvenido', 'Inicio de sesión exitoso.');
    } else {
      //Mostrar un dialogo de error
      //print(response['message']);
      _showCupertinoDialog('Error', response['message']);
    }
  }

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
      resizeToAvoidBottomInset: true, // Esto asegura que la pantalla se ajuste al aparecer el teclado
      body: SingleChildScrollView( // Esto permite que el contenido sea desplazable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              width: screenWidth * 0.8, // 80% del ancho de la pantalla
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Image.asset(
                    'lib/assets/logo.png',
                    height: 150,
                  ),
                  SizedBox(height: 50),
                  Container(
                    alignment: Alignment.centerLeft, // Alineación a la izquierda
                    child: CustomWidgets().Tittle(
                      text: 'Login',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 10), 
                  Container(
                    alignment: Alignment.centerLeft, // Alineación a la izquierda
                    child: CustomWidgets().Subtittle(
                      text: 'Por favor inicia sesión para continuar.',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Usamos el widget customTextField desde CustomWidgets
                  CustomWidgets().TextfieldPrimary(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    hasIcon: true, // Pasamos true para mostrar el ícono
                    icon: Icons.email, // El ícono del email
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  // Usamos el widget TextfieldPass para la contraseña
                  CustomWidgets().TextfieldPass(
                    controller: _passwordController,
                    label: 'Contraseña',
                    hasIcon: true, // Mostrar ícono
                    icon: Icons.lock, // Ícono de lock
                  ),
                  SizedBox(height: 20),
                  Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: colores.colorPrincipal,
                        fontWeight: FontWeight.normal,
                        fontSize: 16
                      )),
                  SizedBox(height: 30),
                  // Usamos el widget customButton desde CustomWidgets
                  CustomWidgets().ButtonPrimary(
                    text: 'Iniciar sesión',
                    onPressed: () async {
                      await _login();
                    },
                  ),
                  SizedBox(height: 20),
                  Text('¿No tienes una cuenta?',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 61, 61, 61),
                        fontSize: 16
                      )),
                  GestureDetector(
  onTap: () {
   //Navegar a RegisterScreen
    Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return RegisterScreen(); // La página a la que vas
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Aquí definimos cómo se realiza la animación de la transición
      const begin = Offset(1.0, 0.0); // Deslizar desde la derecha
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      // Aquí puedes modificar la animación a tu gusto
      return SlideTransition(position: offsetAnimation, child: child);
    },
  ),
);
  },
  child: Text(
    'Regístrate aquí',
    style: TextStyle(
      color: colores.colorPrincipal,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
)

                      
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
