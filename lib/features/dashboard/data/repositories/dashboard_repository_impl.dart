import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this.localDataSource);

  final DashboardLocalDataSource localDataSource;

  @override
  Future<DashboardSummary> getDashboardSummary() {
    return localDataSource.getDashboardSummary();
  }
}
