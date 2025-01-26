import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_drive/ui_screens/homepage/homepage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
              child: LottieBuilder.asset("assets/lottie/drivingAnimation.json"))
        ],
      ),
      nextScreen: const Homepage(),
      splashIconSize: 400,
      backgroundColor: Colors.deepPurple,
    );
  }
}
