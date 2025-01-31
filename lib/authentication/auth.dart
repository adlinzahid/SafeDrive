// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AuthActivity {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Register an account with email, username, and password
  Future<User?> registerUserwithEmailAndPassword(String email, String password,
      String username, BuildContext context) async {
    //if username is already taken, notify the user
    try {
      if (await isUsernameTaken(username)) {
        throw 'Username is already taken';
      }

      //check if input fields are not empty
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        log('Email, password or full name is empty');
        return null;
      }

      //create a new user with email and password with firebase authentication
      final creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //upon registering, create a unique user id for the user and save it to the database. E.g: userId: UID000
      String userId;
      bool exists;
      var uuid = const Uuid();

      do {
        String uniqueId = uuid.v4().substring(0, 6).toUpperCase();
        userId = 'UID$uniqueId';

        var doc = await _firestore.collection('Users').doc(userId).get();
        exists = doc.exists;
      } while (exists);

      //save input from user to the database
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'email': email,
        'username': username,
        'phone': '',
        'Gender': '',
        'Birthdate': '',
        'Address': '',
        'name': '',
        'userId': userId,
      });

      return creds.user;
    } catch (e) {
      rethrow;
    }
  }

  //Sign in user account with username and password
  Future<User?> signInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  //Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong while signing out");
    }
  }

  //Get the current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  //Check if the username is already taken
  Future<bool> isUsernameTaken(String username) async {
    //if the username is already taken, return true and notify the user
    final query = await _firestore
        .collection('Users')
        .where('username', isEqualTo: username)
        .get();

    return query.docs.isNotEmpty;
  }
}
