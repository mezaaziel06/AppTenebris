import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AvatarService {
  final _storage = FlutterSecureStorage();
  final String baseUrl = "http://192.168.0.111:8000";

  Future<List<dynamic>> getAvatars() async {
    final token = await _storage.read(key: "access_token");

    final res = await http.get(
      Uri.parse("$baseUrl/v1/gallery?type=avatar"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("Avatar response: ${res.body}");

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body["items"];
    }

    return [];
  }
}
