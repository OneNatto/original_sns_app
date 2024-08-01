import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:original_sns_app/services/auth/auth_service.dart';

import '../../provider/auth_provider.dart';

class AuthServiceImpl extends AuthService {
  final UsernameNotifier usernameNotifier;

  //インスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthServiceImpl(this.usernameNotifier);

  //状態管理

  //サインイン
  @override
  Future signIn(String email, String password) async {
    try {
      //auth
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final username = await fetchUsername(result.user!.uid);

      usernameNotifier.setUserName(username);
    } catch (e) {
      throw "エラー：$e";
    }
  }

  //サインアップ
  @override
  Future signUp(String name, String email, String password) async {
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
    } catch (e) {
      throw "エラー：$e";
    }
  }

  //サインアウト
  @override
  Future signOut() async {
    return await auth.signOut();
  }

  // ユーザー名を取得するメソッド
  @override
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
