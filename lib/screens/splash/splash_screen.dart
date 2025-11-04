import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/login/login_screen.dart';
import 'dart:math' as math;

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

    // Controlador para animación de fade
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Navegar al login después de 3 segundos
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B0000), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔥 Logo SVG grande
                SvgPicture.asset(
                  'assets/images/svgs/titulo.svg',
                  height: 300,
                ),
                const SizedBox(height: 60),
                // 🔴 Animación de bolitas rojas
                const _RedDotsLoader(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget animado de bolitas rojas girando 🔴
class _RedDotsLoader extends StatefulWidget {
  const _RedDotsLoader();

  @override
  State<_RedDotsLoader> createState() => _RedDotsLoaderState();
}

class _RedDotsLoaderState extends State<_RedDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(8, (index) {
              final angle = (index * (math.pi / 4)) + (_controller.value * 2 * math.pi);
              final radius = 20.0;
              final x = radius * math.cos(angle);
              final y = radius * math.sin(angle);
              final size = 8.0 + (index.isEven ? 3.0 : 0.0); // alterna tamaños

              return Positioned(
                left: 30 + x,
                top: 30 + y,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(
                      const Color(0xFFB71C1C),
                      const Color(0xFFD32F2F),
                      index / 8,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
