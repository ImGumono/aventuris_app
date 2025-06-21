import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aventuris APP')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Character Sheet'),
            onTap: () => context.go('/character-sheet'),
          ),
          ListTile(
            title: const Text('Dice Roller'),
            onTap: () => context.go('/dice-roller'),
          ),
          ListTile(
            title: const Text('Name Generator'),
            onTap: () => context.go('/name-generator'),
          ),
          ListTile(
            title: const Text('Campaign'),
            onTap: () => context.go('/campaign'),
          ),
        ],
      ),
    );
  }
}
