import 'package:aventuris_app/features/character_sheet/components/character_ability_score_component.dart';
import 'package:aventuris_app/features/character_sheet/components/character_save_throw.component.dart';
import 'package:aventuris_app/features/character_sheet/components/character_skills_proficiency_component.dart';
import 'package:aventuris_app/features/character_sheet/providers/character_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterAttributeDetailsView extends ConsumerWidget {
  final String characterId;

  const CharacterAttributeDetailsView({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCharacter = ref.watch(characterViewModelProvider(characterId));

    return asyncCharacter.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
      data: (character) {
        if (character == null) {
          return const Center(child: Text('Personagem não encontrado'));
        }
        final viewModel = ref.read(
          characterViewModelProvider(characterId).notifier,
        );
        return Column(
          children: [
            CharacterAbilityScoreComponent(viewModel: viewModel),
            CharacterSaveThrowComponent(characterId: characterId),
            CharacterSkillsProficiencyComponent(characterId: characterId),
          ],
        );
      },
    );
  }
}
