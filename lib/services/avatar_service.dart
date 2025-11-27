import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MediaItem {
  final String id;
  final String url;
  final String title;
  final String description;
  final String mimeType;

  MediaItem({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.mimeType,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json["id"],
      url: json["url"],
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      mimeType: json["mime_type"] ?? "",
    );
  }
}

class AvatarService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = "http://192.168.0.111:8000";


  Future<List<MediaItem>> getAvatars() async {
    final token = await _storage.read(key: "access_token");

    final res = await http.get(
      Uri.parse("$baseUrl/v1/gallery?type=avatar"),
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
