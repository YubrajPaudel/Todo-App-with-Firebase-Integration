import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/homepage.dart';
import 'package:todo_app/screens/todo_homepage.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
          Duration(seconds: 3),
          (() => Navigator.push(
              context, MaterialPageRoute(builder: (context) => TodoApp()))));
    } else {
      Timer(
          Duration(seconds: 3),
          (() => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()))));
    }
  }
}
