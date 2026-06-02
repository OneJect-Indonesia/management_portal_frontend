enum AppEnvironment { dev, staging, prod }

class EnvConfig {
  static AppEnvironment environment = AppEnvironment.dev;

  static String get apiBaseUrl {
    switch (environment) {
      case AppEnvironment.dev:
        return 'http://127.0.0.1:80/api/v1';
      case AppEnvironment.staging:
        return 'https://staging-portal.example.com/api/v1';
      case AppEnvironment.prod:
        return 'https://portal.example.com/api/v1';
    }
  }
}
