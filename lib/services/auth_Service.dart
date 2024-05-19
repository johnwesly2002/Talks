import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static init() async {
    _data = await SharedPreferences.getInstance();
  }

  static late final SharedPreferences _data;
  Future<void> loginUser(String userName) async {
    try {
      _data.setString("userName", userName);
    } catch (e) {
      print(e);
    }
  }

  void logoutUser() {
    _data.clear();
  }

  String? getUsername() {
    return _data.getString('userName') ?? 'DefaultValue';
  }

  void UpdateUserName(String newUsername) {
    _data.setString("userName", newUsername);
    notifyListeners();
  }

  Future<bool> LoggedIn() async {
    String? username = await _data.getString('userName');
    if (username == null) return false;
    return true;
  }
}
