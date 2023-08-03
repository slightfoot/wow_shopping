enum AppEnv {
  dev,
  prod,
}

class AppConfig {
  const AppConfig({required this.env});

  final AppEnv env;
}
