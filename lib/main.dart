import 'package:flutter/material.dart';
import 'package:aventuris_app/shared/themes/app_theme.dart';
import 'package:aventuris_app/shared/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AventurisApp()));
}

class AventurisApp extends StatelessWidget {
  const AventurisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aventuris',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes.router,
    );
  }
}
