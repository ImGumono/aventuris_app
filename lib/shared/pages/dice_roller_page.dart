import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiceRollerPage extends StatelessWidget {
  const DiceRollerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Rolagem de Dados'),
      ),
      body: const Center(
        child: Text(
          'Em Breve',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
