import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/PrimerosPasos/PP_Model.dart';
import 'package:tortillapp/models/Register/RegisterModel.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/SucursalScreen.dart';
import 'package:tortillapp/screens/Register/RegisterPassword.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class PP_Productos_Screen extends StatefulWidget {
  @override
  _PP_Productos_ScreenState createState() => _PP_Productos_ScreenState();
}

class _PP_Productos_ScreenState extends State<PP_Productos_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _tiendaController = TextEditingController();
  final TextEditingController _publicoController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isKeyboardVisible = false;

  List<Map<String, dynamic>> productos = [
  {
    "id": 1,
    "nombre": "Salsa de tomate",
    "precio": 10.5,
  },
  {
    "id": 2,
    "nombre": "Salsa de d",
    "precio": 10.5,
  }
];

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
    _progressAnimation = Tween(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Usa una curva más suave
      ),
    );

    // Agregar un listener al controlador de texto
    _tiendaController.addListener(_updateProgress);
    _publicoController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _tiendaController.removeListener(_updateProgress);
    _publicoController.removeListener(_updateProgress);

    _tiendaController.dispose();
    _publicoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    // Verificar si el campo de email está lleno y el campo de publico
    if (_tiendaController.text.isNotEmpty &&
        _publicoController.text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
      _animationController.forward();
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

  void _savePrice() {
    //Verificar que no este vacio
    if (_tiendaController.text.isEmpty) {
      _showCupertinoDialog(
          'Error', 'Por favor, ingresa el nombre de tu negocio.');
      return;
    }
    if (_publicoController.text.isEmpty) {
      _showCupertinoDialog('Error', 'Por favor, ingresa el precio al público.');
      return;
    }
    //Guardar el nombre en el modelo
    pp_model.setPrecioPublico(double.parse(_publicoController.text));
    pp_model.setPrecioTienda(double.parse(_tiendaController.text));
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PP_Sucursal_Screen();
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
                                      'lib/assets/icons/product_icon.svg',
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
                                text: "Productos",
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Subtittle(
                                text: 'Todo los productos adicionales (0)',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            //AQui el containter conla lista de productos
                            SizedBox(height: 15),
Container(
  padding: EdgeInsets.all(0),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 85, 66, 66),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        spreadRadius: 2,
      ),
    ],
  ),
  child: Column(
    children: [
      Container(
        height: 150, // Altura ajustable
        child: ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity, // Ocupa todo el ancho disponible
              decoration: BoxDecoration(
                color: Color(0xFFEBF1FD), // Fondo del ítem
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xFFDDE5FD)), // Borde
              ),
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 16), // Aumento el espacio lateral
              child: ListTile(
                contentPadding: EdgeInsets.zero, // Evita márgenes internos
                leading: SvgPicture.asset(
                  "lib/assets/icons/etiqueta_icon.svg",
                  width: 24, // Ajusta el tamaño según sea necesario
                  height: 24,
                  colorFilter: ColorFilter.mode(Color(0xFF1B374D), BlendMode.srcIn), // Color del ícono
                ),
                title: Text(productos[index]["nombre"]),
                subtitle: Text("\$${productos[index]["precio"].toString()}"),
                trailing: Icon(Icons.delete, color: Color(0xFFABB9D4)), // Ícono de eliminar
                onTap: () {
                  // Acción al tocar el producto
                },
              ),
            );
          },
        ),
      ),
    ],
  ),
),
                            Spacer(),
                            CustomWidgets().ButtonSecondary(
                              text: 'Agregar producto',
                              onPressed: () {
                                
                              },
                            ),
                            SizedBox(height: 10),
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
                                  _savePrice();
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
