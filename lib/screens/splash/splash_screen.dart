import 'package:flutter/material.dart';
import '../../screens/login/login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para la animación de desvanecido
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // duración del fade
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Después de 3 segundos, navega al LoginScreen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔥 Aquí va tu logo (puedes reemplazar la imagen)
              Image.asset(
                'assets/logo.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Ex Tenebris',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 28,
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
