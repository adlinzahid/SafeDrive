import 'package:flutter/material.dart';
import 'package:safe_drive/components/safedrivebutton.dart';
import 'package:safe_drive/components/safedrivetextfield.dart';
import 'package:safe_drive/ui_screens/authentication/login.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _Registerpage();
}

class _Registerpage extends State<Registerpage> {
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
                controller: TextEditingController(),
                hintText: 'Email',
                obscureText: false),
            const SizedBox(height: 10),
            //Username textfield
            Safedrivetextfield(
                controller: TextEditingController(),
                hintText: 'Username',
                obscureText: false),
            //Password textfield
            const SizedBox(height: 10),
            Safedrivetextfield(
                controller: TextEditingController(),
                hintText: 'Password',
                obscureText: true),

            const SizedBox(height: 30),
            //Register button
            Safedrivebutton(
              text: "Register",
              onTap: () {
                // Add your onTap functionality here
              },
            ),
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
}
