import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:safe_drive/ui_screens/drivetrip/drivetrip.dart';
import 'package:safe_drive/ui_screens/settings/settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:safe_drive/ui_screens/user_profile/userprofile.dart';

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
    const Settings(),
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
  Position? _lastPosition;
  double totalDistance = 0.0;
  int hardBrakes = 0;
  int sharpTurns = 0;
  Timer? _tripTimer;
  DateTime? startTime;
  DateTime? endTime;
  double avgSpeed = 0.0;

// Mock user profile data
  String userName = "Hannah";
  String vehiclePlate = "vba 585";

  void toggleTrip() async {
    if (!isTripActive) {
      log("Trip started!");
      setState(() {
        isTripActive = true;
        totalDistance = 0.0;
        hardBrakes = 0;
        sharpTurns = 0;
        startTime = DateTime.now();
      });
      _startTracking();
    } else {
      log("Trip stopped!");
      setState(() {
        isTripActive = false;
        endTime = DateTime.now();
      });
      _tripTimer?.cancel();
    }
  }

  void _startTracking() {
    _tripTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);

      if (_lastPosition != null) {
        double distanceInMeters = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        // Convert meters to km
        totalDistance += distanceInMeters / 1000;

        // Calculate speed (m/s to km/h)
        double timeDifference =
            DateTime.now().difference(startTime!).inSeconds as double;
        if (timeDifference > 0) {
          avgSpeed = (totalDistance * 1000) / timeDifference * 3.6;
        }

        // Simulated hard brake detection
        if (distanceInMeters < 3) {
          hardBrakes++;
        }

        // Simulated sharp turn detection
        double directionChange =
            (position.heading - _lastPosition!.heading).abs();
        if (directionChange > 30) {
          sharpTurns++;
        }
      }
      _lastPosition = position;
    });
  }

  String getFeedback() {
    if (hardBrakes == 0 && sharpTurns == 0) {
      return "Great job! Your driving was smooth and safe.";
    } else if (hardBrakes > 0 && sharpTurns == 0) {
      return "You hit hard brakes $hardBrakes time(s). Maintain a safe distance!";
    } else if (sharpTurns > 0 && hardBrakes == 0) {
      return "You made $sharpTurns sharp turn(s). Try to plan your turns earlier!";
    } else {
      return "You had $hardBrakes hard brakes and $sharpTurns sharp turns. Drive with caution!";
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
                color: Colors.white,
                child: Row(
                  children: [
                    // Profile Image
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          AssetImage('assets/images/profile_pic.png'),
                    ),
                    const SizedBox(width: 15),
                    // Profile Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, $userName!",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Vehicle: $vehiclePlate",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                getFeedback(),
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: toggleTrip,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTripActive
                                ? Colors.redAccent
                                : Colors.yellowAccent[700],
                            foregroundColor: Colors.deepPurple,
                          ),
                          child:
                              Text(isTripActive ? 'Stop Trip' : 'Start Trip'),
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
