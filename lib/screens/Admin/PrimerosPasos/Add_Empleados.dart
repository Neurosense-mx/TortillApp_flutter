import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar JSON
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:tortillapp/config/backend.dart';

class PP_AddEmpleados_Screen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave; // Callback para guardar el empleado
  final String dominoname; // Agregamos este nuevo parámetro

  PP_AddEmpleados_Screen({required this.onSave, required this.dominoname}); // Recibir el callback

  @override
  _PP_AddEmpleados_ScreenState createState() => _PP_AddEmpleados_ScreenState();
}

class _PP_AddEmpleados_ScreenState extends State<PP_AddEmpleados_Screen>
    with SingleTickerProviderStateMixin {
  final PaletaDeColores colores = PaletaDeColores();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isKeyboardVisible = false;

  // Variables para manejar los puestos
  List<Map<String, dynamic>> _puestos = []; // Lista de puestos
  int? _selectedPuestoId; // ID del puesto seleccionado

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
    _emailController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);

    // Obtener los puestos al iniciar la pantalla
    _fetchPuestos();
  }

  @override
  void dispose() {
    // Limpiar el listener y el AnimationController
    _nombreController.removeListener(_updateProgress);
    _emailController.removeListener(_updateProgress);
    _passwordController.removeListener(_updateProgress);

    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Método para obtener los puestos desde el backend
Future<void> _fetchPuestos() async {
  final url = Uri.parse(ApiConfig.backendUrl + '/admin/puestos'); // URL del backend
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _puestos = List<Map<String, dynamic>>.from(data['puestos'])
            .where((puesto) => puesto['nombre'].toLowerCase() != 'admin') // Filtrar "admin"
            .map((puesto) => {
                  'id': puesto['id'],
                  'nombre': puesto['nombre'].toUpperCase(), // Convertir a uppercase
                  'descripcion': puesto['descripcion']
                })
            .toList();
      });
    } else {
      _showCupertinoDialog('Error', 'No se pudieron obtener los puestos.');
    }
  } catch (e) {
    _showCupertinoDialog('Error', 'Error de conexión: $e');
  }
}


  void _updateProgress() {
    // Verificar si los campos están llenos
    if (_nombreController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
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

  void _saveEmpleado() {
    // Verificar que los campos no estén vacíos
    if (_nombreController.text.isEmpty) {
      _showCupertinoDialog('Error', 'Por favor, ingresa el nombre del empleado.');
      return;
    }
    if (_emailController.text.isEmpty) {
      _showCupertinoDialog('Error', 'Por favor, ingresa el correo electrónico.');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showCupertinoDialog('Error', 'Por favor, ingresa la contraseña.');
      return;
    }
    // Verificar que las contraseñas coincidan
    if (_passwordController.text != _confirmPasswordController.text) {
      _showCupertinoDialog('Error', 'Las contraseñas no coinciden.');
      return;
    }
    // Verificar que se haya seleccionado un puesto
    if (_selectedPuestoId == null) {
      _showCupertinoDialog('Error', 'Por favor, selecciona un puesto.');
      return;
    }

    // Crear un mapa con los datos del nuevo empleado
    Map<String, dynamic> nuevoEmpleado = {
      "id": DateTime.now().millisecondsSinceEpoch, // Generar un ID único
      "name": _nombreController.text,
      "email": _emailController.text + '@' + widget.dominoname + '.com',
      "password": _passwordController.text,
      "puesto_id": _selectedPuestoId, // Incluir el ID del puesto seleccionado
      "puesto": _puestos.firstWhere((puesto) => puesto['id'] == _selectedPuestoId)['nombre'],
    };

    // Llamar al callback con el nuevo empleado
    widget.onSave(nuevoEmpleado);

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
          'Agregar nuevo empleado',
          style: TextStyle(
            color: colores.colorPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colores.colorFondo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colores.colorPrincipal,
          ),
          onPressed: () {
            Navigator.pop(context);
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
                        width: screenWidth * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidgets().Subtittle(
                                text: 'Completa la información del nuevo empleado: ',
                                color: colores.colorPrincipal,
                              ),
                            ),
                            SizedBox(height: 30),
                            CustomWidgets().TextfieldPrimary(
                              controller: _nombreController,
                              label: 'Nombre del empleado',
                              hasIcon: true,
                              icon: Icons.person,
                            ),
                            SizedBox(height: 20),
                            // Combo para seleccionar el puesto
                           DropdownButtonFormField<int>(
  value: _selectedPuestoId,
  decoration: InputDecoration(
    labelText: 'Selecciona un puesto',
    labelStyle: TextStyle(color: colores.colorNegro),
    filled: true,
    fillColor: colores.colorInputs,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colores.colorContornoBlanco, width: 0),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colores.colorPrincipal, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
  ),
  items: _puestos.map((puesto) {
    return DropdownMenuItem<int>(
      value: puesto['id'],
      child: Text(
        puesto['nombre'],
        style: TextStyle(
          color: colores.colorNegro,
          fontSize: 16,
        ),
      ),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedPuestoId = value;
    });
  },
  dropdownColor: colores.colorInputs,
  icon: Icon(Icons.arrow_drop_down, color: colores.colorPrincipal),
  style: TextStyle(
    color: colores.colorNegro,
    fontSize: 16,
  ),
),

                            SizedBox(height: 20),
                            CustomWidgets().TextfieldPrimary(
                              controller: _emailController,
                              label: 'Nombre de usuario',
                              hasIcon: true,
                              icon: Icons.email,
                            ),
                            SizedBox(height: 20),
                            CustomWidgets().TextfieldPass(
                              controller: _passwordController,
                              label: 'Contraseña',
                              hasIcon: true,
                              icon: Icons.lock,
                            ),
                            SizedBox(height: 20),
                            CustomWidgets().TextfieldPass(
                              controller: _confirmPasswordController,
                              label: 'Confirmar contraseña',
                              hasIcon: true,
                              icon: Icons.lock,
                            ),
                            SizedBox(height: 20),
                            Spacer(),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: _isKeyboardVisible ? 30 : 50,
                              width: double.infinity,
                              child: CustomWidgets().ButtonPrimary(
                                text: 'Agregar empleado',
                                onPressed: () {
                                  _saveEmpleado();
                                },
                              ),
                            ),
                            SizedBox(height: keyboardHeight > 0 ? keyboardHeight + 10 : 30),
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