import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safe_drive/authentication/auth.dart';
import 'package:safe_drive/authentication/wrapper.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthActivity _auth = AuthActivity();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Text('Settings',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 27,
                color: Colors.yellowAccent[700],
                letterSpacing: 1.5)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Profile',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white)),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, '/userprofile'); // route
                },
              ),
              ListTile(
                title: const Text('Notifications',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white)),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, 'Notifications'); // route
                },
              ),
              ListTile(
                title: const Text('Logout Account',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white)),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  log("Logout button clicked");
                  _confirmationSnackbar(context);
                },
              ),
            ],
          ),
          // Add other settings options here
        ],
      ),
    );
  }

  _signout() async {
    await _auth.signOut();
    log("User signed out");
    //ask user for confirmation if they want to sign out
    // ignore: use_build_context_synchronously

    //user wrapper()
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => Wrapper()));
  }

  _confirmationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Are you sure you want to sign out?",
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        showCloseIcon: true,
        closeIconColor: Colors.grey[600],
        action: SnackBarAction(
          label: 'Yes',
          textColor: Colors.black,
          onPressed: () {
            _signout();
          },
        ),
      ),
    );
  }
}
