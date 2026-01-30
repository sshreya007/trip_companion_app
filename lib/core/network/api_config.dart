class ApiConfig {
  // Your backend API base URL
  static const String baseUrl =
      'http://10.0.2.2:5050/api'; // For Android emulator
  // static const String baseUrl = 'http://localhost:5050/api'; // For iOS simulator
  // static const String baseUrl = 'http://YOUR_IP:5050/api'; // For real device
  // static const String baseUrl = 'https://your-api.com/api'; // For production

  // API Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String getCurrentUser = '/auth/me';
  static const String logout = '/auth/logout';

  // Profile Endpoints
  static const String getProfile = '/profile/{userId}';
  static const String updateProfile = '/profile/{userId}';
  static const String uploadProfileImage = '/profile/upload';
}
