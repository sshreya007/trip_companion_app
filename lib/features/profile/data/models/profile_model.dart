import 'package:hive/hive.dart';
import 'package:trip_planner/features/profile/domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 1) // Different from auth (typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? gender;

  @HiveField(4)
  final int? age;

  @HiveField(5)
  final String? profileImageUrl;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.gender,
    this.age,
    this.profileImageUrl,
  });

  /// Convert Domain Entity → Data Model
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      gender: entity.gender,
      age: entity.age,
      profileImageUrl: entity.profileImageUrl,
    );
  }

  /// Convert Data Model → Domain Entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      email: email,
      gender: gender,
      age: age,
      profileImageUrl: profileImageUrl,
    );
  }

  /// Convert JSON → Data Model
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'],
      age: json['age'],
      profileImageUrl:
          json['profileImageUrl'] ?? json['profileImage'] ?? json['avatar'],
    );
  }

  /// Convert Data Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'profileImageUrl': profileImageUrl,
    };
  }

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, email: $email, gender: $gender, age: $age)';
  }
}
