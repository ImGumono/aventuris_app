import '../models/character_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/definitions.dart'; // Importa o enum ProficiencyType

class CharacterService {
  Future<CharacterModel> loadCharacterFromLocal() async {
    await Future.delayed(const Duration(seconds: 1));
    return CharacterModel(
      id: '001',
      name: 'Mallaggor Skashraii',
      race: 'Undead',
      characterClass: 'Warlock',
      level: 18,
      experience: 0,
      strength: 15,
      dexterity: 14,
      constitution: 13,
      intelligence: 12,
      wisdom: 10,
      charisma: 8,
      life: 12,
      maxLife: 12,
      temporaryLife: 0,
      armorClass: 15,
      background: 'Soldier',
      alignment: 'Neutral Good',
      skills: {
        'Atletismo': ProficiencyType.none,
        'Acrobacia': ProficiencyType.proficiency,
        'Furtividade': ProficiencyType.expertise,
        'Prestidigitação': ProficiencyType.none,
        'Arcana': ProficiencyType.proficiency,
        'História': ProficiencyType.expertise,
        'Investigação': ProficiencyType.none,
        'Religião': ProficiencyType.proficiency,
        'Intuição': ProficiencyType.expertise,
        'Medicina': ProficiencyType.none,
        'Percepção': ProficiencyType.proficiency,
        'Sobrevivência': ProficiencyType.expertise,
        'Atuação': ProficiencyType.none,
        'Enganação': ProficiencyType.proficiency,
        'Intimidação': ProficiencyType.expertise,
        'Persuasão': ProficiencyType.none,
      },
    );
  }
}

final characterServiceProvider = Provider<CharacterService>((ref) {
  return CharacterService();
});
