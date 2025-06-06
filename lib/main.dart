import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <-- IMPORTANTE
import 'package:tortillapp/screens/Splashscreen/Splashscreen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await _configureLocalNotifications();

  runApp(MyApp());
}

Future<void> _configureLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

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
      theme: ThemeData(
        // Personalización del esquema de colores
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 19, 33, 68)),
        useMaterial3: true, // Puedes poner false si usas Material 2
        // Opcionalmente, personaliza aún más:
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color.fromARGB(255, 15, 50, 87), // Color del CircularProgressIndicator
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStatePropertyAll(const Color.fromARGB(255, 9, 47, 76)), // Color del radio button
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      routes: {
        '/splashscreen': (context) => SplashScreen(),
      },

      // ✅ Agrega estas líneas:
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
