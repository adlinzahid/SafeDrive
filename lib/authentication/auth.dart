// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthActivity {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Register user account with email and password
  Future<User?> registerUserWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(username);
      await userCredential.user!.reload();

      // Generate a unique ID for the user
      var uuid = const Uuid();
      String uniqueId =
          'UID${uuid.v4().substring(0, 6).toUpperCase()}'; //UID + 6 random characters

      // Save the user data to Firestore with the unique ID
      await _firestore.collection('Users').doc(uniqueId).set({
        'username': username,
        'email': email,
        'userId':
            uniqueId, // save the user's unique ID for identification purposes
        'uid': userCredential.user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  //Sign in user account with username and password
  Future<User?> signInUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      //check if the user is registered
      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection('Users')
            .where('email', isEqualTo: email)
            .get()
            .then((value) => value.docs.first);

        if (userDoc.exists) {
          return user;
        } else {
          log("User not found in Firestore");
          _errorSnackbar(context, "User is not registered");
        }
      }

      //if password does not match, show error message
      if (user == null) {
        log("Password does not match");
        _errorSnackbar(context, "Wrong password");
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        log("Password does not match");
        _errorSnackbar(context, "Wrong password");
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  //Sign in with Google
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log("User canceled the Google Sign-In process.");
        return null; // Handle case when user cancels sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //save user data to Firestore if the user is new
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection('Users')
            .where('email', isEqualTo: user.email)
            .get()
            .then((value) => value.docs.first);

        if (!userDoc.exists) {
          // Generate a unique ID for the user
          var uuid = const Uuid();
          String uniqueId =
              'UID${uuid.v4().substring(0, 6).toUpperCase()}'; //UID + 6 random characters

          await _firestore.collection('Users').doc(uniqueId).set({
            'username': user.displayName,
            'email': user.email,
            'userId': uniqueId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      log("Error signing in with Google: $e");
      _errorSnackbar(context, "Error signing in with Google");
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

//show error snackbar message
  void _errorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        showCloseIcon: true,
      ),
    );
  }

  //is user logged in
  Future<bool> isLoggedIn() async {
    final User? user = _auth.currentUser;
    return user != null;
  }
}
