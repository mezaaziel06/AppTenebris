import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptenebris/core/constants/text_styles.dart';
import 'package:apptenebris/state/providers/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    await auth.login(_emailCtrl.text.trim(), _passCtrl.text);

    if (!mounted) return;
    if (auth.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/splash');
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!)),
      );
    }
  }

  InputDecoration _input(String label) => InputDecoration(
        filled: true,
        fillColor: Colors.black.withOpacity(0.4), // igual a tu maquetado
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
      );

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // USERNAME (o email si prefieres)
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: _input('USERNAME'),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Ingresa tu usuario';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // PASSWORD
          TextFormField(
            controller: _passCtrl,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: _input('PASSWORD'),
            validator: (v) =>
                (v == null || v.length < 8) ? 'Mínimo 8 caracteres' : null,
          ),

          const SizedBox(height: 40),

          // Botón con el mismo tamaño visual (solo por padding)
          Center(
            child: ElevatedButton(
              onPressed: auth.loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 84, 0, 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: auth.loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'LOGIN',
                      style: AppTextStyles.title.copyWith(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
