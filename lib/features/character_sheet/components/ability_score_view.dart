import 'package:aventuris_app/features/character_sheet/components/skills_proficiency_view.dart';
import 'package:aventuris_app/features/character_sheet/controllers/character_controller.dart';
import 'package:aventuris_app/features/character_sheet/models/character_model.dart';
import 'package:aventuris_app/features/character_sheet/widgets/title_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbilityScoresView extends ConsumerWidget {
  final CharacterModel character;

  const AbilityScoresView({super.key, required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    if (character == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const TitleDivider(title: 'Valores de Atributos'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AbilityBox(title: 'STR', value: character.strength),
              _AbilityBox(title: 'DEX', value: character.dexterity),
              _AbilityBox(title: 'CON', value: character.constitution),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AbilityBox(title: 'INT', value: character.intelligence),
              _AbilityBox(title: 'WIS', value: character.wisdom),
              _AbilityBox(title: 'CHA', value: character.charisma),
            ],
          ),
        ),
        SkillsProficiencyView(),
      ],
    );
  }
}

class _AbilityBox extends ConsumerWidget {
  final String title;
  final int value;

  const _AbilityBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () => _showEditPopup(context, ref),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '${value > 10 ? '+' : ''}${((value - 10) / 2).floor()}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPopup(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Alterar $title'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 80,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: controller,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    final input = int.tryParse(controller.text);
                    if (input != null) {
                      final charController = ref.read(
                        characterProvider.notifier,
                      );

                      switch (title) {
                        case 'Força':
                          charController.updateStrength(input);
                          break;
                        case 'Destreza':
                          charController.updateDexterity(input);
                          break;
                        case 'Constituição':
                          charController.updateConstitution(input);
                          break;
                        case 'Inteligência':
                          charController.updateIntelligence(input);
                          break;
                        case 'Sabedoria':
                          charController.updateWisdom(input);
                          break;
                        case 'Carisma':
                          charController.updateCharisma(input);
                          break;
                      }
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
