import '../../../core/utils/result.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

abstract class IAuthRepository {
  Future<Result<UserModel>> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getSession();
}

class AuthRepository implements IAuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  @override
  Future<Result<UserModel>> login(String email, String password) {
    return _authService.login(email, password);
  }

  @override
  Future<void> logout() {
    return _authService.logout();
  }

  @override
  Future<UserModel?> getSession() {
    return _authService.getSession();
  }
}
