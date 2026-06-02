import 'package:dio/dio.dart';
import '../../../core/utils/logger.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/result.dart';
import '../../../core/config/api_config.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  Future<Result<DashboardModel>> getDashboardData() async {
    try {
      Log.d('[DashboardService] Fetching dashboard Data...');
      final dio = await ApiConfig.dio;
      final response = await dio.get(AppConstants.dashboardEndpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          final rawList = data['data'] as List<dynamic>;
          final model = DashboardModel(
            status: 'success',
            message: data['message'] ?? '',
            data: DashboardData.fromList(rawList),
          );
          return Result.success(model);
        }
      }

      return Result.failure('Failed with status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return Result.failure('Unauthorized');
      }
      Log.e('[DashboardService] DIO ERROR: ${e.message}');
      return Result.failure(e.message ?? 'Unknown error');
    } catch (e) {
      Log.e('[DashboardService] ERROR: $e');
      return Result.failure(e.toString());
    }
  }

  Future<Result<String>> fetchSsoTicket() async {
    try {
      Log.d('[DashboardService] Fetching SSO Ticket...');
      final dio = await ApiConfig.dio;
      final response = await dio.post(AppConstants.ssoTicketEndpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return Result.success(data['data']['ticket'] as String);
        }
      }

      return Result.failure('Failed to generate ticket with status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return Result.failure('Unauthorized');
      }
      return Result.failure(e.message ?? 'Unknown error');
    } catch (e) {
      Log.e('[DashboardService] ERROR: $e');
      return Result.failure(e.toString());
    }
  }
}
