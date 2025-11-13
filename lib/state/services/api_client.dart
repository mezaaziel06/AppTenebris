import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const baseUrl = 'http://10.0.2.2:8000/'; // cambia si usas dispositivo físico
  static final _storage = const FlutterSecureStorage();
  static final ApiClient I = ApiClient._();

  late final Dio dio;

  ApiClient._() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final access = await _storage.read(key: 'accessToken');
          if (access != null && access.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $access';
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          // Reintento único si 401 y tenemos refresh
          if (e.response?.statusCode == 401) {
            final refreshed = await _tryRefresh();
            if (refreshed) {
              final req = e.requestOptions;
              final newAccess = await _storage.read(key: 'accessToken');
              req.headers['Authorization'] = 'Bearer $newAccess';
              final clone = await dio.fetch(req);
              return handler.resolve(clone);
            }
          }
          handler.next(e);
        },
      ),
    );
  }

  Future<bool> _tryRefresh() async {
    final refresh = await _storage.read(key: 'refreshToken');
    final userId = await _storage.read(key: 'userId');
    if (refresh == null || userId == null) return false;

    try {
      final res = await dio.post('/v1/auth/refresh2', data: {
        'userId': userId,
        'refreshToken': refresh,
      });
      final data = res.data as Map<String, dynamic>;
      await _storage.write(key: 'accessToken', value: data['accessToken'] as String);
      await _storage.write(key: 'refreshToken', value: data['refreshToken'] as String);
      return true;
    } catch (_) {
      // refresh inválido → limpiar
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      await _storage.delete(key: 'userId');
      return false;
    }
  }
}
