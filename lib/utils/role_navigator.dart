import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tortillapp/screens/Admin/Home/Home_Admin.dart';
import 'package:tortillapp/screens/Molinero/MolineroScreen.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/NombreScreen.dart';

class RoleNavigator {
  static Future<void> navigateByRole({
    required BuildContext context,
    required String idRole,
    required Map<String, dynamic> user,
    required Map<String, dynamic>? config,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', user['nombre'] ?? '');

    switch (idRole) {
      case "1": // ------------------------------------------------------------------- Admin
        final nombre = user['nombre'];
        if (nombre == "") {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (_) => PP_Nombre_Screen()),
          );
          return;
        }

        if (_isConfigComplete(config)) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Home_Admin()),
            (route) => false,
          );
        } else {
          _showDialog(context, 'Bienvenido', 'No configurado sucursales, etc.');
        }
        break;

      case "2": // ----------------------------------------------------------------------- Molinero
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Molinero_Screen()),
          (route) => false,
        );
        break;

      // Agrega aquí más roles si lo necesitas
      default:
        _showDialog(context, 'Error', 'Rol no reconocido.');
    }
  }

  static bool _isConfigComplete(Map<String, dynamic>? config) {
    if (config == null) return false;
    return config.values.every((value) => value == 1);
  }

  static void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Aceptar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
