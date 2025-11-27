import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GalleryService {
  final String baseUrl = "http://192.168.0.111:8000";

  final _storage = const FlutterSecureStorage();

  Future<List<dynamic>> getYoutubeVideos() async {
    final token = await _storage.read(key: "access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/v1/gallery?type=youtube"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["items"]; // lista de media
    }

    return [];
  }
}

