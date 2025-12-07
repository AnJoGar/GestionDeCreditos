import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Cabecera con Fondo Curvo (Header)
            Stack(
              children: [
                Container(
                  height: size.height * 0.35,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 30,
                  child: FadeInDown(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bienvenido',
                          style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Inicia sesión para gestionar',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            // 2. Formulario Login
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    const CustomTextField(
                      label: 'Correo Electrónico',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    const CustomTextField(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 10),
                    // Olvidé mi contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.push('/forgot-password');
                        },
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Botón de Login
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          //AGREGAR AQUÍ LÓGICA DE BACKEND, POR AHORA
                          //SE REDIRECCIONARÁ AL HOME AUTOMÁTICAMENTE
                          context.go('/home');
                        },
                        child: const Text('INGRESAR', style: TextStyle(fontSize: 18)),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Ir a Registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta?'),
                        TextButton(
                          onPressed: () {
                            context.push('/register'); // Navegación con GoRouter
                          },
                          child: Text(
                            'Regístrate',
                            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary),
                          ),
                        ),
                      ],
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