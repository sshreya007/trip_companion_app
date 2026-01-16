import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String userName;
  final String? status;

  AuthApiModel({this.id, required this.userName, this.status});

  // Model → JSON (send to API)
  Map<String, dynamic> toJson() {
    return {"userName": userName};
  }

  // JSON → Model (response from API)
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] ?? json['id'],
      userName: json['userName'],
      status: json['status'],
    );
  }

  // Model → Entity
  AuthEntity toEntity() {
    return AuthEntity(id: id, username: userName, email: '');
  }

  // Entity → Model
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.id,
      userName: entity.username,
      status: entity.status,
    );
  }
}
