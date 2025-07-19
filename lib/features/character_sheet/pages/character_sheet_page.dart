import 'package:aventuris_app/features/character_sheet/components/character_profile_component.dart';
import 'package:aventuris_app/features/character_sheet/models/character_model.dart';
import 'package:aventuris_app/features/character_sheet/viewmodels/character_viewmodel.dart';
import 'package:aventuris_app/features/character_sheet/providers/character_providers.dart'; // Adicione esta importação
import 'package:aventuris_app/features/character_sheet/views/character_atribute_details_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterSheetPage extends ConsumerWidget {
  const CharacterSheetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).uri.queryParameters['id'];
    if (id == null) {
      return const Scaffold(body: Center(child: Text('ID não informado')));
    }

    final viewModelState = ref.watch(characterViewModelProvider(id));

    return viewModelState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Erro: $error'))),
      data: (character) {
        if (character == null) {
          return const Scaffold(
            body: Center(child: Text('Personagem não encontrado')),
          );
        }

        final viewModel = ref.read(characterViewModelProvider(id).notifier);
        return _CharacterSheetContent(viewModel: viewModel);
      },
    );
  }
}

class _CharacterSheetContent extends StatefulWidget {
  final CharacterViewModel viewModel;

  const _CharacterSheetContent({required this.viewModel});

  @override
  State<_CharacterSheetContent> createState() => _CharacterSheetContentState();
}

class _CharacterSheetContentState extends State<_CharacterSheetContent> {
  int _screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final character = widget.viewModel.character;
    if (character == null) {
      return const Scaffold(
        body: Center(child: Text('Personagem não encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/character-select'),
        ),
      ),
      body: Column(
        children: [
          CharacterProfileComponent(characterId: character.id),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_screenIndex == 0)
                      CharacterAttributeDetailsView(characterId: character.id),
                    if (_screenIndex == 1) _buildHistoryView(character),
                    if (_screenIndex == 2) _buildArmoryView(),
                    if (_screenIndex == 3) _buildOtherView(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.outline,
        onTap: (index) => setState(() => _screenIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Atributos'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'História'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Arsenal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'Outro',
          ),
        ],
      ),
    );
  }

  // ===========================
  // ==== HISTORY VIEW =========
  // ===========================
  Widget _buildHistoryView(CharacterModel character) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Histórico: ${character.background}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Alinhamento: ${character.alignment}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              const Text('Lore do personagem... (Expansível futuramente)'),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================
  // ==== ARMORY VIEW ==========
  // ===========================
  Widget _buildArmoryView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Text('Arsenal em construção...'),
              SizedBox(height: 8),
              Icon(Icons.build, size: 50),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================
  // ==== OTHER VIEW ===========
  // ===========================
  Widget _buildOtherView() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Outra aba... Talvez magias, anotações, status, etc.'),
        ),
      ),
    );
  }
}
