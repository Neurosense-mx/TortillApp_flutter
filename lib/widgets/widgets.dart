import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomWidgets extends StatelessWidget {
  final PaletaDeColores colores = PaletaDeColores();
  bool _isPasswordVisible = false;

  // Método para TextField con icono opcional
  Widget TextfieldPrimary({
    required TextEditingController controller,
    required String label,
    bool hasIcon = false,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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
        prefixIcon: hasIcon
            ? Icon(
                icon,
                color: colores.colorInputsIcon,
              )
            : null,
      ),
      keyboardType: keyboardType,
      cursorColor: colores.colorPrincipal,
    );
  }

  Widget TextfieldNumber({
    required TextEditingController controller,
    required String label,
    bool hasIcon = false,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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
        prefixIcon: hasIcon
            ? Icon(
                icon,
                color: colores.colorInputsIcon,
              )
            : null,
      ),
      keyboardType: TextInputType.number,
      cursorColor: colores.colorPrincipal,
    );
  }

  // Método para TextField de tipo Password (TextfieldPass)
  Widget TextfieldPass({
    required TextEditingController controller,
    required String label,
    bool hasIcon = false,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colores.colorNegro),
        filled: true,
        fillColor: colores.colorInputs,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colores.colorContornoBlanco, width: 0),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colores.colorPrincipal, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        prefixIcon: hasIcon
            ? Icon(
                icon,
                color: colores.colorInputsIcon,
              )
            : null,
      ),
      cursorColor: colores.colorPrincipal,
    );
  }

  // Método para ElevatedButton
  Widget ButtonPrimary({
    required String text,
    required VoidCallback onPressed,
    Icon? icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: colores.colorFondo,
        backgroundColor: colores.colorPrincipal,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Método para ElevatedButton con borde de 1px de color.colorPrincipal
  Widget ButtonSecondary({
    required String text,
    required VoidCallback onPressed,
    Icon? icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: colores.colorPrincipal,
        backgroundColor: colores.colorFondo,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: colores.colorPrincipal,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Tittle widget
  Widget Tittle({required String text, required Color color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget Tittle_28({required String text, required Color color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  // Subtittle widget
  Widget Subtittle({required String text, required Color color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: color,
      ),
    );
  }

  Widget Puesto({
    required String text,
    String? icon,
    Color? color,
    double? maxWidth, // Añadimos un parámetro opcional para definir el maxWidth
  }) {
    return GestureDetector(
      onTap: () {
        // Si deseas manejar algún evento al presionar, lo puedes hacer aquí
        print("Elemento presionado");
      },
      child: Align(
        alignment: Alignment.centerLeft, // Alineación a la izquierda
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: maxWidth ??
                200, // Definir el maxWidth, si no se pasa, se usa 300 por defecto
          ),
          decoration: BoxDecoration(
            color: color ?? colores.colorFondo,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colores.colorInputs),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 10.0), // Espacio entre el icono y el texto
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  color: colores.colorPrincipal, // Color del texto
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Metodo para Button de menu
  Widget ButtonMenu({
    required String text,
    required VoidCallback onPressed,
    String? icon,
    Color? color, // Parámetro para personalizar el color
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: colores.colorFondo,
        backgroundColor:
            color ?? colores.colorPrincipal, // Utiliza el color si se pasa
        minimumSize: Size(150, 150), // Tamaño cuadrado del botón
        maximumSize: Size(150, 150),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Esquinas redondeadas
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            SvgPicture.asset(
              icon,
              width: 42,
              height: 42,
            ),
            SizedBox(height: 30.0),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white, // Color del texto
            ),
          ),
        ],
      ),
    );
  }

  Widget DropdownPrimary({
    required int value,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
    required String label,
    bool hasIcon = false,
    IconData? icon,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
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
        prefixIcon: hasIcon
            ? Icon(
                icon,
                color: colores.colorInputsIcon,
              )
            : null,
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: colores.colorInputs,
      icon: Icon(Icons.arrow_drop_down, color: colores.colorPrincipal),
      style: TextStyle(
        color: colores.colorNegro,
        fontSize: 16,
      ),
    );
  }

  // Widget para el dropdown de puestos
  Widget PuestosDropdown({
    required int value,
    required List<Map<String, dynamic>> puestos,
    required Function(int?) onChanged,
    required String label,
    bool hasIcon = false,
    IconData? icon,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
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
        prefixIcon: hasIcon
            ? Icon(
                icon,
                color: colores.colorInputsIcon,
              )
            : null,
      ),
      items: puestos.map((puesto) {
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
      onChanged: onChanged,
      dropdownColor: colores.colorInputs,
      icon: Icon(Icons.arrow_drop_down, color: colores.colorPrincipal),
      style: TextStyle(
        color: colores.colorNegro,
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
