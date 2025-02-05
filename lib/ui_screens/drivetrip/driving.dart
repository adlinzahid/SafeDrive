//this is the driving screen ui to display the driving screen
//this screen will be displayed when the user starts the trip
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/services/drivingtracker.dart';
import 'package:safe_drive/database/tripdata.dart';
import 'dart:async';

class DrivingScreen extends StatefulWidget {
  const DrivingScreen({super.key});

  @override
  State<DrivingScreen> createState() => _DrivingScreenState();
}

class _DrivingScreenState extends State<DrivingScreen> {
  final DrivingTracker drivingTracker = DrivingTracker();
  final TripData tripData = TripData();

  double speed = 0.0;
  double distance = 0.0;
  int elapsedTime = 0; // Time in seconds
  bool isPaused = false;
  Timer? _timer;
  DatabaseReference? _realtime;

  @override
  void initState() {
    super.initState();
    drivingTracker.startTrip(); // Start tracking trip
    startTimer();
    listenToTripData();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (!isPaused) {
        setState(() {
          elapsedTime++;
        });
      }
    });
  }

  void listenToTripData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _realtime = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            "https://safedrive-f52ba-default-rtdb.asia-southeast1.firebasedatabase.app/",
      ).ref().child("Users").child(user.uid).child("ActiveTrip");

      _realtime!.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          setState(() {
            speed = (data["speed"] ?? 0.0).toDouble();
            distance = (data["distance"] ?? 0.0).toDouble();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Driving Mode",
            style: TextStyle(
                color: Colors.yellowAccent[700],
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: true,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat("TIME", formatTime(elapsedTime)),
            _buildStat("AVG SPEED", "${speed.toStringAsFixed(2)} KM/H"),
            _buildStat("DISTANCE", "${distance.toStringAsFixed(2)} KM"),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                    isPaused ? "Resume" : "Pause",
                    isPaused ? Colors.green : Colors.orange,
                    isPaused ? resumeTrip : pauseTrip),
                const SizedBox(width: 20),
                _buildButton("Stop", Colors.red, stopTrip),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void stopTrip() {
    tripData.stopTrip(); // Stop trip logic
    Navigator.of(context).pop(); // Go back to previous screen
  }

  void pauseTrip() {
    setState(() {
      isPaused = true;
    });
    DrivingTracker().pauseTrip(); // Pause trip logic
  }

  void resumeTrip() {
    setState(() {
      isPaused = false;
    });
    DrivingTracker().resumeTrip(); // Resume trip logic
  }
}

String formatTime(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return "00:$minutes:$secs";
}

Widget _buildStat(String label, String value) {
  return Column(
    children: [
      Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Text(value,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
    ],
  );
}

Widget _buildButton(String text, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    child: Text(text,
        style: const TextStyle(color: Colors.white, fontFamily: 'Montserrat')),
  );
}
