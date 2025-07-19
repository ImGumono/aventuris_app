import 'package:aventuris_app/features/character_sheet/providers/character_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aventuris_app/features/character_sheet/controllers/character_controller.dart';
import 'package:aventuris_app/features/character_sheet/services/character_service.dart';
import 'package:aventuris_app/features/character_sheet/models/definitions.dart';
import '../models/character_model.dart';

class CharacterViewModel extends StateNotifier<AsyncValue<CharacterModel?>> {
  final Ref ref;
  final CharacterService _service;

  CharacterViewModel(this.ref, this._service)
    : super(const AsyncValue.loading());

  CharacterController get _controller =>
      ref.read(characterControllerProvider.notifier);

  CharacterModel? get character => state.value;

  Future<void> loadCharacter(String id) async {
    state = const AsyncValue.loading();

    try {
      final character = await _service.fetchCharacterById(id);
      if (character != null) {
        _controller.setCharacter(character);
        state = AsyncValue.data(character);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error('Erro ao carregar personagem: $e', st);
    }
  }

  // Atualiza e sincroniza estado com o controller
  void _update(void Function() action) {
    action();
    _syncState();
  }

  void updateStrength(int value) =>
      _update(() => _controller.updateStrength(value));
  void updateDexterity(int value) =>
      _update(() => _controller.updateDexterity(value));
  void updateConstitution(int value) =>
      _update(() => _controller.updateConstitution(value));
  void updateIntelligence(int value) =>
      _update(() => _controller.updateIntelligence(value));
  void updateWisdom(int value) =>
      _update(() => _controller.updateWisdom(value));
  void updateCharisma(int value) =>
      _update(() => _controller.updateCharisma(value));

  void updateLife(int value) => _update(() => _controller.updateLife(value));
  void updateMaxLife(int value) =>
      _update(() => _controller.updateMaxLife(value));
  void updateTemporaryLife(int value) =>
      _update(() => _controller.updateTemporaryLife(value));
  void updateArmorClass(int value) =>
      _update(() => _controller.updateArmorClass(value));

  void updateName(String value) => _update(() => _controller.updateName(value));
  void updateAvatarPath(String value) =>
      _update(() => _controller.updateAvatarPath(value));

  // Modificadores
  int _calcMod(int v) => ((v - 10) / 2).floor();

  int get strengthModifier => _calcMod(character?.strength ?? 10);
  int get dexterityModifier => _calcMod(character?.dexterity ?? 10);
  int get constitutionModifier => _calcMod(character?.constitution ?? 10);
  int get intelligenceModifier => _calcMod(character?.intelligence ?? 10);
  int get wisdomModifier => _calcMod(character?.wisdom ?? 10);
  int get charismaModifier => _calcMod(character?.charisma ?? 10);

  int get proficiencyBonus => ((character?.level ?? 1) - 1) ~/ 4 + 2;
  int get initiative => dexterityModifier;
  int get passivePerception => 10 + wisdomModifier;

  // Skills
  int getSkillValue(String skill) {
    if (character == null) return 0;

    final proficiency = character!.skills[skill] ?? ProficiencyType.none;
    final base = _getSkillBaseModifier(skill);

    switch (proficiency) {
      case ProficiencyType.proficiency:
        return base + proficiencyBonus;
      case ProficiencyType.expertise:
        return base + 2 * proficiencyBonus;
      default:
        return base;
    }
  }

  void toggleProficiency(String skill) {
    if (character == null) return;

    final current = character!.skills[skill] ?? ProficiencyType.none;
    final next = current == ProficiencyType.none
        ? ProficiencyType.proficiency
        : ProficiencyType.none;

    _update(() => _controller.updateSkillProficiency(skill, next));
  }

  void setExpertise(String skill) {
    if (character == null) return;

    final current = character!.skills[skill] ?? ProficiencyType.none;
    final next = current == ProficiencyType.expertise
        ? ProficiencyType.none
        : ProficiencyType.expertise;

    _update(() => _controller.updateSkillProficiency(skill, next));
  }

  int _getSkillBaseModifier(String skill) {
    switch (skill) {
      case 'Atletismo':
        return strengthModifier;
      case 'Acrobacia':
      case 'Furtividade':
      case 'Prestidigitação':
        return dexterityModifier;
      case 'Arcana':
      case 'História':
      case 'Investigação':
      case 'Religião':
        return intelligenceModifier;
      case 'Intuição':
      case 'Medicina':
      case 'Percepção':
      case 'Sobrevivência':
        return wisdomModifier;
      case 'Atuação':
      case 'Enganação':
      case 'Intimidação':
      case 'Persuasão':
        return charismaModifier;
      default:
        return 0;
    }
  }

  void _syncState() {
    state = AsyncValue.data(_controller.state);
  }
}
