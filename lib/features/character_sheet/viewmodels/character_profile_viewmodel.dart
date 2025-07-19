import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/character_controller.dart';
import '../services/character_service.dart';

final characterProfileViewModelProvider =
    StateNotifierProvider<CharacterProfileViewModel, CharacterProfileUIState>(
      (ref) => CharacterProfileViewModel(ref),
    );

class CharacterProfileViewModel extends StateNotifier<CharacterProfileUIState> {
  final Ref ref;
  Timer? _timer;

  CharacterProfileViewModel(this.ref) : super(const CharacterProfileUIState());

  void openPopup(String type) {
    state = state.copyWith(isLifePopupOpen: true, editingType: type);
  }

  void closePopup() {
    state = state.copyWith(isLifePopupOpen: false, editingType: '');
    stopIncrement();
  }

  void increment() {
    _applyValue(1);
  }

  void decrement() {
    _applyValue(-1);
  }

  void startIncrement() {
    _timer?.cancel();
    _applyValue(1); // Incrementa imediatamente ao pressionar
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _applyValue(1);
    });
  }

  void startDecrement() {
    _timer?.cancel();
    _applyValue(-1); // Decrementa imediatamente ao pressionar
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _applyValue(-1);
    });
  }

  void stopIncrement() {
    _timer?.cancel();
    _timer = null;
  }

  void _applyValue(int amount) {
    final controller = ref.read(characterProvider.notifier);
    final character = ref.read(characterProvider);

    if (character == null) return;

    switch (state.editingType) {
      case 'life':
        controller.setLife(
          (character.life + amount).clamp(0, character.maxLife),
        );
        break;
      case 'maxLife':
        controller.setMaxLife((character.maxLife + amount).clamp(1, 9999));
        if (character.life > (character.maxLife + amount).clamp(1, 9999)) {
          controller.setLife((character.maxLife + amount).clamp(1, 9999));
        }
        break;
      case 'temporaryLife':
        controller.setTemporaryLife(
          (character.temporaryLife + amount).clamp(0, 9999),
        );
        break;
      case 'armorClass':
        controller.setArmorClass((character.armorClass + amount).clamp(0, 99));
        break;
      default:
        break;
    }
  }

  Future<void> loadCharacterById(String id) async {
    final service = ref.read(characterServiceProvider);
    final character = await service.fetchCharacterById(id);
    if (character != null) {
      // Atualiza o controller com o personagem carregado
      ref.read(characterProvider.notifier).setCharacter(character);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class CharacterProfileUIState {
  final bool isLifePopupOpen;
  final String editingType;

  const CharacterProfileUIState({
    this.isLifePopupOpen = false,
    this.editingType = '',
  });

  CharacterProfileUIState copyWith({
    bool? isLifePopupOpen,
    String? editingType,
  }) {
    return CharacterProfileUIState(
      isLifePopupOpen: isLifePopupOpen ?? this.isLifePopupOpen,
      editingType: editingType ?? this.editingType,
    );
  }
}

Future<void> _openArmorClassDialog(
  BuildContext context,
  WidgetRef ref,
  CharacterController controller,
  dynamic character,
) async {
  final viewModel = ref.read(characterProfileViewModelProvider.notifier);
  viewModel.openPopup('armorClass');
  int currentValue = character.armorClass;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Classe de Armadura'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: viewModel.decrement,
              onTapDown: (_) => viewModel.startDecrement(),
              onTapUp: (_) => viewModel.stopIncrement(),
              onTapCancel: viewModel.stopIncrement,
              child: const Icon(Icons.remove),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$currentValue',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            GestureDetector(
              onTap: viewModel.increment,
              onTapDown: (_) => viewModel.startIncrement(),
              onTapUp: (_) => viewModel.stopIncrement(),
              onTapCancel: viewModel.stopIncrement,
              child: const Icon(Icons.add),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              viewModel.closePopup();
              Navigator.pop(context);
            },
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
  viewModel.closePopup();
}

// ...no _buildProperty de CA:
Widget buildArmorClassProperty({
  required BuildContext context,
  required WidgetRef ref,
  required CharacterController controller,
  required dynamic character,
}) {
  return _buildProperty(
    icon: Icons.shield,
    title: 'Classe de Armadura',
    text: '${character.armorClass}',
    onTap: () => _openArmorClassDialog(context, ref, controller, character),
  );
}

Widget _buildProperty({
  required IconData icon,
  required String title,
  required String text,
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(text),
    onTap: onTap,
  );
}
