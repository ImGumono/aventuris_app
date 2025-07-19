import 'package:aventuris_app/features/character_sheet/models/definitions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character_model.dart';

class CharacterController extends StateNotifier<CharacterModel?> {
  CharacterController() : super(null);

  void setCharacter(CharacterModel character) {
    state = character;
  }

  void _updateCharacter(CharacterModel Function(CharacterModel) update) {
    if (state == null) return;
    state = update(state!);
  }

  // Métodos básicos de atualização
  void updateStrength(int value) =>
      _updateCharacter((c) => c.copyWith(strength: value));

  void updateDexterity(int value) =>
      _updateCharacter((c) => c.copyWith(dexterity: value));

  void updateConstitution(int value) =>
      _updateCharacter((c) => c.copyWith(constitution: value));

  void updateIntelligence(int value) =>
      _updateCharacter((c) => c.copyWith(intelligence: value));

  void updateWisdom(int value) =>
      _updateCharacter((c) => c.copyWith(wisdom: value));

  void updateCharisma(int value) =>
      _updateCharacter((c) => c.copyWith(charisma: value));

  void updateLife(int value) =>
      _updateCharacter((c) => c.copyWith(life: value));

  void updateMaxLife(int value) =>
      _updateCharacter((c) => c.copyWith(maxLife: value));

  void updateTemporaryLife(int value) =>
      _updateCharacter((c) => c.copyWith(temporaryLife: value));

  void updateArmorClass(int value) =>
      _updateCharacter((c) => c.copyWith(armorClass: value));

  void updateName(String value) =>
      _updateCharacter((c) => c.copyWith(name: value));

  void updateAvatarPath(String value) =>
      _updateCharacter((c) => c.copyWith(avatarPath: value));

  void updateSkillProficiency(String skill, ProficiencyType proficiency) {
    if (state == null) return;

    final updatedSkills = Map<String, ProficiencyType>.from(state!.skills);
    updatedSkills[skill] = proficiency;

    state = state!.copyWith(skills: updatedSkills);
  }
}

final characterModelProvider =
    StateNotifierProvider<CharacterController, CharacterModel?>((ref) {
      return CharacterController();
    });
