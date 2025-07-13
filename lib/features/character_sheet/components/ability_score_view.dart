import 'package:aventuris_app/features/character_sheet/components/skills_proficiency_view.dart';
import 'package:aventuris_app/features/character_sheet/controllers/character_controller.dart';
import 'package:aventuris_app/features/character_sheet/models/character_model.dart';
import 'package:aventuris_app/features/character_sheet/widgets/title_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbilityScoresView extends ConsumerWidget {
  const AbilityScoresView({super.key, required this.character});
  final CharacterModel character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);
    final controller = ref.read(characterProvider.notifier);

    if (character == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const TitleDivider(title: 'Valores de Atributos'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _AbilityBox(
                title: 'For',
                value: character.strength,
                modifier: controller.calculateModifier(character.strength),
                onEdit: (v) => controller.updateStrength(v),
              ),
              _AbilityBox(
                title: 'Des',
                value: character.dexterity,
                modifier: controller.calculateModifier(character.dexterity),
                onEdit: (v) => controller.updateDexterity(v),
              ),
              _AbilityBox(
                title: 'Con',
                value: character.constitution,
                modifier: controller.calculateModifier(character.constitution),
                onEdit: (v) => controller.updateConstitution(v),
              ),
              _AbilityBox(
                title: 'Int',
                value: character.intelligence,
                modifier: controller.calculateModifier(character.intelligence),
                onEdit: (v) => controller.updateIntelligence(v),
              ),
              _AbilityBox(
                title: 'Sab',
                value: character.wisdom,
                modifier: controller.calculateModifier(character.wisdom),
                onEdit: (v) => controller.updateWisdom(v),
              ),
              _AbilityBox(
                title: 'Car',
                value: character.charisma,
                modifier: controller.calculateModifier(character.charisma),
                onEdit: (v) => controller.updateCharisma(v),
              ),
            ],
          ),
        ),
        SkillsProficiencyView(),
      ],
    );
  }
}

class _AbilityBox extends StatelessWidget {
  final String title;
  final int value;
  final int modifier;
  final ValueChanged<int> onEdit;

  const _AbilityBox({
    required this.title,
    required this.value,
    required this.modifier,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showEditPopup(context),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          width: 115,
          height: 115,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                modifier >= 0 ? '+$modifier' : '$modifier',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPopup(BuildContext context) {
    final tec = TextEditingController(text: value.toString());

    final Map<String, String> fullNames = {
      'For': 'Força',
      'Des': 'Destreza',
      'Con': 'Constituição',
      'Int': 'Inteligência',
      'Sab': 'Sabedoria',
      'Car': 'Carisma',
    };
    final displayTitle = fullNames[title] ?? title;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(displayTitle, textAlign: TextAlign.center),
        content: SizedBox(
          width: 100,
          height: 80,
          child: Center(
            child: SizedBox(
              width: 80,
              child: TextField(
                autofocus: true,
                controller: tec,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Valor',
                ),
              ),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final input = int.tryParse(tec.text);
              if (input != null) {
                onEdit(input);
              }
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
