import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/register_provider.dart';
import '../../models/credito_dto.dart'; // <--- IMPORT DTO
import '../../data/services/auth_service.dart';
import '../widgets/custom_text_field.dart';

class CreditDataScreen extends StatefulWidget {
  const CreditDataScreen({super.key});

  @override
  State<CreditDataScreen> createState() => _CreditDataScreenState();
}

class _CreditDataScreenState extends State<CreditDataScreen> {
  final _precioCtrl = TextEditingController();
  final _entradaCtrl = TextEditingController();
  final _cuotasCtrl = TextEditingController();

  String _frecuencia = 'Semanal';
  DateTime _fechaPago = DateTime.now();

  double _montoFinanciar = 0;
  double _valorCuota = 0;
  DateTime _proximaCuota = DateTime.now();

  @override
  void initState() {
    super.initState();
    _precioCtrl.addListener(_calcularValores);
    _entradaCtrl.addListener(_calcularValores);
    _cuotasCtrl.addListener(_calcularValores);
  }

  @override
  void dispose() {
    _precioCtrl.dispose(); _entradaCtrl.dispose(); _cuotasCtrl.dispose();
    super.dispose();
  }

  void _calcularValores() {
    final precio = double.tryParse(_precioCtrl.text) ?? 0;
    final entrada = double.tryParse(_entradaCtrl.text) ?? 0;
    final cuotas = int.tryParse(_cuotasCtrl.text) ?? 1;

    setState(() {
      _montoFinanciar = precio - entrada;
      if (_montoFinanciar < 0) _montoFinanciar = 0;
      _valorCuota = (cuotas > 0) ? _montoFinanciar / cuotas : 0;
      _proximaCuota = _calcularProximaFecha(_fechaPago, _frecuencia);
    });
  }

  DateTime _calcularProximaFecha(DateTime fechaBase, String frecuencia) {
    switch (frecuencia) {
      case 'Semanal': return fechaBase.add(const Duration(days: 7));
      case 'Quincenal': return fechaBase.add(const Duration(days: 15));
      case 'Mensual': return DateTime(fechaBase.year, fechaBase.month + 1, fechaBase.day);
      default: return fechaBase.add(const Duration(days: 7));
    }
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context, initialDate: _fechaPago, firstDate: DateTime.now(), lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _fechaPago = picked;
        _calcularValores();
      });
    }
  }

  void _finalizarRegistro() async { // <--- Convertir a async
    if (_precioCtrl.text.isEmpty || _cuotasCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Define precio y cuotas')));
      return;
    }

    // 1. Mostrar carga
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );

    // 2. Guardar último paso en Provider
    final credito = CreditoDTO(
      monto: double.parse(_precioCtrl.text),
      entrada: double.tryParse(_entradaCtrl.text) ?? 0,
      plazoCuotas: int.parse(_cuotasCtrl.text),
      frecuenciaPago: _frecuencia,
      diaPago: _fechaPago,
      valorPorCuota: _valorCuota,
      totalPagar: _montoFinanciar,
      proximaCuota: _proximaCuota,
      estado: 'PENDIENTE',
    );
    context.read<RegisterProvider>().setCredito(credito);

    // 3. Armar el JSON Gigante
    final usuarioCompleto = context.read<RegisterProvider>().armarJsonRegistroCompleto();

    // 4. Enviar a la API (Nota: necesitamos convertir el JSON map de vuelta a objeto DTO para el servicio,
    // o ajustar el servicio para recibir Map. Por limpieza, usaremos el objeto DTO del provider si es posible,
    // pero como armarJsonRegistroCompleto devuelve Map, lo usaremos así).

    // Truco: Para usar el AuthService tal cual, reconstruimos el objeto desde el JSON armado
    // O mejor, modificamos AuthService para aceptar Map si fuera necesario, pero mantengamos el tipado fuerte.
    // Vamos a asumir que tu Provider tiene una forma de devolver el UsuarioDTO completo.

    // CORRECCIÓN RÁPIDA: Accederemos a los datos internos del provider para armar el DTO final aquí mismo o en el provider.
    // (Asumimos que agregaste un getter en el provider llamado `usuarioDTOCompleto` o usamos la lógica interna).

    // ... Supongamos que armaste el objeto 'usuarioFinal' ...
    // Para simplificar, haremos que el provider tenga un método 'getUsuarioFinal()' que devuelva el objeto UsuarioDTO.

    final usuarioDto = context.read<RegisterProvider>().getUsuarioFinal(); // <--- Necesitas crear este método en Provider

    final authService = AuthService();
    final exito = await authService.registrarUsuario(usuarioDto);

    // 5. Cerrar carga y navegar
    Navigator.pop(context); // Cierra el loading

    if (exito) {
      final correoUser = context.read<RegisterProvider>().usuario.correo;
      context.push('/verify-otp', extra: correoUser);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar. Verifica tu conexión o datos.'), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Paso 4: Crédito')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  const Text('Saldo a Financiar', style: TextStyle(color: Colors.white70)),
                  Text('\$${_montoFinanciar.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Cuota: \$${_valorCuota.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    Text('Prox: ${DateFormat('dd/MM').format(_proximaCuota)}', style: const TextStyle(color: Colors.greenAccent)),
                  ])
                ],
              ),
            ),
            const SizedBox(height: 30),
            CustomTextField(label: 'Precio Equipo (Total)', controller: _precioCtrl, keyboardType: TextInputType.number, icon: Icons.smartphone),
            const SizedBox(height: 15),
            CustomTextField(label: 'Entrada (Pago Inicial)', controller: _entradaCtrl, keyboardType: TextInputType.number, icon: Icons.monetization_on),
            const SizedBox(height: 15),
            CustomTextField(label: 'Plazo (Cuotas)', controller: _cuotasCtrl, keyboardType: TextInputType.number, icon: Icons.calendar_view_week),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _frecuencia,
              decoration: InputDecoration(labelText: 'Frecuencia de Pago', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: ['Semanal', 'Quincenal', 'Mensual'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (val) { setState(() { _frecuencia = val!; _calcularValores(); }); },
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Fecha de Inicio / Pago'), subtitle: Text(DateFormat('dd MMMM yyyy').format(_fechaPago)),
              trailing: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.withOpacity(0.5))),
              onTap: _seleccionarFecha,
            ),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: _finalizarRegistro, child: const Text('FINALIZAR Y VERIFICAR', style: TextStyle(fontSize: 16)))),
          ],
        ),
      ),
    );
  }
}