import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../providers/register_provider.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    // 1. Validar Formulario
    if (!_formKey.currentState!.validate()) return;

    // 2. Guardar en Provider (Sin foto)
    context.read<RegisterProvider>().setUsuarioBasico(
        _nameController.text,
        _emailController.text,
        _passController.text
    );

    // 3. Avanzar
    context.push('/client-data');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Curvo
            Stack(
              children: [
                Container(
                  height: size.height * 0.25,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(60)),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(height: 10),
                        FadeInDown(child: const Text('Paso 1', style: TextStyle(color: Colors.white70, fontSize: 18))),
                        FadeInDown(child: const Text('Crear Cuenta', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // YA NO HAY FOTO DE PERFIL AQUÍ

                    CustomTextField(
                      label: 'Nombre y Apellidos',
                      icon: Icons.person_outline,
                      controller: _nameController,
                      validator: (v) => (v == null || v.trim().length < 5) ? 'Nombre completo requerido' : null,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Correo Electrónico',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (v) => (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v ?? '')) ? 'Correo inválido' : null,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
                        if (value.length < 12) return 'Mínimo 12 caracteres';
                        if (!value.contains(RegExp(r'[A-Z]'))) return 'Debe tener al menos una mayúscula';
                        return null;
                      },
                    ),

                    const SizedBox(height: 50),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                          onPressed: _onNextPressed,
                          child: const Text('SIGUIENTE', style: TextStyle(fontSize: 18))
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}