import 'package:flutter/material.dart';
import 'package:aventuris_app/features/character_sheet/models/definitions.dart';

class SkillProficiencyWidget extends StatelessWidget {
  final String title;
  final ProficiencyType proficiency;
  final int value;

  const SkillProficiencyWidget({
    super.key,
    required this.title,
    required this.proficiency,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Icon(_defineIcon(), size: 14, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                value > 0 ? '+$value' : '$value',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    if (proficiency == ProficiencyType.none) {
      return Theme.of(context).colorScheme.outline;
    } else if (proficiency == ProficiencyType.proficiency) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Colors.amber;
    }
  }

  IconData _defineIcon() {
    switch (proficiency) {
      case ProficiencyType.none:
        return Icons.circle_outlined;
      case ProficiencyType.proficiency:
        return Icons.circle;
      case ProficiencyType.expertise:
        return Icons.star_rate;
    }
  }
}
