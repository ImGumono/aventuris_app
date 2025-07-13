import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/character_list_service.dart';
import 'package:go_router/go_router.dart';

class CharacterSelectPage extends ConsumerWidget {
  const CharacterSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(characterListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),

      body: charactersAsync.when(
        data: (characters) {
          if (characters.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não possui personagens criados.\nCrie um novo personagem para começar!',
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: character.avatarPath != null
                      ? CircleAvatar(
                          backgroundImage: AssetImage(character.avatarPath!),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(character.name),
                  subtitle: Text(
                    '${character.race} • ${character.characterClass}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navegue para a ficha do personagem
                    context.go('/character-sheet?id=${character.id}');
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}
