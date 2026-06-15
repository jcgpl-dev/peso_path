import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/register_user.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Datasource

  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());

  // Repository

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthLocalDataSource>()),
  );

  // Use Cases

  sl.registerLazySingleton(() => RegisterUser(sl<AuthRepository>()));

  sl.registerLazySingleton(() => LoginUser(sl<AuthRepository>()));

  // Bloc

  sl.registerFactory(
    () =>
        AuthBloc(registerUser: sl<RegisterUser>(), loginUser: sl<LoginUser>()),
  );
}
