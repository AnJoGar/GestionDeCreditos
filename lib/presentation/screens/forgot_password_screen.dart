import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';
import '../../models/forgot_password_dto.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // <--- 1. Agregamos la llave
  bool _isLoading = false;

  void _enviarSolicitud() async {
    // <--- 2. Validamos el formulario antes de enviar
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final service = AuthService();
    final dto = ForgotPasswordDTO(correo: _emailCtrl.text);
    final exito = await service.forgotPassword(dto);

    setState(() => _isLoading = false);

    if (exito) {
      context.push('/reset-password');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error. Verifica el correo.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form( // <--- 3. Envolvemos en Form
          key: _formKey,
          child: Column(
            children: [
              const Text('Ingresa tu correo y te enviaremos un código para restablecer tu clave.'),
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Correo',
                controller: _emailCtrl,
                icon: Icons.email,
                // <--- 4. Agregamos validador de correo estricto
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El correo es obligatorio';
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) return 'Ingresa un correo válido (@ y dominio)';
                  return null;
                },
              ),

              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: _enviarSolicitud, child: const Text('ENVIAR CÓDIGO'))
              ),
            ],
          ),
        ),
      ),
    );
  }
}