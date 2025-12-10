import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/credito_dto.dart';

class CreditSummaryCard extends StatelessWidget {
  final CreditoDTO credito;

  const CreditSummaryCard({super.key, required this.credito});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Cálculo visual de progreso (Simulado, ya que la API nos daría el saldo real)
    // Asumimos que si es nuevo, el progreso es 0.
    double progreso = 0.1;
    final proximaCuotaStr = credito.proximaCuota != null
        ? dateFormat.format(credito.proximaCuota!)
        : 'No definido';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, const Color(0xFF283593)], // Azul degradado
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Próximo Pago',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    credito.estado ?? 'ACTIVO',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              currencyFormat.format(credito.valorPorCuota),
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Vence el: $proximaCuotaStr',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Barra de Progreso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${currencyFormat.format(credito.montoPendiente)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const Text('Progreso de pago', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progreso,
                backgroundColor: Colors.black26,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00BFA5)), // Verde menta
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}