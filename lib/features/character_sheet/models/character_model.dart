import 'package:aventuris_app/features/character_sheet/models/definitions.dart';

class CharacterModel {
  final String id;
  final String name;
  final String race;
  final String characterClass;
  final int level;
  final int experience;

  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  final int life;
  final int maxLife;
  final int temporaryLife;
  final int temporaryMaxLife;
  final int armorClass;

  final String background;
  final String alignment;

  final Map<String, ProficiencyType> skills;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.race,
    required this.characterClass,
    required this.level,
    required this.experience,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.life,
    required this.maxLife,
    required this.temporaryLife,
    required this.temporaryMaxLife,
    required this.armorClass,
    required this.background,
    required this.alignment,
    required this.skills,
  });

  CharacterModel copyWith({
    String? id,
    String? name,
    String? race,
    String? characterClass,
    int? level,
    int? experience,
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
    int? life,
    int? maxLife,
    int? temporaryLife,
    int? temporaryMaxLife,
    int? armorClass,
    String? background,
    String? alignment,
    Map<String, ProficiencyType>? skills,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
      life: life ?? this.life,
      maxLife: maxLife ?? this.maxLife,
      temporaryLife: temporaryLife ?? this.temporaryLife,
      temporaryMaxLife: temporaryMaxLife ?? this.temporaryMaxLife,
      armorClass: armorClass ?? this.armorClass,
      background: background ?? this.background,
      alignment: alignment ?? this.alignment,
      skills: skills ?? this.skills,
    );
  }
}
