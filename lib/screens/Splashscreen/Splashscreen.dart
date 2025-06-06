import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tortillapp/screens/Admin/Home/Home_Admin.dart';
import 'package:tortillapp/screens/Molinero/MolineroScreen.dart';
import 'package:tortillapp/screens/Login/Login.dart';
import 'package:tortillapp/config/backend.dart';
import 'package:tortillapp/screens/Mostrador/MostradorScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _iniciarFlujo();
  }

  Future<void> _iniciarFlujo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final idRol = prefs.getInt('id_rol') ?? 0;
      final idAdmin = prefs.getInt('id_admin') ?? 0;

      if (token.isEmpty) {
        _redirigirAlLogin(delay: 3);
        return;
      }

      final facturacionOk = await _verificarFacturacion(idAdmin);
      if (!facturacionOk) {
        _mostrarAlerta("Pago no efectuado");
        return;
      }

      final tokenValido = await _verificarToken(token);
      if (!tokenValido) {
        _redirigirAlLogin();
        return;
      }

      _redirigirPorRol(idRol);
    } catch (e) {
      _mostrarAlerta("Error de conexión: $e");
    }
  }

  Future<bool> _verificarFacturacion(int idAdmin) async {
    final url = Uri.parse('${ApiConfig.backendUrl}/rutinas/facturacion/$idAdmin');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 1;
    }

    _mostrarAlerta("Error al verificar facturación");
    return false;
  }

  Future<bool> _verificarToken(String token) async {
    final url = Uri.parse('${ApiConfig.backendUrl}/rutinas/auth/check-token');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  void _redirigirPorRol(int idRol) {
    Widget destino;

    switch (idRol) {
      case 1:
        destino = Home_Admin();
        break;
      case 2:
        destino = Molinero_Screen();
        break;
      case 3:
        destino = Mostrador_Screen();
        break;
      default:
        _redirigirAlLogin();
        return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => destino),
      (route) => false,
    );
  }

  void _redirigirAlLogin({int delay = 0}) {
    Future.delayed(Duration(seconds: delay), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Atención"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _redirigirAlLogin();
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final altoPantalla = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/backgroundSplashScreen.png',
              height: altoPantalla * 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
