import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tortillapp/screens/Admin/Home/Home_Admin.dart';
import 'package:tortillapp/screens/Molinero/MolineroScreen.dart';
import 'package:tortillapp/screens/Login/Login.dart';
import 'package:tortillapp/config/backend.dart'; // Asegúrate de que ApiConfig.backendUrl esté definido

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSesion();
  }

  void _checkSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    int idCuenta = prefs.getInt('id_cuenta') ?? 0;
    int idRol = prefs.getInt('id_rol') ?? 0;
    int idAdmin = prefs.getInt('id_admin') ?? 0;

    if (token.isNotEmpty) {
      try {
        // Primer endpoint: verificar facturación
        final facturacionUrl =
            Uri.parse('${ApiConfig.backendUrl}/rutinas/facturacion/$idAdmin');
        final factResponse = await http.get(facturacionUrl);
        print("Facturación URL: $facturacionUrl");
        if (factResponse.statusCode == 200) {
          final factData = jsonDecode(factResponse.body);
          if (factData['status'] == 1) {
            print(
                "--------------------------------- Facturación exitosa ---------------------------------");
            // Segundo endpoint: verificar si el token es válido
            final tokenUrl =
                Uri.parse('${ApiConfig.backendUrl}/rutinas/auth/check-token');
            
            final tokenResponse = await http.get(
              tokenUrl,
              headers: {
                'Authorization': 'Bearer $token',
              },
            );

            if (tokenResponse.statusCode == 200) {
              // Token válido, redirige según el rol
              Future.delayed(Duration(seconds: 1), () {
                print("Token válido, redirigiendo...");

                if (idRol == 1) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home_Admin()),
                    (Route<dynamic> route) => false,
                  );
                } else if (idRol == 2) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Molinero_Screen()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  // Rol desconocido
                  _irAlLogin();
                }
              });
            } else {
              // Token inválido o expirado
              _irAlLogin();
            }
          } else {
            // Pago no efectuado
            _mostrarAlerta("Pago no efectuado");
            //lanzar pantalla de pago

          }
        } else {
          _mostrarAlerta("Error al verificar facturación");
        }
      } catch (e) {
        _mostrarAlerta("Error de conexión: $e");
      }
    } else {
      // No hay token
      Future.delayed(Duration(seconds: 3), () => _irAlLogin());
    }
  }

  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Atención"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _irAlLogin();
            },
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  void _irAlLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 226, 226),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 0, 0, 0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/backgroundSplashScreen.png',
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
