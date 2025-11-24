import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login/register_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/pages/gallery_screen.dart';
import 'screens/navbar/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://lriywzjlvzxtqppyaqqh.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxyaXl3empsdnp4dHFwcHlhcXFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzM2NDQsImV4cCI6MjA3OTUwOTY0NH0.4HK-U1qJK3gQmHsrvbRuLpvLIabVANYik_ETuFz1nOw", // pega tu anon key aquí
  );

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
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/splash': (context) => const SplashScreen(),
        '/app': (context) => const AppShell(),
      },
    );
  }
}
