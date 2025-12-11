import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/register_provider.dart';
import '../../models/detalle_cliente_dto.dart';
import '../../data/services/firebase_service.dart'; // Asegúrate de tener este archivo creado
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

  // Controladores
  final _cedulaCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  // Variables para fotos locales
  File? _fotoCliente;
  File? _fotoCelular;
  File? _fotoContrato;

  // Control de estado de carga
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Pre-llenamos el nombre desde el paso anterior (UX)
    final nombreRegistrado = context.read<RegisterProvider>().usuario.nombreApellidos;
    _nombreCtrl.text = nombreRegistrado ?? '';
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  void _onNextPressed() async {
    // 1. Validar Inputs de Texto
    if (!_formKey.currentState!.validate()) return;

    // 2. Validar que las 3 fotos existan (Requerimiento estricto)
    if (_fotoCliente == null || _fotoCelular == null || _fotoContrato == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes subir las 3 fotos obligatorias (Cliente, Celular y Contrato)'),
          backgroundColor: Colors.red,
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

<<<<<<< HEAD
    // 3. Iniciar proceso de subida
    setState(() => _isUploading = true);

    // Mostrar diálogo de carga modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false, // Evita que cierren el diálogo con 'atrás'
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 15),
              Text("Subiendo imágenes a la nube...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );

    try {
      final firebaseService = FirebaseService();

      // Subimos las 3 imágenes en paralelo o secuencia.
      // Usamos carpetas organizadas en Firebase Storage.
      final String? urlCliente = await firebaseService.uploadImage(_fotoCliente!, 'clientes');
      final String? urlCelular = await firebaseService.uploadImage(_fotoCelular!, 'celulares');
      final String? urlContrato = await firebaseService.uploadImage(_fotoContrato!, 'contratos');

      // Cerrar el diálogo de carga
      if (mounted) Navigator.pop(context);
      setState(() => _isUploading = false);

      // 4. Verificar si alguna subida falló
      if (urlCliente == null || urlCelular == null || urlContrato == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir imágenes. Verifica tu internet.'), backgroundColor: Colors.red),
          );
        }
        return;
      }

      // 5. Crear DTO con las URLs de Firebase
      final detalle = DetalleClienteDTO(
        numeroCedula: _cedulaCtrl.text,
        nombreApellidos: _nombreCtrl.text,
        telefono: _telefonoCtrl.text,
        direccion: _direccionCtrl.text,
        fotoClienteUrl: urlCliente,            // URL Web
        fotoCelularEntregadoUrl: urlCelular,   // URL Web
        fotoContrato: urlContrato,             // URL Web
      );

      // 6. Guardar en Provider y Avanzar
      if (mounted) {
        context.read<RegisterProvider>().setDetalleCliente(detalle);
        context.push('/store-data');
      }

    } catch (e) {
      // Manejo de error general
      if (mounted) Navigator.pop(context); // Cerrar dialog si sigue abierto
      setState(() => _isUploading = false);
      print("Error crítico: $e");
    }
=======

    context.push('/store-data');
>>>>>>> 416748d793b36000680975f7e27775fbe2bccb44
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
                label: 'Número de Cédula',
                controller: _cedulaCtrl,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.length != 10) ? 'La cédula debe tener 10 dígitos' : null,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                label: 'Nombres y Apellidos',
                controller: _nombreCtrl,
                icon: Icons.person,
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                label: 'Teléfono',
                controller: _telefonoCtrl,
                keyboardType: TextInputType.phone,
                icon: Icons.phone,
                validator: (v) => (v == null || v.length != 10) ? 'El teléfono debe tener 10 dígitos' : null,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                label: 'Dirección / Sector',
                controller: _direccionCtrl,
                icon: Icons.location_on,
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),

              const SizedBox(height: 30),
              const Text('Evidencia Digital', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: PhotoUploadCard(
                      label: 'Foto Cliente *',
                      onImageSelected: (f) => _fotoCliente = f,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: PhotoUploadCard(
                      label: 'Foto Celular *',
                      onImageSelected: (f) => _fotoCelular = f,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              PhotoUploadCard(
                label: 'Foto Contrato *',
                onImageSelected: (f) => _fotoContrato = f,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _onNextPressed, // Deshabilitar si está subiendo
                  child: const Text('SIGUIENTE: DATOS TIENDA', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}