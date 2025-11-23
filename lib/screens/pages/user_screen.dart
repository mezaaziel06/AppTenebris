import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/stats_row.dart';
import '../widgets/archivement.dart';
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
      print('❌ Error cargando usuario: $e');
      setState(() => isLoading = false);
    }
  }

  /// 🔥 Abre la pantalla de editar perfil
  Future<void> _openEdit() async {
    if (userData == null) return;

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          user: userData!,
        ),
      ),
    );

    if (updated != null) {
      setState(() => userData = updated);
    }
  }

  // ------------------------------------------------------------
  // 🔥 ESTE build DEBE ESTAR FUERA DE CUALQUIER MÉTODO
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Error cargando datos del usuario",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 🔥 FONDO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Color(0xFF240000),
                  Color(0xFF1A0000),
                  Colors.black,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 25),

                // 🔥 Avatar editable
                ProfileAvatar(
                  imageUrl: userData!.avatarUrl,
                  onTap: _openEdit,
                ),

                const SizedBox(height: 12),

                Chip(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  label: Text(
                    userData!.displayName.isEmpty
                        ? "Sin nombre"
                        : userData!.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),

                Text(
                  userData!.email,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    maxChildSize: 0.9,
                    minChildSize: 0.45,
                    builder: (_, controller) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.80),
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(28)),
                          border: Border(
                            top: BorderSide(
                              color: Colors.red.withOpacity(0.20),
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: ListView(
                          controller: controller,
                          children: const [
                            SizedBox(height: 20),
                            StatsRow(
                              deaths: '45',
                              zone: '120',
                              lugubres: '3420',
                            ),
                            SizedBox(height: 25),
                            Text(
                              "Logros",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            AchievementTile(
                              icon: Icons.star,
                              title: "Pecador",
                              description: "Derrota a 100 enemigos sin morir.",
                            ),
                            AchievementTile(
                              icon: Icons.shield,
                              title: "Abandonad toda esperanza",
                              description: "Supera el prólogo.",
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Coleccionables",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
