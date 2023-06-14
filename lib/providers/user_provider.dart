import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
      id: "",
      name: "",
      email: "",
      password: "",
      address: "",
      type: "",
      token: "",
      cart: []);

  User get user => _user;

  void setUser(String userData){
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
