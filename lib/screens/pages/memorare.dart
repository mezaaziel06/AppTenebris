import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/screens/pages/bestiarium.dart';

/// ====== Ajustes de layout (toca aquí para afinar) ======
const double kHeroHeight = 320; // ↑ altura del HERO (antes 260)
const double kSpaceAfterHero = 28; // espacio Hero → Carrusel
const double kAvatarSize = 76; // diámetro de cada avatar
const double kCarouselHeight = 112; // alto total carrusel (círculo + label)
const double kSpaceAfterCarousel = 28; // espacio Carrusel → Lore
const double kLoreCardHeight = 180; // ↑ altura de cada card de Lore (antes 132)
const double kLoreTitleSize = 22; // tamaño del título "Lore"

class MemorareScreen extends StatelessWidget {
  const MemorareScreen({super.key});

  // Catálogo de iconos locales
  List<_AvatarData> get _avatars => const [
    _AvatarData('Cáscara', 'assets/images/svgs/cascara.svg'),
    _AvatarData('Lamentador', 'assets/images/svgs/lamentador.svg'),
    _AvatarData('Stalker', 'assets/images/svgs/stalker.svg'),
    _AvatarData('Nicromante', 'assets/images/svgs/nicromante.svg'),
    _AvatarData('Odium', 'assets/images/svgs/odium.svg'),
    _AvatarData('Mala Copa', 'assets/images/svgs/mala copa.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    const heroImage = 'assets/images/backgrounds/vitral.jpg';

    // Tono “café” del círculo
    const coffee = Color(0xFF3B2B1F);
    const coffeeBorder = Color(0xFF5A4736);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: CustomScrollView(
        slivers: [
          // 1) HERO más grande
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.maybePop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () {},
              ),
            ],
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

          // 2) ESPACIO DESPUÉS DEL HERO
          SliverToBoxAdapter(child: SizedBox(height: kSpaceAfterHero)),

          // 3) CARRUSEL DE AVATARES
          SliverToBoxAdapter(
            child: SizedBox(
              height: kCarouselHeight,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _avatars.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final a = _avatars[i];
                  return GestureDetector(
                    onTap: () {
  Navigator.of(context, rootNavigator: false).push(
    MaterialPageRoute(builder: (_) => const BestiariumScreen()),
  );
},

                    child: _AvatarItem(
                      label: a.label,
                      asset: a.asset,
                      circleColor: coffee,
                      borderColor: coffeeBorder,
                      size: kAvatarSize,
                    ),
                  );
                },
              ),
            ),
          ),

          // 4) ESPACIO CARRUSEL → LORE
          SliverToBoxAdapter(child: SizedBox(height: kSpaceAfterCarousel)),

          // 5) LORE (más grande)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lore',
                          style: TextStyle(
                            fontSize: kLoreTitleSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Mostrar todo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _LoreCard(
                          title: 'Limbo',
                          image: heroImage,
                          height: kLoreCardHeight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LoreCard(
                          title: 'Lujuria',
                          image: heroImage,
                          height: kLoreCardHeight,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Divider(color: Colors.white12, height: 1, thickness: 1),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Widgets ---------- */

class _AvatarItem extends StatelessWidget {
  final String label;
  final String asset;
  final Color circleColor;
  final Color borderColor;
  final double size; // diámetro del círculo

  const _AvatarItem({
    required this.label,
    required this.asset,
    required this.circleColor,
    required this.borderColor,
    this.size = 76,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Círculo con el SVG llenándolo por completo
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              allowDrawingOutsideViewBox: true,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: size + 12,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.92),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoreCard extends StatelessWidget {
  final String title;
  final String image;
  final double height;

  const _LoreCard({
    required this.title,
    required this.image,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
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
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- Modelo simple ---------- */
class _AvatarData {
  final String label;
  final String asset;
  const _AvatarData(this.label, this.asset);
}
