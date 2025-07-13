import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character_model.dart';
import '../models/definitions.dart';
import '../services/character_service.dart';

final characterProvider =
    StateNotifierProvider<CharacterController, CharacterModel?>(
      (ref) => CharacterController(ref),
    );

class CharacterController extends StateNotifier<CharacterModel?> {
  final Ref _ref;

  // Timer para incremento contínuo de maxLife
  Timer? _incrementMaxLifeTimer;

  CharacterController(this._ref) : super(null);

  // ====== Carregar Personagem ======
  Future<void> loadCharacter() async {
    final service = _ref.read(characterServiceProvider);
    try {
      final character = await service.loadCharacterFromLocal();
      state = character;
    } catch (e, stack) {
      debugPrint('Erro ao carregar personagem: $e\n$stack');
      state = null;
    }
  }

  // ====== Atualização de Dados ======
  void _updateCharacterField(CharacterModel Function(CharacterModel) update) {
    if (state == null) return;
    state = update(state!);
  }

  // Atualizações básicas de atributos
  void updateLife(int life) =>
      _updateCharacterField((c) => c.copyWith(life: life));

  void updateStrength(int value) =>
      _updateCharacterField((c) => c.copyWith(strength: value));

  void updateDexterity(int value) =>
      _updateCharacterField((c) => c.copyWith(dexterity: value));

  void updateConstitution(int value) =>
      _updateCharacterField((c) => c.copyWith(constitution: value));

  void updateIntelligence(int value) =>
      _updateCharacterField((c) => c.copyWith(intelligence: value));

  void updateWisdom(int value) =>
      _updateCharacterField((c) => c.copyWith(wisdom: value));

  void updateCharisma(int value) =>
      _updateCharacterField((c) => c.copyWith(charisma: value));

  void levelUp() =>
      _updateCharacterField((c) => c.copyWith(level: c.level + 1));

  // ====== Vida Atual ======
  void incrementLife() {
    if (state == null) return;
    final newLife = (state!.life + 1).clamp(0, state!.maxLife);
    _updateCharacterField((c) => c.copyWith(life: newLife));
  }

  void decrementLife() {
    if (state == null) return;
    final newLife = (state!.life - 1).clamp(0, state!.maxLife);
    _updateCharacterField((c) => c.copyWith(life: newLife));
  }

  void setLife(int value) {
    if (state == null) return;
    final newLife = value.clamp(0, state!.maxLife);
    _updateCharacterField((c) => c.copyWith(life: newLife));
  }

  // ====== Vida Máxima ======
  void incrementMaxLife() {
    if (state == null) return;
    _updateCharacterField((c) => c.copyWith(maxLife: c.maxLife + 1));
  }

  void decrementMaxLife() {
    if (state == null) return;
    final newMax = (state!.maxLife - 1).clamp(1, 9999);
    _updateCharacterField((c) => c.copyWith(maxLife: newMax));
  }

  void setMaxLife(int value) {
    if (state == null) return;
    final newMax = value.clamp(1, 9999);
    _updateCharacterField((c) => c.copyWith(maxLife: newMax));
  }

  // Incremento contínuo para maxLife
  void startIncrementMaxLife() {
    if (state == null) return;
    _incrementMaxLifeTimer?.cancel();
    _incrementMaxLifeTimer = Timer.periodic(const Duration(milliseconds: 500), (
      _,
    ) {
      _updateCharacterField((c) => c.copyWith(maxLife: c.maxLife + 2));
    });
  }

  void stopIncrementMaxLife() {
    _incrementMaxLifeTimer?.cancel();
  }

  // ====== Vida Temporária ======
  void incrementTemporaryLife() {
    if (state == null) return;
    final newTemp = (state!.temporaryLife + 1).clamp(0, 9999);
    _updateCharacterField((c) => c.copyWith(temporaryLife: newTemp));
  }

  void decrementTemporaryLife() {
    if (state == null) return;
    final newTemp = (state!.temporaryLife - 1).clamp(0, 9999);
    _updateCharacterField((c) => c.copyWith(temporaryLife: newTemp));
  }

  void setTemporaryLife(int value) {
    if (state == null) return;
    final newTemp = value.clamp(0, 9999);
    _updateCharacterField((c) => c.copyWith(temporaryLife: newTemp));
  }

  // ====== Limpar Estado ======
  void clear() => state = null;

  // ====== Proficiência ======
  /// Alterna entre [none] e [proficiency]
  void toggleProficiency(String skill) {
    if (state == null) return;
    final current = state!.skills[skill] ?? ProficiencyType.none;
    final next = (current == ProficiencyType.proficiency)
        ? ProficiencyType.none
        : ProficiencyType.proficiency;

    final updatedSkills = Map<String, ProficiencyType>.from(state!.skills);
    updatedSkills[skill] = next;

    _updateCharacterField((c) => c.copyWith(skills: updatedSkills));
  }

