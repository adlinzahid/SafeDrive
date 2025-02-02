// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/authentication/auth.dart';
import 'package:safe_drive/components/safedrivebutton.dart';
import 'package:safe_drive/components/safedrivetextfield.dart';
import 'package:safe_drive/ui_screens/authentication/login.dart';
import 'package:safe_drive/ui_screens/homepage/homepage.dart';
import 'package:uuid/uuid.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _Registerpage();
}

class _Registerpage extends State<Registerpage> {
  final _auth = AuthActivity();
  final _firestore = FirebaseFirestore.instance;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    //dispose of the controllers when the widget is removed from the tree
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            //SafeDrive Logo
            Image.asset("assets/images/2.png", height: 200, width: 200),

            //Register text
            const Text(
              "Register your account now to get started",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 25),
            //Email textfield
            Safedrivetextfield(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false),
            const SizedBox(height: 10),
            //Username textfield
            Safedrivetextfield(
                controller: _usernameController,
                hintText: 'Username',
                obscureText: false),
            //Password textfield
            const SizedBox(height: 10),
            Safedrivetextfield(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true),

            const SizedBox(height: 30),
            //Register button
            Safedrivebutton(
                text: "Register",
                onTap: () {
                  _registerUser();
                }),
            const SizedBox(
              height: 30,
            ),
            //A member? Sign in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have an account? ",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginpage()));
                  },
                  child: Text(
                    "Login here",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Colors.yellowAccent[700],
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  _registerUser() async {
    try {
      final email = _emailController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;

      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        final user = await _auth.registerUserWithEmailAndPassword(
            email, password, username);

        if (user != null) {
          // Navigate to HomePage FIRST
          Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Homepage()))
              .then((_) async {
            // Only save user data in Firestore after successful navigation
            var uuid = const Uuid();
            String uniqueId = 'UID${uuid.v4().substring(0, 6).toUpperCase()}';

            await _firestore.collection('Users').doc(uniqueId).set({
              'username': username,
              'email': email,
              'userId': uniqueId,
              'authId': user.uid, // Store Firebase Auth UID
              'createdAt': FieldValue.serverTimestamp(),
            });
          });
        } else {
          _showSnackbar("This email is already in use");
        }
      } else {
        _showSnackbar("Please fill in all fields");
      }
    } catch (e) {
      log('Error in registerUser: $e');
    }
  }

  void _showSnackbar(String message) {
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
}
