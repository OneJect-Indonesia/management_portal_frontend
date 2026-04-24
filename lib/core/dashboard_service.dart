import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';

class UnauthorizedException implements Exception {}
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred.']);
}

class DashboardService {
  static const String _baseUrl = 'http://127.0.0.1:80/api/v1';

  Future<DashboardData?> getDashboardData(String token) async {
    try {
      debugPrint('[DashboardService] Fetching dashboard Data...');

      final response = await http.get(
        Uri.parse('$_baseUrl/my-dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15)); // adding reasonable timeout

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final rawList = data['data'] as List<dynamic>;
          return DashboardData.fromList(rawList);
        }
      }

      // Instead of silently failing for 500s or others, throw NetworkException
      throw NetworkException('Failed with status: ${response.statusCode}');
      
    } on UnauthorizedException {
      rethrow; // Pass up
    } catch (e) {
      debugPrint('[DashboardService] ERROR: $e');
      throw NetworkException(e.toString());
    }
  }

  Future<String> fetchSsoTicket(String token) async {
    try {
      debugPrint('[DashboardService] Fetching SSO Ticket...');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/sso-ticket'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw UnauthorizedException();
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data']['ticket'] as String;
        }
      }

      throw NetworkException('Failed to generate ticket with status: ${response.statusCode}');
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      debugPrint('[DashboardService] ERROR: $e');
      throw NetworkException(e.toString());
    }
  }
}
