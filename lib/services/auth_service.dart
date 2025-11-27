import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final supabase = Supabase.instance.client;
  final _storage = const FlutterSecureStorage();

  /// LOGIN
  Future<bool> login(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

    print("token: ${res.session?.accessToken}");

      if (res.session == null) return false;

      // 🔥 GUARDAR TOKEN
      await _storage.write(
        key: "access_token",
        value: res.session!.accessToken,
      );

      return true;

    } catch (e) {
      print("LOGIN ERROR => $e");
      return false;
    }
  }

  /// REGISTER + AUTO LOGIN + PROFILE AUTO-CREATE
  Future<bool> register(String email, String password) async {
    try {
      // 1. Crear usuario
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.session == null) return false;

      // 2. Guardar token del registro
      await _storage.write(
        key: "access_token",
        value: res.session!.accessToken,
      );

      
      // 3. Login automático (opcional pero mantiene consistencia)
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final token = supabase.auth.currentSession?.accessToken;

      // 4. Forzar que el backend cree el profile
      await http.get(
        Uri.parse("http://10.10.57.29:8000/v1/users/profile"),
        headers: {"Authorization": "Bearer $token"},
      );

      return true;

    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  /// Para logout
  Future<void> logout() async {
    await supabase.auth.signOut();
    await _storage.deleteAll();
  }
}
