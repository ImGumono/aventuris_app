import 'package:aventuris_app/features/character_sheet/models/definitions.dart';
import 'package:aventuris_app/features/character_sheet/providers/character_providers.dart';
import 'package:aventuris_app/features/character_sheet/viewmodels/character_viewmodel.dart';
import 'package:aventuris_app/features/character_sheet/widgets/skill_proficiency_widget.dart';
import 'package:aventuris_app/features/character_sheet/widgets/title_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterSkillsProficiencyComponent extends ConsumerWidget {
  final String characterId;

  const CharacterSkillsProficiencyComponent({
    super.key,
    required this.characterId,
  });

  static const List<String> allSkills = [
    'Atletismo', // Força
    'Acrobacia', 'Furtividade', 'Prestidigitação', // Destreza
    'Arcana', 'História', 'Investigação', 'Religião', // Inteligência
    'Intuição', 'Medicina', 'Percepção', 'Sobrevivência', // Sabedoria
    'Atuação', 'Enganação', 'Intimidação', 'Persuasão', // Carisma
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(
      characterViewModelProvider(characterId).notifier,
    );
    final state = ref.watch(characterViewModelProvider(characterId));

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(child: Text('Erro: ${state.error}'));
    }

    final character = viewModel.character;
    if (character == null) {
      return const Center(child: Text('Nenhum personagem carregado'));
    }

    final half = (allSkills.length / 2).ceil();
    final leftSkills = allSkills.sublist(0, half);
    final rightSkills = allSkills.sublist(half);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleDivider(title: 'Perícias'),
        SizedBox(
          height: 260,
          child: Row(
            children: [
              Expanded(
                child: _buildSkillList(
                  skills: leftSkills,
                  viewModel: viewModel,
                  context: context,
                ),
              ),
              VerticalDivider(
                width: 8,
                color: Theme.of(context).colorScheme.outline,
              ),
              Expanded(
                child: _buildSkillList(
                  skills: rightSkills,
                  viewModel: viewModel,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Constrói a lista de perícias em uma das colunas
  Widget _buildSkillList({
    required List<String> skills,
    required CharacterViewModel viewModel,
    required BuildContext context,
  }) {
    final character = viewModel.character;
    if (character == null) return const SizedBox.shrink();

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        final proficiency = character.skills[skill] ?? ProficiencyType.none;
        final value = viewModel.getSkillValue(skill);

        return GestureDetector(
          onTap: () => viewModel.toggleProficiency(skill),
          onLongPress: () => viewModel.setExpertise(skill),
          child: SkillProficiencyWidget(
            title: skill,
            proficiency: proficiency,
            value: value,
          ),
        );
      },
    );
  }
}
