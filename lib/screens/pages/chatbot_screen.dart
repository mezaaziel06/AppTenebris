import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Chatbot Screen',
          style: Theme.of(context).textTheme.headlineLarge
        ),
      ),
    );
  }
}
