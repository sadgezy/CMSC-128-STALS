import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _id = "";
  String _email = "";
  String _username = "";
  String _type = "guest";
  bool _verified = false;
  bool _rejected = false;

  List<dynamic> get userInfo {
    return [_id, _email, _username, _type, _verified, _rejected];
  }

  Future<void> _storeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', _id);
    prefs.setString('email', _email);
    prefs.setString('username', _username);
    prefs.setString('type', _type.toString());
    prefs.setBool('verified', _verified);
    prefs.setBool('rejected', _rejected);
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? "";
    _email = prefs.getString('email') ?? "";
    _username = prefs.getString('username') ?? "";
    _type = prefs.getString('type') ?? "guest";
    _verified = prefs.getBool('verified') ?? false;
    _rejected = prefs.getBool('rejected') ?? false;
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('email');
    prefs.remove('username');
    prefs.remove('type');
    prefs.remove('verified');
    prefs.remove('rejected');
  }


  UserProvider() {
    loadUserData(); // Load user data from SharedPreferences
  }

  void setUser(
      String id, String email, String username, String type, bool verified, bool rejected) {
    _id = id;
    _email = email;
    _username = username;
    _type = type == 'admin' ? 'admin' : type;
    _verified = verified;
    _rejected = rejected;
    _storeUserData(); // Store user data in SharedPreferences
    notifyListeners();
  }

  Future<void> removeUser(String x) async {
    _id = "";
    _email = "";
    _username = "";
    _type = 'guest';
    _verified = false;
    _rejected = false;
    await _clearUserData(); // Clear user data from SharedPreferences
    notifyListeners();
  }


  bool get isAuthenticated {
    return this._id != "";
  }

  bool get isAdmin {
    return this._type == 'admin';
  }

  bool get isOwner {
    return this._type == 'owner';
  }

  bool get isGuest {
    return this._type == 'guest';
  }

  bool get isVerified {
    return this._verified;
  }

  bool get isRejected {
    return this._rejected;
  }

  String get getID {
    return this._id;
  }
}
