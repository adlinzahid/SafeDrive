// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:safe_drive/authentication/auth.dart';
import 'package:safe_drive/components/errorsnackbar.dart';
import 'package:safe_drive/components/safedrivebutton.dart';
import 'package:safe_drive/components/safedrivetextfield.dart';
import 'package:safe_drive/ui_screens/authentication/login.dart';
import 'package:safe_drive/ui_screens/homepage/homepage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _Registerpage();
}

class _Registerpage extends State<Registerpage> {
  final _auth = AuthActivity();

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
        final user = await _auth.registerUserwithEmailAndPassword(
            email, password, username, context);
        if (user != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Errorsnackbar(message: "An error occurred")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Errorsnackbar(message: "Please fill all fields")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Errorsnackbar(message: "An error occurred")));
    }
  }
}
