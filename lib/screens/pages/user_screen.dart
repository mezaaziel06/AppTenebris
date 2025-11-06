import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(143, 14, 4, 1),// Fondo oscuro gamer
      body: Stack(
        children: [
          // Fondo superior decorativo
          Container(
            height: size.height * 0.35,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(143, 14, 4, 1), Color.fromARGB(255, 58, 8, 4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Imagen de perfil
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color.fromARGB(255, 79, 6, 6),
                    backgroundImage: AssetImage('assets/profile.png')
                  ),
                ),

                const SizedBox(height: 12),

                // Nombre del usuario
                // Nombre del usuario
Container(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  decoration: BoxDecoration(
    color: Color.fromARGB(105, 14, 14, 1), // Fondo rojo
    borderRadius: BorderRadius.circular(30), // Forma ovalada
  ),
  child: const Text(
    'SirGalahad',
    style: TextStyle(
      color: Colors.white, // Texto blanco
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  ),
),


                const SizedBox(height: 8),

                // Etiqueta opcional
                Text(
                  '@mauri_player',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 16),

                // Panel deslizable
                Expanded(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.45,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 41, 39, 39),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Indicador de arrastre
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(53, 230, 230, 225),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              // Estadísticas
                              const Text(
                                'Estadísticas',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: const [
                                  _StatCard(label: 'Muertes', value: '45'),
                                  _StatCard(label: 'Zona', value: '120'),
                                  _StatCard(label: 'Lugubres', value: '3420'),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // Logros
                              const Text(
                                'Logros',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _AchievementTile(
                                icon: Icons.star,
                                title: 'Pecador',
                                description: 'Derrota a 100 enemigos sin morir.',
                              ),
                              _AchievementTile(
                                icon: Icons.shield,
                                title: 'Abandonad toda esperanza',
                                description: 'Supera el prólogo.',
                              ),

                              const SizedBox(height: 25),

                              // Coleccionables
                              const Text(
                                'Coleccionables',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              SizedBox(
                                height: 100,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: const [
                                    _CollectibleCard(image: 'assets/item1.png', name: 'Espada dorada'),
                                    _CollectibleCard(image: 'assets/item2.png', name: 'Escudo arcano'),
                                    _CollectibleCard(image: 'assets/item3.png', name: 'Gema del caos'),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

// Widget para estadísticas
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color.fromARGB(255, 143, 7, 10),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }
}

// Widget para logros
class _AchievementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AchievementTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C3E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.amberAccent, size: 30),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: TextStyle(color: Colors.white.withOpacity(0.7))),
      ),
    );
  }
}

// Widget para coleccionables
class _CollectibleCard extends StatelessWidget {
  final String image;
  final String name;

  const _CollectibleCard({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A4F),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}