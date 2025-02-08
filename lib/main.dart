import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tortillapp/screens/Splashscreen/Splashscreen.dart';

// Instancia global del plugin de notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura la orientación de la pantalla
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Solo permite la orientación vertical normal
  ]);

  // Configura el plugin de notificaciones locales
  await _configureLocalNotifications();

  runApp(MyApp());
}

// Función para configurar las notificaciones locales
Future<void> _configureLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // Ícono de la app

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TortillApp',
      initialRoute: '/splashscreen', // Ruta inicial
      debugShowCheckedModeBanner: false,
      routes: {
        '/splashscreen': (context) => SplashScreen(), // Ruta para la pantalla de Splash
      },
    );
  }
}