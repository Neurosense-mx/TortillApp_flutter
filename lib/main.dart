import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <-- IMPORTANTE
import 'package:tortillapp/config/paletteColor.dart';
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
  final PaletaDeColores colores = PaletaDeColores();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TortillApp',
      theme: ThemeData(
        // Personalización del esquema de colores
        colorScheme: ColorScheme.fromSeed(seedColor: colores.colorPrincipal),
        useMaterial3: true, // Puedes poner false si usas Material 2
        // Opcionalmente, personaliza aún más:
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colores.colorPrincipal // Color del CircularProgressIndicator
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStatePropertyAll(colores.colorPrincipal), // Color del radio button
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
       
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
