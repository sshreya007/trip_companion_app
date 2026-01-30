import 'package:equatable/equatable.dart';
import 'dart:io';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final File? image;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.image,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    File? image,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      image: image ?? this.image,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, image, errorMessage];
}
