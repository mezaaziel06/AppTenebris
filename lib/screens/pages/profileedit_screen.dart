import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../services/avatar_service.dart';
import '../../services/user_service.dart';
import '../../screens/pages/avatar_picker_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  String? avatarUrl;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile["display_name"] ?? "";
    avatarUrl = widget.profile["avatar_url"];
  }

  Future<void> save() async {
    setState(() => loading = true);

    final service = UserService();

    try {
      await service.updateUser(
        displayName: _nameController.text,
        avatarUrl: avatarUrl ?? "",
      );

      if (!mounted) return;

      Navigator.pop(context, true); // regresar confirmando que se guardó
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error al actualizar el perfil"),
        ),
      );
    }

    setState(() => loading = false);
  }

  void pickAvatar() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AvatarPickerScreen(),
      ),
    );

    if (selected != null) {
      setState(() {
        avatarUrl = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = avatarUrl;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ========================
            // AVATAR
            // ========================
            GestureDetector(
              onTap: pickAvatar,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.redAccent,
                backgroundImage: (avatar != null && avatar.isNotEmpty)
                    ? NetworkImage(avatar)
                    : const AssetImage("assets/images/avatars/default.png")
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 12),

            TextButton(
              onPressed: pickAvatar,
              child: const Text("Cambiar avatar", style: TextStyle(color: Colors.redAccent)),
            ),

            const SizedBox(height: 24),

            // ========================
            // DISPLAY NAME
            // ========================
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Nombre",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ========================
            // SAVE BUTTON
            // ========================
            ElevatedButton(
              onPressed: loading ? null : save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Guardar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
