import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'), 
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Profile'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                    Navigator.pushNamed(context, '/userprofile'); // route
                },
            
              ),
              ListTile(
                title: Text('Notifications'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, 'Notifications'); // route
                },
              ),
              ListTile(
                title: Text('Logout Account'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Implement logout functionality here
                },
              ),
            ],
          ),
          // Add other settings options here
        ],
      ),
    );
  }
}