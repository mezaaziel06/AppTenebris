import 'package:flutter/material.dart';
import 'package:apptenebris/services/auth_service.dart';
import 'package:apptenebris/core/constants/text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  Future<void> _register() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final confirm = confirmCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      return _msg("Todos los campos son obligatorios");
    }

    if (pass != confirm) {
      return _msg("Las contraseñas no coinciden");
    }

    final auth = AuthService();
    final ok = await auth.register(email, pass);

    if (ok) {
      _msg("Registro exitoso. Bienvenido 👑");
      Navigator.pushReplacementNamed(context, "/splash");
    } else {
      _msg("No se pudo registrar");
    }
  }

  void _msg(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: Image.asset(
            "assets/images/backgrounds/vitral.jpg",
            fit: BoxFit.cover,
          )),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _input(emailCtrl, "EMAIL"),
                  const SizedBox(height: 20),
                  _input(passCtrl, "PASSWORD", obscure: true),
                  const SizedBox(height: 20),
                  _input(confirmCtrl, "CONFIRM PASSWORD", obscure: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF540000),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "REGISTER",
                      style: AppTextStyles.title.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String label, {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
