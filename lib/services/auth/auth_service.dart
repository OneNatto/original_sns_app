import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/provider/username_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final userNameNotifier = ref.read(userNameProvider.notifier);
  return AuthService(userNameNotifier);
});

class AuthService {
  final UsernameNotifier usernameNotifier;

  //インスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthService(this.usernameNotifier);

  //状態管理

  //サインイン
  Future<bool> signIn(String email, String password) async {
    try {
      //auth
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final username = await fetchUsername(result.user!.uid);

      usernameNotifier.setUserName(username);

      return true;
    } catch (e) {
      return false;
    }
  }

  //サインアップ
  Future<bool> signUp(String name, String email, String password) async {
    try {
      //auth
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //firestore
      firestore.collection('users').doc(result.user!.uid).set({
        'id': result.user!.uid,
        'name': name,
        'email': email,
      });

      usernameNotifier.setUserName(name);

      return true;
    } catch (e) {
      return false;
    }
  }

  //サインアウト
  Future<void> signOut() async {
    return await auth.signOut();
  }

  // ユーザー名を取得するメソッド
  Future<String> fetchUsername(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      return userDoc.get('name');
    } catch (e) {
      return e.toString();
    }
  }
}
