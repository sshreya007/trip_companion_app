import 'package:hive_flutter/hive_flutter.dart';
import 'package:trip_planner/core/constants/hive_table_constants.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

class HiveService {
  HiveService._(); // private constructor
  static final HiveService instance = HiveService._();

  /// Open a Hive box
  Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  /// Close a Hive box
  Future<void> closeBox(String boxName) async {
    final box = Hive.isBoxOpen(boxName) ? Hive.box(boxName) : null;
    if (box != null) await box.close();
  }

  /// Delete a Hive box completely
  Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).clear();
      await Hive.box(boxName).deleteFromDisk();
    } else {
      await Hive.deleteBoxFromDisk(boxName);
    }
  }

  /// Add or update a key-value in a box
  Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  /// Get value by key
  Future<T?> get<T>(String boxName, dynamic key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }

  /// Delete a key
  Future<void> delete(String boxName, dynamic key) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  /// Get all values as a list
  Future<List<T>> getAll<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    return box.values.toList().cast<T>();
  }

  //===============Auth Queries =================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authBox);

  Future<void> registerUser(AuthHiveModel model) async {
    // Use email as the key
    await _authBox.put(model.email, model);
  }

  //login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  //logout
  Future<void> logoutUser(String id) async {
    await _authBox.delete(id);
  }

  //get cuurent user
  AuthHiveModel? getCurrentUser(String id) {
    return _authBox.get(id);
  }
}
