import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'avatar_service.dart'; // reutilizamos MediaItem


class LoreService {
  final _storage = const FlutterSecureStorage();
    final String baseUrl = "http://192.168.0.111:8000";

  Future<List<MediaItem>> getLore() async {
    final token = await _storage.read(key: "access_token");

    final res = await http.get(
      Uri.parse("$baseUrl/v1/gallery?type=lore"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return (body["items"] as List)
          .map((e) => MediaItem.fromJson(e))
          .toList();
    }
    return [];
  }
}
