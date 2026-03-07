import 'package:hive/hive.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

class AuthLocalDatasource {
  static const boxName = 'authBox';

  Box<AuthHiveModel> get _box => Hive.box<AuthHiveModel>(boxName);

  // ✅ Use a separate box for storing the current user email
  Box get _prefsBox => Hive.box('prefsBox');

  Future<bool> register(AuthHiveModel model) async {
    print('📦 LOCAL DATASOURCE: Saving to Hive - ${model.email}');

    // Store user with email as key
    await _box.put(model.email, model);

    print('✅ LOCAL DATASOURCE: User saved with key: ${model.email}');
    print('📋 Total users in box: ${_box.length}');

    return true;
  }

  Future<AuthHiveModel> login(String email, String password) async {
    print('📦 LOCAL DATASOURCE: Login attempt - $email');
    print('📋 Available keys in box: ${_box.keys.toList()}');

    // Get user from box using email as key
    final user = _box.get(email);

    if (user == null) {
      print('❌ User not found: $email');
      throw Exception('User not found');
    }

    print('🔍 Found user: ${user.email}, password check...');

    if (user.password != password) {
      print('❌ Wrong password for: $email');
      throw Exception('Wrong password');
    }

    print('✅ Login successful: $email');

    // ✅ Store the email in a separate preferences box
    await _prefsBox.put('currentUserEmail', email);

    return user;
  }

  Future<AuthHiveModel?> getCurrentUser() async {
    // ✅ Get the stored email from preferences box
    final email = _prefsBox.get('currentUserEmail');

    print('🔍 getCurrentUser: stored email = $email');

    if (email == null) return null;

    // Get the user by email
    return _box.get(email);
  }

  Future<bool> logout() async {
    await _prefsBox.delete('currentUserEmail');
    return true;
  }
}
