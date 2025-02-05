import 'dart:developer';
// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:safe_drive/ui_screens/drivetrip/drivesummary.dart';
import 'package:safe_drive/ui_screens/drivetrip/driving.dart';
import 'package:safe_drive/ui_screens/settings/settings.dart'
    as safedrive_settings;
// import 'package:geolocator/geolocator.dart';

import 'package:safe_drive/services/drivingtracker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Homecontent(),
    const DriveTrip(),
    const safedrive_settings.Settings(),
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
            text: 'Trip History',
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
        ],
      ),
    );
  }
}

class Homecontent extends StatefulWidget {
  const Homecontent({super.key});

  @override
  State<Homecontent> createState() => _HomecontentState();
}

class _HomecontentState extends State<Homecontent> {
  bool isTripActive = false;
  double totalDistance = 0.0;
  int hardBrakes = 0;
  int sharpTurns = 0;
  DateTime? startTime;
  DateTime? endTime;
  double avgSpeed = 0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  final DrivingTracker drivingTracker = DrivingTracker();

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF673AB7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.deepPurple,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/2.png',
                        width: 130,
                        height: 130,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Hi, ${currentUser?.displayName}!",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Recent Trip Details Box (Individual Boxes)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.deepPurple[200],
                    child: Column(
                      children: [
                        const Text(
                          "Latest Trip Summary",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Display trip info
                        _buildStatBox(
                            'Distance',
                            '${totalDistance.toStringAsFixed(2)} km',
                            Icons.directions_car),
                        _buildStatBox('Speed',
                            '${avgSpeed.toStringAsFixed(1)} km/h', Icons.speed),
                        _buildStatBox(
                            'Sharp Turns', '$sharpTurns', Icons.turn_right),
                        _buildStatBox(
                            'Hard Brakes', '$hardBrakes', Icons.car_crash),

                        const SizedBox(height: 20),

                        Text(
                          "Feedback: Good driving!",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent[700],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DrivingScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Start Trip",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build individual stat boxes
  Widget _buildStatBox(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.deepPurple,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
