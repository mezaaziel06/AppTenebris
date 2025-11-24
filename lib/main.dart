import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/navbar/navbar.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B0B0B),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 0,
          backgroundColor: const Color(0xFF0E0E0E),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? const Color(0xFFFFD54F) : Colors.white70,
            );
          }),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/splash': (context) => const SplashScreen(),

        // NUEVO: Home con bottom nav
        '/app': (context) => const AppShell(),
      },
    );
  }
}