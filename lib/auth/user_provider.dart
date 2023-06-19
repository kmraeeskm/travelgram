import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelgram/auth/auth_methods.dart';
import 'package:travelgram/models/models.dart' as model;

class AuthProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final authmethods _authmethods = authmethods();
  User? _user;

  AuthProvider() {
    auth.authStateChanges().listen((user) {
      _user = user;

      notifyListeners();
    });
  }
  bool get isAuthenticated => _user != null;
}

class UserProvider extends ChangeNotifier {
  model.UserModel? _userModel;

  model.UserModel? get userModel => _userModel;

  void setUserModel(model.UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}
