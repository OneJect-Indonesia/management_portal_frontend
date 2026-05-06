import '../../../core/utils/result.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

abstract class IAuthRepository {
  Future<Result<UserModel>> login(String email, String password);
  Future<Result<void>> logout();
  Future<Result<UserModel>> getMe();
}

class AuthRepository implements IAuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  @override
  Future<Result<UserModel>> login(String email, String password) {
    return _authService.login(email, password);
  }

  @override
  Future<Result<void>> logout() {
    return _authService.logout();
  }

  @override
  Future<Result<UserModel>> getMe() {
    return _authService.getMe();
  }
}
