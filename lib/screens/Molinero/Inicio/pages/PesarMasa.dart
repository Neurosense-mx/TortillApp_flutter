import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tortillapp/models/Molinero/MolineroModelo.dart';
import 'package:tortillapp/widgets/widgets.dart';
import 'package:tortillapp/config/paletteColor.dart';

class PesarMasa extends StatefulWidget {
  final MostradorModel molino;

  const PesarMasa({Key? key, required this.molino}) : super(key: key);

  @override
  State<PesarMasa> createState() => _PesarMasaState();
}

class _PesarMasaState extends State<PesarMasa> {
  final PaletaDeColores colores = PaletaDeColores();
  final CustomWidgets customWidgets = CustomWidgets();

  final TextEditingController _kgMasa = TextEditingController();
  List<Map<String, dynamic>> maizRegistrado = [];
  int? _selectedMaizId;
  String? _selectedKg;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaizRegistrado();
  }

  Future<void> _loadMaizRegistrado() async {
    try {
      final data = await widget.molino.getMaizSinPesar();
      if (!mounted) return;

      final lista = data.map<Map<String, dynamic>>((item) {
        return {
          "id": item["id"],
          "fecha": DateFormat('dd/MM/yyyy HH:mm')
              .format(DateTime.parse(item["fecha"])),
          "kg": item["kg_cocidos"].toString()
        };
      }).toList();

      setState(() {
        maizRegistrado = lista;
        if (maizRegistrado.isNotEmpty) {
          _selectedMaizId = maizRegistrado[0]["id"];
          _selectedKg = maizRegistrado[0]["kg"];
        }
        _isLoading = false;
      });
    } catch (e) {
      print("Error al cargar maíz registrado: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _guardarPeso() async {
    final pesoText = _kgMasa.text.trim();
    if (pesoText.isEmpty || _selectedMaizId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa la cantidad de maíz')),
      );
      return;
    }

    final kg = double.tryParse(pesoText);
    if (kg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El peso ingresado no es válido')),
      );
      return;
    }

    final success = await widget.molino.pesarMasa(_selectedMaizId!, kg);
    //si fue exitoso, limpiar el campo de texto y actualizar la lista

    if (success) {
      _kgMasa.clear();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Peso de masa registrado exitosamente!',
        title: '¡Éxito!',
        confirmBtnText: 'Aceptar',
        onConfirmBtnTap: () {
          Navigator.pop(context); // cerrar esta pantalla
          //cerrar ventana
          Navigator.pop(context);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ocurrió un error al guardar'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _kgMasa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anchoContenedor = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Pesar Masa',
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
          icon: Icon(Icons.arrow_back, color: colores.colorPrincipal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : maizRegistrado.isEmpty
              ? const Center(
                  child: Text('No hay registros de maíz cocido sin pesar.'))
              : Center(
                  child: Container(
                    width: anchoContenedor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        customWidgets.Subtittle(
                          text: 'Por favor registra el peso de la masa (kg)',
                          color: colores.colorPrincipal,
                        ),
                        const SizedBox(height: 40),
                        customWidgets.TextfieldNumber(
                          controller: _kgMasa,
                          label: "Peso",
                          hasIcon: true,
                          icon: Icons.scale,
                        ),
                        const SizedBox(height: 40),
                        customWidgets.DropdownPrimary(
                          value: (_selectedMaizId ?? maizRegistrado[0]['id'])
                              as int,
                          items: maizRegistrado.map((maiz) {
                            return DropdownMenuItem<int>(
                              value: maiz['id'],
                              child:
                                  Text('${maiz['fecha']} - ${maiz['kg']} kg'),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedMaizId = newValue;
                              _selectedKg = maizRegistrado.firstWhere(
                                  (maiz) => maiz['id'] == newValue)['kg'];
                            });
                          },
                          label: 'Selecciona Maíz',
                          hasIcon: true,
                          icon: Icons.event_note,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: customWidgets.ButtonPrimary(
                              text: 'Guardar',
                              onPressed: _guardarPeso,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }
}
