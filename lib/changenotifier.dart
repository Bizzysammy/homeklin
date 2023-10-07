import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  void setUser(UserData userData) {
    _userData = userData;
    notifyListeners();
  }
}
class UserData {
  final String userName;
  final String userEmail;

  UserData({
    required this.userName,
    required this.userEmail,
  });
}