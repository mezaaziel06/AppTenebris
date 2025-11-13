import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  /// ⚠️ Cambia esto según dónde corra tu backend:
  /// - Android emulador: http://10.0.2.2:8000/
  /// - iOS simulator:    http://127.0.0.1:8000/
  /// - Web/Windows app:  http://127.0.0.1:8000/
  static const String _baseUrl = 'http://10.0.2.2:8000/';

  final _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  final _storage = const FlutterSecureStorage();

  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _user;

  bool get loading => _loading;
  String? get error => _error;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _dio.post('/v1/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = res.data as Map<String, dynamic>;
      final access = data['accessToken'] as String;
      final refresh = data['refreshToken'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await _storage.write(key: 'accessToken', value: access);
      await _storage.write(key: 'refreshToken', value: refresh);
      await _storage.write(key: 'userId', value: user['id'] as String);

      _user = user;
    } on DioException catch (e) {
      _error = (e.response?.statusCode == 401)
          ? 'Credenciales inválidas'
          : 'Error de red';
      _user = null;
    } catch (_) {
      _error = 'Error inesperado';
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Intenta restaurar sesión al abrir la app (Splash).
  /// Lee tokens del secure storage y valida con /v1/users/me.
  Future<bool> tryRestore() async {
    final access = await _storage.read(key: 'accessToken');
    if (access == null || access.isEmpty) return false;

    try {
      final res = await _dio.get(
        '/v1/users/me',
        options: Options(headers: {'Authorization': 'Bearer $access'}),
      );
      _user = res.data as Map<String, dynamic>;
      return true;
    } on DioException catch (e) {
      // Si vence el access podrías intentar refresh aquí si lo deseas.
      // Por simplicidad: si falla, limpiamos y devolvemos false.
      if (e.response?.statusCode == 401) {
        await logout();
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}
