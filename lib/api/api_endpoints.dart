class ApiEndpoints {
  ApiEndpoints._();

  // ================= Base =================
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  // For Android Emulator: http://10.0.2.2:3000/api/v1
  // For iOS Simulator: http://localhost:3000/api/v1
  // For Physical device: http://192.168.x.x:3000/api/v1

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================= Auth Endpoints =================
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';

  // ================= User/Profile Endpoints =================
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static String userProfile(String id) => '/users/$id/profile';
  static String userAvatar(String id) => '/users/$id/avatar';

  // ================= Trip Endpoints =================
  static const String trips = '/trips';
  static String tripById(String id) => '/trips/$id';
  static String tripsByUser(String userId) => '/trips/user/$userId';
  static String tripJoin(String id) => '/trips/$id/join';
  static String tripLeave(String id) => '/trips/$id/leave';

  // ================= Place/Destination Endpoints =================
  static const String places = '/places';
  static String placeById(String id) => '/places/$id';
  static String placesByTrip(String tripId) => '/places/trip/$tripId';

  // ================= Booking Endpoints =================
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String bookingsByUser(String userId) => '/bookings/user/$userId';
  static String bookingsByTrip(String tripId) => '/bookings/trip/$tripId';

  // ================= Review Endpoints =================
  static const String reviews = '/reviews';
  static String reviewById(String id) => '/reviews/$id';
  static String reviewsByPlace(String placeId) => '/reviews/place/$placeId';
  static String reviewLike(String id) => '/reviews/$id/like';
}
