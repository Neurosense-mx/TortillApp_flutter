import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/PrimerosPasos/PP_Model.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/NegocioScreen.dart';
import 'package:tortillapp/screens/Register/RegisterPassword.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class PP_Nombre_Screen extends StatefulWidget {
  final dynamic id_Cuenta;

  const PP_Nombre_Screen({super.key, required this.id_Cuenta});

  @override
  _PP_Nombre_ScreenState createState() => _PP_Nombre_ScreenState();
}

class _PP_Nombre_ScreenState extends State<PP_Nombre_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _nombreController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isKeyboardVisible = false;

  var _nombre = "";

  //Instanciar el modelo
  final PP_Model pp_model = PP_Model();

  @override
  void initState() {
    super.initState();
    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.0, end: 0.14).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );

    // Agregar un listener al controlador de texto
    _nombreController.addListener(_updateProgress);

    // Espera 2 segundos antes de mostrar el diálogo
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        // Verifica que el widget aún esté en pantalla
        _showCupertinoDialog('¡Bienvenido a TortillApp!',
            'Vamos a configurar tu cuenta. Empieza por decirnos tu nombre, por favor que no exceda de 13 caracteres.');
      }
    });
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _nombreController.removeListener(_updateProgress);
    _nombreController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    setState(() {
      _nombre = _nombreController.text.length > 13
          ? _nombreController.text.substring(0, 13)
          : _nombreController.text;
    });

    // Verificar si el campo de email está lleno
    if (_nombreController.text.isEmpty) {
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

  Future<void> _guardarNombre() async {
    //Verificar que no este vacio
    if (_nombreController.text.isEmpty) {
      _showCupertinoDialog('Error', 'El nombre no puede estar vacío.');
    }
    //Verificar si el nombre es mayor a 13 caracteres
    if (_nombreController.text.length > 13) {
      _showCupertinoDialog(
          'Error', 'El nombre no puede ser mayor a 13 caracteres.');
    } else {
      //Guardar el nombre en el modelo
      pp_model.setNombre(_nombreController.text);

      //SETEAR EL ID DE CUENTA
      pp_model.setID_Cuenta(widget.id_Cuenta);

      //Mostrar la siguiente pantalla PP_Negocio_Screen()
      await _animationController.forward();

      // Navegar a la siguiente pantalla
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return PP_Negocio_Screen(pp_model: pp_model);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Deslizar desde la derecha
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }
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
                                      'lib/assets/icons/icon_person.svg',
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
                                text: 'Hola, ',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Tittle(
                                text: _nombre,
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Subtittle(
                                text: '¿Cúal es tú nombre?',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 30),
                            CustomWidgets().TextfieldPrimary(
                              controller: _nombreController,
                              label: 'Nombre',
                              hasIcon: true,
                              icon: Icons.person,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 20),
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
                                  _guardarNombre();
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
