import 'package:aventuris_app/features/character_sheet/models/definitions.dart';

import '../models/character_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterService {
  // Simulação: lista mock
  final List<CharacterModel> _mockCharacters = [
    CharacterModel(
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
      background: 'Sábio',
      alignment: 'Neutro Real',
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
    ),
    CharacterModel(
      id: '002',
      name: 'Aliccía Drapt',
      race: 'Humana',
      characterClass: 'Multiclasse',
      level: 20,
      experience: 0,
      strength: 20,
      dexterity: 20,
      constitution: 30,
      intelligence: 16,
      wisdom: 16,
      charisma: 18,
      life: 220,
      maxLife: 220,
      temporaryLife: 0,
      armorClass: 35,
      background: 'Soldier',
      alignment: 'Caótico Maligno',
      skills: {
        'Atletismo': ProficiencyType.proficiency,
        'Acrobacia': ProficiencyType.none,
        'Furtividade': ProficiencyType.none,
        'Prestidigitação': ProficiencyType.none,
        'Arcana': ProficiencyType.expertise,
        'História': ProficiencyType.proficiency,
        'Investigação': ProficiencyType.proficiency,
        'Religião': ProficiencyType.expertise,
        'Intuição': ProficiencyType.proficiency,
        'Medicina': ProficiencyType.proficiency,
        'Percepção': ProficiencyType.expertise,
        'Sobrevivência': ProficiencyType.proficiency,
        'Atuação': ProficiencyType.none,
        'Enganação': ProficiencyType.none,
        'Intimidação': ProficiencyType.none,
        'Persuasão': ProficiencyType.proficiency,
      },
    ),
  ];

  Future<List<CharacterModel>> fetchCharacters() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCharacters;
  }

  Future<CharacterModel?> fetchCharacterById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCharacters.firstWhere(
      (c) => c.id == id,
      orElse: () => _mockCharacters.first,
    );
  }
}

final characterServiceProvider = Provider<CharacterService>((ref) {
  return CharacterService();
});

final characterListProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final service = ref.read(characterServiceProvider);
  return service.fetchCharacters();
});

final characterByIdProvider = FutureProvider.family<CharacterModel?, String>((
  ref,
  id,
) async {
  final service = ref.read(characterServiceProvider);
  return service.fetchCharacterById(id);
});
