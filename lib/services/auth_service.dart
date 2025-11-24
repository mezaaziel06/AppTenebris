// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final supabase = Supabase.instance.client;

  /// LOGIN normal
  Future<bool> login(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return res.session != null;
    } catch (e) {
      print("LOGIN ERROR => $e");
      return false;
    }
  }

  /// REGISTER + AUTO LOGIN
  Future<bool> register(String email, String password) async {
  final supabase = Supabase.instance.client;

  try {
    // 1. Crear usuario
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final session = res.session;

    if (session == null) {
      return false;
    }

    // 2. Login automático
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final token = supabase.auth.currentSession?.accessToken;

    // 3. Forzar creación/lectura de profile
    await http.get(
      Uri.parse("http://192.168.0.111:8000/v1/users/profile"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return true;

  } catch (e) {
    print("Register error: $e");
    return false;
  }
}
}