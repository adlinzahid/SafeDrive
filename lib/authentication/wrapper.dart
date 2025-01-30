import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_drive/ui_screens/homepage/homepage.dart';
import 'package:safe_drive/ui_screens/homepage/splashscreen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          //check if user is logged in or not
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //is the user logged in?
            if (snapshot.hasData) {
              return const Homepage();
            } else {
              return const SplashScreen(); //if not, show the login page
            }
          }),
    );
  }
}
