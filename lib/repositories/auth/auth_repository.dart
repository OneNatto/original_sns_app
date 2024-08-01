abstract class AuthRepository {
  Future signIn(String email, String password);
  Future signUp(String name, String email, String password);
  Future signOut();
  Future<String> fetchUsername(String userId);
}
