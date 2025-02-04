//this is the file to  start track user's driving trip using real time database and then save to firestoreimport 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart'; //fluttertoast will be used to show alerts to the user

class DrivingTracker {
  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://safedrive-f52ba-default-rtdb.asia-southeast1.firebasedatabase.app/",
  )
      .ref()
      .child("Users")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("ActiveTrip");

  void startTrip() {
    // Initialize trip data
    log('Starting trip...');
    _db.set({
      "startTime": DateTime.now().toIso8601String(),
      "hardBrakes": 0,
      "sharpTurns": 0,
      "suddenAcceleration": 0,
      "speed": 0.0,
      "route": [],
    });

    // Track location & speed
    log('Tracking location & speed...');
    Geolocator.getPositionStream(
            locationSettings: LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((Position position) {
      double speed = position.speed;
      _db.child("speed").set(speed);

      // 🚨 Trigger alert if speed is too high (e.g., 80 km/h)
      if (speed > 22.22) {
        // 22.22 m/s = 80 km/h
        showSpeedAlert();
      }
    });
  }

  //pause the trip when user clicks on the pause button
  void pauseTrip() {
    log('Pausing trip...');
    _db.child("paused").set(true);
  }

  //resume the trip when user clicks on the resume button
  void resumeTrip() {
    log('Resuming trip...');
    _db.child("paused").remove();
  }

  // Alert Function
  void showSpeedAlert() {
    log('message: Speed alert triggered');
    Fluttertoast.showToast(
      msg: "⚠️ Slow down! You're driving too fast!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }

  //stop the trip method is in the tripdata.dart file
}
