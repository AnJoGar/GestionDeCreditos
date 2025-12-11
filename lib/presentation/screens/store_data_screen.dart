import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/register_provider.dart';
import '../../models/tienda_crear_dto.dart';
import '../../data/services/firebase_service.dart'; // Importar servicio
import '../widgets/custom_text_field.dart';
import '../widgets/photo_upload_card.dart';

class StoreDataScreen extends StatefulWidget {
  const StoreDataScreen({super.key});

  @override
  State<StoreDataScreen> createState() => _StoreDataScreenState();
}

class _StoreDataScreenState extends State<StoreDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreTiendaCtrl = TextEditingController();
  final _encargadoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _codigoTiendaCtrl = TextEditingController();

  File? _logoTienda;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // NOTA: No pre-llenamos el encargado, se deja vacío según requerimiento.
  }

  @override
  void dispose() {
    _nombreTiendaCtrl.dispose();
    _encargadoCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _codigoTiendaCtrl.dispose();
    super.dispose();
  }

  void _onNextPressed() async {
    // 1. Validar formulario
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);
    String? urlLogo;

    // 2. Subir Logo solo si existe (es opcional)
    if (_logoTienda != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final firebaseService = FirebaseService();
      urlLogo = await firebaseService.uploadImage(_logoTienda!, 'logos_tiendas');

      if (mounted) Navigator.pop(context); // Cerrar loading

      if (urlLogo == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir el logo, intenta de nuevo.'), backgroundColor: Colors.red),
          );
        }
        setState(() => _isUploading = false);
        return;
      }
    }

    setState(() => _isUploading = false);

    // 3. Crear DTO con la URL
    final tienda = TiendaCrearDTO(
      nombreTienda: _nombreTiendaCtrl.text,
      nombreEncargado: _encargadoCtrl.text,
      telefono: _telefonoCtrl.text,
      direccion: _direccionCtrl.text,
      codigoTienda: _codigoTiendaCtrl.text,
      // Aunque el campo se llame logoBase64 en el DTO (por compatibilidad legacy),
      // le pasamos la URL de Firebase que es un String.
      logoBase64: urlLogo,
    );

    // 4. Guardar y Avanzar
    if (mounted) {
      context.read<RegisterProvider>().setTienda(tienda);
      context.push('/credit-data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso 3: Datos Tienda'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Sección de Logo
              Center(
                child: SizedBox(
                  width: 150,
                  child: PhotoUploadCard(
                    label: 'Logo Tienda (Opcional)',
                    onImageSelected: (file) => _logoTienda = file,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Nombre de la Tienda',
                controller: _nombreTiendaCtrl,
                icon: Icons.store,
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                label: 'Código de Tienda',
                controller: _codigoTiendaCtrl,
                icon: Icons.qr_code,
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                label: 'Nombre Encargado',
                controller: _encargadoCtrl,
                icon: Icons.person_pin,
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                label: 'Teléfono Tienda',
                controller: _telefonoCtrl,
                keyboardType: TextInputType.phone,
                icon: Icons.phone_android,
                validator: (v) => (v == null || v.length != 10) ? 'Debe tener 10 dígitos' : null,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                label: 'Dirección',
                controller: _direccionCtrl,
                icon: Icons.location_city,
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _onNextPressed,
                  child: const Text('SIGUIENTE: DATOS CRÉDITO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}