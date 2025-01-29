import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:safe_drive/ui_screens/drivetrip/drivetrip.dart';
import 'package:safe_drive/ui_screens/settings/settings.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Homecontent(),
    DriveTrip(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: GNav(
          backgroundColor: Colors.deepPurple,
          activeColor: Colors.yellowAccent[700],
          gap: 8,
          onTabChange: (index) => setState(() {
                log('Selected index: $index');
                _selectedIndex = index;
              }),
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
              textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  color: Colors.yellowAccent[700]),
              iconColor: Colors.white,
              backgroundColor: Colors.deepPurple,
            ),
            GButton(
              icon: Icons.drive_eta,
              text: 'Drive Trip',
              textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  color: Colors.yellowAccent[700]),
              iconColor: Colors.white,
              backgroundColor: Colors.deepPurple,
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
              textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  color: Colors.yellowAccent[700]),
              iconColor: Colors.white,
              backgroundColor: Colors.deepPurple,
            ),
          ]),
    );
  }
}

class Homecontent extends StatelessWidget {
  const Homecontent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF673AB7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromRGBO(103, 58, 183, 1),
            centerTitle: true, // Center the title
            expandedHeight: 130,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/2.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(height: 400, color: Colors.deepPurple[200])),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(height: 400, color: Colors.deepPurple[200])),
            ),
          ),
        ],
      ),
    );
  }
}
