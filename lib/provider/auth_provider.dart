import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/repositories/auth/auth_repository_impl.dart';
import 'package:original_sns_app/services/auth/auth_service_impl.dart';
import 'package:original_sns_app/viewmodels/auth_viewmodel.dart';

class UsernameNotifier extends StateNotifier<String> {
  UsernameNotifier() : super('');

  void setUserName(String name) {
    state = name;
  }

  void clearUserName() {
    state = '';
  }
}

final userNameProvider = StateNotifierProvider<UsernameNotifier, String>((ref) {
  return UsernameNotifier();
});

final authServiceProvider = Provider<AuthServiceImpl>((ref) {
  final usernameNotifier = ref.read(userNameProvider.notifier);
  return AuthServiceImpl(usernameNotifier);
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService: authService);
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<User?>>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthViewModel(authRepository);
});
