import 'dart:io';
import 'package:aventuris_app/features/character_sheet/providers/character_providers.dart';
import 'package:aventuris_app/features/character_sheet/viewmodels/character_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterProfileComponent extends ConsumerWidget {
  final String characterId;

  const CharacterProfileComponent({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pega o viewModel e o estado async
    final viewModel = ref.watch(
      characterViewModelProvider(characterId).notifier,
    );
    final state = ref.watch(characterViewModelProvider(characterId));

    // Trata loading, erro e ausência de personagem
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

    // UI principal
    return Container(
      color: Theme.of(context).colorScheme.surface,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLeftColumn(context, viewModel),
              _buildAvatar(context, viewModel),
              _buildRightColumn(viewModel),
            ],
          ),
          _buildTitleBar(context, viewModel),
        ],
      ),
    );
  }

  /// ======================
  /// PROPRIEDADES (USADAS NOS LADOS ESQUERDO E DIREITO)
  /// ======================
  Widget _buildPropertyContent({
    required BuildContext context,
    required String title,
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: _buildProperty(icon: icon, title: title, text: text),
    );
  }

  Widget _buildProperty({
    required String title,
    required String text,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(icon, size: 18),
            ),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(
          width: 80,
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
          ),
        ),
      ],
    );
  }

  /// ======================
  /// LADO ESQUERDO
  /// ======================
  Widget _buildLeftColumn(BuildContext context, CharacterViewModel viewModel) {
    final character = viewModel.character!;
    return SizedBox(
      height: 200,
      width: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPropertyContent(
            context: context,
            title: 'Pontos de Vida',
            text: '${character.life}/${character.maxLife}',
            icon: Icons.favorite,
            onTap: () => _openValueDialog(
              context: context,
              title: 'PV Atual',
              initialValue: character.life,
              minValue: 0,
              onSave: viewModel.updateLife,
            ),
            onLongPress: () => _openValueDialog(
              context: context,
              title: 'PV Máximo',
              initialValue: character.maxLife,
              minValue: 1,
              onSave: viewModel.updateMaxLife,
            ),
          ),
          _buildPropertyContent(
            context: context,
            title: 'Vida Temporária',
            text: '${character.temporaryLife}',
            icon: Icons.favorite_border,
            onTap: () {},
            onLongPress: () => _openValueDialog(
              context: context,
              title: 'Vida Temporária',
              initialValue: character.temporaryLife,
              minValue: 0,
              onSave: viewModel.updateTemporaryLife,
            ),
          ),
          _buildPropertyContent(
            context: context,
            title: 'Classe de Armadura',
            text: '${character.armorClass}',
            icon: Icons.shield,
            onTap: () {},
            onLongPress: () => _openValueDialog(
              context: context,
              title: 'Classe de Armadura',
              initialValue: character.armorClass,
              minValue: 0,
              onSave: viewModel.updateArmorClass,
            ),
          ),
        ],
      ),
    );
  }

  /// ======================
  /// LADO DIREITO
  /// ======================
  Widget _buildRightColumn(CharacterViewModel viewModel) {
    return SizedBox(
      height: 200,
      width: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildProperty(
            icon: Icons.flash_on,
            title: 'Iniciativa',
            text: '+${viewModel.initiative}',
          ),
          _buildProperty(
            icon: Icons.remove_red_eye,
            title: 'Percepção Passiva',
            text: '${viewModel.passivePerception}',
          ),
          _buildProperty(
            icon: Icons.sports_martial_arts,
            title: 'Bônus de Proficiência',
            text: '+${viewModel.proficiencyBonus}',
          ),
        ],
      ),
    );
  }

  /// ======================
  /// AVATAR
  /// ======================
  Widget _buildAvatar(BuildContext context, CharacterViewModel viewModel) {
    final character = viewModel.character!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: GestureDetector(
        onTap: () async {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(
            source: ImageSource.gallery,
          );
          if (pickedFile != null) {
            viewModel.updateAvatarPath(pickedFile.path);
          }
        },
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 3,
            ),
          ),
          child: character.avatarPath != null
              ? ClipOval(
                  child: Image.file(
                    File(character.avatarPath!),
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.person, size: 50),
        ),
      ),
    );
  }

  /// ======================
  /// TÍTULO INFERIOR
  /// ======================
  Container _buildTitleBar(BuildContext context, CharacterViewModel viewModel) {
    final character = viewModel.character!;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onLongPress: () => _showEditNameDialog(context, viewModel),
              child: Text(
                character.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  wordSpacing: 5,
                  letterSpacing: 3,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditNameDialog(
    BuildContext context,
    CharacterViewModel viewModel,
  ) async {
    final textController = TextEditingController(
      text: viewModel.character?.name,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: 'Nome do personagem'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  viewModel.updateName(textController.text.trim());
                }
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// ======================
  /// DIÁLOGO GENÉRICO DE VALORES
  /// ======================
  Future<void> _openValueDialog({
    required BuildContext context,
    required String title,
    required int initialValue,
    required int minValue,
    required ValueChanged<int> onSave,
  }) async {
    int currentValue = initialValue;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (currentValue > minValue) {
                        setState(() => currentValue--);
                      }
                    },
                  ),
                  Text('$currentValue', style: const TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => currentValue++),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    onSave(currentValue);
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
