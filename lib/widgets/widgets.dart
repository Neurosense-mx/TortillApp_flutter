import 'package:flutter/material.dart';
import 'package:tortillapp/config/paletteColor.dart';

class CustomWidgets extends StatelessWidget {
  final PaletaDeColores colores = PaletaDeColores();

  // Método para TextField con icono opcional
  Widget TextfieldPrimary({
    required TextEditingController controller,
    required String label,
    bool hasIcon = false, // Parámetro para decidir si tiene ícono
    IconData? icon, // Parámetro para el icono, si se pasa
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
        contentPadding: EdgeInsets.symmetric(
            vertical: 9, horizontal: 12), // Ajusta el alto aquí
        prefixIcon: hasIcon
            ? Icon(
                icon, // Si tiene ícono, lo pasa
                color: colores.colorInputsIcon,
              )
            : null, // Si no tiene ícono, no se pasa nada
      ),
      keyboardType: keyboardType,
      cursorColor: colores.colorPrincipal, // Cambia el color del puntero aquí
    );
  }

// Método para TextField de tipo Password (TextfieldPass)
  Widget TextfieldPass({
    required TextEditingController controller,
    required String label,
    bool hasIcon = false, // Parámetro para decidir si tiene ícono
    IconData? icon, // Parámetro para el icono, si se pasa
  }) {
    return TextField(
      controller: controller,
      obscureText: true, // Hacemos que los caracteres se oculten
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
        contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 12), // Ajusta el alto aquí
        prefixIcon: hasIcon
            ? Icon(
                icon, // Si tiene ícono, lo pasa
                color: colores.colorInputsIcon,
              )
            : null, // Si no tiene ícono, no se pasa nada
      ),
      cursorColor: colores.colorPrincipal, // Cambia el color del puntero aquí
    );
  }

  // Método para ElevatedButton
  Widget ButtonPrimary({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: colores.colorFondo,
        backgroundColor: colores.colorPrincipal, // Color del texto
        minimumSize: Size(double.infinity,
            48), // Tamaño mínimo del botón (igual al tamaño del TextField)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              15), // Radio de borde para que sea consistente con el TextField
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16), // Ajusta el tamaño del texto si lo necesitas
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
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
