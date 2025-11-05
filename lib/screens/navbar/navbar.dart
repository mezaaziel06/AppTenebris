import 'package:flutter/material.dart';

// IMPORTA TUS PANTALLAS REALES
import '/screens/pages/gallery_screen.dart';
import '/screens/pages/chatbot_screen.dart';
import '/screens/pages/user_screen.dart';
import '/screens/pages/memorare.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();

}

class _AppShellState extends State<AppShell> {
  int _index = 1; // inicia en Discover (como la captura)
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      GalleryScreen(),
      MemorareScreen(),
      ChatbotScreen(),
      UserScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Colores tipo “dorado” para el seleccionado
    final selected = const Color.fromARGB(255, 238, 64, 64); 
    final unselected = Colors.white70;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),

      // NavigationBar (Material 3). Si prefieres el clásico, ver nota al final.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        height: 64,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        backgroundColor: const Color(0xFF0E0E0E),
        indicatorColor: selected.withOpacity(0.10), // halo sutil
        indicatorShape: const CircleBorder(),       // círculo como la referencia
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined, color: unselected),
            selectedIcon: Icon(Icons.photo_library_rounded, color: selected),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: unselected),
            selectedIcon: Icon(Icons.explore_rounded, color: selected),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded, color: unselected),
            selectedIcon: Icon(Icons.chat_bubble_rounded, color: selected),
            label: 'Chatbot',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: unselected),
            selectedIcon: Icon(Icons.person_rounded, color: selected),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
