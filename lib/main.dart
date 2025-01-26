import 'package:flutter/material.dart';
// import 'package:safe_drive/ui_screens/homepage/homepage.dart';
import 'package:safe_drive/ui_screens/homepage/splashscreen.dart';

void main() {
  runApp(const SafeDrive());
}

class SafeDrive extends StatelessWidget {
  const SafeDrive({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          SplashScreen(), // Wrapper() wrapper is a widget that decides which screen to show based on the user's authentication status
    );
  }
}
