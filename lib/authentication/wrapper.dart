import 'package:flutter/material.dart';
import 'package:safe_drive/ui_screens/homepage/homepage.dart';
import 'package:safe_drive/ui_screens/homepage/splashscreen.dart';
import 'package:safe_drive/ui_screens/settings/settings.dart';
import 'package:safe_drive/ui_screens/user_profile/userprofile.dart';
import 'package:safe_drive/ui_screens/authentication/login.dart';
import 'package:safe_drive/ui_screens/authentication/register.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/', // Named parameter
      routes: {
        '/': (context) => const SplashScreen(), // Define the initial route
        '/settings': (context) => const Settings(), // Define the settings route
        '/userprofile': (context) => const UserProfile(),
        '/login': (context) => const Loginpage(),
        '/register': (context) => const Registerpage(),
        '/home': (context) => const Homepage(),
      },
    );
  }
}
