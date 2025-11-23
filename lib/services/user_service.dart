import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserService {
  final Dio _dio = Dio();

  final String baseUrl = "http://10.0.2.2:8000"; // tu API

  Future<UserModel> getUser() async {
    final response = await _dio.get("$baseUrl/users/me");

    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateUser({
    required String displayName,
    required String avatarUrl,
  }) async {
    final response = await _dio.put(
      "$baseUrl/users/me",
      data: {
        "display_name": displayName,
        "avatar_url": avatarUrl,
      },
    );

    return UserModel.fromJson(response.data);
  }
}
