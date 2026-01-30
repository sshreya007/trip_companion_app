import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner/core/network/api_config.dart';
import 'package:trip_planner/core/network/dio_client.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

class AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasource(this._dioClient);

  Future<AuthHiveModel> register(AuthHiveModel model) async {
    try {
      print('🌐 REMOTE: Registering user - ${model.email}');

      // Split fullName into firstName and lastName
      final nameParts = model.fullName.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      print('📝 Sending: firstName="$firstName", lastName="$lastName"');

      final response = await _dioClient.dio.post(
        ApiConfig.register,
        data: {
          'firstName': firstName, // ✅ Capital F
          'lastName': lastName, // ✅ Capital L
          'username': model.username,
          'email': model.email,
          'password': model.password,
          'confirmPassword': model.password,
        },
      );

      print('✅ REMOTE: Registration successful');
      print('📦 Response data: ${response.data}');

      // Save token if provided
      if (response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['token']);
        print('🔑 Token saved');
      }

      // Handle different response structures
      Map<String, dynamic> userData;
      if (response.data['user'] != null) {
        userData = response.data['user'];
      } else if (response.data['data'] != null) {
        userData = response.data['data'];
      } else {
        userData = response.data;
      }

      // Convert response to model (handle both firstName/lastName and fullName)
      String fullName;
      if (userData['fullName'] != null) {
        fullName = userData['fullName'];
      } else if (userData['firstName'] != null &&
          userData['lastName'] != null) {
        fullName = '${userData['firstName']} ${userData['lastName']}';
      } else if (userData['firstname'] != null &&
          userData['lastname'] != null) {
        fullName = '${userData['firstname']} ${userData['lastname']}';
      } else {
        fullName = model.fullName; // Fallback to original
      }

      return AuthHiveModel(
        id:
            userData['id']?.toString() ??
            userData['_id']?.toString() ??
            model.id,
        fullName: fullName,
        username: userData['username'] ?? model.username,
        email: userData['email'] ?? model.email,
        password: null, // Don't store password
      );
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');

      String errorMessage = 'Registration failed';

      if (e.response?.data != null) {
        if (e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data['error'] != null) {
          errorMessage = e.response!.data['error'];
        }
      }

      throw Exception(errorMessage);
    }
  }

  Future<AuthHiveModel> login(String email, String password) async {
    try {
      print('🌐 REMOTE: Login attempt - $email');

      final response = await _dioClient.dio.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );

      print('✅ REMOTE: Login successful');
      print('📦 Response data: ${response.data}');

      // Save token
      if (response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['token']);
        print('🔑 Token saved');
      }

      // Handle different response structures
      Map<String, dynamic> userData;
      if (response.data['user'] != null) {
        userData = response.data['user'];
      } else if (response.data['data'] != null) {
        userData = response.data['data'];
      } else {
        userData = response.data;
      }

      // Convert response to model
      String fullName;
      if (userData['fullName'] != null) {
        fullName = userData['fullName'];
      } else if (userData['firstName'] != null &&
          userData['lastName'] != null) {
        fullName = '${userData['firstName']} ${userData['lastName']}';
      } else if (userData['firstname'] != null &&
          userData['lastname'] != null) {
        fullName = '${userData['firstname']} ${userData['lastname']}';
      } else {
        fullName = userData['username'] ?? 'User';
      }

      return AuthHiveModel(
        id: userData['id']?.toString() ?? userData['_id']?.toString() ?? '',
        fullName: fullName,
        username: userData['username'] ?? '',
        email: userData['email'] ?? email,
        password: null, // Don't store password
      );
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');

      String errorMessage = 'Login failed';

      if (e.response?.data != null) {
        if (e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data['error'] != null) {
          errorMessage = e.response!.data['error'];
        }
      }

      throw Exception(errorMessage);
    }
  }

  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      print('🌐 REMOTE: Getting current user');

      final response = await _dioClient.dio.get(ApiConfig.getCurrentUser);

      print('✅ REMOTE: User retrieved');
      print('📦 Response data: ${response.data}');

      // Handle different response structures
      Map<String, dynamic> userData;
      if (response.data['user'] != null) {
        userData = response.data['user'];
      } else if (response.data['data'] != null) {
        userData = response.data['data'];
      } else {
        userData = response.data;
      }

      // Convert response to model
      String fullName;
      if (userData['fullName'] != null) {
        fullName = userData['fullName'];
      } else if (userData['firstName'] != null &&
          userData['lastName'] != null) {
        fullName = '${userData['firstName']} ${userData['lastName']}';
      } else if (userData['firstname'] != null &&
          userData['lastname'] != null) {
        fullName = '${userData['firstname']} ${userData['lastname']}';
      } else {
        fullName = userData['username'] ?? 'User';
      }

      return AuthHiveModel(
        id: userData['id']?.toString() ?? userData['_id']?.toString() ?? '',
        fullName: fullName,
        username: userData['username'] ?? '',
        email: userData['email'] ?? '',
        password: null,
      );
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      print('🌐 REMOTE: Logging out');

      await _dioClient.dio.post(ApiConfig.logout);

      // Clear token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      print('✅ REMOTE: Logout successful');

      return true;
    } on DioException catch (e) {
      print('❌ REMOTE ERROR: ${e.response?.data ?? e.message}');

      // Still clear token even if request fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      return true;
    }
  }
}
