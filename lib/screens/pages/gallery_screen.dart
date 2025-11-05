// lib/screens/galery_screen.dart
// Pantalla tipo “Live Channels” con fondo, degradado y lista de canales.
// Soporta avatars en SVG (usa flutter_svg en pubspec).
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fondo completo
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/ira.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Degradado para oscurecer y dar contraste al panel inferior
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  const Spacer(), // empuja el panel a la parte baja

                  const Text(
                    'Live Channels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Panel con blur y bordes redondeados
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: const _ChannelList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de canales (usa datos de ejemplo)
class _ChannelList extends StatelessWidget {
  const _ChannelList();

  static final channels = <Channel>[
    Channel(
      title: 'Game Pro Ti...',
      viewers: 78400,
      streamer: 'Rishab',
      thumb: 'assets/images/backgrounds/vitral.jpg',
      avatar: 'assets/images/svgs/nicromante.svg',
      live: true,
    ),
    Channel(
      title: 'Game Tour...',
      viewers: 23500,
      streamer: 'Ravi',
      thumb: 'assets/images/backgrounds/ira.jpg',
      avatar: 'assets/images/svgs/odium.svg',
      live: true,
    ),
    Channel(
      title: 'World Tourn...',
      viewers: 20500,
      streamer: 'Agnes',
      thumb: 'assets/images/backgrounds/ira.jpg',
      avatar: 'assets/images/svgs/stalker.svg',
      live: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: channels.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => ChannelTile(channel: channels[i]),
    );
  }
}

/// Tarjeta/ítem de canal
class ChannelTile extends StatelessWidget {
  final Channel channel;
  const ChannelTile({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Miniatura con badge LIVE
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                channel.thumb,
                width: 88,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            if (channel.live)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channel.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.remove_red_eye, size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    _formatViewers(channel.viewers),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  AvatarRound(assetPath: channel.avatar, radius: 9),
                  const SizedBox(width: 6),
                  Text(
                    channel.streamer,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, color: Colors.white38),
      ],
    );
  }

  String _formatViewers(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M Viewers';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K Viewers';
    return '$v Viewers';
  }
}

/// Modelo simple
class Channel {
  final String title;
  final int viewers;
  final String streamer;
  final String thumb;
  final String avatar;
  final bool live;

  Channel({
    required this.title,
    required this.viewers,
    required this.streamer,
    required this.thumb,
    required this.avatar,
    this.live = true,
  });
}

/// Avatar redondo que soporta SVG y raster
class AvatarRound extends StatelessWidget {
  final String assetPath;
  final double radius;

  const AvatarRound({
    super.key,
    required this.assetPath,
    this.radius = 9,
  });

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    if (_isSvg) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            assetPath,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(assetPath),
      );
    }
  }
}
