import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<void> call(User user) {
    return repository.register(user);
  }
}
