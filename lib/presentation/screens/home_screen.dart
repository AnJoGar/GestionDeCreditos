import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../models/credito_dto.dart';
import '../../models/tienda_dto.dart';
import '../widgets/credit_summary_card.dart';
import '../widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // DATOS FICTICIOS (MOCKS)
  final String _nombreUsuario = "Luis Developer";
  final String _emailUsuario = "luis@ejemplo.com";

  final CreditoDTO _creditoMock = CreditoDTO(
      montoTotal: 800.00,
      entrada: 50.00,
      plazoCuotas: 12,
      frecuenciaPago: "Mensual",
      diaPago: DateTime.now(),
      valorPorCuota: 75.50,
      montoPendiente: 906.00,
      // Prueba cambiando este número (ej: -2, 0, 3, 15) para ver los distintos colores
      proximaCuota: DateTime.now().add(const Duration(days: 15)),
      estado: "AL DÍA",
      clienteId: 1
  );

  final TiendaDTO _tiendaMock = TiendaDTO(
    nombreTienda: "Celulares El Centro",
    nombreEncargado: "Luis",
    telefono: "0999999999",
    direccion: "Av. Principal 123",
  );

  // --- 1. AQUÍ INICIA LA LÓGICA DE LA ALERTA ---
  @override
  void initState() {
    super.initState();
    // Programamos la alerta para que salga justo después de que la pantalla se dibuje
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarAlertaDiasRestantes();
    });
  }

  void _mostrarAlertaDiasRestantes() {
    // 1. Obtenemos la fecha (que puede ser null)
    final proximaCuota = _creditoMock.proximaCuota;

    // CORRECCIÓN: Si no hay fecha de próxima cuota, no hacemos nada y salimos.
    if (proximaCuota == null) return;

    final now = DateTime.now();

    // 2. Normalizamos las fechas (Ahora Dart sabe que 'proximaCuota' no es null aquí)
    final fechaVencimiento = DateTime(proximaCuota.year, proximaCuota.month, proximaCuota.day);
    final fechaHoy = DateTime(now.year, now.month, now.day);

    final diferencia = fechaVencimiento.difference(fechaHoy).inDays;

    Color colorBanner;
    String mensaje;
    IconData icono;

    // 3. Lógica de colores según urgencia
    if (diferencia < 0) {
      // Vencido
      colorBanner = Colors.red.shade700;
      mensaje = "¡CUIDADO! Tu pago está vencido por ${diferencia.abs()} días.";
      icono = Icons.warning_amber_rounded;
    } else if (diferencia == 0) {
      // Es hoy
      colorBanner = Colors.orange.shade800;
      mensaje = "¡Tu pago vence HOY!";
      icono = Icons.access_time_filled;
    } else if (diferencia <= 3) {
      // Urgente (1 a 3 días)
      colorBanner = Colors.orangeAccent.shade700;
      mensaje = "Atención: Tu pago vence en $diferencia días.";
      icono = Icons.priority_high_rounded;
    } else {
      // Normal (Más de 3 días)
      colorBanner = Colors.blue.shade600;
      mensaje = "Faltan $diferencia días para tu próximo pago.";
      icono = Icons.calendar_today;
    }

    // 4. Mostramos el SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorBanner,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            Icon(icono, color: Colors.white, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Estado de Cuenta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white70)),
                  Text(mensaje, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- FIN DE LA LÓGICA DE ALERTA ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: theme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // BOTÓN DE NOTIFICACIONES CONECTADO
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Navegamos a la pantalla que acabas de crear
              context.push('/notifications');
            },
          )
        ],
      ),
      drawer: SideMenu(userName: _nombreUsuario, userEmail: _emailUsuario),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Saludo
            FadeInDown(
              child: Text(
                'Hola, $_nombreUsuario',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            FadeInDown(
              child: Text(
                'Aquí está el resumen de tu crédito',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 20),

            // 2. Tarjeta Principal (Crédito)
            FadeInLeft(
              child: CreditSummaryCard(credito: _creditoMock),
            ),

            const SizedBox(height: 30),

            // 3. Sección Tienda
            FadeInUp(
              child: Text(
                'Mi Tienda',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.store, color: Colors.orange),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tiendaMock.nombreTienda,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _tiendaMock.direccion,
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 4. Accesos Rápidos
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickActionBtn(
                    icon: Icons.receipt_long,
                    label: 'Historial',
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  _QuickActionBtn(
                    icon: Icons.support_agent,
                    label: 'Soporte',
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  _QuickActionBtn(
                    icon: Icons.qr_code,
                    label: 'Mi QR',
                    color: Colors.teal,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}