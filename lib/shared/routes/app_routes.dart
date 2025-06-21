import 'package:go_router/go_router.dart';

import 'package:aventuris_app/shared/pages/home_page.dart';
import 'package:aventuris_app/features/character_sheet/pages/character_sheet_page.dart';
import 'package:aventuris_app/shared/pages/placeholder_page.dart';

class AppRoutes {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/character-sheet',
        name: 'characterSheet',
        builder: (context, state) => const CharacterSheetPage(),
      ),
      GoRoute(
        path: '/dice-roller',
        name: 'diceRoller',
        builder: (context, state) =>
            const PlaceholderPage(title: 'Dice Roller'),
      ),
      GoRoute(
        path: '/name-generator',
        name: 'nameGenerator',
        builder: (context, state) =>
            const PlaceholderPage(title: 'Name Generator'),
      ),
      GoRoute(
        path: '/campaign',
        name: 'campaign',
        builder: (context, state) => const PlaceholderPage(title: 'Campaign'),
      ),
    ],
  );
}
