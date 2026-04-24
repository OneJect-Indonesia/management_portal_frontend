import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class SessionService {
  static const _storage = FlutterSecureStorage();
  static const _userKey = 'user_session_data';

  /// Save User data along with the token to secure storage
  static Future<void> saveSession(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _storage.write(key: _userKey, value: userJson);
      debugPrint('[SessionService] Session saved successfully.');
    } catch (e) {
      debugPrint('[SessionService] Error saving session: $e');
    }
  }

  /// Retrieve User data from secure storage
  static Future<UserModel?> getSession() async {
    try {
      final userString = await _storage.read(key: _userKey);
      if (userString != null && userString.isNotEmpty) {
        final decoded = jsonDecode(userString);
        // The token was also saved inside the JSON object by toJson()
        // so we can extract it and pass it to fromJson().
        return UserModel.fromJson(decoded, decoded['token'] ?? '');
      }
    } catch (e) {
      debugPrint('[SessionService] Error reading session: $e');
    }
    return null;
  }

  /// Delete session from secure storage (Logout)
  static Future<void> clearSession() async {
    try {
      await _storage.delete(key: _userKey);
      debugPrint('[SessionService] Session cleared.');
    } catch (e) {
      debugPrint('[SessionService] Error clearing session: $e');
    }
  }
}
