import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

import 'package:tortillapp/config/Notification.dart';
import 'package:tortillapp/config/paletteColor.dart';
import 'package:tortillapp/screens/Admin/PrimerosPasos/pdf/Pdf_Genertor.dart';
import 'package:tortillapp/widgets/widgets.dart';

class PP_Detalle_Empleado extends StatefulWidget {
  final String nombre; // Nombre del empleado
  final String email; // Email del empleado
  final String password; // Contraseña del empleado
  final String puesto; // Puesto del empleado

  PP_Detalle_Empleado({
    required this.nombre,
    required this.email,
    required this.password,
    required this.puesto,
  });

  @override
  _PP_Detalle_EmpleadoState createState() => _PP_Detalle_EmpleadoState();
}

class _PP_Detalle_EmpleadoState extends State<PP_Detalle_Empleado> {
  final PaletaDeColores colores = PaletaDeColores();

  PDFGenerator pdfGenerator = PDFGenerator();
    NotificationService notificationService = NotificationService();
  
Future<void> _mostrarNotificacion(String titulo, String mensaje) async {
  // Inicializar el servicio de notificaciones
  await notificationService.init();

  // Llamar a la función para mostrar la notificación
  await notificationService.mostrarNotificacion(
    idCanal: 0, // ID de la notificación
    id: 'general_channel', // ID del canal
    titulo: titulo, // Título
    mensaje: mensaje, // Mensaje
  );
}


//Metodo para obtener la ruta de la carpeta de descargas
  Future<String> getDownloadsDirectory() async {
    Directory? downloadsDir = Directory('/storage/emulated/0/Download');
    if (await downloadsDir.exists()) {
      return downloadsDir.path;
    } else {
      throw Exception("La carpeta de Descargas no existe.");
    }
  }

  Future<void> _download_PDF() async {
    // verificar si ya se han concedido los permisos
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      //print
      print("No se han concedido los permisos");
      // si no se han concedido los permisos, solicitarlos
      await Permission.storage.request();
    }
    String downloadsPath = await getDownloadsDirectory();
    print("📂 Ruta de descargas: $downloadsPath");
    try {
      String pdfPath = await pdfGenerator.generatePDF(
        downloadPath: downloadsPath,
        nombre: widget.nombre,
        email: widget.email,
        password: widget.password,
        puesto: widget.puesto,
      );

      print("✅ PDF guardado en: $pdfPath");
     //mostrar notificacion
     _mostrarNotificacion("PDF Descargado", "El PDF se ha guardado en la carpeta de Descargas");
    } catch (e) {
      print("❌ Error al guardar el PDF: $e");
    }
  }

  Future<void> _CompartirPDF() async {
// verificar si ya se han concedido los permisos
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      //print
      print("No se han concedido los permisos");
      // si no se han concedido los permisos, solicitarlos
      await Permission.storage.request();
    }
    String downloadsPath = await getDownloadsDirectory();
    print("📂 Ruta de descargas: $downloadsPath");
    try {
      String pdfPath = await pdfGenerator.generatePDF(
        downloadPath: downloadsPath,
        nombre: widget.nombre,
        email: widget.email,
        password: widget.password,
        puesto: widget.puesto,
      );

      print("✅ PDF guardado en: $pdfPath");
      Share.shareXFiles([XFile(pdfPath)]);

    } catch (e) {
      print("❌ Error al guardar el PDF: $e");
    }
  }

  void _OpenPDF() async {
    String downloadsPath = await getDownloadsDirectory();
    String pdfPath = await pdfGenerator.generatePDF(
      downloadPath: downloadsPath,
      nombre: widget.nombre,
      email: widget.email,
      password: widget.password,
      puesto: widget.puesto,
    );
    OpenFile.open(pdfPath);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colores.colorFondo,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Detalles del empleado',
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card con la información del empleado
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del empleado
                        Row(
                          children: [
                            Icon(Icons.person, color: colores.colorPrincipal),
                            SizedBox(width: 10),
                            Text(
                              "Nombre:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colores.colorPrincipal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.nombre,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.person, color: colores.colorPrincipal),
                            SizedBox(width: 10),
                            Text(
                              "Puesto:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colores.colorPrincipal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.puesto,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Email del empleado
                        Row(
                          children: [
                            Icon(Icons.email, color: colores.colorPrincipal),
                            SizedBox(width: 10),
                            Text(
                              "Email:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colores.colorPrincipal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Contraseña del empleado
                        Row(
                          children: [
                            Icon(Icons.lock, color: colores.colorPrincipal),
                            SizedBox(width: 10),
                            Text(
                              "Contraseña:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colores.colorPrincipal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.password,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Botones de Descargar y Compartir
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botón de Descargar
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _download_PDF();
                      },
                      icon: Icon(Icons.download, color: Colors.white),
                      label: Text(
                        "Descargar",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colores.colorPrincipal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Botón de Compartir
                    ElevatedButton.icon(
                      onPressed: () {
                        // Acción para compartir
                        print("Compartir información del empleado");
                        _CompartirPDF();
                      },
                      icon: Icon(Icons.share, color: Colors.white),
                      label: Text(
                        "Compartir",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colores.colorPrincipal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _OpenPDF();
                  },
                  icon: Icon(Icons.remove_red_eye, color: Colors.white),
                  label: Text(
                    "Ver PDF",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colores.colorPrincipal,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
