import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safe_drive/authentication/auth.dart';
import 'package:safe_drive/components/safedrivebutton.dart';
import 'package:safe_drive/components/safedrivetextfield.dart';
import 'package:safe_drive/ui_screens/authentication/register.dart';
import 'package:safe_drive/ui_screens/homepage/homepage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = AuthActivity();

  @override
  void dispose() {
    //dispose of the controllers when the widget is removed from the tree
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
            //Welcome back text, you've been missed
            const Text(
              "Welcome back, ready to drive?",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),
            //Username textfield
            Safedrivetextfield(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false),

            //Password textfield
            const SizedBox(height: 10),
            Safedrivetextfield(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true),

            const SizedBox(height: 10),
            //forgot password?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.deepPurple[100],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            //Login button
            Safedrivebutton(
              text: "Sign In",
              onTap: () {
                _loginUser();
              },
            ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    " Or continue with ",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            //or continue with google
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _signinWithGoogle();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      "assets/images/googleicon.png",
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 30,
            ),
            //not a member? Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Not a member yet? ",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    log("Register now clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Registerpage(),
                      ),
                    );
                  },
                  child: Text(
                    "Register now",
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

  _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Please fill in all the fields");
      return;
    }

    try {
      User? user =
          await _auth.signInUserWithEmailAndPassword(context, email, password);

      if (user != null) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      }
    } catch (e) {
      log("Error signing in: $e");
      _showSnackbar("An error occurred. Please try again");
    }
  }

  _signinWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      // ignore: use_build_context_synchronously
      final user = await _auth.signInWithGoogle(context);
      if (user != null) {
        log('User logged in successfully');
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const Homepage(),
            ));
      }
    } catch (e) {
      log("Error signing in with Google: $e");
      _showSnackbar("An error occurred. Please try again");
    }
  }
}
