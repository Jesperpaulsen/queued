import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/all.dart';

class UserState {
  bool loading;
  User user;

  UserState() {
    loading = false;
  }
}

class UserProvider extends StateNotifier<UserState> {
  UserProvider() : super(UserState()) {
    FirebaseAuth.instance.authStateChanges().listen((user) => setUser(user));
  }

  setUser(User user) {
    var newState = state;
    newState.user = user;
    state = newState;
  }

  setLoading(bool loading) {
    var newState = state;
    newState.loading = loading;
    state = newState;
  }

  static signIn() async {
    return FirebaseAuth.instance.signInAnonymously();
  }

  static signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  updateDisplayName(String displayName) async {
    setLoading(true);
    await FirebaseAuth.instance.currentUser
        .updateProfile(displayName: displayName);
    setLoading(false);
  }

  static final provider =
      StateNotifierProvider<UserProvider>((_) => UserProvider());
}
