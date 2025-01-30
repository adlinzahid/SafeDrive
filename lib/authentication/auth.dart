import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthActivity {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Register an account with email, username, and password
  Future<void> registerAccount(
      String email, String username, String password) async {
    //check if the email is already in use
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
    } catch (e) {
      rethrow;
    }
  }

  //Sign in user account with username and password
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      }
    } catch (e) {
      rethrow;
    }
  }

  //Sign out user
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //Get the current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
