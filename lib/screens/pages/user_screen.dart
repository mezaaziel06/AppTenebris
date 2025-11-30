import 'dart:ui';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../pages/profileedit_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserModel? userData;
  bool isLoading = true;

  final _service = UserService();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final data = await _service.getUser();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error cargando usuario: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _openEdit() async {
    if (userData == null) return;

    final changed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(profile: userData!.toJson()),
      ),
    );

    if (changed == true) {
      await loadUser(); // 🔥 Reload total desde backend
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.redAccent),
        ),
      );
    }

    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("Error cargando usuario",
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF150000),
                  Color(0xFF0B0000),
                  Colors.black,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // TARJETA SUPERIOR (avatar + nombre)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.3),
                            width: 1.4,
                          ),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _openEdit,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.redAccent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent.withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage:
                                      _buildAvatar(userData!.avatarUrl),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              userData!.displayName.isEmpty
                                  ? "Sin nombre"
                                  : userData!.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.3,
                              ),
                            ),

                            Text(
                              userData!.email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // PANEL DESLIZABLE
                Expanded(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.60,
                    maxChildSize: 0.92,
                    minChildSize: 0.45,
                    builder: (_, controller) {
                      return Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.92),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: ListView(
                          controller: controller,
                          children: [
                            const SizedBox(height: 10),

                            // ----- STATS -----
                            _buildStatsRow(),

                            const SizedBox(height: 30),

                            // ----- LOGROS -----
                            const Text(
                              "Logros",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            _achievement(
                              "Pecador",
                              "Derrota a 100 enemigos sin morir",
                              Icons.bolt_rounded,
                            ),
                            _achievement(
                              "Abandonad toda esperanza",
                              "Supera el prólogo del juego",
                              Icons.shield,
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // AVATAR fallback
  ImageProvider _buildAvatar(String? url) {
    if (url == null || url.isEmpty) {
      return const AssetImage("assets/images/backgrounds/avatar.jpg");
    }
    return NetworkImage(url);
  }

  // STATS
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statBox("45", "Muertes"),
        _statBox("120", "Zonas"),
        _statBox("3420", "Lúgubres"),
      ],
    );
  }

  Widget _statBox(String value, String label) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.25),
            blurRadius: 10,
          )
        ],
        color: Colors.black.withOpacity(0.45),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // LOGRO (Achievement)
  Widget _achievement(String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(desc,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
