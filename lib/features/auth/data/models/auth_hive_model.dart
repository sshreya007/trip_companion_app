import 'package:hive/hive.dart';
import 'package:trip_planner/core/constants/hive_table_constants.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? password;

  AuthHiveModel({
    String? id,
    required this.username,
    required this.email,
    this.password,
  }) : id = id ?? Uuid().v4();

  ///  Data → Domain
  AuthEntity toEntity() {
    return AuthEntity(id: id, username: username, email: email);
  }

  ///  Domain → Data
  factory AuthHiveModel.fromEntity(
    AuthEntity entity, {
    required String password,
  }) {
    return AuthHiveModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      password: password,
    );
  }
}
