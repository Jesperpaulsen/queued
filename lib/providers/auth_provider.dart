import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/all.dart';

class Auth {
  static signIn() async {
    return FirebaseAuth.instance.signInAnonymously();
  }

  static signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static var provider = StreamProvider<User>((ref) {
    return FirebaseAuth.instance.authStateChanges();
  });
}
