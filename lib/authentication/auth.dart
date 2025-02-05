// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthActivity {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? phone;
  String? vehicleNumber;
  String? profilePicture;
  String? vehicle;

  AuthActivity({this.phone, this.profilePicture});

  Future<User?> registerUserWithEmailAndPassword(
      String email, String password, String username,
      {String? phone, String? address, String? profilePicture}) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        //phoneNumber: phone,
      );

      await userCredential.user?.updateDisplayName(username);
      await userCredential.user?.reload();

      // Generate a unique ID for the user
      var uuid = const Uuid();
      String uniqueId = 'UID${uuid.v4().substring(0, 6).toUpperCase()}';

      // Save the user data to Firestore
      await _firestore.collection('Users').doc(uniqueId).set({
        'username': username,
        'email': email,
        'phone': phone,
        'profilePicture': profilePicture, // Empty at first
        'uid': userCredential.user?.uid,
        'userId': uniqueId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      log('User $username with user ID $uniqueId registered successfully');

      return userCredential.user;
    } catch (e) {
      log('Error registering user: $e');
      return null;
    }
  }

  //Get current logged in user's unique ID for query data
  Future<String?> getCurrentUserUniqueId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null; // User not logged in

    try {
      // Fetch user document using Firebase UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid) // Using UID to directly access the document
          .get();

      if (userDoc.exists) {
        String uniqueId = userDoc['uniqueId']; // Get the uniqueId
        log('User uniqueId: $uniqueId fetched successfully');
        return uniqueId;
      } else {
        return null; // No document found
      }
    } catch (e) {
      log('Error fetching uniqueId: $e');
      return null;
    }
  }

  //Sign in user account with username and password
  Future<User?> signInUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        log('Email or password is empty');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error', textAlign: TextAlign.center),
              content: const Text('Email or password is empty'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return null;
      }

      final creds = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return creds.user;
    } catch (e) {
      //check if email is registered
      if (!e.toString().contains('no user record')) {
        log('Error in signing in: $e'); // Log the error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error', textAlign: TextAlign.center),
              content: const Text('Invalid email or password'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    return null;
  }

  //Sign in with Google
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _auth.signInWithCredential(cred);
    } catch (e) {
      log("Error signing in with Google");
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

  // Upload profile picture to Firebase Storage
  Future<String?> uploadProfilePicture(File imageFile) async {
    String? uniqueId = await getCurrentUserUniqueId();
    if (uniqueId == null) {
      log("Error: User uniqueId not found");
      return null;
    }

    try {
      String filePath = 'profile_pictures/$uniqueId.jpg';
      TaskSnapshot uploadTask = await _storage.ref(filePath).putFile(imageFile);
      String downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update Firestore with new image URL
      await _firestore.collection('Users').doc(uniqueId).update({
        'profilePicture': downloadUrl,
      });

      log("Profile picture updated successfully!");
      return downloadUrl;
    } catch (e) {
      log("Error uploading profile picture: $e");
      return null;
    }
  }

  //is user logged in
  Future<bool> isLoggedIn() async {
    final User? user = _auth.currentUser;
    return user != null;
  }
}
