import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/PrimerosPasos/PP_Model.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/Add_Productos.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/GastosScreen.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class PP_Productos_Screen extends StatefulWidget {
    final PP_Model pp_model;
  const PP_Productos_Screen({super.key, required this.pp_model});

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

  List<Map<String, dynamic>> productos = [];


  @override
  void initState() {
    super.initState();

    // Inicializar el AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700), // Ajusta la duración para suavizar
    );

    // Definir la animación con un Tween
    _progressAnimation = Tween(begin: 0.56, end: 0.7).animate(
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
          'Configuración de productos',
          'En esta sección podrás agregar los productos que ofreces en tu negocio adicionales a las tortillas. \n Puedes omitir este paso seleccionando el botón "Continuar", más adelante podrás agregarlos nuevamente.',
        );
      }
    });
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
    if (_tiendaController.text.isNotEmpty && _publicoController.text.isNotEmpty) {
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

  Future<void> _continuar() async {
    // Almacenar los productos en el modelo
    widget.pp_model.setProductos(productos);

    await _animationController.forward();
    // Validar si animación está completa

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PP_Gastos_Screen(pp_model: widget.pp_model,);
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

  void _addProductos() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PP_AddProductos_Screen(
            onSave: (nuevoProducto) {
              // Agregar el nuevo producto a la lista
              setState(() {
                productos.add(nuevoProducto);
              });
            },
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0); // Deslizar desde la izquierda
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación antes de eliminar
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Eliminar producto'),
          content: Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            CupertinoDialogAction(
              onPressed: () {
                // Eliminar el producto de la lista
                setState(() {
                  productos.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.8;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      body: SafeArea(
        child: Center(
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
                            valueColor: AlwaysStoppedAnimation<Color>(colores.colorPrincipal),
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isKeyboardVisible ? 30 : 50,
                  width: screenWidth,
                  child: CustomWidgets().Tittle(
                    text: "Productos",
                    color: colores.colorPrincipal,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
                  child: CustomWidgets().Subtittle(
                    text: 'Todos los productos (${productos.length})',
                    color: colores.colorPrincipal,
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: Container(
                    width: screenWidth,
                    child: productos.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: productos.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEBF1FD),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xFFDDE5FD)),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SvgPicture.asset(
                                    "lib/assets/icons/etiqueta_icon.svg",
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(Color(0xFF1B374D), BlendMode.srcIn),
                                  ),
                                  title: Text(productos[index]["nombre"]),
                                  subtitle: Text("\$${productos[index]["precio"].toString()}"),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Color(0xFFABB9D4)),
                                    onPressed: () {
                                      // Mostrar el diálogo de confirmación
                                      _showDeleteConfirmationDialog(index);
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No hay productos agregados",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
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
                    text: 'Agregar producto',
                    onPressed: () {
                      // Acción para agregar producto
                      _addProductos();
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
                      _continuar();
                    },
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}