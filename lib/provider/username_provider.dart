import 'package:flutter_riverpod/flutter_riverpod.dart';

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
