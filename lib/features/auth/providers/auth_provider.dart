import 'package:flutter/material.dart';
import '../../../core/utils/result.dart';
import '../../../data/local/session_service.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final IAuthRepository _authRepository;
  final ISessionService _sessionService;
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;

  AuthProvider(this._authRepository, this._sessionService) {
    checkSession();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _currentUser != null;

  /// Call this when the app starts to auto-login based on Secure Storage
  Future<void> checkSession() async {
    _currentUser = await _sessionService.getSession();
    _isInitialized = true;
    notifyListeners();
  }

  /// Update the current user manually (e.g. from splash screen after token verification)
  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Perform login and save to session
  Future<Result<UserModel>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authRepository.login(email, password);

    if (result.isSuccess && result.data != null) {
      _currentUser = result.data;
      await _sessionService.saveSession(_currentUser!);
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  /// Logout and clear session
  Future<void> logout() async {
    await _sessionService.clearSession();
    _currentUser = null;
    notifyListeners();
  }
}
