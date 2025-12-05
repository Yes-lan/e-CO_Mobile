class ApiConfig {
  // URL de base de votre API
  static const String baseUrl = 'https://uneffectuated-immovably-jair.ngrok-free.dev';
  
  // Endpoints
  static const String loginEndpoint = '/api/login_check';
  static const String usersEndpoint = '/api/users';
  static const String coursesEndpoint = '/api/courses';
  static const String sessionsEndpoint = '/api/sessions';
  static const String beaconsEndpoint = '/api/beacons';
  static const String runnersEndpoint = '/api/runners';
  static const String logSessionsEndpoint = '/api/log_sessions';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
