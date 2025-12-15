import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/notificacion_dto.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK DATA: Aquí deberías llamar a tu NotificationService.getNotifications()
    final List<NotificacionDTO> notificaciones = [
      NotificacionDTO(id: 1, clienteId: 1, tipo: "Aviso", mensaje: "Recuerda que tu pago vence en 3 días", fecha: DateTime.now().subtract(const Duration(hours: 2)), leida: false),
      NotificacionDTO(id: 2, clienteId: 1, tipo: "Pago", mensaje: "Hemos recibido tu pago de 50.00. ¡Gracias!", fecha: DateTime.now().subtract(const Duration(days: 5)), leida: true),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: notificaciones.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final noti = notificaciones[index];
          return Card(
            elevation: noti.leida ? 0 : 3, // Resalta las no leídas
            color: noti.leida ? Colors.white : Colors.blue[50], // Fondo azulito si no está leída
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getColorPorTipo(noti.tipo),
                child: Icon(_getIconPorTipo(noti.tipo), color: Colors.white, size: 20),
              ),
              title: Text(
                noti.tipo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: noti.leida ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(noti.mensaje),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(noti.fecha),
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: !noti.leida
                  ? const Icon(Icons.circle, color: Colors.blue, size: 12)
                  : null,
            ),
          );
        },
      ),
    );
  }

  // Helpers visuales
  Color _getColorPorTipo(String tipo) {
    if (tipo.contains("Pago")) return Colors.green;
    if (tipo.contains("Aviso")) return Colors.orange;
    if (tipo.contains("Mora")) return Colors.red;
    return Colors.blue;
  }

  IconData _getIconPorTipo(String tipo) {
    if (tipo.contains("Pago")) return Icons.attach_money;
    if (tipo.contains("Aviso")) return Icons.notifications_active;
    if (tipo.contains("Mora")) return Icons.warning;
    return Icons.info_outline;
  }
}