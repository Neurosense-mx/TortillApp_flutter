import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tortillapp/config/Notification.dart';
import 'package:tortillapp/config/backend.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/main.dart';
import 'package:tortillapp/models/Login/LoginModel.dart';
import 'package:tortillapp/screens/Admin/Home/Home_Admin.dart';
import 'package:tortillapp/screens/Molinero/MolineroScreen.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/NombreScreen.dart';
import 'package:tortillapp/screens/Mostrador/MostradorScreen.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tortillapp/screens/Register/RegisterEmail.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void initState() {
    super.initState();
    //Varificar si ya se ha iniciado sesión, con token
   
  }

 
Future<void> _login() async {
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    _showCupertinoDialog('Error', 'Por favor, llena todos los campos.');
    return;
  }

  if (!_emailController.text.contains('@')) {
    _showCupertinoDialog('Error', 'Por favor, ingresa un correo válido.');
    return;
  }

  // Mostrar loader
  _showLoadingDialog();

  // Instanciamos el modelo de Login
  LoginModel loginModel = LoginModel();
  loginModel.setEmail(_emailController.text);
  loginModel.setPassword(_passwordController.text);

  // Realizar la solicitud de login
  Map<String, dynamic> response = await loginModel.login();

  // Mantener el loader visible 1 segundo adicional
  await Future.delayed(Duration(seconds: 1));

  // Ocultar loader
  Navigator.pop(context);

  print("Response: ---------------------" + response.toString());

  if (response['statusCode'] == 200) {
    var id_role = response['user']['id_rol'].toString();
    print("Mi rol es : " + id_role);

    // Guardar info en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final idAdmin = await prefs.getInt('id_admin') ?? 0;
    await prefs.setString('nombre', response['user']['nombre']);

    
    print("------------------------------- ID Admin: $idAdmin");
    // Validar facturación
    final facturacionUrl = Uri.parse('${ApiConfig.backendUrl}/rutinas/facturacion/$idAdmin');
    final factResponse = await http.get(facturacionUrl);
    print("Facturación URL: $facturacionUrl");

    if (factResponse.statusCode == 200) {
      final factData = jsonDecode(factResponse.body);
      print("Facturación Data: $factData");
      if (factData['status'] == 1) {
        // ===>> CONTINUAR CON REDIRECCIONAMIENTO SEGÚN ROL <<===

        if (id_role == "1") {
          var nombre = response['user']['nombre'];
          var config = response['config'];

          if (nombre == "") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PP_Nombre_Screen(id_Cuenta: 1,))); // PENDIENTE eliminar el redireccionamiento
          } else {
            var negocio = config['negocio'];
            var sucursal = config['sucursal'];
            var precio = config['precio'];
            var productos = config['productos'];
            var gastos = config['gastos'];
            var empleados = config['empleados'];

            if (negocio == 1 &&
                sucursal == 1 &&
                precio == 1 &&
                productos == 1 &&
                gastos == 1 &&
                empleados == 1) { //------------------ ROL ADMIN PERO YA CONFIGURADO
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home_Admin()),
                (Route<dynamic> route) => false,
              );
            } else {
              _showCupertinoDialog('Bienvenido', 'No configurado sucursales, etc.');
            }
          }
        } else if (id_role == "2") { //-------------------------------------------- ROL MOLINER
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Molinero_Screen()),
            (Route<dynamic> route) => false,
          );
        }
        else if (id_role == "3") { //-------------------------------------------- ROL MOSTRADOR
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Mostrador_Screen()),
            (Route<dynamic> route) => false,
          );
        } else {
          _showCupertinoDialog('Error', 'Rol no reconocido.');
        }

      } else {
        
       if(factData['status'] == 0) {
        _showCupertinoDialog('Facturación inválida', factData['message'] ?? 'Error, pago no realizado.');
        //lanzar pantalla de pago
        } else {
          print("Error desconocido en la facturación.");
        }
      }
    } else {
      _showCupertinoDialog('Error de red', 'Error al obtener la facturación: ${factResponse.statusCode}');
      print("Error al obtener la facturación: ${factResponse.statusCode}");
    }
  } else {
    _showCupertinoDialog('Error', response['message']);
  }
}

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario lo cierre manualmente
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: colores.colorPrincipal, // Color del loader
                ),
                SizedBox(height: 16),
                Text(
                  "Iniciando sesión...",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Función para ocultar el loader
  void _hideLoadingDialog() {
    Navigator.pop(context);
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
      resizeToAvoidBottomInset:
          true, // Esto asegura que la pantalla se ajuste al aparecer el teclado
      body: SingleChildScrollView(
        // Esto permite que el contenido sea desplazable
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
                    alignment:
                        Alignment.centerLeft, // Alineación a la izquierda
                    child: CustomWidgets().Tittle(
                      text: 'Login',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment:
                        Alignment.centerLeft, // Alineación a la izquierda
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
                          fontSize: 16)),
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
                          fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      //Navegar a RegisterScreen
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return RegisterScreen(); // La página a la que vas
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // Aquí definimos cómo se realiza la animación de la transición
                            const begin =
                                Offset(1.0, 0.0); // Deslizar desde la derecha
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            // Aquí puedes modificar la animación a tu gusto
                            return SlideTransition(
                                position: offsetAnimation, child: child);
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
