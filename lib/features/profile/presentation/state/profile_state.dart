import 'package:equatable/equatable.dart';
import 'package:trip_planner/features/profile/domain/entities/profile_entity.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  updating,
  updated,
  uploadingImage,
  imageUploaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;
  final String? uploadedImageUrl;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.uploadedImageUrl,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    String? uploadedImageUrl,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      uploadedImageUrl: uploadedImageUrl,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, uploadedImageUrl];
}
