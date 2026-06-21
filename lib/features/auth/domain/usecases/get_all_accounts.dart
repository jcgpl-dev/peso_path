import 'package:peso_path/features/auth/domain/entities/user.dart';
import 'package:peso_path/features/auth/domain/repositories/auth_repository.dart';

class GetAllAccounts {
  final AuthRepository repository;

  GetAllAccounts(this.repository);

  Future<List<User>> call() async {
    return await repository.getAllStoredAccounts();
  }
}
