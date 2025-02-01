import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tortillapp/screens/Splashscreen/Splashscreen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Solo permite la orientación vertical normal
  ]).then((_) {
    runApp(MyApp());
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TortillApp',
      initialRoute: '/splashscreen', // Ruta inicial
      debugShowCheckedModeBanner: false,
      routes: {
        '/splashscreen': (context) => SplashScreen(), // Ruta para la pantalla de información
      },
    );
  }
}
//SplashScreen
//InfoScreen