import 'package:dio/dio.dart';
import 'package:trip_planner/core/network/api_config.dart';
import 'package:trip_planner/core/network/dio_client.dart';
import 'package:trip_planner/features/package/data/models/package_model.dart';
import 'package:trip_planner/features/package/domain/entities/package_entity.dart';

class PackageRemoteDatasource {
  final DioClient _dioClient;

  PackageRemoteDatasource(this._dioClient);

  /// Get all packages with filters
  Future<List<PackageModel>> getAllPackages(PackageFilterEntity filters) async {
    try {
      print('🌐 REMOTE: Fetching packages with filters');

      final response = await _dioClient.dio.get(
        ApiConfig.getAllPackages,
        queryParameters: filters.toJson(),
      );

      print('✅ REMOTE: Packages fetched successfully');
      print('📦 Response: ${response.data}');

      // Handle different response structures
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => PackageModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch packages',
      );
    }
  }

  /// Get package by ID
  Future<PackageModel> getPackageById(String id) async {
    try {
      print('🌐 REMOTE: Fetching package with ID: $id');

      final response = await _dioClient.dio.get(
        ApiConfig.getPackageById.replaceAll('{id}', id),
      );

      print('✅ REMOTE: Package fetched successfully');

      final data = response.data['data'] ?? response.data;
      return PackageModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch package');
    }
  }

  /// Get featured packages
  Future<List<PackageModel>> getFeaturedPackages({int limit = 6}) async {
    try {
      print('🌐 REMOTE: Fetching featured packages');

      final response = await _dioClient.dio.get(
        ApiConfig.getFeaturedPackages,
        queryParameters: {'limit': limit},
      );

      print('✅ REMOTE: Featured packages fetched');

      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => PackageModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch featured packages',
      );
    }
  }

  /// Get packages by category
  Future<List<PackageModel>> getPackagesByCategory(
    String category, {
    int limit = 10,
  }) async {
    try {
      print('🌐 REMOTE: Fetching packages for category: $category');

      final response = await _dioClient.dio.get(
        ApiConfig.getPackagesByCategory.replaceAll('{category}', category),
        queryParameters: {'limit': limit},
      );

      print('✅ REMOTE: Category packages fetched');

      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => PackageModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch category packages',
      );
    }
  }

  /// Check availability
  Future<bool> checkAvailability(String id) async {
    try {
      print('🌐 REMOTE: Checking availability for package: $id');

      final response = await _dioClient.dio.get(
        ApiConfig.checkAvailability.replaceAll('{id}', id),
      );

      print('✅ REMOTE: Availability checked');

      final data = response.data['data'] ?? response.data;
      return data['available'] ?? false;
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to check availability',
      );
    }
  }
}
