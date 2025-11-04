import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼 Fondo con la imagen vitral.jpg
          SizedBox.expand(
            child: Image.asset(
              'assets/images/backgrounds/vitral.jpg', // Asegúrate de que la ruta sea correcta
              fit: BoxFit.cover,
            ),
          ),

          // 🕶 Filtro oscuro encima del fondo
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // 🔲 Contenido principal (formulario)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SVG del logo/título (si lo tienes)
                  // SvgPicture.asset('assets/svgs/logo_ex_tenebris.svg', height: 120),

                  const SizedBox(height: 40),

                  // Username
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.4),
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.redAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.4),
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.redAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón LOGIN
                  ElevatedButton(
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
                    onPressed: () {
                      // Navegación a la galería u otra pantalla
                      // Navigator.pushNamed(context, '/gallery');
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
