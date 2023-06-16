import 'package:flutter/material.dart';

class TokenProvider with ChangeNotifier {
  String _token = "";

  String get currToken {
    return _token;
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  Future<void> removeToken(String x) async {
    _token = "";
    notifyListeners();
  }

}