import 'package:dio/dio.dart';
import 'package:trip_planner/core/network/api_config.dart';
import 'package:trip_planner/core/network/dio_client.dart';
import 'package:trip_planner/features/booking/data/models/booking_model.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';

class BookingRemoteDatasource {
  final DioClient _dioClient;

  BookingRemoteDatasource(this._dioClient);

  /// Create booking
  Future<BookingModel> createBooking(CreateBookingEntity booking) async {
    try {
      print('🌐 REMOTE: Creating booking');
      print('📦 Package ID: ${booking.packageId}');

      final response = await _dioClient.dio.post(
        ApiConfig.createBooking,
        data: booking.toJson(),
      );

      print('✅ REMOTE: Booking created successfully');
      print('📦 Response: ${response.data}');

      final data = response.data['data'] ?? response.data;
      return BookingModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create booking',
      );
    }
  }

  /// Get user bookings
  Future<List<BookingModel>> getUserBookings(
    BookingFilterEntity filters,
  ) async {
    try {
      print('🌐 REMOTE: Fetching user bookings');

      final response = await _dioClient.dio.get(
        ApiConfig.getUserBookings,
        queryParameters: filters.toJson(),
      );

      print('✅ REMOTE: User bookings fetched');

      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => BookingModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch bookings',
      );
    }
  }

  /// Get booking by ID
  Future<BookingModel> getBookingById(String id) async {
    try {
      print('🌐 REMOTE: Fetching booking by ID: $id');

      final response = await _dioClient.dio.get(
        ApiConfig.getBookingById.replaceAll('{id}', id),
      );

      print('✅ REMOTE: Booking fetched');

      final data = response.data['data'] ?? response.data;
      return BookingModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch booking');
    }
  }

  /// Get booking by reference
  Future<BookingModel> getBookingByReference(String reference) async {
    try {
      print('🌐 REMOTE: Fetching booking by reference: $reference');

      final response = await _dioClient.dio.get(
        ApiConfig.getBookingByReference.replaceAll('{reference}', reference),
      );

      print('✅ REMOTE: Booking fetched');

      final data = response.data['data'] ?? response.data;
      return BookingModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch booking');
    }
  }

  /// Cancel booking
  Future<BookingModel> cancelBooking(String id, String reason) async {
    try {
      print('🌐 REMOTE: Cancelling booking: $id');

      final response = await _dioClient.dio.delete(
        ApiConfig.cancelBooking.replaceAll('{id}', id),
        data: {'reason': reason},
      );

      print('✅ REMOTE: Booking cancelled');

      final data = response.data['data'] ?? response.data;
      return BookingModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to cancel booking',
      );
    }
  }

  /// Add review
  Future<BookingModel> addReview(
    String id,
    double rating,
    String comment,
  ) async {
    try {
      print('🌐 REMOTE: Adding review to booking: $id');

      final response = await _dioClient.dio.post(
        ApiConfig.addReview.replaceAll('{id}', id),
        data: {'rating': rating, 'comment': comment},
      );

      print('✅ REMOTE: Review added');

      final data = response.data['data'] ?? response.data;
      return BookingModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to add review');
    }
  }

  /// Get booking statistics
  Future<Map<String, dynamic>> getBookingStats() async {
    try {
      print('🌐 REMOTE: Fetching booking statistics');

      final response = await _dioClient.dio.get(ApiConfig.getBookingStats);

      print('✅ REMOTE: Stats fetched');

      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch statistics',
      );
    }
  }
}
