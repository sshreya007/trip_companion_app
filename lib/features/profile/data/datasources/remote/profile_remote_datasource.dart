import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:trip_planner/core/network/api_config.dart';
import 'package:trip_planner/core/network/dio_client.dart';
import 'package:trip_planner/features/profile/data/models/profile_model.dart';

class ProfileRemoteDatasource {
  final DioClient _dioClient;

  ProfileRemoteDatasource(this._dioClient);

  /// Get profile from API
  Future<ProfileModel> getProfile(String userId) async {
    try {
      print('🌐 REMOTE: Getting profile for user $userId');

      final response = await _dioClient.dio.get(
        ApiConfig.getProfile.replaceAll('{userId}', userId),
      );

      print('✅ REMOTE: Profile retrieved');
      print('📦 Response: ${response.data}');

      // Handle different response structures
      final data =
          response.data['data'] ?? response.data['profile'] ?? response.data;

      return ProfileModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to get profile');
    }
  }

  /// Update profile on API
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      print('🌐 REMOTE: Updating profile for user ${profile.id}');

      final response = await _dioClient.dio.put(
        ApiConfig.updateProfile.replaceAll('{userId}', profile.id),
        data: {
          'name': profile.name,
          'gender': profile.gender,
          'age': profile.age,
        },
      );

      print('✅ REMOTE: Profile updated');
      print('📦 Response: ${response.data}');

      final data =
          response.data['data'] ?? response.data['profile'] ?? response.data;

      return ProfileModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update profile',
      );
    }
  }

  /// Upload profile image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      print('🌐 REMOTE: Uploading profile image for user $userId');
      print('📁 File path: ${imageFile.path}');

      // Get file extension
      final fileName = imageFile.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();

      // Determine media type
      MediaType mediaType;
      if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
        mediaType = MediaType('image', 'jpeg');
      } else if (fileExtension == 'png') {
        mediaType = MediaType('image', 'png');
      } else {
        mediaType = MediaType('image', fileExtension);
      }

      // Create multipart file
      final multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: mediaType,
      );

      // Create form data
      final formData = FormData.fromMap({
        'image': multipartFile,
        'userId': userId,
      });

      print('📤 Uploading...');

      final response = await _dioClient.dio.post(
        ApiConfig.uploadProfileImage,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print('✅ REMOTE: Image uploaded successfully');
      print('📦 Response: ${response.data}');

      // Extract image URL from response
      final imageUrl =
          response.data['imageUrl'] ??
          response.data['url'] ??
          response.data['profileImageUrl'] ??
          response.data['data']?['imageUrl'] ??
          response.data['data']?['url'];

      if (imageUrl == null) {
        throw Exception('Image URL not found in response');
      }

      return imageUrl.toString();
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to upload image');
    }
  }
}
