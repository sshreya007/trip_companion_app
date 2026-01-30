import 'package:hive/hive.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

// ⚠️ IMPORTANT: After copying this file, run this command in your terminal:
// flutter packages pub run build_runner build --delete-conflicting-outputs

part 'auth_hive_model.g.dart';

@HiveType(typeId: 0)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String? password;

  AuthHiveModel({
    String? id,
    required this.fullName,
    required this.username,
    required this.email,
    this.password,
  }) : id = id ?? const Uuid().v4();

  /// Convert Data → Domain
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      fullName: fullName,
      username: username,
      email: email,
      password: password ?? '',
    );
  }

  /// Convert Domain → Data
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      id: entity.id.isEmpty ? null : entity.id,
      fullName: entity.fullName,
      username: entity.username,
      email: entity.email,
      password: entity.password,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  /// Create from JSON
  factory AuthHiveModel.fromJson(Map<String, dynamic> data) {
    return AuthHiveModel(
      id: data['id'],
      fullName: data['fullName'],
      username: data['username'],
      email: data['email'],
      password: data['password'],
    );
  }

  @override
  String toString() {
    return 'AuthHiveModel(id: $id, fullName: $fullName, username: $username, email: $email)';
  }
}
