import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {}

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
                    onPressed: () {
                      print("Botón presionado");
                    },
                  ),
                  SizedBox(height: 20),
                  Text('¿No tienes una cuenta?',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 61, 61, 61),
                        fontSize: 16
                      )),
                  Text('Regístrate aquí',
                      style: TextStyle(
                        color: colores.colorPrincipal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
