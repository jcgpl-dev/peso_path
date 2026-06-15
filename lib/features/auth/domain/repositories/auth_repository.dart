import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> register(User user);

  Future<User?> login(String username, String password);
}
