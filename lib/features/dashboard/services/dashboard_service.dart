import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/logger.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/result.dart';
import '../models/dashboard_model.dart';

// Exceptions removed in favor of Result pattern

class DashboardService {
  final http.Client _client;

  DashboardService({http.Client? client}) : _client = client ?? http.Client();

  Future<Result<DashboardModel>> getDashboardData(String token) async {
    try {
      Log.d('[DashboardService] Fetching dashboard Data...');

      final response = await _client.get(
        Uri.parse(AppConstants.dashboardEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 401 || response.statusCode == 403) {
        return Result.failure('Unauthorized');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
      
    } catch (e) {
      Log.e('[DashboardService] ERROR: $e');
      return Result.failure(e.toString());
    }
  }

  Future<Result<String>> fetchSsoTicket(String token) async {
    try {
      Log.d('[DashboardService] Fetching SSO Ticket...');

      final response = await _client.post(
        Uri.parse(AppConstants.ssoTicketEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 401 || response.statusCode == 403) {
        return Result.failure('Unauthorized');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return Result.success(data['data']['ticket'] as String);
        }
      }

      return Result.failure('Failed to generate ticket with status: ${response.statusCode}');
    } catch (e) {
      Log.e('[DashboardService] ERROR: $e');
      return Result.failure(e.toString());
    }
  }
}
