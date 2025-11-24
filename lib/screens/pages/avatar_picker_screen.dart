import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/avatar_service.dart';

class AvatarPickerScreen extends StatefulWidget {
  const AvatarPickerScreen({super.key});

  @override
  State<AvatarPickerScreen> createState() => _AvatarPickerScreenState();
}
class _AvatarPickerScreenState extends State<AvatarPickerScreen> {
  final AvatarService _service = AvatarService();
  List<dynamic> avatars = [];
  bool loading = true;

  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    loadAvatars();
  }

  Future<void> loadAvatars() async {
    try {
      final items = await _service.getAvatars();

      setState(() {
        avatars = items;
        loading = false;
      });
    } catch (e) {
      print("❌ Error cargando avatars: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Selecciona un Avatar",
          style: TextStyle(letterSpacing: 1.1),
        ),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : avatars.isEmpty
              ? const Center(
                  child: Text(
                    "No hay avatares disponibles",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: avatars.length,
                  itemBuilder: (_, i) {
                    final avatar = avatars[i];
                    final url = avatar["url"];

                    final isSelected = selectedAvatar == url;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedAvatar = url);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.redAccent
                                : Colors.white.withOpacity(0.2),
                            width: isSelected ? 4 : 1.5,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black,
        child: ElevatedButton(
          onPressed: selectedAvatar == null
              ? null
              : () {
                  Navigator.pop(context, selectedAvatar);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            disabledBackgroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Guardar",
            style: TextStyle(fontSize: 18, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }
}
