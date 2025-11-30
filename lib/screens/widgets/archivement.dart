import 'package:flutter/material.dart';

class AchievementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AchievementTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white24,
          width: 0.6,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 32),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
