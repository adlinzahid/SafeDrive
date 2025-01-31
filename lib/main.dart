import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/authentication/wrapper.dart';
import 'package:safe_drive/services/firebase_options.dart';
// import 'package:safe_drive/ui_screens/homepage/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SafeDrive());
}

class SafeDrive extends StatelessWidget {
  const SafeDrive({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          Wrapper(), // Wrapper() wrapper is a widget that decides which screen to show based on the user's authentication status
    );
  }
}
