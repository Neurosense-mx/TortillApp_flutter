import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFGenerator {
  // Método para generar el PDF y guardarlo en la carpeta de Descargas
  Future<String> generatePDF() async {
    final pdf = pw.Document(); // Crea un nuevo documento PDF

    // Agrega una página con un texto simple
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              '¡Hola, este es un PDF de ejemplo!',
              style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
            ),
          ); // El contenido de la página
        },
      ),
    );

    // Obtén la carpeta de descargas en el dispositivo
    final directory = await getExternalStorageDirectory();
    final downloadsDir = Directory('${directory?.parent.path}/Download');
    
    // Verifica si la carpeta de "Descargas" existe, si no la crea
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    final outputFile = File("${downloadsDir.path}/ejemplo.pdf");

    // Guarda el PDF en la carpeta de Descargas
    await outputFile.writeAsBytes(await pdf.save());

    return outputFile.path; // Retorna la ruta donde se guardó el PDF
  }
}
