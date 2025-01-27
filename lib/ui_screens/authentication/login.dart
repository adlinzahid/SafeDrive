import 'package:flutter/material.dart';
import 'package:safe_drive/components/safedrivebutton.dart';
import 'package:safe_drive/components/safedrivetextfield.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
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
                controller: TextEditingController(),
                hintText: 'Username',
                obscureText: false),

            //Password textfield
            const SizedBox(height: 10),
            Safedrivetextfield(
                controller: TextEditingController(),
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
                // Add your onTap functionality here
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
                Container(
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
                Text(
                  "Register now",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.yellowAccent[700],
                      fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
