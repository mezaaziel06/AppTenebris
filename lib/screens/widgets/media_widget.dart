import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MediaImage extends StatelessWidget {
  final String url;
  final String mime;

  const MediaImage({super.key, required this.url, required this.mime});

  @override
  Widget build(BuildContext context) {
    if (mime.contains("svg") || url.endsWith(".svg")) {
      return SvgPicture.network(url, fit: BoxFit.cover);
    }
    return Image.network(url, fit: BoxFit.cover);
  }
}
