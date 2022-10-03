import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Result.dart';

class AppSession extends ChangeNotifier {
  static final AppSession _instance = AppSession._internal();

  AppSession._internal() {
    firbaseAuth.authStateChanges().listen((event) {
      notifyListeners();
    });

    pageController.addListener(() {
      notifyListeners();
    });
  }
  factory AppSession() {
    return _instance;
  }

  Future<Result> signIn({required String email, required String password}) {
    return firbaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => Result(tilte: Result.success, message: "Logged in sucessfully"))
        .onError((error, stackTrace) => Result(tilte: Result.failure, message: error.toString()));
  }

  final PageController pageController = PageController(initialPage: 1);

  final firbaseAuth = FirebaseAuth.instance;
  User? get currentUser => firbaseAuth.currentUser;
}
