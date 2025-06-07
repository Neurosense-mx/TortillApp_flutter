import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/models/Mostrador/ModelMostrador.dart';
import 'package:tortillapp/widgets/widgets.dart';

class AddSobrantesScreen extends StatefulWidget {
  final MostradorModel mostrador;
  
  const AddSobrantesScreen({Key? key, required this.mostrador}) : super(key: key);
  
  @override
  _AddSobrantesScreenState createState() => _AddSobrantesScreenState();
}

class _AddSobrantesScreenState extends State<AddSobrantesScreen> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();
  
  final TextEditingController _kgTortillaController = TextEditingController();
  final List<String> sugerencias = ["2kg", "3kg", "5kg", "8kg", "10kg"];

  Future<void> _guardarSobrantes() async {
    // Validar si el campo de texto está vacío
    String texto = _kgTortillaController.text.trim();
    // Reemplazar coma por punto
    texto = texto.replaceAll(',', '.');

    if (_kgTortillaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa la cantidad de tortillas')),
      );
      return;
    }
    
    // Intentamos convertir el texto a doble y verificamos
    final sobrantes = double.tryParse(texto);
    if (sobrantes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El valor ingresado no es válido')),
      );
      return;
    }

    // Intentamos guardar y mostramos el resultado
    bool response = await widget.mostrador.addSobrantes(sobrantes);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response
            ? '¡Sobrante de ${_kgTortillaController.text} registrado correctamente!'
            : 'Ocurrió un error al guardar'),
        backgroundColor: response ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
    //limpiar el campo de texto
    _kgTortillaController.clear();
  }
  
  @override
  void dispose() {
    _kgTortillaController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final anchoContenedor = MediaQuery.of(context).size.width * 0.8;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Sobrantes',
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: colores.colorPrincipal),
        ),
      ),
      body: Center(
        child: Container(
          width: anchoContenedor,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customWidgets.Subtittle(
                  text: "Cantidad de kilogramos:",
                  color: colores.colorPrincipal),
              const SizedBox(height: 40),
              customWidgets.TextfieldNumber(
                controller: _kgTortillaController,
                label: "Kilos de tortilla",
                hasIcon: true,
                icon: Icons.circle,
              ),
              const SizedBox(height: 20),
              // Sección de sugerencias con scroll horizontal
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: sugerencias.map((valor) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colores.colorFondo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        onPressed: () {
                          _kgTortillaController.text =
                              valor.replaceAll('kg', '');
                        },
                        child: Text(valor,
                            style: const TextStyle(color: Colors.black)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              // Botón final alineado en la parte inferior
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: customWidgets.ButtonPrimary(
                    text: 'Finalizar',
                    icon: const Icon(Icons.trending_down),
                    onPressed: () {
                      if (_kgTortillaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ingresa la cantidad de tortillas'),
                          ),
                        );
                      } else {
                        _guardarSobrantes();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
