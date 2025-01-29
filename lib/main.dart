import 'package:flutter/material.dart';
// import 'package:safe_drive/ui_screens/homepage/homepage.dart';
import 'package:safe_drive/ui_screens/homepage/splashscreen.dart';
import 'package:safe_drive/ui_screens/settings/settings.dart';
import 'package:safe_drive/ui_screens/user_profile/userprofile.dart';

void main() {
  runApp(const SafeDrive());
}

class SafeDrive extends StatelessWidget {
  const SafeDrive({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          SplashScreen(), // Wrapper() wrapper is a widget that decides which screen to show based on the user's authentication status
          
          initialRoute: '/', // Named parameter
      routes: {
        '/settings': (context) => Settings(), // Define the settings route
        '/userprofile': (context) => const UserProfile(),
      }
    );
  }
}