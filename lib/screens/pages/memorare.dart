import 'package:flutter/material.dart';

class MemorareScreen extends StatelessWidget {
  const MemorareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Memorare Screen',
          style: Theme.of(context).textTheme.headlineLarge
        ),
      ),
    );
  }
}