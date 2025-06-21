import 'package:aventuris_app/features/character_sheet/controllers/character_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterProfileView extends ConsumerWidget {
  const CharacterProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);
    final controller = ref.read(characterProvider.notifier);

    if (character == null) {
      return const Center(child: Text('Nenhum personagem carregado'));
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Coluna Esquerda
              SizedBox(
                height: 200,
                width: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProperty(
                      icon: Icons.favorite_sharp,
                      title: 'Pontos de Vida',
                      text: '${character.life}/${character.maxLife}',
                    ),
                    _buildProperty(
                      icon: Icons.favorite_border_sharp,
                      title: 'Pontos de Vida Temporários',
                      text:
                          '${character.temporaryLife}/${character.temporaryMaxLife}',
                    ),
                    _buildProperty(
                      icon: Icons.shield,
                      title: 'Classe de Armadura',
                      text: '${character.armorClass}',
                    ),
                  ],
                ),
              ),

              // Avatar no Meio
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 3,
                        ),
                      ),
                      child: const Icon(Icons.person, size: 50),
                    ),
                  ),
                ],
              ),

              // Coluna Direita
              SizedBox(
                height: 200,
                width: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProperty(
                      icon: Icons.flash_on,
                      title: 'Iniciativa',
                      text: '+${controller.getInitiative().toString()}',
                    ),
                    _buildProperty(
                      icon: Icons.remove_red_eye,
                      title: 'Percepção Passiva',
                      text: controller.getPassivePerception().toString(),
                    ),
                    _buildProperty(
                      icon: Icons.sports_martial_arts,
                      title: 'Bônus de Proficiência',
                      text: '+${controller.getProficiencyBonus().toString()}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildTitleBar(context, character),
        ],
      ),
    );
  }

  /// Widget de propriedade individual
  Widget _buildProperty({
    required String title,
    required String text,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(icon, size: 18),
            ),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(
          width: 80,
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
          ),
        ),
      ],
    );
  }

  /// Barra inferior com nome, classe e nível
  Container _buildTitleBar(BuildContext context, character) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${character.name} | ${character.race} | ${character.characterClass} ${character.level}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                wordSpacing: 5,
                letterSpacing: 3,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
