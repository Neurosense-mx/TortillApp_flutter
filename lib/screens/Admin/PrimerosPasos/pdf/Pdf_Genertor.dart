import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFGenerator {
  // Método para generar el PDF con datos del empleado
  Future<String> generatePDF({
    required String downloadPath,
    required String nombre,
    required String email,
    required String password,
    required String puesto,
  }) async {
    final pdf = pw.Document(); // Crea un nuevo documento PDF

    // Formatear la fecha y hora actual
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    
    // Nombre del archivo: usuario_fecha_hora.pdf
    String fileName = "${nombre}_$timestamp.pdf";
    String filePath = "$downloadPath/$fileName";

    // Agrega una página con la información del empleado
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Datos del Empleado' ),
                pw.SizedBox(height: 20),
                pw.Text(' Nombre: $nombre'),
                pw.Text(' Email: $email'),
                pw.Text(' Contraseña: $password'),
                pw.Text('Puesto: $puesto'),
              ],
            ),
          );
        },
      ),
    );

    final outputFile = File(filePath);

    // Guarda el PDF en la ruta especificada
    await outputFile.writeAsBytes(await pdf.save());

    return filePath; // Retorna la ruta donde se guardó el PDF
  }
}
