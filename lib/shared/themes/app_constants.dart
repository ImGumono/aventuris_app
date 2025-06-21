class AppConstants {
  // Nome do App
  static const String appName = 'Aventuris';

  // Versão do App
  static const String version = '1.0.0';

  // Nome do Dev ou Empresa
  static const String developer = 'Brother Dev Studio';

  // URL's úteis
  static const String privacyPolicyUrl = 'https://seudominio.com/privacy';
  static const String termsOfUseUrl = 'https://seudominio.com/terms';
  static const String supportEmail = 'suporte@seudominio.com';

  // Delay padrão para simulações (Ex.: loading fake)
  static const Duration defaultDelay = Duration(milliseconds: 500);

  // Padding e espaçamentos padrão
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Raio de borda padrão
  static const double borderRadius = 12.0;

  // Ícones padrão (se quiser, pode criar uma classe separada também)
  static const String defaultAvatar =
      'https://api.dicebear.com/6.x/adventurer/svg?seed=Aventuris';

  // Rotas nomeadas (se não usa GoRouter com nomes, ignora)
  static const String routeHome = '/';
  static const String routeCharacterSheet = '/character-sheet';
  static const String routeDiceRoller = '/dice-roller';
  static const String routeNameGenerator = '/name-generator';
  static const String routeCampaign = '/campaign';

  // Chaves de storage/local storage
  static const String localCharacterKey = 'local_character';
  static const String settingsKey = 'app_settings';
}
