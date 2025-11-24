import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/avatar_service.dart';
import '../../services/lore_service.dart';
import '/screens/pages/bestiarium.dart';

/// ====== Ajustes ======
const double kHeroHeight = 320;
const double kSpaceAfterHero = 28;
const double kAvatarSize = 76;
const double kCarouselHeight = 112;
const double kSpaceAfterCarousel = 28;
const double kLoreCardHeight = 180;
const double kLoreTitleSize = 22;

class MemorareScreen extends StatefulWidget {
  const MemorareScreen({super.key});

  @override
  State<MemorareScreen> createState() => _MemorareScreenState();
}

class _MemorareScreenState extends State<MemorareScreen> {
  final AvatarService _avatarService = AvatarService();
  final LoreService _loreService = LoreService();

  List<MediaItem> avatarItems = [];
  List<MediaItem> loreItems = [];

  bool loadingAvatars = true;
  bool loadingLore = true;

  @override
  void initState() {
    super.initState();
    loadAvatars();
    loadLore();
  }

  Future<void> loadAvatars() async {
    final data = await _avatarService.getAvatars();
    setState(() {
      avatarItems = data;
      loadingAvatars = false;
    });
  }

  Future<void> loadLore() async {
    final data = await _loreService.getLore();
    setState(() {
      loreItems = data;
      loadingLore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const heroImage = 'assets/images/backgrounds/vitral.jpg';
    const coffee = Color(0xFF3B2B1F);
    const coffeeBorder = Color(0xFF5A4736);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: CustomScrollView(
        slivers: [
          // -------- HERO --------
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.maybePop(context),
            ),
            pinned: true,
            expandedHeight: kHeroHeight,
            backgroundColor: const Color(0xFF0B0B0B),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('Memorare'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(heroImage, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x660B0B0B),
                          Color(0xCC0B0B0B),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: kSpaceAfterHero)),

          // -------- AVATARES (CARRUSEL) --------
          SliverToBoxAdapter(
            child: SizedBox(
              height: kCarouselHeight,
              child: loadingAvatars
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
                    )
                  : avatarItems.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay avatares",
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: avatarItems.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, i) {
                            final a = avatarItems[i];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BestiariumScreen(
                                            media: a,
                                          )),
                                );
                              },
                              child: _AvatarItem(
                                label: a.title,
                                url: a.url,
                                circleColor: coffee,
                                borderColor: coffeeBorder,
                                size: kAvatarSize,
                              ),
                            );
                          },
                        ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: kSpaceAfterCarousel)),

          // -------- LORE --------
          // -------- LORE --------
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Loading
        if (loadingLore)
          const Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          ),

        // Sin datos
        if (!loadingLore && loreItems.isEmpty)
          const Center(
            child: Text(
              "No hay lore disponible",
              style: TextStyle(color: Colors.white54),
            ),
          ),

        // Grid Lore
        if (!loadingLore && loreItems.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: _LoreCard(
                  media: loreItems[0],
                  height: kLoreCardHeight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: loreItems.length > 1
                    ? _LoreCard(
                        media: loreItems[1],
                        height: kLoreCardHeight,
                      )
                    : _FakeLoreCard(height: kLoreCardHeight),
              ),
            ],
          ),

        const SizedBox(height: 24),
        Divider(color: Colors.white12, height: 1),
        const SizedBox(height: 16),
      ],
    ),
  ),
),
],
      ),
    );
  }
}

/* ---------------- AVATAR ITEM ---------------- */

class _AvatarItem extends StatelessWidget {
  final String label;
  final String url;
  final Color circleColor;
  final Color borderColor;
  final double size;

  const _AvatarItem({
    required this.label,
    required this.url,
    required this.circleColor,
    required this.borderColor,
    this.size = 76,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = url.toLowerCase().endsWith(".svg");

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: ClipOval(
            child: isSvg
                ? SvgPicture.network(url, fit: BoxFit.cover)
                : Image.network(url, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: size + 12,
          child: Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/* ---------------- LORE CARD ---------------- */

class _LoreCard extends StatelessWidget {
  final MediaItem media;
  final double height;

  const _LoreCard({
    required this.media,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = media.url.toLowerCase().endsWith(".svg");

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BestiariumScreen(media: media)),
        );
      },
      child: SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              isSvg
                  ? SvgPicture.network(media.url, fit: BoxFit.cover)
                  : Image.network(media.url, fit: BoxFit.cover),

              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xB3000000), Colors.transparent],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    media.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------- FAKE CARD cuando hay 1 solo -------- */

class _FakeLoreCard extends StatelessWidget {
  final double height;
  const _FakeLoreCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white12,
      ),
      child: const Center(
        child: Text(
          "Próximamente",
          style: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }
}
