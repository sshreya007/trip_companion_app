import 'dart:io';

abstract class IProfileLocalDatasource {
  Future<bool> uploadProfilePhoto(File image);
}

class ProfileLocalDatasource implements IProfileLocalDatasource {
  @override
  Future<bool> uploadProfilePhoto(File image) async {
    // Later connect with API or Firebase
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
