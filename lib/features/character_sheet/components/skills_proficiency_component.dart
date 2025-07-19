import 'package:aventuris_app/features/character_sheet/controllers/character_controller.dart';
import 'package:aventuris_app/features/character_sheet/models/character_model.dart';
import 'package:aventuris_app/features/character_sheet/models/definitions.dart';
import 'package:aventuris_app/features/character_sheet/widgets/skill_proficiency_widget.dart';
import 'package:aventuris_app/features/character_sheet/widgets/title_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkillsProficiencyComponent extends ConsumerWidget {
  const SkillsProficiencyComponent({super.key});

  static const List<String> allSkills = [
    'Atletismo', // Força
    'Acrobacia', 'Furtividade', 'Prestidigitação', // Destreza
    'Arcana', 'História', 'Investigação', 'Religião', // Inteligência
    'Intuição', 'Medicina', 'Percepção', 'Sobrevivência', // Sabedoria
    'Atuação', 'Enganação', 'Intimidação', 'Persuasão', // Carisma
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);
    final controller = ref.read(characterProvider.notifier);

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
                  leftSkills,
                  character,
                  controller,
                  context,
                ),
              ),
              VerticalDivider(
                width: 8,
                color: Theme.of(context).colorScheme.outline,
              ),
              Expanded(
                child: _buildSkillList(
                  rightSkills,
                  character,
                  controller,
                  context,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillList(
    List<String> skills,
    CharacterModel character,
    CharacterController controller,
    BuildContext context,
  ) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        final proficiency = character.skills[skill] ?? ProficiencyType.none;
        final value = controller.getSkillValue(skill);

        return GestureDetector(
          onTap: () => controller.toggleProficiency(skill),
          onLongPress: () => controller.setExpertise(skill),
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
