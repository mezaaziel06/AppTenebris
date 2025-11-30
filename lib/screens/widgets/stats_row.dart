import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final String deaths;
  final String zone;
  final String lugubres;

  const StatsRow({
    super.key,
    required this.deaths,
    required this.zone,
    required this.lugubres,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _stat("Muertes", deaths),
        _stat("Zona", zone),
        _stat("Lúgubres", lugubres),
      ],
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFB30000),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
          ),
        )
      ],
    );
  }
}
