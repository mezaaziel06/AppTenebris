import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatbotScreen(),
  ));
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  // === Constantes/Assets ===
  static const redAccent = Color(0xFF7A0E0E);
  static const backgroundImage = 'assets/images/backgrounds/vitral.jpg';
  static const avatarImage = 'assets/images/backgrounds/ira.jpg';
  static const commentAvatarsPath = 'assets/images/svgs/';

  // Límite del sheet (para alinear el título)
  static const double kMaxSheet = 0.60;

  // Estado
  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();
  ScrollController? _sheetCtrl;

  final List<_Message> _items = [
    const _Message.system(name: 'Comentarios'),
    const _Message(
      name: 'Piyush',
      text: 'No puedo pasar el nivel 1',
      avatar: '${commentAvatarsPath}odium.svg',
      isUser: false,
    ),
    const _Message(
      name: 'Jagjit',
      text: 'Buaf q pro',
      avatar: '${commentAvatarsPath}lamentador.svg',
      isUser: false,
    ),
    const _Message(
      name: 'Pradeep',
      text: 'Gracias por la guía',
      avatar: '${commentAvatarsPath}stalker.svg',
      isUser: false,
    ),
    const _Message(
      name: 'Gunnagyam',
      text: 'awa de coco',
      avatar: '${commentAvatarsPath}nicromante.svg',
      isUser: false,
    ),
    const _Message(
      name: 'Sumit',
      text: 'detrás de ti',
      avatar: '${commentAvatarsPath}cascara.svg',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(_Message(name: 'Tú', text: text, isUser: true));
    });
    _textCtrl.clear();

    // Auto-scroll al final dentro del sheet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = _sheetCtrl;
      if (c != null && c.hasClients) {
        c.animateTo(
          c.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Deja que el teclado empuje el input fijo (abajo)
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ===== Fondo principal (nivel) =====
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.35),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // ===== Degradado superior sobre la imagen (profundidad) =====
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6],
                  ),
                ),
              ),
            ),
          ),

          // ===== Top bar + avatar (parte del "nivel") =====
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const Spacer(),
                      const _ViewsBadge(count: '124.5K'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // avatar "nivel"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.22),
                          width: 1.2,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(avatarImage),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // (No ponemos el título aquí)
              ],
            ),
          ),

          // ===== Título + "Seguir" ANCLADOS justo arriba del límite del chat =====
          Positioned(
            // El borde superior del chat a su máximo está a 0.60 * altura desde abajo.
            // Colocamos el título justo un poco por encima (8 px).
            bottom: size.height * kMaxSheet + 8,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Guía de los lamentos',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redAccent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Seguir',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== Panel de chat arrastrable (oscuro sólido, sin transparencias) =====
          DraggableScrollableSheet(
            minChildSize: 0.28,
            initialChildSize: 0.45,
            maxChildSize: kMaxSheet, // 0.60
            snap: true,
            snapSizes: const [0.28, 0.45, kMaxSheet],
            builder: (context, controller) {
              _sheetCtrl ??= controller;

              // Altura reservada para el input fijo
              const inputReserve = 80.0;

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF141212), // tono oscuro sólido
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.07), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: CustomScrollView(
                    controller: controller,
                    slivers: [
                      // handle + etiqueta "Comentarios"
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              width: 74,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Comentarios',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),

                      // lista con divisiones sutiles
                      SliverList.separated(
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                        itemBuilder: (context, i) {
                          final m = _items[i];
                          if (m.isSystemLabel) return const SizedBox.shrink();
                          if (m.isUser) return _UserBubble(text: m.text);
                          return _CommentItem(
                            name: m.name,
                            message: m.text,
                            avatar: m.avatar!,
                          );
                        },
                      ),

                      // espacio inferior para no tapar últimos ítems por el input fijo
                      const SliverToBoxAdapter(child: SizedBox(height: inputReserve)),
                    ],
                  ),
                ),
              );
            },
          ),

          // ===== Velo inferior + Input FIJO =====
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.88),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Campo de texto (oscuro sólido, borde rojo)
                    Expanded(
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: const Color(0xFF181515), // oscuro sólido
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: redAccent, // borde rojo
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _textCtrl,
                          focusNode: _focusNode,
                          onSubmitted: (_) => _send(),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Di algo...',
                            hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Botón enviar ROJO
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: redAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== Helpers & UI ===================== */

class _Message {
  final String name;
  final String text;
  final String? avatar;
  final bool isUser;
  final bool isSystemLabel;

  const _Message({
    required this.name,
    required this.text,
    this.avatar,
    this.isUser = false,
  }) : isSystemLabel = false;

  // FIX: constructor "system" correcto
  const _Message.system({required this.name})
      : text = '',
        avatar = null,
        isUser = false,
        isSystemLabel = true;
}

class _ViewsBadge extends StatelessWidget {
  final String count;
  const _ViewsBadge({required this.count});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

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
        backgroundColor: const Color(0xFF0F0F0F),
        child: SvgPicture.asset(avatar, width: 30, height: 30),
      ),
      title: const SizedBox.shrink(), // ocultamos nombre para clavar el mock
      subtitle: Text(
        message,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      horizontalTitleGap: 12,
    );
  }
}

/// Burbuja simple para mensajes del usuario (lado derecho)
class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 6, 16, 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF7A0E0E), // rojo para mensajes del usuario
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }
}
