import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final TextEditingController emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  //create user account with email and password
  Future<User?> createAccount(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }
}
