import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/screens/Register/RegisterCode.dart';
import 'package:tortillapp/screens/Register/RegisterSucripcion.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class RegisterCode extends StatefulWidget {
  final RegisterModel registerModel;
  RegisterCode({required this.registerModel});

  @override
  _RegisterCodeState createState() => _RegisterCodeState();
}

class _RegisterCodeState extends State<RegisterCode>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _pass2Controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  String _email = "";

  final List<TextEditingController> _digitControllers =
      List.generate(4, (_) => TextEditingController());

 bool _isButtonDisabled = false; // Estado para deshabilitar el botón
  int _remainingTime = 0; // Tiempo restante en segundos
  Timer? _timer; // Temporizador
  
  @override
  void initState() {
    super.initState();
    _email = widget.registerModel.getEmail();
    widget.registerModel.sendCode(); // Enviar el código de confirmación

    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.50, end: 0.75).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );
    // Agregar listeners a los controladores de texto
    _digitControllers[3].addListener(_updateProgress);
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _digitControllers[3].removeListener(_updateProgress);
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateProgress() {
    // Verificar si el campo de email está lleno
    if (_digitControllers[3].text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
      _animationController.forward();
    } else {
      // Reiniciar la animación al valor inicial
      _animationController.reverse();
    }
  }

Future<void> _sendCode() async {
    if (_isButtonDisabled) return; // Evitar múltiples llamadas

    widget.registerModel.sendCode(); // Enviar el código de confirmación
    
    // Limpiar los campos de texto
    _digitControllers.forEach((controller) => controller.clear());

    // Mostrar un diálogo de aviso
    _showCupertinoDialog(
      'Código de confirmación enviado',
      'Se ha enviado un nuevo código de confirmación al correo electrónico.',
    );

    // Deshabilitar el botón y comenzar el temporizador
    setState(() {
      _isButtonDisabled = true;
      _remainingTime = 300; // 5 minutos en segundos
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        setState(() => _isButtonDisabled = false);
      }
    });
  }

  Future<void> _confirmCode() async {
    //Validar que los textcontroller no esten vacios
    if (_digitControllers[0].text.isEmpty ||
        _digitControllers[1].text.isEmpty ||
        _digitControllers[2].text.isEmpty ||
        _digitControllers[3].text.isEmpty) {
      _showCupertinoDialog(
        'Código de confirmación',
        'Por favor, ingresa el código de confirmación.',
      );
      return;
    }
    //obtener el codigo ingresado
    String codeScreen = _digitControllers[0].text +
        _digitControllers[1].text +
        _digitControllers[2].text +
        _digitControllers[3].text;
    //obtener el code del modelo
    String codeModel = widget.registerModel.getCode();
    //imprimir el codigo
    print('Código ingresado: $codeScreen');
    print('Código del modelo: $codeModel');

    // Verificar si el código ingresado es correcto(strings)
    if (codeScreen == codeModel) {
      // Si el código es correcto, navegar a la siguiente pantalla
     
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return RegisterSuscripcion(registerModel: widget.registerModel);
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
    } else {
      // Si el código es incorrecto, mostrar un diálogo de error
      _showCupertinoDialog(
        'Código de confirmación incorrecto',
        'El código de confirmación ingresado es incorrecto. Por favor, verifica e intenta de nuevo.',
      );
    }
    
  }

  // Método para mostrar el dialogo en caso de error
  void _showCupertinoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: TextStyle(fontSize: 18)),
          content: Text('\n' + message, style: TextStyle(fontSize: 15)),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text(
                'Aceptar',
                style: TextStyle(color: colores.colorPrincipal),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              width: screenWidth *
                  0.8, // Ajusta el contenedor para pantallas grandes
              constraints: BoxConstraints(
                  maxWidth:
                      400), // Limita el ancho máximo a 400px para teléfonos
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  // Usar AnimatedBuilder para optimizar la animación
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  colores.colorPrincipal),
                              strokeWidth: 5.0,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          // Agregar el icono dentro del progress bar
                          SvgPicture.asset(
                            'lib/assets/icons/code_icon.svg',
                            width: 40,
                            height: 40,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 50),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: CustomWidgets().Tittle(
                      text: 'Paso 3',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: CustomWidgets().Subtittle(
                      text:
                          'Se ha enviado un código de confirmación al correo:',
                      color: colores.colorPrincipal,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    _email,
                    style: TextStyle(
                      color: colores.colorPrincipal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 50,
                        height: 70,
                        child: TextField(
                          controller: _digitControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: colores.colorInputs,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: colores.colorContornoBlanco, width: 0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: colores.colorPrincipal, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          cursorColor: colores.colorPrincipal,
                          onChanged: (value) {
                            if (value.length == 1 && index < 3) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 50),
                  Text('Espera algunos segundos para recibir el código.'),
                  ElevatedButton(
  onPressed: _isButtonDisabled ? null : _sendCode,
  style: ElevatedButton.styleFrom(
    foregroundColor: colores.colorPrincipal,
    backgroundColor: colores.colorFondo, // Color de fondo
    minimumSize: Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Radio de borde
      side: BorderSide( // Define el borde de 1px con colorPrincipal
        color: colores.colorPrincipal,
        width: 1,
      ),
    ),
  ),
  
  child: Text(
    _isButtonDisabled ? 'Reenviar en $_remainingTime s' : 'Reenviar código',
    style: TextStyle(fontSize: 16),
  ),
),

                  SizedBox(height: 10),
                  CustomWidgets().ButtonPrimary(
                    text: 'Continuar',
                    onPressed: () {
                      _confirmCode();
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
