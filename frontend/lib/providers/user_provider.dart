import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _id = "";
  String _email = "";
  String _username = "";
  String _type = "guest";

  List<String> get userInfo {
    return [_id, _email, _username, _type];
  }

  void setUser(String id, String email, String username, String type) {
    _id = id;
    _email = email;
    _username = username;
    _type = type;
    notifyListeners();
  }

  void removeUser(String x) {
    _id = "";
    _email = "";
    _username = "";
    _type = "guest";
    print("XXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    notifyListeners();
  }

  bool get isAuthenticated {
    return UserProvider()._id != "";
  }

  bool get isAdmin {
    return UserProvider()._type == "admin";
  }

  bool get isGuest {
    return UserProvider()._type == "guest";
  }
}
