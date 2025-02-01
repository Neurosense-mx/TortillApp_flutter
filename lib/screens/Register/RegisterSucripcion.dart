import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/screens/Login/Login.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class RegisterSuscripcion extends StatefulWidget {
  final RegisterModel registerModel;
  RegisterSuscripcion({required this.registerModel});

  @override
  _RegisterSuscripcionState createState() => _RegisterSuscripcionState();
}

class _RegisterSuscripcionState extends State<RegisterSuscripcion>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _pass1Controller = TextEditingController();
  final TextEditingController _pass2Controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  ValueNotifier<int?> _selectedSubscriptionId = ValueNotifier<int?>(null);

  List<Map<String, dynamic>> suscripciones = [
    {
      "id": 1,
      "nombre": "Básica",
      "precio": 0,
      "descuento": 0,
      "estado": 1,
    },
    {
      "id": 2,
      "nombre": "Standard",
      "precio": 300,
      "descuento": 0,
      "estado": 1,
    }
  ];

  @override
  void initState() {
    super.initState();

    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );

    // Agregar listeners a los ValueNotifier
    _selectedSubscriptionId.addListener(_updateProgress);
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _selectedSubscriptionId.removeListener(_updateProgress);
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    // Verificar si la suscripción ha sido seleccionada (es decir, si el ID no es null)
    if (_selectedSubscriptionId.value != null) {
      // Iniciar la animación hacia el 100% (o el valor deseado)
      _animationController.forward();
    } else {
      // Reiniciar la animación al valor inicial (o cualquier otro valor de tu elección)
      _animationController.reverse();
    }
  }

  Future<void> _confirmSuscripcion() async {
    //Validar que tenga una suscripción seleccionada
    if (_selectedSubscriptionId.value == null) {
      _showCupertinoDialog('Error', 'Por favor selecciona una suscripción.');
      return;
    }
    // Guardar el ID de la suscripción en el modelo
    widget.registerModel.id_suscription = _selectedSubscriptionId.value!;
    //enviar datos al backend para registrar el usuario
    final response = await widget.registerModel.sendRegister();
    // Verificar si la respuesta fue exitosa
    if (response['statusCode'] == 200) {
      // Mostrar un diálogo de éxito
      _showCupertinoDialog('Registro exitoso', response['message']);
        // Ir a la siguiente pantalla RegisterPassword()
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return LoginScreen(); // Aquí va tu pantalla de login
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0); // Deslizar desde la izquierda
        const end = Offset.zero;
        const curve = Curves.easeInOut;
  
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
  
        return SlideTransition(position: offsetAnimation, child: child); // Aplicar la animación de deslizamiento
      },
    ),
    (route) => false, // Elimina todas las pantallas anteriores
  );
     
    } else {
      // Mostrar un diálogo de error
      _showCupertinoDialog('Error', response['message']);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calcular el ancho máximo (el ancho máximo de un teléfono)
                      double maxWidth =
                          400; // Define un ancho máximo como el de un teléfono
                      double containerWidth = screenWidth * 0.8;
                      if (containerWidth > maxWidth) {
                        containerWidth =
                            maxWidth; // Limitar el ancho máximo en tabletas
                      }

                      return Container(
                        width: containerWidth,
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
                                      'lib/assets/icons/rocket_icon.svg',
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
                                text: 'Paso 4',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Subtittle(
                                text: 'Por favor selecciona una suscripción:',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: suscripciones.length,
                              itemBuilder: (context, index) {
                                final suscripcion = suscripciones[index];
                                bool isSelected =
                                    _selectedSubscriptionId.value ==
                                        suscripcion['id'];

                                return Card(
                                  elevation: isSelected ? 6 : 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: isSelected
                                          ? colores.colorPrincipal
                                          : Color.fromARGB(255, 190, 190, 190),
                                      width: 1,
                                    ),
                                  ),
                                  color: isSelected
                                      ? Colors.white
                                      : colores.colorFondo,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    title: Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        suscripcion['nombre'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? colores.colorPrincipal
                                              : colores.colorNegro,
                                        ),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          print(
                                              "Ver beneficios de ${suscripcion['nombre']}");
                                        },
                                        child: Text(
                                          "Ver beneficios",
                                          style: TextStyle(
                                            color: colores.colorPrincipal,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "\$${suscripcion['precio']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? colores.colorPrincipal
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: colores.colorPrincipal,
                                          ),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (_selectedSubscriptionId.value ==
                                            suscripcion['id']) {
                                          _selectedSubscriptionId.value = null;
                                        } else {
                                          _selectedSubscriptionId.value =
                                              suscripcion['id'];
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Botón alineado abajo con separación de 10px
            LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = 400; // Ancho máximo
                double buttonWidth = screenWidth * 0.8;
                if (buttonWidth > maxWidth) {
                  buttonWidth = maxWidth; // Limitar el ancho máximo en tabletas
                }
                return Container(
                  width: buttonWidth,
                  child: CustomWidgets().ButtonPrimary(
                    text: 'Finalizar',
                    onPressed: () {
                      _confirmSuscripcion();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
