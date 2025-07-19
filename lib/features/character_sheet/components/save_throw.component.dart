import 'package:aventuris_app/features/character_sheet/controllers/character_controller.dart';
import 'package:aventuris_app/features/character_sheet/widgets/title_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveThrowComponent extends ConsumerWidget {
  const SaveThrowComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);
    final controller = ref.read(characterProvider.notifier);

    if (character == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const TitleDivider(title: 'Salva-guardas'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 40,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [
            _buildSaveThrow(
              'Força',
              controller.calculateModifier(character.strength),
            ),
            _buildSaveThrow(
              'Destreza',
              controller.calculateModifier(character.dexterity),
            ),
            _buildSaveThrow(
              'Constituição',
              controller.calculateModifier(character.constitution),
            ),
            _buildSaveThrow(
              'Inteligência',
              controller.calculateModifier(character.intelligence),
            ),
            _buildSaveThrow(
              'Sabedoria',
              controller.calculateModifier(character.wisdom),
            ),
            _buildSaveThrow(
              'Carisma',
              controller.calculateModifier(character.charisma),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSaveThrow(String title, int value) {
    return Column(
      children: [
        Text(
          value >= 0 ? '+$value' : '$value',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(height: 1, width: 100, color: Colors.black),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
