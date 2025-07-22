import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/PrimerosPasos/PP_Model.dart';
import 'package:tortillapp/screens/Admin/Home/Home_Admin.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/Add_Empleados.dart'; // Importar la pantalla de agregar empleados
import 'package:tortillapp/screens/Admin/PrimerosPasos/ViewDataEmpleado.dart';
import 'package:tortillapp/screens/Login/Login.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';


class PP_Empleados_Screen extends StatefulWidget {
  final PP_Model pp_model;
  const PP_Empleados_Screen({super.key, required this.pp_model});

  @override
  _PP_Empleados_ScreenState createState() => _PP_Empleados_ScreenState();
}

class _PP_Empleados_ScreenState extends State<PP_Empleados_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _tiendaController = TextEditingController();
  final TextEditingController _publicoController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isKeyboardVisible = false;
  late ConfettiController _confettiController;
  late String _dominioname;
  List<Map<String, dynamic>> empleados = [];
bool _isContinueButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _dominioname = widget.pp_model.getDominio();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));

    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );

    // Agregar un listener al controlador de texto
    _tiendaController.addListener(_updateProgress);
    _publicoController.addListener(_updateProgress);

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        // Asegura que el widget aún esté en pantalla antes de ejecutar
        _showCupertinoDialog(
          'Configuración de empleados',
          'En esta sección podrás agregar empleados a tu sucursal. \n Puedes omitir este paso seleccionando el botón "Continuar", más adelante podrás agregarlos nuevamente.',
        );
      }
    });
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _tiendaController.removeListener(_updateProgress);
    _publicoController.removeListener(_updateProgress);
    _confettiController.dispose();
    _tiendaController.dispose();
    _publicoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showConfetti() {
    _confettiController.play();
  }

  void _updateProgress() {
    // Verificar si el campo de email está lleno y el campo de publico
    if (_tiendaController.text.isNotEmpty &&
        _publicoController.text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
      // _animationController.forward();
    } else {
      // Reiniciar la animación al valor inicial
      _animationController.reverse();
    }
  }

  // Método para mostrar el diálogo en caso de error
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

  // Método para mostrar el diálogo de confirmación antes de eliminar
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Eliminar empleado'),
          content: Text('¿Estás seguro de que deseas eliminar este empleado?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            CupertinoDialogAction(
              onPressed: () {
                // Eliminar el empleado de la lista
                setState(() {
                  empleados.removeAt(index);
                });
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _addEmpleado() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PP_AddEmpleados_Screen(
            onSave: (nuevoEmpleado) {
              setState(() {
                empleados.add(nuevoEmpleado);
              });
            },
            dominoname: _dominioname, // Pasa el valor aquí
            empleadosExistentes: empleados, // << Agrega esto
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
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

  Future<void> _continue() async {
    //pasar la lsita de empleados a models
    widget.pp_model.setEmpleados(empleados);
    //construir el json
    
    
    var response = await widget.pp_model.enviarData();
    print(response);
    if(response['statusCode'] == 200){
      setState(() {
    _isContinueButtonDisabled = true; // Deshabilita el botón
  });
     _showConfetti();
    await _animationController.forward();
    print("Se registró correctamente");
    
    //Delay para mostrar el confeti
    await Future.delayed(Duration(seconds: 4));
   
    Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => LoginScreen()), // PENDIENTE. IR AL LOGIN 
  (Route<dynamic> route) => false, // Esto elimina todas las rutas anteriores
);


    

  }
    
    //Enviar todo al server
   // _showConfetti();
    //await _animationController.forward();
    // Mostrar confeti
  }

  void _viewEmployeeDetails(int index) {
    // Obtener los datos del empleado
    Map<String, dynamic> empleado = empleados[index];
    // Navegar a la pantalla de detalles del empleado PP_Detalle_Empleado

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PP_Detalle_Empleado(
            nombre: empleado["name"],
            email: empleado["email"],
            password: empleado["password"],
            puesto: empleado["puesto"],
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.8;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              // Centra el contenido principal en la pantalla
              child: Container(
                width: screenWidth, // Ocupa el 80% del ancho de la pantalla
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    colores.colorPrincipal),
                                strokeWidth: 5.0,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            SvgPicture.asset(
                              'lib/assets/icons/user_icon.svg',
                              width: 40,
                              height: 40,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 50),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: _isKeyboardVisible ? 30 : 50,
                      width: screenWidth,
                      child: CustomWidgets().Tittle(
                        text: "Empleados",
                        color: colores.colorPrincipal,
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment
                          .centerLeft, // Alinea el texto a la izquierda
                      child: CustomWidgets().Subtittle(
                        text: 'Todos los empleados (${empleados.length})',
                        color: colores.colorPrincipal,
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        child: empleados.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: empleados.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEBF1FD),
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(color: Color(0xFFDDE5FD)),
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: SvgPicture.asset(
                                        "lib/assets/icons/user2_icon.svg",
                                        width: 24,
                                        height: 24,
                                        colorFilter: ColorFilter.mode(
                                            Color(0xFF1B374D), BlendMode.srcIn),
                                      ),
                                      title: Text(empleados[index]["name"]),
                                      subtitle: Text(empleados[index]["puesto"]
                                          .toString()),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Asegura que el Row no ocupe más espacio del necesario
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove_red_eye,
                                                color: Color(
                                                    0xFFABB9D4)), // Icono de ojo
                                            onPressed: () {
                                              // Acción para ver detalles del empleado
                                              _viewEmployeeDetails(index);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Color(
                                                    0xFFABB9D4)), // Icono de papelera
                                            onPressed: () {
                                              // Mostrar el diálogo de confirmación
                                              _showDeleteConfirmationDialog(
                                                  index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  "No hay empleados agregados",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: _isKeyboardVisible ? 30 : 50,
                      width: screenWidth,
                      child: CustomWidgets().ButtonSecondary(
                        text: 'Agregar empleado',
                        onPressed: () {
                          // Acción para agregar empleado
                          _addEmpleado();
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: _isKeyboardVisible ? 30 : 50,
                      width: screenWidth,
                      child: CustomWidgets().ButtonPrimary(
                        text: 'Continuar',
                        onPressed: () {
  if (!_isContinueButtonDisabled) {
    _continue();
  }
},             
                      ),
                    ),
                    SizedBox(height: 30),
                    Positioned(
                      top: -100, // Eleva el confeti más arriba de la pantalla
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirection: -pi / 2, // Hacia arriba
                          emissionFrequency: 0.06, // Frecuencia de partículas
                          numberOfParticles: 30, // Cantidad de partículas
                          gravity: 0.1, // Menos gravedad para que suban más
                          maxBlastForce:
                              30, // Aumenta la fuerza inicial del confeti
                          minBlastForce: 20, // Evita que caigan rápido
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Confetti Widget
          ],
        ),
      ),
    );
  }
}
