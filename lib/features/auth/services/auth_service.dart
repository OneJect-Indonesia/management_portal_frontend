import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/logger.dart';
import '../../../core/utils/result.dart';
import '../models/user_model.dart';

class AuthService {
  final http.Client _client;
  final DeviceInfoPlugin _deviceInfo;

  AuthService({http.Client? client, DeviceInfoPlugin? deviceInfo})
      : _client = client ?? http.Client(),
        _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  Future<Result<UserModel>> login(String email, String password) async {
    try {
      final deviceName = await _getDeviceName();

      final response = await _client.post(
        Uri.parse(AppConstants.loginEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': deviceName,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final userData = data['data']['user'];
        final token = data['data']['token'];
        final user = UserModel.fromJson(userData, token);
        return Result.success(user);
      } else {
        final message = data['message'] ?? 'Login failed';
        Log.e('[AuthService] Login failed: $message');
        return Result.failure(message);
      }
    } catch (e) {
      Log.e('[AuthService] Connection error: $e');
      return Result.failure('Connection error: $e');
    }
  }

  Future<void> logout() async {
    // Implement API logout if needed
  }

  Future<UserModel?> getSession() async {
    // This is handled by SessionService, but we can put logic here if needed
    return null;
  }

  Future<String> _getDeviceName() async {
    String deviceName = 'Unknown Device';

    try {
      if (kIsWeb) {
        final webBrowserInfo = await _deviceInfo.webBrowserInfo;
        deviceName = webBrowserInfo.userAgent ?? 'Web Browser';
      } else {
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          deviceName = '${androidInfo.brand} ${androidInfo.model}';
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceName = iosInfo.utsname.machine;
        } else if (Platform.isLinux) {
          final linuxInfo = await _deviceInfo.linuxInfo;
          deviceName = linuxInfo.prettyName;
        } else if (Platform.isMacOS) {
          final macOsInfo = await _deviceInfo.macOsInfo;
          deviceName = macOsInfo.computerName;
        } else if (Platform.isWindows) {
          final windowsInfo = await _deviceInfo.windowsInfo;
          deviceName = windowsInfo.computerName;
        } else {
          deviceName = 'Unknown Device';
        }
      }
    } catch (e) {
      Log.e('Error getting device info: $e');
    }

    return deviceName;
  }
}
