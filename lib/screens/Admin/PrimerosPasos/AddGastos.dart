import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para cargar el archivo SVG
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/widgets/widgets.dart';

class PP_AddGastos_Screen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave; // Callback para guardar el gasto

  PP_AddGastos_Screen({required this.onSave}); // Recibir el callback

  @override
  _PP_AddGastos_ScreenState createState() => _PP_AddGastos_ScreenState();
}

class _PP_AddGastos_ScreenState extends State<PP_AddGastos_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isKeyboardVisible = false;
  int _tipoGasto = 1; // 1: Fijo, 2: Variable

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
    _nombreController.addListener(_updateProgress);
    _descripcionController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _nombreController.removeListener(_updateProgress);
    _descripcionController.removeListener(_updateProgress);

    _nombreController.dispose();
    _descripcionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    // Verificar si los campos están llenos
    if (_nombreController.text.isNotEmpty && _descripcionController.text.isNotEmpty) {
      // Iniciar la animación hacia el 25%
      _animationController.forward();
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

  void _saveGasto() {
    // Verificar que los campos no estén vacíos
    if (_nombreController.text.isEmpty) {
      _showCupertinoDialog('Error', 'Por favor, ingresa el nombre del gasto.');
      return;
    }
    if (_descripcionController.text.isEmpty) {
      _showCupertinoDialog('Error', 'Por favor, ingresa la descripción del gasto.');
      return;
    }

    // Crear un mapa con los datos del nuevo gasto
    Map<String, dynamic> nuevoGasto = {
      "id": DateTime.now().millisecondsSinceEpoch, // Generar un ID único
      "nombre": _nombreController.text,
      "tipo_gasto": _tipoGasto,
      "descripcion": _descripcionController.text,
    };

    // Llamar al callback con el nuevo gasto
    widget.onSave(nuevoGasto);

    // Regresar a la pantalla anterior
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Agregar nuevo gasto',
          style: TextStyle(
            color: colores.colorPrincipal, // Color del texto
            fontSize: 18, // Tamaño del texto
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        backgroundColor: colores.colorFondo, // Color de fondo del AppBar
        elevation: 0, // Elimina la sombra del AppBar
        centerTitle: true, // Centra el título
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colores.colorPrincipal, // Color del ícono de retroceso
          ),
          onPressed: () {
            Navigator.pop(context); // Acción para volver atrás
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                setState(() {
                  _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
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
                      child: Container(
                        width: screenWidth * 0.8, // El ancho es el 80% del ancho de la pantalla
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Subtittle(
                                text: 'Completa la información del nuevo gasto',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 30),
                            CustomWidgets().TextfieldPrimary(
                              controller: _nombreController,
                              label: 'Nombre del gasto',
                              hasIcon: true,
                              icon: Icons.attach_money,
                            ),
                            SizedBox(height: 20),
                            CustomWidgets().TextfieldPrimary(
                              controller: _descripcionController,
                              label: 'Descripción',
                              hasIcon: true,
                              icon: Icons.description,
                            ),
                            SizedBox(height: 20),
                            CustomWidgets().DropdownPrimary(
  value: _tipoGasto,
  items: [
    DropdownMenuItem(value: 1, child: Text('Gasto fijo')),
    DropdownMenuItem(value: 2, child: Text('Gasto variable')),
  ],
  onChanged: (value) {
    setState(() {
      _tipoGasto = value!;
    });
  },
  label: 'Tipo de gasto',
  hasIcon: true,
  icon: Icons.category,
),
SizedBox(height: 20),
                            Spacer(),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: _isKeyboardVisible ? 30 : 50, // Reduce tamaño cuando teclado está abierto
                              width: double.infinity,
                              child: CustomWidgets().ButtonPrimary(
                                text: 'Agregar gasto',
                                onPressed: () {
                                  // Acción del botón
                                  _saveGasto();
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