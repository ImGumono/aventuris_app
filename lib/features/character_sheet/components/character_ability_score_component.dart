import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/title_divider_widget.dart';
import '../viewmodels/character_viewmodel.dart';

class CharacterAbilityScoreComponent extends ConsumerWidget {
  final CharacterViewModel viewModel;

  const CharacterAbilityScoreComponent({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = viewModel.character; // precisa do getter
    if (character == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const TitleDivider(title: 'Valores de Atributos'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _AbilityBox(
              title: 'For',
              value: character.strength,
              modifier: viewModel.strengthModifier,
              onEdit: viewModel.updateStrength,
            ),
            _AbilityBox(
              title: 'Des',
              value: character.dexterity,
              modifier: viewModel.dexterityModifier,
              onEdit: viewModel.updateDexterity,
            ),
            _AbilityBox(
              title: 'Con',
              value: character.constitution,
              modifier: viewModel.constitutionModifier,
              onEdit: viewModel.updateConstitution,
            ),
            _AbilityBox(
              title: 'Int',
              value: character.intelligence,
              modifier: viewModel.intelligenceModifier,
              onEdit: viewModel.updateIntelligence,
            ),
            _AbilityBox(
              title: 'Sab',
              value: character.wisdom,
              modifier: viewModel.wisdomModifier,
              onEdit: viewModel.updateWisdom,
            ),
            _AbilityBox(
              title: 'Car',
              value: character.charisma,
              modifier: viewModel.charismaModifier,
              onEdit: viewModel.updateCharisma,
            ),
          ],
        ),
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
                  shadows: const [
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
