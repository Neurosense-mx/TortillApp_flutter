import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Función para inicializar el plugin de notificaciones
  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher'); // Usar el ícono predeterminado
    const InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Función para mostrar la notificación
  Future<void> mostrarNotificacion({
    required int idCanal,
    required String id,
    required String titulo,
    required String mensaje,
  }) async {
    // Verificar y solicitar permisos en Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Verificar si el permiso fue concedido
    if (await Permission.notification.isGranted) {
      final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        id, // ID del canal
        titulo, // Nombre del canal
        channelDescription: mensaje, // Descripción del canal
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        idCanal, // ID de la notificación
        titulo, // Título
        mensaje, // Cuerpo
        platformChannelSpecifics,
      );

      print("Notificación enviada");
    } else {
      print("Permiso de notificaciones no concedido");
    }
  }
}