  /// Seta diretamente como [expertise]
  void setExpertise(String skill) {
    if (state == null) return;
    final updatedSkills = Map<String, ProficiencyType>.from(state!.skills);
    updatedSkills[skill] = ProficiencyType.expertise;

    _updateCharacterField((c) => c.copyWith(skills: updatedSkills));
  }

  // ====== Cálculo de Regras ======
  int calculateModifier(int value) => ((value - 10) / 2).floor();

  int calculateProficiencyBonus() {
    if (state == null) return 0;
    final level = state!.level;
    return ((level - 1) ~/ 4) + 2;
  }

  int getProficiencyBonus() => calculateProficiencyBonus();

  int getSkillValue(String skill) {
    if (state == null) return 0;

    final ability = _abilityForSkill(skill);
    final abilityValue = _getAbilityScore(ability);
    final modifier = calculateModifier(abilityValue);

    final proficiency = state!.skills[skill] ?? ProficiencyType.none;
    final proficiencyBonus = getProficiencyBonus();

    switch (proficiency) {
      case ProficiencyType.none:
        return modifier;
      case ProficiencyType.proficiency:
        return modifier + proficiencyBonus;
      case ProficiencyType.expertise:
        return modifier + (proficiencyBonus * 2);
    }
  }

  int getPassivePerception() {
    if (state == null) return 0;
    final wisdomModifier = calculateModifier(state!.wisdom);
    final proficiency = state!.skills['Percepção'] ?? ProficiencyType.none;
    final proficiencyBonus = getProficiencyBonus();

    int bonus = 0;
    switch (proficiency) {
      case ProficiencyType.none:
        bonus = 0;
        break;
      case ProficiencyType.proficiency:
        bonus = proficiencyBonus;
        break;
      case ProficiencyType.expertise:
        bonus = proficiencyBonus * 2;
        break;
    }

    return 10 + wisdomModifier + bonus;
  }

  int getInitiative() {
    if (state == null) return 0;
    return calculateModifier(state!.dexterity);
  }

  // ===== Helpers =====
  String _abilityForSkill(String skill) {
    switch (skill) {
      case 'Atletismo':
        return 'strength';
      case 'Acrobacia':
      case 'Furtividade':
      case 'Prestidigitação':
        return 'dexterity';
      case 'Arcana':
      case 'História':
      case 'Investigação':
      case 'Religião':
        return 'intelligence';
      case 'Intuição':
      case 'Medicina':
      case 'Percepção':
      case 'Sobrevivência':
        return 'wisdom';
      case 'Atuação':
      case 'Enganação':
      case 'Intimidação':
      case 'Persuasão':
        return 'charisma';
      default:
        return 'strength';
    }
  }

  int _getAbilityScore(String ability) {
    if (state == null) return 10;
    switch (ability) {
      case 'strength':
        return state!.strength;
      case 'dexterity':
        return state!.dexterity;
      case 'constitution':
        return state!.constitution;
      case 'intelligence':
        return state!.intelligence;
      case 'wisdom':
        return state!.wisdom;
      case 'charisma':
        return state!.charisma;
      default:
        return 10;
    }
  }

  @override
  void dispose() {
    _incrementMaxLifeTimer?.cancel();
    super.dispose();
  }

  int get life {
    if (state == null) return 0;
    return state!.life;
  }

  int get maxLife {
    if (state == null) return 0;
    return state!.maxLife;
  }

  int get temporaryLife {
    if (state == null) return 0;
    return state!.temporaryLife;
  }

  // ====== Classe de Armadura ======
  void incrementArmorClass() {
    if (state == null) return;
    final newAC = (state!.armorClass + 1).clamp(0, 99);
    _updateCharacterField((c) => c.copyWith(armorClass: newAC));
  }

  void decrementArmorClass() {
    if (state == null) return;
    final newAC = (state!.armorClass - 1).clamp(0, 99);
    _updateCharacterField((c) => c.copyWith(armorClass: newAC));
  }

  void setArmorClass(int value) {
    if (state == null) return;
    final newAC = value.clamp(0, 99);
    _updateCharacterField((c) => c.copyWith(armorClass: newAC));
  }

  // ====== Nome do Personagem ======
  void updateName(String name) {
    if (state == null) return;
    _updateCharacterField((c) => c.copyWith(name: name));
  }

  // ====== Foto do Personagem ======
  void updateAvatarPath(String path) {
    if (state == null) return;
    _updateCharacterField((c) => c.copyWith(avatarPath: path));
  }
}
