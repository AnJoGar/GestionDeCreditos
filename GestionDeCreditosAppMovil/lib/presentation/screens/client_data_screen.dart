import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/register_provider.dart';
import '../../models/detalle_cliente_dto.dart'; // <--- IMPORT DTO
import '../widgets/custom_text_field.dart';
import '../widgets/photo_upload_card.dart';
import '../../services/UsuarioRegistroData.dart';

import '../../models/cliente_dto.dart';

class ClientDataScreen extends StatefulWidget {
  const ClientDataScreen({super.key});

  @override
  State<ClientDataScreen> createState() => _ClientDataScreenState();
}

class _ClientDataScreenState extends State<ClientDataScreen> {

    UsuarioRegistroData registroData = UsuarioRegistroData();
  final _formKey = GlobalKey<FormState>();
  final _cedulaCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  File? _fotoCliente;
  File? _fotoCelular;
  File? _fotoContrato;

  @override
  void initState() {
    super.initState();
    final nombreRegistrado = context.read<RegisterProvider>().usuario.nombreApellidos;
    _nombreCtrl.text = nombreRegistrado ?? '';
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose(); _nombreCtrl.dispose(); _telefonoCtrl.dispose(); _direccionCtrl.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    // 1. Validar Inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Validar TODAS las Fotos (Corrección)
    if (_fotoCliente == null || _fotoCelular == null || _fotoContrato == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Debes subir las 3 fotos obligatorias (Cliente, Celular y Contrato)'),
            backgroundColor: Colors.red
        ),
      );
      return;
    }
final detalle = DetalleClienteDTO(
  numeroCedula: _cedulaCtrl.text,
  nombreApellidos: _nombreCtrl.text,
  telefono: _telefonoCtrl.text,
  direccion: _direccionCtrl.text,
  fotoClienteUrl: _fotoCliente?.path,
  fotoCelularEntregadoUrl: _fotoCelular?.path,
  fotoContrato: _fotoContrato?.path,
);
// Guardar el detalle del cliente en registroData
  registroData.cliente ??= ClienteDTO(); // Crear cliente si no existe
registroData.cliente!.detalleCliente = detalle;

// Si quieres guardar las fotos en el DTO, podrías hacer algo así
//registroData.cliente!.detalleCliente!.fotoClienteUrl = _fotoCliente;
//registroData.cliente!.detalleCliente!.fotoCelularEntregadoUrl = _fotoCelular;
//registroData.cliente!.detalleCliente!.fotoContrato = _fotoContrato;


    context.push('/store-data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso 2: Datos Cliente'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Información Personal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 15),
              CustomTextField(
                label: 'Número de Cédula', controller: _cedulaCtrl, keyboardType: TextInputType.number,
                validator: (v) => (v!.isEmpty || v.length != 10) ? 'Debe tener 10 dígitos' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                label: 'Nombres y Apellidos', controller: _nombreCtrl, icon: Icons.person,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                label: 'Teléfono', controller: _telefonoCtrl, keyboardType: TextInputType.phone, icon: Icons.phone,
                validator: (v) => (v!.isEmpty || v.length != 10) ? 'Debe tener 10 dígitos' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                label: 'Dirección / Sector', controller: _direccionCtrl, icon: Icons.location_on,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 30),
              const Text('Evidencia Digital', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: PhotoUploadCard(label: 'Foto Cliente *', onImageSelected: (f) => _fotoCliente = f)),
                  const SizedBox(width: 15),
                  Expanded(child: PhotoUploadCard(label: 'Foto Celular', onImageSelected: (f) => _fotoCelular = f)),
                ],
              ),
              const SizedBox(height: 15),
              PhotoUploadCard(label: 'Foto Contrato', onImageSelected: (f) => _fotoContrato = f),
              const SizedBox(height: 40),
              SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _onNextPressed, child: const Text('SIGUIENTE: DATOS TIENDA'))),
            ],
          ),
        ),
      ),
    );
  }
}