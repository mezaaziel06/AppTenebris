import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import '../../services/pdf_brain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// -----------------------------------------------------------------------------
// ChatbotScreen (archivo listo para pegar)
// -----------------------------------------------------------------------------
void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: ChatbotScreen()),
  );
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

  static const double kMaxSheet = 0.60;

  // Estado
  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();
  ScrollController? _sheetCtrl;

  // Sugerencias (chips)
  final List<String> _suggestions = [
    '¿Cómo paso el nivel?',
    'Dame una pista',
    '¿Qué hacen los lamentos?',
    'Explica a Odium',
    '¿Dónde está el símbolo rojo?',
    'Me atoro en un puzzle',
    '¿Cómo derrotar al jefe?',
    'Recomendaciones de equipo',
    'Buscar coleccionables cerca',
    'Atajos y secretos',
  ];

  // Lista de mensajes (vacía al inicio — el usuario iniciará la conversación)
  final List<_Message> _items = [];

  // Typing indicator
  bool _isTyping = false;

  // Dio client (para consumo de API real)
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    _sheetCtrl = null;
    _dio.close();
    super.dispose();
  }

  // Enviar mensaje local y solicitar respuesta
  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(_Message(name: 'Tú', text: text, isUser: true));
    });

    _textCtrl.clear();
    _focusNode.unfocus();

    _scrollToBottom();

    // Mostrar typing y obtener respuesta (local o desde API)
    setState(() => _isTyping = true);

    Future.delayed(const Duration(milliseconds: 400), () async {
      // Puedes cambiar _getBotReplyLocal por _getBotReplyFromApi para usar tu API.
      final reply = await _getBotReplyFromApi(text);

      setState(() {
        _isTyping = false;
        _items.add(
          _Message(
            name: 'Guía',
            text: reply,
            isUser: false,
            avatar: '${commentAvatarsPath}stalker.svg',
          ),
        );
      });
      _scrollToBottom();
    });
  }

  // Auto-scroll seguro al final del sheet
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = _sheetCtrl;
      if (c != null && c.hasClients) {
        c.animateTo(
          c.position.maxScrollExtent + 140,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Ejemplo: obtener respuesta desde tu API (descomenta y adapta)
Future<String> _getBotReplyFromApi(String question) async {
  try {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: "access_token");

    if (token == null) {
      return "No se encontró token. Inicia sesión para consultar la guía.";
    }

    final response = await _dio.post(
      'http://192.168.0.111:8000/v1/lore/chat',
      data: {"question": question},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    return response.data["answer"] ?? "La guía guardó silencio...";
  } catch (e) {
    return "No pude contactar la Guía... Error: $e";
  }
}



  // Si el usuario toca una sugerencia

void _onSuggestionTap(String text) {
  setState(() {
    _items.add(_Message(name: 'Tú', text: text, isUser: true));
    _isTyping = true;
  });
  _scrollToBottom();

  Future.delayed(const Duration(milliseconds: 400), () async {
    final reply = await _getBotReplyFromApi(text); // <-- IA real

    setState(() {
      _isTyping = false;
      _items.add(
        _Message(
          name: 'Guía',
          text: reply,
          isUser: false,
          avatar: '${commentAvatarsPath}stalker.svg',
        ),
      );
    });
    _scrollToBottom();
  });
}



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.35),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Degradado superior
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

          // Top bar y avatar
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      const _ViewsBadge(count: '124.5K'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
              ],
            ),
          ),

          // Título + seguir (anclado arriba del sheet)
          Positioned(
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
                      horizontal: 18,
                      vertical: 10,
                    ),
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

          // Sheet arrastrable del chat
          DraggableScrollableSheet(
            minChildSize: 0.28,
            initialChildSize: 0.45,
            maxChildSize: kMaxSheet,
            snap: true,
            snapSizes: const [0.28, 0.45, kMaxSheet],
            builder: (context, controller) {
              _sheetCtrl ??= controller;
              const inputReserve = 120.0; // más espacio para chips + input

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF141212),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.07),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: CustomScrollView(
                    controller: controller,
                    slivers: [
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

                      // Lista de mensajes (cada mensaje usa _ChatBubble)
                      SliverList.separated(
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 0),
                        itemBuilder: (context, i) {
                          final m = _items[i];
                          if (m.isSystemLabel) return const SizedBox.shrink();
                          return _ChatBubble(m);
                        },
                      ),

                      // typing indicator y margen final
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            if (_isTyping)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.55),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        SizedBox(
                                          width: 8,
                                          height: 8,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white70,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'La guía está escribiendo...',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: inputReserve),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Velo inferior + Input FIJO con chips de sugerencias
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sugerencias (chips horizontales)
                    SizedBox(
                      height: 46,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        itemBuilder: (context, index) {
                          final text = _suggestions[index];
                          return GestureDetector(
                            onTap: () => _onSuggestionTap(text),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: redAccent.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: redAccent.withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo de texto + boton enviar
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: const Color(0xFF181515),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: redAccent, width: 1),
                            ),
                            child: TextField(
                              controller: _textCtrl,
                              focusNode: _focusNode,
                              onSubmitted: (_) => _send(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Di algo...',
                                hintStyle: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _send,
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: redAccent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
          const Icon(
            Icons.remove_red_eye_outlined,
            size: 14,
            color: Colors.white70,
          ),
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

/// Item de comentario (izquierda) — usa SVGs para avatares
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
      title: const SizedBox.shrink(),
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

/// Burbuja principal usada por mensajes (izquierda/derecha)
class _ChatBubble extends StatelessWidget {
  final _Message msg;
  const _ChatBubble(this.msg);

  @override
  Widget build(BuildContext context) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color(0xFF7A0E0E).withOpacity(0.95)
                  : Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isUser
                    ? Colors.red.shade700
                    : Colors.white.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: isUser
                      ? Colors.red.withOpacity(0.28)
                      : Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              msg.text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
