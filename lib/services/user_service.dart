import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';


class UserService {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  final String baseUrl = "http://10.132.157.176:8000";


  Future<String?> _getToken() async {
    return await _storage.read(key: "access_token");
  }

  Future<UserModel> getUser() async {
    final token = await _getToken();

    final me = await _dio.get(
      "$baseUrl/v1/users/me",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final profile = await _dio.get(
      "$baseUrl/v1/users/profile",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return UserModel(
      id: me.data["id"],
      email: me.data["email"],
      displayName: profile.data["display_name"] ?? "",
      avatarUrl: profile.data["avatar_url"],
    );
  }

  Future<UserModel> updateUser({
    required String displayName,
    required String avatarUrl,
  }) async {
    final token = await _getToken();

    final res = await _dio.patch(
      "$baseUrl/v1/users/profile",
      data: FormData.fromMap({
        "display_name": displayName,
        "avatar_url": avatarUrl,
      }),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return UserModel(
      id: res.data["id"],
      email: "", // lo actualizará getUser() en el reload
      displayName: res.data["display_name"] ?? "",
      avatarUrl: res.data["avatar_url"],
    );
  }
}
