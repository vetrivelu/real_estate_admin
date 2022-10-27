import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Model/Project.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Result.dart';

import '../Model/Staff.dart';

class AppSession extends ChangeNotifier {
  static final AppSession _instance = AppSession._internal();

  List<Staff> staffs = [];
  List<Agent> agents = [];

  AppSession._internal() {
    firbaseAuth.authStateChanges().listen((event) async {
      if (event != null) {
        staffs = await Staff.getStaffs();
        FirebaseFirestore.instance
            .collection('agents')
            .get()
            .then((value) => value.docs.map((e) => Agent.fromSnapshot(e)).toList())
            .then((value) => agents = value);
      }
      notifyListeners();
    });

    pageController.addListener(() {
      notifyListeners();
    });
  }
  factory AppSession() {
    return _instance;
  }

  Property? selectedProperty;
  Project? selectedProject;

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
