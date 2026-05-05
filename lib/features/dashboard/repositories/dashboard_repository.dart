import '../../../core/utils/result.dart';
import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

abstract class IDashboardRepository {
  Future<Result<DashboardModel>> getDashboardData(String token);
}

class DashboardRepository implements IDashboardRepository {
  final DashboardService _dashboardService;

  DashboardRepository(this._dashboardService);

  @override
  Future<Result<DashboardModel>> getDashboardData(String token) {
    return _dashboardService.getDashboardData(token);
  }
}
