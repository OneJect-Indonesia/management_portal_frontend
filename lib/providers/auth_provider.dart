import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/auth_service.dart';
import '../core/session_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  /// Call this when the app starts to auto-login based on Secure Storage
  Future<void> checkSession() async {
    _currentUser = await SessionService.getSession();
    notifyListeners();
  }

  /// Update the current user manually (e.g. from splash screen after token verification)
  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Perform login and save to session
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    if (result['success']) {
      _currentUser = result['user'];
      await SessionService.saveSession(_currentUser!);
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  /// Logout and clear session
  Future<void> logout() async {
    await SessionService.clearSession();
    _currentUser = null;
    notifyListeners();
  }
}
