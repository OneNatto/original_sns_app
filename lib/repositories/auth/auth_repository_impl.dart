import 'package:original_sns_app/services/auth/auth_service.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
  Future signIn(String email, String password) =>
      authService.signIn(email, password);

  @override
  Future signUp(String name, String email, String password) =>
      authService.signUp(name, email, password);

  @override
  Future signOut() => authService.signOut();

  @override
  Future<String> fetchUsername(String userId) =>
      authService.fetchUsername(userId);
}
