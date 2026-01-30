import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? gender;
  final int? age;
  final String? profileImageUrl;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.gender,
    this.age,
    this.profileImageUrl,
  });

  ProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    int? age,
    String? profileImageUrl,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, gender, age, profileImageUrl];
}
