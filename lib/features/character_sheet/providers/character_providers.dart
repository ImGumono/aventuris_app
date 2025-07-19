import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character_model.dart';
import '../services/character_service.dart';
import '../controllers/character_controller.dart';
import '../viewmodels/character_viewmodel.dart';

// Provider do Service
final characterServiceProvider = Provider<CharacterService>((ref) {
  return CharacterService();
});

// Provider do Controller
final characterControllerProvider =
    StateNotifierProvider<CharacterController, CharacterModel?>((ref) {
      return CharacterController();
    });

// Provider para buscar lista de personagens
final characterListProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final service = ref.read(characterServiceProvider);
  return service.fetchCharacters();
});

// Provider para buscar personagem por ID (modo direto, sem viewmodel)
final characterByIdProvider = FutureProvider.family<CharacterModel?, String>((
  ref,
  id,
) async {
  final service = ref.read(characterServiceProvider);
  return service.fetchCharacterById(id);
});

// Provider do ViewModel (com estado assíncrono e injeção de dependência)
final characterViewModelProvider =
    StateNotifierProvider.family<
      CharacterViewModel,
      AsyncValue<CharacterModel?>,
      String
    >((ref, id) {
      final service = ref.read(characterServiceProvider);
      final viewModel = CharacterViewModel(ref, service);
      viewModel.loadCharacter(id);
      return viewModel;
    });
