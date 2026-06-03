import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/logger.dart';
import '../../../core/utils/result.dart';
import '../../../core/config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  final DeviceInfoPlugin _deviceInfo;

  AuthService({DeviceInfoPlugin? deviceInfo})
      : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  Future<Result<UserModel>> login(String email, String password) async {
    try {
      final dio = await ApiConfig.dio;
      final deviceName = await _getDeviceName();

      final response = await dio.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
          'device_name': deviceName,
        },
      );

      final data = response.data;

      if (response.statusCode == 200 && data['status'] == 'success') {
        final userData = data['data']['user'];
        final user = UserModel.fromJson(userData, data['data']['token']);
        return Result.success(user);
      } else {
        final message = data['message'] ?? 'Login failed';
        Log.e('[AuthService] Login failed: $message');
        return Result.failure(message);
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Connection error: ${e.message}';
      Log.e('[AuthService] Dio error: $message');
      return Result.failure(message);
    } catch (e) {
      Log.e('[AuthService] Unexpected error: $e');
      return Result.failure('Unexpected error: $e');
    }
  }

  Future<Result<UserModel>> getMe() async {
    try {
      final dio = await ApiConfig.dio;
      final response = await dio.get(AppConstants.meEndpoint);
      final data = response.data;

      if (response.statusCode == 200 && data['status'] == 'success') {
        final userData = data['data'];
        final user = UserModel.fromJson(userData);
        return Result.success(user);
      } else {
        return Result.failure(data['message'] ?? 'Failed to retrieve user data');
      }
    } on DioException catch (e) {
      return Result.failure(e.response?.data?['message'] ?? 'Auth check failed');
    } catch (e) {
      return Result.failure('Session check error: $e');
    }
  }

  Future<Result<void>> logout() async {
    try {
      final dio = await ApiConfig.dio;
      final response = await dio.post(AppConstants.logoutEndpoint);
      if (response.statusCode == 200) {
        return Result.success(null);
      }
      return Result.failure('Logout failed');
    } catch (e) {
      return Result.failure('Logout error: $e');
    }
  }

  Future<String> _getDeviceName() async {
    String deviceName = 'Unknown Device';

    try {
      if (kIsWeb) {
        final webBrowserInfo = await _deviceInfo.webBrowserInfo;
        deviceName = webBrowserInfo.userAgent ?? 'Web Browser';
      } else {
        if (defaultTargetPlatform == TargetPlatform.android) {
          final androidInfo = await _deviceInfo.androidInfo;
          deviceName = '${androidInfo.brand} ${androidInfo.model}';
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceName = iosInfo.utsname.machine;
        } else {
          deviceName = 'Other Mobile/Desktop';
        }
      }
    } catch (e) {
      Log.e('Error getting device info: $e');
    }

    return deviceName;
  }
}
