enum AppEnv {
  dev,
  prod,
}

class AppConfig {
  const AppConfig({
    required this.env,
    required this.baseApiUrl,
  });

  final AppEnv env;

  final String baseApiUrl;

  static const empty = AppConfig(env: AppEnv.dev, baseApiUrl: '');
}
