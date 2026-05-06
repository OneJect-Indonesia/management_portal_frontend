import '../config/env_config.dart';

class AppConstants {
  static String get apiBaseUrl => EnvConfig.apiBaseUrl;
  
  // Auth Endpoints
  static String get loginEndpoint => '$apiBaseUrl/auth/login';
  static String get ssoTicketEndpoint => '$apiBaseUrl/auth/sso-ticket';
  
  // Dashboard Endpoints
  static String get dashboardEndpoint => '$apiBaseUrl/my-dashboard';
  
  // Timeout
  static const int apiTimeoutSeconds = 15;
}
