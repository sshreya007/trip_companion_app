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

  // Package Endpoints
  static const String getAllPackages = '/packages';
  static const String getPackageById = '/packages/{id}';
  static const String getFeaturedPackages = '/packages/featured';
  static const String getPackagesByCategory = '/packages/category/{category}';
  static const String checkAvailability = '/packages/{id}/availability';

  // Booking Endpoints
  static const String createBooking = '/bookings';
  static const String getUserBookings = '/bookings';
  static const String getBookingById = '/bookings/{id}';
  static const String getBookingByReference = '/bookings/reference/{reference}';
  static const String cancelBooking = '/bookings/{id}';
  static const String addReview = '/bookings/{id}/review';
  static const String getBookingStats = '/bookings/stats';
}
