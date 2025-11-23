import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/ira.jpg',
              fit: BoxFit.cover,
            ),
          ),

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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Spacer(),

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

// -----------------------------------------------------
// MODELO CHANNEL
// -----------------------------------------------------
class Channel {
  final String title;
  final int viewers;
  final String streamer;
  final String thumb;
  final String avatar;
  final bool live;
  final String youtubeUrl;

  Channel({
    required this.title,
    required this.viewers,
    required this.streamer,
    required this.thumb,
    required this.avatar,
    required this.live,
    required this.youtubeUrl,
  });
}

// -----------------------------------------------------
// LISTA DE CANALES
// -----------------------------------------------------
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
      youtubeUrl: 'https://youtu.be/Gub3zXa35wg?si=sxnWlkAI9ZrtnAT2',
    ),
    Channel(
      title: 'Diseño de nivel...',
      viewers: 23500,
      streamer: 'Javi',
      thumb: 'assets/images/backgrounds/timeline.jpeg',
      avatar: 'assets/images/svgs/odium.svg',
      live: true,
      youtubeUrl: 'https://youtu.be/c59L23hTWyc',
    ),
     Channel(
      title: 'Game Tour...',
      viewers: 23500,
      streamer: 'Ravi',
      thumb: 'assets/images/backgrounds/morado.jpg',
      avatar: 'assets/images/svgs/odium.svg',
      live: true,
      youtubeUrl: 'https://youtube.com/watch?v=aqz-KE-bpKQ',
    ),
    Channel(
      title: 'World Tourn...',
      viewers: 20500,
      streamer: 'Agnes',
      thumb: 'assets/images/backgrounds/ira.jpg',
      avatar: 'assets/images/svgs/stalker.svg',
      live: true,
      youtubeUrl: 'https://youtube.com/watch?v=z9Ul9ccDOqE',
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

// -----------------------------------------------------
// ITEM DE LA LISTA (TARJETA DEL CANAL)
// -----------------------------------------------------
class ChannelTile extends StatelessWidget {
  final Channel channel;
  const ChannelTile({super.key, required this.channel});

  Future<void> _openYoutube() async {
    final url = Uri.parse(channel.youtubeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ No se pudo abrir YouTube");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openYoutube,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
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

          // INFO
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
      ),
    );
  }

  String _formatViewers(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M Viewers';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K Viewers';
    return '$v Viewers';
  }
}

// -----------------------------------------------------
// CÍRCULO DE AVATAR SVG
// -----------------------------------------------------
class AvatarRound extends StatelessWidget {
  final String assetPath;
  final double radius;
  const AvatarRound({super.key, required this.assetPath, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SvgPicture.asset(
        assetPath,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
      ),
    );
  }
}
