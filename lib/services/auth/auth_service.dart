//final authServiceProvider = Provider<AuthService>((ref) {
//  final userNameNotifier = ref.read(userNameProvider.notifier);
//  return AuthService(userNameNotifier);
//});

abstract class AuthService {
  Future signIn(String email, String password);
  Future signUp(String name, String email, String password);
  Future signOut();
  Future<String> fetchUsername(String userId);
}
