import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';
// import 'auth_service.dart'; // To get the base URL if needed, or define it here

class DashboardService {
  // Using the same IP as AuthService.
  // Ideally, this should be in a shared config file.
  static const String _baseUrl = 'http://127.0.0.1:80/api/v1';

  Future<DashboardData?> getDashboardData(String token) async {
    try {
      debugPrint(
        '[DashboardService] Fetching dashboard with token: ${token.substring(0, token.length.clamp(0, 20))}...',
      );

      final response = await http.get(
        Uri.parse('$_baseUrl/my-dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('[DashboardService] Status: ${response.statusCode}');
      debugPrint('[DashboardService] Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('[DashboardService] status field: ${data['status']}');
        debugPrint(
          '[DashboardService] data field type: ${data['data']?.runtimeType}',
        );

        if (data['status'] == 'success') {
          // data['data'] adalah List (flat array), bukan Map.
          // Gunakan fromList yang mengelompokkan berdasarkan module.category.
          final rawList = data['data'] as List<dynamic>;
          final dashboardData = DashboardData.fromList(rawList);
          debugPrint(
            '[DashboardService] Categories parsed: ${dashboardData.categories.keys.toList()}',
          );
          return dashboardData;
        } else {
          debugPrint(
            '[DashboardService] status != success, got: ${data['status']}',
          );
        }
      } else {
        debugPrint(
          '[DashboardService] Non-200 status: ${response.statusCode}, body: ${response.body}',
        );
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('[DashboardService] ERROR: $e');
      debugPrint('[DashboardService] StackTrace: $stackTrace');
      return null;
    }
  }
}
