import 'package:flutter/material.dart';
import 'package:safe_drive/authentication/auth.dart';
import 'package:safe_drive/ui_screens/drivetrip/drivesummary.dart';
import 'package:safe_drive/ui_screens/drivetrip/driving.dart';
import 'package:safe_drive/ui_screens/homepage/homepage.dart';
import 'package:safe_drive/ui_screens/homepage/splashscreen.dart';
import 'package:safe_drive/ui_screens/settings/settings.dart';
import 'package:safe_drive/ui_screens/user_profile/userprofile.dart';
import 'package:safe_drive/ui_screens/authentication/login.dart';
import 'package:safe_drive/ui_screens/authentication/register.dart';

class Wrapper extends StatelessWidget {
  Wrapper({super.key});

  final AuthActivity _auth = AuthActivity();

  Future<bool> _checkLoginStatus() async {
    // Replace this with your actual authentication check logic
    return await _auth.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // Show splash screen while checking login status
        } else if (snapshot.hasData && snapshot.data == true) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/home', // User is logged in, go to home
            routes: {
              '/': (context) => const SplashScreen(),
              '/settings': (context) => const Settings(),
              '/userprofile': (context) => const UserProfile(),
              '/login': (context) => const Loginpage(),
              '/register': (context) => const Registerpage(),
              '/home': (context) => const Homepage(),
              '/driving': (context) => const DrivingScreen(),
              '/tripSummary': (context) => const DriveTrip(),
            },
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/login', // User is not logged in, go to login
            routes: {
              '/': (context) => const SplashScreen(),
              '/settings': (context) => const Settings(),
              '/userprofile': (context) => const UserProfile(),
              '/login': (context) => const Loginpage(),
              '/register': (context) => const Registerpage(),
              '/home': (context) => const Homepage(),
            },
          );
        }
      },
    );
  }
}
