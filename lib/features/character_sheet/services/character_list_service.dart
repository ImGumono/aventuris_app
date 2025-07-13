import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_model.dart';

class CharacterListService {
  Future<List<CharacterModel>> fetchCharacters() async {
    // Simulação: retorne uma lista mock
    await Future.delayed(const Duration(milliseconds: 500));
    return [
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
        background: 'Soldier',
        alignment: 'Neutral Good',
        skills: const {},
        avatarPath: null,
      ),
      // Adicione outros personagens aqui
    ];
  }
}

final characterListServiceProvider = Provider<CharacterListService>((ref) {
  return CharacterListService();
});

final characterListProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final service = ref.read(characterListServiceProvider);
  return service.fetchCharacters();
});
