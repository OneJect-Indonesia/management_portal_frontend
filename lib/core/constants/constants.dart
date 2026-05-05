class AppConstants {
  static const String apiBaseUrl = 'http://127.0.0.1:80/api/v1';
  
  // Auth Endpoints
  static const String loginEndpoint = '$apiBaseUrl/auth/login';
  static const String ssoTicketEndpoint = '$apiBaseUrl/auth/sso-ticket';
  
  // Dashboard Endpoints
  static const String dashboardEndpoint = '$apiBaseUrl/my-dashboard';
  
  // Timeout
  static const int apiTimeoutSeconds = 15;
}
