import 'package:flutter/material.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void redirectToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
