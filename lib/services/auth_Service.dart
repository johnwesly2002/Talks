import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  User? _user;

  AuthService() {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  bool isLoggedIn() {
    return _user != null;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
