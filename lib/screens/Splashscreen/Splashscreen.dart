import 'package:flutter/material.dart';
import 'package:tortillapp/screens/Admin/Sucursales/Mis_Sucursales.dart';
import 'package:tortillapp/screens/Admin/Sucursales/PanelSucursal.dart';
import 'package:tortillapp/screens/Login/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Espera 3 segundos y luego navega a la siguiente pantalla
    Future.delayed(Duration(seconds: 3), () {
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));

     // Cambiar a la siguiente pantalla
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Panel_Sucursal()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo de color #FF3434
      backgroundColor: Color.fromARGB(255, 226, 226, 226),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height, // Ocupa el 100% del alto de la pantalla
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 0, 0, 0), // Color de fondo del contenedor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Agregar una imagen centrada
              Image.asset(
                'lib/assets/backgroundSplashScreen.png', // Reemplaza con la ruta de tu imagen
                height: MediaQuery.of(context).size.height * 0.5, // Personaliza la altura de la imagen
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}