import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:original_sns_app/repositories/auth/auth_repository.dart';

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository authRepository;

  AuthViewModel(this.authRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future _init() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await authRepository.signIn(email, password);
      state = AsyncValue.data(FirebaseAuth.instance.currentUser);
      return true;
    } catch (e) {
      state = const AsyncValue.data(null);
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      await authRepository.signUp(name, email, password);
      state = AsyncValue.data(FirebaseAuth.instance.currentUser);
      return true;
    } catch (e) {
      state = const AsyncValue.data(null);
      return false;
    }
  }

  Future signOut() async {
    try {
      await authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
