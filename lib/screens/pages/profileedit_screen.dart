import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  String newAvatar = "";

  final userService = UserService();

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.user.displayName);
    newAvatar = widget.user.avatarUrl;
  }

  Future<void> save() async {
    final updatedUser = await userService.updateUser(
      displayName: nameCtrl.text,
      avatarUrl: newAvatar,
    );

    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nombre",
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Aquí luego cargaremos foto real
                setState(() {
                  newAvatar = "https://i.pravatar.cc/300";
                });
              },
              child: const Text("Cambiar foto"),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: save,
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}
