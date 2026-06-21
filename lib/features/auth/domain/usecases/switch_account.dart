import 'package:peso_path/features/auth/domain/repositories/auth_repository.dart';

class SwitchAccount {
  final AuthRepository repository;

  SwitchAccount(this.repository);

  Future<void> call(String userId) async {
    return await repository.setActiveAccount(userId);
  }
}
