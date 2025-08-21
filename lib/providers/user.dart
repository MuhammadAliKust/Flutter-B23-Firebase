import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_b23_firebase/models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel _userModel = UserModel();

  void setUser(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  UserModel getUser() => _userModel;
}
