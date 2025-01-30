import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_drive/ui_screens/authentication/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/splashlogo.png", height: 70),
          LottieBuilder.asset("assets/lottie/drivingAnimation.json",
              height: 200),
        ],
      ),
      nextScreen: const Loginpage(),
      splashTransition: SplashTransition.scaleTransition,
      splashIconSize: 450,
      backgroundColor: Colors.deepPurple,
    );
  }
}
