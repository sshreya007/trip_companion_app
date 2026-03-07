import 'package:hive/hive.dart';
import 'package:trip_planner/features/profile/data/models/profile_model.dart';

class ProfileLocalDatasource {
  static const boxName = 'profileBox';

  Box<ProfileModel> get _box => Hive.box<ProfileModel>(boxName);

  /// Save profile to local storage
  Future<ProfileModel> saveProfile(ProfileModel profile) async {
    print('💾 LOCAL: Saving profile - ${profile.email}');

    await _box.put(profile.id, profile);

    print('✅ LOCAL: Profile saved');
    return profile;
  }

  /// Get profile from local storage
  Future<ProfileModel?> getProfile(String userId) async {
    print('💾 LOCAL: Getting profile for user $userId');

    final profile = _box.get(userId);

    if (profile != null) {
      print('✅ LOCAL: Profile found');
    } else {
      print('⚠️ LOCAL: Profile not found');
    }

    return profile;
  }

  /// Update profile in local storage
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    print('💾 LOCAL: Updating profile - ${profile.email}');

    await _box.put(profile.id, profile);

    print('✅ LOCAL: Profile updated');
    return profile;
  }

  /// Delete profile from local storage
  Future<bool> deleteProfile(String userId) async {
    print('💾 LOCAL: Deleting profile for user $userId');

    await _box.delete(userId);

    print('✅ LOCAL: Profile deleted');
    return true;
  }

  /// Check if profile exists
  bool hasProfile(String userId) {
    return _box.containsKey(userId);
  }
}
