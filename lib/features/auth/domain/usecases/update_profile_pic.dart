import '../repositories/auth_repository.dart';

class UpdateProfilePic {
  final AuthRepository repository;

  UpdateProfilePic(this.repository);

  Future<void> call(String userId, String imagePath) async {
    return await repository.updateProfilePicture(userId, imagePath);
  }
}
