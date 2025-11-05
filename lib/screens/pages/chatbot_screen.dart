import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundImage = 'assets/images/backgrounds/vitral.jpg';
    const avatarImage = 'assets/images/backgrounds/ira.jpg';
    const commentAvatarsPath = 'assets/images/svgs/';
    const redAccent = Color(0xFF7A0E0E);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: Stack(
        children: [
          // FONDO PRINCIPAL
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.55),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // CONTENIDO SCROLLEABLE
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra superior
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 110, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),  
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Imagen de usuario / streamer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2), width: 1.2),
                          image: DecorationImage(
                            image: AssetImage(avatarImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Título y botón Seguir
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Guía de los lamentos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text(
                            'Seguir',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Comentarios
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Comentarios',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Lista de comentarios
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _CommentItem(
                          name: 'Piyush',
                          message: 'No puedo pasar el nivel 1',
                          avatar: '${commentAvatarsPath}odium.svg'),
                      _CommentItem(
                          name: 'Jagjit',
                          message: 'Buaf q pro',
                          avatar: '${commentAvatarsPath}lamentador.svg'),
                      _CommentItem(
                          name: 'Pradeep',
                          message: 'Gracias por la guía',
                          avatar: '${commentAvatarsPath}stalker.svg'),
                      _CommentItem(
                          name: 'Gunnagyam',
                          message: 'awa de coco',
                          avatar: '${commentAvatarsPath}nicromante.svg'),
                      _CommentItem(
                          name: 'Sumit',
                          message: 'detrás de ti',
                          avatar: '${commentAvatarsPath}cascara.svg'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // CAMPO DE TEXTO INFERIOR
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: redAccent.withOpacity(0.5)),
                ),
                child: const Text(
                  'Di algo...',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Widget de Comentario ---------- */
class _CommentItem extends StatelessWidget {
  final String name;
  final String message;
  final String avatar;

  const _CommentItem({
    required this.name,
    required this.message,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey.shade900,
        child: SvgPicture.asset(
          avatar,
          fit: BoxFit.cover,
          width: 36,
          height: 36,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Color(0xFFFF3B3B), // rojo apagado tipo “demoníaco”
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
