import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      {
        'title': 'Lista de\nPersonagens',
        'image': 'assets/images/char_icon_homepage.png',
        'route': '/character-select',
      },
      {
        'title': 'Rolagem\nde Dados',
        'image': 'assets/images/dice_icon_homepage.png',
        'route': '/dice-roller',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Aventuris APP'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: cards.map((card) {
            return _customCardWidget(context, card);
          }).toList(),
        ),
      ),
    );
  }

  GestureDetector _customCardWidget(
    BuildContext context,
    Map<String, String> card,
  ) {
    return GestureDetector(
      onTap: () => context.go(card['route']!),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox.expand(
                child: Image.asset(card['image']!, fit: BoxFit.cover),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox.expand(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  card['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(0, 0),
                        blurRadius: 6,
                      ),
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
