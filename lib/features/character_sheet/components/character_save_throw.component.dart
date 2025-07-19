import 'package:aventuris_app/features/character_sheet/providers/character_providers.dart';
import 'package:aventuris_app/features/character_sheet/widgets/title_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterSaveThrowComponent extends ConsumerWidget {
  final String characterId;

  const CharacterSaveThrowComponent({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(
      characterViewModelProvider(characterId).notifier,
    );
    final state = ref.watch(characterViewModelProvider(characterId));

    return state.when(
      data: (character) {
        if (character == null) {
          return const Center(child: Text('Nenhum personagem carregado'));
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
                _buildSaveThrow('Força', viewModel.strengthModifier),
                _buildSaveThrow('Destreza', viewModel.dexterityModifier),
                _buildSaveThrow('Constituição', viewModel.constitutionModifier),
                _buildSaveThrow('Inteligência', viewModel.intelligenceModifier),
                _buildSaveThrow('Sabedoria', viewModel.wisdomModifier),
                _buildSaveThrow('Carisma', viewModel.charismaModifier),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro: $error')),
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
