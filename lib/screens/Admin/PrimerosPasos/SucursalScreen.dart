import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/PrimerosPasos/PP_Model.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/Maps.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/PreciosScreen.dart';
import 'package:tortillapp/screens/Register/RegisterPassword.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class PP_Sucursal_Screen extends StatefulWidget {
  @override
  _PP_Sucursal_ScreenState createState() => _PP_Sucursal_ScreenState();
}

class _PP_Sucursal_ScreenState extends State<PP_Sucursal_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _nombreNegocioController =
      TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isKeyboardVisible = false;

  double latitude = 0.0;
  double longitude = 0.0;

  late bool serviceEnabled;
  late LocationPermission permission;
  //Instanciar el modelo
  final PP_Model pp_model = PP_Model();

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();

    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.28, end: 0.42).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );

    // Agregar un listener al controlador de texto
    _nombreNegocioController.addListener(_updateProgress);


    Future.delayed(Duration(seconds: 1), () {
    if (mounted) { // Asegura que el widget aún esté en pantalla antes de ejecutar
      _showCupertinoDialog(
      'Configuración de negocio', 
      'Excelente, ahora registra el nombre de tu sucursal y selecciona la ubicación.'
    );
    }
  });
  }

  Future<void> _checkAndRequestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Los permisos fueron denegados.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Los permisos fueron denegados permanentemente.");
      return;
    }
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _nombreNegocioController.removeListener(_updateProgress);
    _nombreNegocioController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    // Verificar si el campo de email está lleno
    if (_nombreNegocioController.text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
     // _animationController.forward();
    } else {
      // Reiniciar la animación al valor inicial
      _animationController.reverse();
    }
  }

  // Método para mostrar el dialogo en caso de error
  void _showCupertinoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeIn,
          )),
          child: CupertinoAlertDialog(
            title: Text(title, style: TextStyle(fontSize: 18)),
            content: Text('\n' + message, style: TextStyle(fontSize: 15)),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el diálogo
                },
                child: Text('Aceptar',
                    style: TextStyle(color: colores.colorPrincipal)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveSucursal() async {
    //Verificar que no este vacio
    if (_nombreNegocioController.text.isEmpty) {
      _showCupertinoDialog(
          'Error', 'Por favor, ingresa el nombre de tu negocio.');
      return;
    }

    //verificar que latitud y longitud no esten vacios
    if (latitude == 0.0 || longitude == 0.0) {
      _showCupertinoDialog(
          'Error', 'Por favor, selecciona la ubicación de tu negocio.');
      return;
    }

    //Guardar el nombre en el modelo
    pp_model.setNombreSucursal(_nombreNegocioController.text);
    pp_model.setLatitud(latitude);
    pp_model.setLongitud(longitude);

    //Ir a la siguiente pantalla
   await _animationController.forward();
  Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return PP_Precio_Screen();
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Deslizar desde la derecha
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );

  }

void _goToMap() async {
   _checkAndRequestPermissions();

    // Verificar si el GPS está activado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("El GPS está apagado. Actívalo e intenta de nuevo.");
      return;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Los permisos fueron denegados.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Los permisos están bloqueados. Habilítalos manualmente.");
      return;
    }

    // Obtener ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    
    var latitude_actual = position.latitude;
    var longitude_actual = position.longitude;

    LatLng currentLocation = LatLng(latitude_actual, longitude_actual);
  print("------------------------------------------------------------------INICIO");
  
  final LatLng? selectedLocation = await Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return MapScreen(initialLocation: currentLocation);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Deslizar desde la derecha
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
  setState(() {
    latitude = selectedLocation!.latitude;
    longitude = selectedLocation.longitude;
  });
  print("------------------------------------------------------------------");
  if (selectedLocation != null) {
    print("Ubicación seleccionada: ${selectedLocation.latitude}, ${selectedLocation.longitude}");
  }
}


  Future<void> _getLocationNow() async {
    _checkAndRequestPermissions();

    // Verificar si el GPS está activado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("El GPS está apagado. Actívalo e intenta de nuevo.");
      return;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Los permisos fueron denegados.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Los permisos están bloqueados. Habilítalos manualmente.");
      return;
    }

    // Obtener ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("Ubicación actual: ${position.latitude}, ${position.longitude}");
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                setState(() {
                  _isKeyboardVisible =
                      MediaQuery.of(context).viewInsets.bottom > 0;
                });
                return false;
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Center(
                      // Aquí envolvemos todo en un Center para centrarlo
                      child: Container(
                        width: screenWidth *
                            0.8, // El ancho es el 80% del ancho de la pantalla
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 80),
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      child: CircularProgressIndicator(
                                        value: _progressAnimation.value,
                                        backgroundColor: Color(0xFFF1F1F3),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                colores.colorPrincipal),
                                        strokeWidth: 5.0,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'lib/assets/icons/marker_icon.svg',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 50),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Tittle(
                                text: "Sucursal",
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Subtittle(
                                text:
                                    'Latitud: $latitude, \nLongitud: $longitude',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Subtittle(
                                text: 'Ingresa el nombre de la sucursal.',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 20),
                            CustomWidgets().TextfieldPrimary(
                              controller: _nombreNegocioController,
                              label: 'Nombre',
                              hasIcon: true,
                              icon: Icons.store,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 20),
                            CustomWidgets().ButtonSecondary(
                              text: 'Usar ubicación actual',
                              onPressed: () {
                                _getLocationNow();
                              },
                            ),
                            SizedBox(height: 20),
                            CustomWidgets().ButtonSecondary(
                              text: 'Seleccionar en el mapa',
                              onPressed: () {
                                _goToMap();
                              },
                            ),
                            Spacer(),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),

                              height: _isKeyboardVisible
                                  ? 30
                                  : 50, // Reduce tamaño cuando teclado está abierto

                              width: double.infinity,
                              child: CustomWidgets().ButtonPrimary(
                                text: 'Continuar',
                                onPressed: () {
                                  // Acción del botón
                                  _saveSucursal();
                                },
                              ),
                            ),
                            SizedBox(height: keyboardHeight > 0 ? 30 : 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
