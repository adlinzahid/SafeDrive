import 'dart:developer';
// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:safe_drive/database/tripdata.dart';
import 'package:safe_drive/ui_screens/drivetrip/drivesummary.dart';
import 'package:safe_drive/ui_screens/drivetrip/driving.dart';
import 'package:safe_drive/ui_screens/settings/settings.dart'
    as safedrive_settings;
// import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:safe_drive/ui_screens/user_profile/userprofile.dart';
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
  // Position? _lastPosition;
  double totalDistance = 0.0;
  int hardBrakes = 0;
  int sharpTurns = 0;
  // Timer? _tripTimer;
  DateTime? startTime;
  DateTime? endTime;
  double avgSpeed = 0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? currentUser;

  final DrivingTracker drivingTracker = DrivingTracker();

  //String vehiclePlate = "vba 585"; // Define the vehicle plate

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    //Initialise the text controllers with the user data
    if (currentUser?.displayName != null) {
      currentUser!.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF673AB7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.deepPurple,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
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
                      "Hi, ${currentUser!.displayName!}!",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    /*Text(
                            "Vehicle: $vehiclePlate",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),*/

                    // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfile(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Start Trip Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 400,
                    color: Colors.deepPurple[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*Text(
                          "Hi, ${currentUser!.displayName!}!",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),*/
                        if (endTime != null) ...[
                          const Text(
                            "Trip Summary",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Start: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime!)}",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "End: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(endTime!)}",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Distance: ${totalDistance.toStringAsFixed(2)} km",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Avg Speed: ${avgSpeed.toStringAsFixed(1)} km/h",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                //feedbackmessage function here
                                "Feedback: Good driving!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.yellowAccent[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            TripData tripData = TripData();
                            tripData.simulateStopTrip();
                          },
                          child: Text(
                            "Simulate Trip",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            //call driving.dart file
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
                              fontSize: 20,
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

  /*Widget _buildStatBox(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 5),
        Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }*/
}
