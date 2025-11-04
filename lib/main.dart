import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/splash/splash_screen.dart';
import './screens/gallery_screen.dart';

void main() {
  runApp(const ExTenebrisApp());
}

class ExTenebrisApp extends StatelessWidget {
  const ExTenebrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ex Tenebris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/splash': (context) => const SplashScreen(),
        '/gallery': (context) => const GalleryScreen(),
      },
    );
  }
}
