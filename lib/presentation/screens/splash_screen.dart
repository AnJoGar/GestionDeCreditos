import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulamos una carga de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if(mounted) {
        context.go('/login'); // Navegación real
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un degradado sutil de fondo
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF283593)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono animado (Simula tu logo)
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.store_mall_directory_rounded,
                    size: 60,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Texto animado
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'GESTIÓN DE TIENDAS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Cargando
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}