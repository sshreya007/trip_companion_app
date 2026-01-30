import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  final String id;
  final String? imageUrl;

  ProfileModel({required this.id, this.imageUrl});

  /// Convert Model → Entity
  ProfileEntity toEntity() {
    return ProfileEntity(id: id, imageUrl: imageUrl);
  }

  /// Convert Entity → Model
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(id: entity.id, imageUrl: entity.imageUrl);
  }

  /// Convert from JSON (for API/Firebase later)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(id: json['id'], imageUrl: json['imageUrl']);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'imageUrl': imageUrl};
  }
}
